const sdl3 = @import("sdl3");
const std = @import("std");

const State = struct {
    quit: bool = false,
};

fn quit(user_data: ?*anyopaque, entry: ?*sdl3.c.SDL_TrayEntry) callconv(.C) void {
    _ = entry;
    const state: *State = @alignCast(@ptrCast(user_data));
    state.quit = true;
}

pub fn main() !void {
    defer sdl3.init.shutdown();

    try sdl3.init.init(.{ .video = true });
    defer sdl3.init.quit(.{ .video = true });

    var state = State{};

    // Tray icon.
    const icon = try sdl3.surface.Surface.init(32, 32, .array_rgba_32);
    try icon.clear(.{ .r = 1, .g = 0, .b = 1, .a = 1 });
    defer icon.deinit();

    // Create tray and menu.
    const tray = sdl3.tray.Tray.init(icon, "SDL3 Tray Example");
    defer tray.deinit();
    const menu = tray.createMenu();
    try std.testing.expectEqual(menu, tray.getMenu());

    // Buttons.
    const checkbox = menu.insertAt(null, "Checkbox", .{ .entry = .{ .checkbox = false } }).?;
    checkbox.setChecked(true);
    try std.testing.expect(checkbox.getChecked());
    checkbox.click();
    try std.testing.expect(!checkbox.getChecked());
    const quit_button = menu.insertAt(null, "Quit", .{
        .entry = .{ .button = {} },
    }).?;
    quit_button.setCallback(quit, &state);

    while (!state.quit) {
        sdl3.tray.update();
        const event = sdl3.events.waitTimeout(true, 200) orelse continue;
        switch (event.event.?) {
            .quit => break,
            else => {},
        }
    }
}
