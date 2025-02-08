pub const audio = @import("audio.zig");
pub const blend_mode = @import("blend_mode.zig");
pub const camera = @import("camera.zig");
pub const clipboard = @import("clipboard.zig");
pub const errors = @import("errors.zig");
pub const gpu = @import("gpu.zig");
pub const GUID = @import("guid.zig").GUID;
pub const hints = @import("hints.zig");
pub const image = if (extension_options.image) @import("image.zig") else void;
pub const init = @import("init.zig");
pub const joystick = @import("joystick.zig");
pub const keyboard = @import("keyboard.zig");
pub const keycode = @import("keycode.zig");
pub const SharedObject = @import("loadso.zig").SharedObject;
pub const Locale = @import("locale.zig").Locale;
pub const log = @import("log.zig");
pub const message_box = @import("message_box.zig");
pub const openURL = @import("misc.zig").openURL;
pub const pen = @import("pen.zig");
pub const pixels = @import("pixels.zig");
pub const PowerState = @import("power.zig").PowerState;
pub const properties = @import("properties.zig");
pub const render = @import("render.zig");
pub const Scancode = @import("scancode.zig").Scancode;
pub const sensor = @import("sensor.zig");
pub const surface = @import("surface.zig");
pub const time = @import("time.zig");
pub const timer = @import("timer.zig");
pub const Version = @import("version.zig").Version;
pub const video = @import("video.zig");

pub const Stream = @import("io_stream.zig").Stream;
pub const rect = @import("rect.zig");

pub const C = @import("c.zig").C;

const extension_options = @import("extension_options");
const std = @import("std");

/// Whether or not to continue the application or exit with success/failure.
pub const AppResult = enum(c_uint) {
    Continue = C.SDL_APP_CONTINUE,
    Success = C.SDL_APP_SUCCESS,
    Failure = C.SDL_APP_FAILURE,
};

/// Free memory allocated with SDL. For slices, pass in the pointer.
pub fn free(mem: ?*anyopaque) void {
    C.SDL_free(mem);
}

test {
    std.testing.refAllDecls(@This());
}
