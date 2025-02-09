pub const audio = @import("audio.zig");
pub const blend_mode = @import("blend_mode.zig");
pub const camera = @import("camera.zig");
pub const clipboard = @import("clipboard.zig");

/// Simple error message routines for SDL.
///
/// Most apps will interface with these APIs in exactly one function:
/// when almost any SDL function call reports failure, you can get a human-readable string of the problem from `errors.get()`.
///
/// These strings are maintained per-thread, and apps are welcome to set their own errors, which is popular when building libraries on top of SDL for other apps to consume.
/// These strings are set by calling `errors.set()`.
pub const errors = @import("errors.zig");
pub const gpu = @import("gpu.zig");
pub const GUID = @import("guid.zig").GUID;

/// This file contains functions to set and get configuration hints, as well as listing each of them alphabetically.
///
/// The convention for naming hints is "xy_z", where "XY_Z" is the environment variable that can be used to override the default.
///
/// In general these hints are just that - they may or may not be supported or applicable on any given platform,
/// but they provide a way for an application or user to give the library a hint as to how they would like the library to work.
pub const hints = @import("hints.zig");
pub const image = if (extension_options.image) @import("image.zig") else void;

/// All SDL programs need to initialize the library before starting to work with it.
///
/// Almost everything can simply call `init.init()` near startup, with a handful of flags to specify subsystems to touch.
/// These are here to make sure SDL does not even attempt to touch low-level pieces of the operating system that you don't intend to use.
/// For example, you might be using SDL for video and input but chose an external library for audio,
/// and in this case you would just need to leave off the `audio` flag to make sure that external library has complete control.
///
/// Most apps, when terminating, should call `init.shutdown()`.
/// This will clean up (nearly) everything that SDL might have allocated, and crucially,
/// it'll make sure that the display's resolution is back to what the user expects if you had previously changed it for your game.
///
/// SDL3 apps are strongly encouraged to call `init.setAppMetadata()` at startup to fill in details about the program.
/// This is completely optional, but it helps in small ways (we can provide an About dialog box for the macOS menu, we can name the app in the system's audio mixer, etc).
/// Those that want to provide a lot of information should look at the more-detailed `init.setAppMetadataProperty()`.
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

/// Return values for optional main callbacks.
///
/// Returning Success or Failure from SDL_AppInit, SDL_AppEvent, or SDL_AppIterate will terminate the program and report success/failure to the operating system.
/// What that means is platform-dependent.
/// On Unix, for example, on success, the process error code will be zero, and on failure it will be 1.
/// This interface doesn't allow you to return specific exit codes, just whether there was an error generally or not.
///
/// Returning Continue from these functions will let the app continue to run.
///
/// See Main callbacks in SDL3 for complete details.
///
/// This enum is available since SDL 3.2.0.
pub const AppResult = enum(c_uint) {
    /// Value that requests that the app continue from the main callbacks.
    Continue = C.SDL_APP_CONTINUE,
    /// Value that requests termination with success from the main callbacks.
    Success = C.SDL_APP_SUCCESS,
    /// Value that requests termination with error from the main callbacks.
    Failure = C.SDL_APP_FAILURE,
};

/// Free memory allocated with SDL. For slices, pass in the pointer.
pub fn free(mem: ?*anyopaque) void {
    C.SDL_free(mem);
}

test {
    std.testing.refAllDecls(@This());
}
