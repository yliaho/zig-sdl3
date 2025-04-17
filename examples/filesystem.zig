const sdl3 = @import("sdl3");
const std = @import("std");

pub fn main() !void {
    const out = std.io.getStdOut().writer();

    // Paths available.
    try out.print("Application Directory: \"{s}\"\n", .{try sdl3.filesystem.getBasePath()});
    try out.print("User Home Directory: \"{s}\"\n", .{try sdl3.filesystem.getUserFolder(.home)});
    const cwd = try sdl3.filesystem.getCurrentDirectory();
    defer sdl3.stdinc.free(cwd);
    try out.print("Current Working Directory: \"{s}\"\n", .{cwd});

    // Check if a path exists.
    _ = sdl3.filesystem.getPathExists("/home");

    // Filesystem manipulation.
}
