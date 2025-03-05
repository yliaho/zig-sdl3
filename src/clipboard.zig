const C = @import("c.zig").C;
const errors = @import("errors.zig");
const std = @import("std");

/// Clear the clipboard data.
///
/// ## Thread Safety
/// This function should only be called on the main thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn clearData() !void {
    const ret = C.SDL_ClearClipboardData();
    return errors.wrapCallBool(ret);
}

/// Get the data from clipboard for a given mime type.
///
/// ## Function Parameters
/// * `mime_type`: MIME type to read from the clipboard.
///
/// ## Return Value
/// Returns the retrieved data buffer.
///
/// ## Remarks
/// The size of text data does not include the terminator, but the text is guaranteed to be null terminated.
///
/// ## Thread Safety
/// This function should only be called on the main thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getData(
    mime_type: [:0]const u8,
) ![]const u8 {
    var size: usize = undefined;
    const val = C.SDL_GetClipboardData(
        mime_type,
        &size,
    );
    const ret: *const u8 = @ptrCast(try errors.wrapNull(*anyopaque, val));
    return ret[0..size];
}

/// Put UTF-8 text into the clipboard.
pub fn setText(
    text: [:0]const u8,
) !void {
    const ret = C.SDL_SetClipboardText(
        text,
    );
    if (!ret)
        return error.SdlError;
}

/// Get UTF-8 text from the clipboard. Note that `sdl3.free` should be called on the return value.
pub fn getText() ![]const u8 {
    const ret = C.SDL_GetClipboardText();
    const converted_ret = std.mem.span(ret);
    if (std.mem.eql(u8, converted_ret, ""))
        return error.SdlError;
    return converted_ret;
}

/// Query whether the clipboard exists and contains a non-empty text string.
pub fn hasText() bool {
    const ret = C.SDL_HasClipboardText();
    return ret;
}

/// Put UTF-8 text into the primary selection.
pub fn setPrimarySelectionText(
    text: [:0]const u8,
) !void {
    const ret = C.SDL_SetPrimarySelectionText(
        text,
    );
    if (!ret)
        return error.SdlError;
}

/// Get UTF-8 text from the primary selection. Note that `sdl3.free` should be called on the return value.
pub fn getPrimarySelectionText() ![]const u8 {
    const ret = C.SDL_GetPrimarySelectionText();
    const converted_ret = std.mem.span(ret);
    if (std.mem.eql(u8, converted_ret, ""))
        return error.SdlError;
    return converted_ret;
}

/// Query whether the primary selection exists and contains a non-empty text string.
pub fn hasPrimarySelectionText() bool {
    const ret = C.SDL_HasPrimarySelectionText();
    return ret;
}

/// Query whether there is data in the clipboard for the provided mime type.
pub fn hasData(
    mime_type: [:0]const u8,
) bool {
    const ret = C.SDL_HasClipboardData(
        mime_type,
    );
    return ret;
}

/// Retrieve the list of mime types available in the clipboard. Result needs to be freed with `sdl3.free`.
pub fn getMimeTypes() []const [:0]const u8 {
    var num_mime_types: usize = undefined;
    const ret = C.SDL_GetClipboardMimeTypes(
        &num_mime_types,
    );
    if (ret == null)
        return error.SdlError;
    return .{ .ptr = std.span(ret), .len = @intCast(num_mime_types) };
}

/// Create user data for the set clipboard data callback function.
pub fn SetDataUserData(comptime UserData: type) type {
    return struct {
        user_data: *UserData,
        callback: *const fn (
            user_data: *UserData,
            mime_type: ?[]const u8,
        ) []const u8,
        cleanup: *const fn (
            user_data: *UserData,
        ) anyerror!void,
    };
}

/// Callback for setting data wrapper.
fn dataCallback(
    user_data: ?*anyopaque,
    mime_type: [*c]const u8,
    size: *usize,
) callconv(.C) []const u8 {
    const cb_data: *SetDataUserData(anyopaque) = @ptrCast(@alignCast(user_data));
    const ret = cb_data.callback(cb_data.user_data, if (mime_type == null) null else std.mem.span(mime_type));
    size.* = ret.len;
    return ret.ptr;
}

/// Callback for cleaning data wrapper.
fn cleanupCallback(
    user_data: ?*anyopaque,
) callconv(.C) bool {
    const cb_data: *SetDataUserData(anyopaque) = @ptrCast(@alignCast(user_data));
    cb_data.cleanup(cb_data.user_data) catch return false;
    return true;
}

/// Set data for the given mime types.
pub fn setData(
    comptime UserData: type,
    user_data: *SetDataUserData(UserData),
    mime_types: []const [:0]const u8,
) !void {
    const ret = C.SDL_SetClipboardData(
        dataCallback,
        cleanupCallback,
        user_data,
        @ptrCast(mime_types.ptr),
        mime_types.len,
    );
    if (!ret)
        return error.SdlError;
}

// Test the clipboard.
test "Clipboard" {
    // clearData
    // getData
}
