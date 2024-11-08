const C = @import("c.zig").C;
const std = @import("std");

fn streamSize(data: ?*anyopaque) callconv(.C) i64 {
    var stream: *std.io.StreamSource = @ptrCast(@alignCast(data.?));
    const end_pos = stream.getEndPos() catch return -1;
    return @intCast(end_pos);
}

fn streamSeek(data: ?*anyopaque, offset: i64, whence: c_uint) callconv(.C) i64 {
    var stream: *std.io.StreamSource = @ptrCast(@alignCast(data.?));
    switch (whence) {
        C.SDL_IO_SEEK_CUR => stream.seekBy(offset) catch return -1,
        C.SDL_IO_SEEK_SET => stream.seekTo(@intCast(offset)) catch return -1,
        C.SDL_IO_SEEK_END => {
            const end_pos = stream.getEndPos() catch return -1;
            if (offset > end_pos)
                return -1;
            stream.seekTo(@intCast(end_pos - @as(u64, @intCast(offset)))) catch return -1;
        },
        else => return -1,
    }
    const pos = stream.getPos() catch return -1;
    return @as(i64, @intCast(pos));
}

fn streamRead(data: ?*anyopaque, ptr: ?*anyopaque, size: usize, status: [*c]c_uint) callconv(.C) usize {
    var stream: *std.io.StreamSource = @ptrCast(@alignCast(data.?));
    var dest: [*]u8 = @ptrCast(ptr.?);
    return stream.read(dest[0..size]) catch blk: {
        status.* = C.SDL_IO_STATUS_ERROR;
        break :blk 0;
    };
}

fn streamWrite(data: ?*anyopaque, ptr: ?*const anyopaque, size: usize, status: [*c]c_uint) callconv(.C) usize {
    var stream: *std.io.StreamSource = @ptrCast(@alignCast(data.?));
    var src: [*]const u8 = @ptrCast(ptr.?);
    return stream.write(src[0..size]) catch blk: {
        status.* = C.SDL_IO_STATUS_ERROR;
        break :blk 0;
    };
}

fn streamFlush(data: ?*anyopaque, status: [*c]c_uint) callconv(.C) bool {
    _ = data;
    _ = status;
    return true; // No flushing needed, idk.
}

fn streamClose(data: ?*anyopaque) callconv(.C) bool {
    _ = data;
    return true;
}

/// Stream for working with SDL IO streams. This just wraps around a stream source so SDL can use it. You should read and write from the stream source.
pub const Stream = struct {
    value: *C.SDL_IOStream,
    const interface = C.SDL_IOStreamInterface{
        .version = @sizeOf(C.SDL_IOStreamInterface),
        .size = streamSize,
        .seek = streamSeek,
        .read = streamRead,
        .write = streamWrite,
        .flush = streamFlush,
        .close = streamClose,
    };

    /// Initialize a stream for compatibility with SDL. Note the source must exist for the lifetime of this stream. Read and write to the stream using the source you provide.
    pub fn init(source: *std.io.StreamSource) !Stream {
        const ret = C.SDL_OpenIO(&interface, source);
        if (ret) |val| {
            return .{ .value = val };
        }
        return error.SDLError;
    }

    /// Create a stream from a file.
    pub fn fromFile(file: std.fs.File, source_out: *std.io.StreamSource) !Stream {
        source_out.* = std.io.StreamSource{ .file = file };
        return try init(source_out);
    }

    /// Create a stream from memory.
    pub fn fromMemory(mem: []u8, source_out: *std.io.StreamSource) !Stream {
        source_out.* = std.io.StreamSource{ .buffer = std.io.fixedBufferStream(mem) };
        return try init(source_out);
    }

    /// Create a stream from constant memory.
    pub fn fromConstMemory(mem: []const u8, source_out: *std.io.StreamSource) !Stream {
        source_out.* = std.io.StreamSource{ .const_buffer = std.io.fixedBufferStream(mem) };
        return try init(source_out);
    }

    /// Cleanup the stream.
    pub fn deinit(self: Stream) !void {
        if (!C.SDL_CloseIO(self.value))
            return error.SDLError;
    }
};

test "Stream" {
    var buffer: [64]u8 = undefined;
    var source: std.io.StreamSource = undefined;
    const stream = try Stream.fromMemory(&buffer, &source);
    defer stream.deinit() catch {};
    try std.testing.expect(C.SDL_WriteU8(stream.value, 7));
    try std.testing.expect(buffer[0] == 7);
    buffer[1] = 3;
    var val: u8 = undefined;
    try std.testing.expect(C.SDL_ReadU8(stream.value, &val));
    try std.testing.expect(val == 3);
    try std.testing.expect(C.SDL_GetIOSize(stream.value) == 64);
    try std.testing.expect(C.SDL_SeekIO(stream.value, 50, C.SDL_IO_SEEK_SET) == 50);
    try std.testing.expect(C.SDL_SeekIO(stream.value, 23, C.SDL_IO_SEEK_END) == 41);
    try std.testing.expect(C.SDL_SeekIO(stream.value, 2, C.SDL_IO_SEEK_CUR) == 43);

    var const_source: std.io.StreamSource = undefined;
    const const_stream = try Stream.fromConstMemory(&buffer, &const_source);
    defer const_stream.deinit() catch {};
    try std.testing.expect(C.SDL_ReadU8(const_stream.value, &val));
    try std.testing.expect(val == 7);
    try std.testing.expect(!C.SDL_WriteU8(const_stream.value, 3));
}
