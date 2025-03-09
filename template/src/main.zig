const sdl3 = @import("sdl3");
const std = @import("std");

const WINDOW_WIDTH = 640;
const WINDOW_HEIGHT = 480;

// Disable main hack.
pub const _start = void;
pub const WinMainCRTStartup = void;

/// Allocator we will use.
/// You probably want a different one for your applications.
const allocator = std.heap.c_allocator;

/// For logging system messages.
const log_app = sdl3.log.Category.application;

/// Sample structure to use to hold our app state.
const AppState = struct {
    init_flags: sdl3.init.Flags,
    window: sdl3.video.Window,
};

/// Handle an error.
fn sdlErr(err: ?[]const u8) void {
    if (err) |val| {
        std.debug.print("******* [Error! {s}] *******\n", .{val});
    } else {
        std.debug.print("******* [Unknown Error!] *******\n", .{});
    }
}

/// An example function to log with SDL.
fn sdlLog(
    user_data: ?*anyopaque,
    category: c_int,
    priority: sdl3.c.SDL_LogPriority,
    message: [*c]const u8,
) callconv(.C) void {
    _ = user_data;
    const category_managed = sdl3.log.Category.fromSdl(category);
    const category_str: ?[]const u8 = if (category_managed) |val| switch (val.value) {
        sdl3.log.Category.application.value => "Application",
        sdl3.log.Category.errors.value => "Errors",
        sdl3.log.Category.assert.value => "Aassert",
        sdl3.log.Category.system.value => "System",
        sdl3.log.Category.audio.value => "Audio",
        sdl3.log.Category.video.value => "Video",
        sdl3.log.Category.render.value => "Render",
        sdl3.log.Category.input.value => "Input",
        sdl3.log.Category.testing.value => "Testing",
        sdl3.log.Category.gpu.value => "Gpu",
        else => null,
    } else null;
    const priority_managed = sdl3.log.Priority.fromSdl(priority);
    const priority_str: [:0]const u8 = if (priority_managed) |val| switch (val) {
        .Trace => "Trace",
        .Verbose => "Verbose",
        .Debug => "Debug",
        .Info => "Info",
        .Warn => "Warn",
        .Error => "Error",
        .Critical => "Critical",
    } else "Unknown";
    if (category_str) |val| {
        std.debug.print("[{s}:{s}] {s}\n", .{ val, priority_str, message });
    } else {
        std.debug.print("[Custom_{d}:{s}] {s}\n", .{ category, priority_str, message });
    }
}

/// Do our initialization logic here.
fn init(
    app_state: *?*AppState,
) !sdl3.AppResult {

    // Prepare app state.
    const state = try allocator.create(AppState);

    // Setup initial data.
    const init_flags = sdl3.init.Flags{
        .video = true,
    };
    const window = try sdl3.video.Window.init("Hello SDL3", WINDOW_WIDTH, WINDOW_HEIGHT, .{});

    // Prove error handling works.
    const dummy: ?sdl3.video.Window = sdl3.video.Window.fromID(99999) catch null;
    if (dummy) |val| {
        val.deinit();
    }

    // Set app state.
    state.* = .{
        .init_flags = init_flags,
        .window = window,
    };
    app_state.* = state;

    log_app.logInfo("Finished initializing");
    return .run;
}

/// This will be called once before anything else.
/// The argc/argv work like they always do.
/// If this returns `sdl3.AppResult.continue`, the app runs.
/// If it returns `sdl3.AppResult.failure`, the app calls `SDL_AppQuit()` and terminates with an exit code that reports an error to the platform.
/// If it returns `sdl3.AppResult.success`, the app calls `SDL_AppQuit()` and terminates with an exit code that reports success to the platform.
/// This function should not go into an infinite mainloop; it should do any one-time startup it requires and then return.
///
/// If you want to, you can assign a pointer to `app_state`, and this pointer will be made available to you in later functions calls in their appstate parameter.
/// This allows you to avoid global variables, but is totally optional.
/// If you don't set this, the pointer will be `null` in later function calls.
pub export fn SDL_AppInit(
    app_state: *?*anyopaque,
    arg_count: c_int,
    arg_values: [*]?[*:0]const u8,
) callconv(.C) sdl3.AppResult {
    _ = arg_count;
    _ = arg_values;

    // Setup logging.
    sdl3.errors.error_callback = &sdlErr;
    sdl3.log.setAllPriorities(.Info);
    sdl3.log.setLogOutputFunction(&sdlLog, null);

    log_app.logInfo("Starting application...");
    return init(@ptrCast(app_state)) catch return .failure;
}

/// Do our render and update logic here.
fn iterate(
    app_state: *AppState,
) !sdl3.AppResult {
    const surface = try app_state.window.getSurface();
    try surface.fillRect(null, surface.mapRgb(128, 30, 255));
    try app_state.window.updateSurface();
    return .run;
}

/// This is called over and over, possibly at the refresh rate of the display or some other metric that the platform dictates.
/// This is where the heart of your app runs.
/// It should return as quickly as reasonably possible, but it's not a "run one memcpy and that's all the time you have" sort of thing.
/// The app should do any game updates, and render a frame of video.
/// If it returns `sdl3.AppResult.failure`, SDL will call `SDL_AppQuit()` and terminate the process with an exit code that reports an error to the platform.
/// If it returns `sdl3.AppResult.success`, the app calls `SDL_AppQuit()` and terminates with an exit code that reports success to the platform.
/// If it returns `sdl3.AppResult.continue`, then `SDL_AppIterate()` will be called again at some regular frequency.
/// The platform may choose to run this more or less (perhaps less in the background, etc), or it might just call this function in a loop as fast as possible.
/// You do not check the event queue in this function (`SDL_AppEvent()` exists for that).
pub export fn SDL_AppIterate(app_state: ?*anyopaque) callconv(.C) sdl3.AppResult {
    return iterate(@alignCast(@ptrCast(app_state))) catch return .failure;
}

/// Handle events here.
fn eventHandler(
    app_state: *AppState,
    event: sdl3.events.Event,
) !sdl3.AppResult {
    _ = app_state;
    switch (event) {
        .quit => return .success,
        else => {},
    }
    return .run;
}

/// This will be called whenever an SDL event arrives.
/// Your app should not call `events.poll()`, `events.pump()`, etc, as SDL will manage all this for you.
/// Return values are the same as from `SDL_AppIterate()`, so you can terminate in response to `events.Type.quit`, etc.
pub export fn SDL_AppEvent(
    app_state: ?*anyopaque,
    event: *sdl3.c.SDL_Event,
) callconv(.C) sdl3.AppResult {
    return eventHandler(@alignCast(@ptrCast(app_state)), sdl3.events.Event.fromSdl(event.*)) catch return .failure;
}

/// Quit logic here.
fn quit(
    app_state: ?*AppState,
    result: sdl3.AppResult,
) void {
    _ = result;
    if (app_state) |val| {
        val.window.deinit();
        allocator.destroy(val);
    }
}

/// This is called once before terminating the app--assuming the app isn't being forcibly killed or crashed--as a last chance to clean up.
/// After this returns, SDL will call `init.shutdown()` so the app doesn't have to (but it's safe for the app to call it, too).
/// Process termination proceeds as if the app returned normally from main(), so atexit handles will run, if your platform supports that.
///
/// If you set `app_state` during `SDL_AppInit()`, this is where you should free that data, as this pointer will not be provided to your app again.
///
/// The `SDL_AppResult` value that terminated the app is provided here, in case it's useful to know if this was a successful or failing run of the app.
pub export fn SDL_AppQuit(
    app_state: ?*anyopaque,
    result: sdl3.AppResult,
) callconv(.C) void {
    quit(@alignCast(@ptrCast(app_state)), result);
}
