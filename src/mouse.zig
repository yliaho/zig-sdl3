const C = @import("c.zig").C;
const errors = @import("errors.zig");
const std = @import("std");
const surface = @import("surface.zig");
const video = @import("video.zig");

/// A callback used to transform mouse motion delta from raw values.
///
/// ## Function Parameters
/// * `user_data`: User data passed to `mouse.setRelativeTransform()`.
/// * `timestamp`: The associated time at which this mouse motion event was received.
/// * `window`: The associated window to which this mouse motion event was addressed.
/// * `id`: The associated mouse from which this mouse motion event was emitted.
/// * `x`: Pointer to a variable that will be treated as the resulting x-axis motion.
/// * `y`: Pointer to a variable that will be treated as the resulting y-axis motion.
///
/// ## Remarks
/// This is called during SDL's handling of platform mouse events to scale the values of the resulting motion delta.
///
/// ## Thread Safety
/// This callback is called by SDL's internal mouse input processing procedure,
/// which may be a thread separate from the main event loop that is run at realtime priority.
/// Stalling this thread with too much work in the callback can therefore potentially freeze the entire system.
/// Care should be taken with proper synchronization practices when adding other side effects beyond mutation of
/// the `x` and `y` values.
///
/// ## Version
/// This datatype is available since SDL 3.2.6.
pub const MotionTransformCallback = *const fn (user_data: ?*anyopaque, timestamp: u64, window: ?*C.SDL_Window, id: C.SDL_MouseID, x: ?*f32, y: ?*f32) callconv(.C) void;

/// A bitmask of pressed mouse buttons, as reported by `mouse.getState()`, etc.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const ButtonFlags = struct {
    left: bool,
    middle: bool,
    right: bool,
    side1: bool,
    side2: bool,

    /// Get button flags from an SDL value.
    pub fn fromSdl(value: C.SDL_MouseButtonFlags) ButtonFlags {
        return .{
            .left = value & C.SDL_BUTTON_LEFT > 0,
            .middle = value & C.SDL_BUTTON_MIDDLE > 0,
            .right = value & C.SDL_BUTTON_RIGHT > 0,
            .side1 = value & C.SDL_BUTTON_X1 > 0,
            .side2 = value & C.SDL_BUTTON_X2 > 0,
        };
    }

    /// Get this as an SDL value.
    pub fn toSdl(self: ButtonFlags) C.SDL_MouseButtonFlags {
        var ret: C.SDL_MouseButtonFlags = 0;
        if (self.left)
            ret |= C.SDL_BUTTON_LEFT;
        if (self.middle)
            ret |= C.SDL_BUTTON_MIDDLE;
        if (self.right)
            ret |= C.SDL_BUTTON_RIGHT;
        if (self.side1)
            ret |= C.SDL_BUTTON_X1;
        if (self.side2)
            ret |= C.SDL_BUTTON_X2;
        return ret;
    }
};

/// This is a unique ID for a mouse for the time it is connected to the system,
/// and is never reused for the lifetime of the application.
///
/// ## Remarks
/// If the mouse is disconnected and reconnected, it will get a new ID.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const ID = packed struct {
    value: C.SDL_MouseID,

    /// The `mouse.ID` for mouse events simulated with touch input.
    ///
    /// ## Version
    /// This constant is available since SDL 3.2.0.
    pub const touch = ID{ .value = C.SDL_TOUCH_MOUSEID };

    /// Get from an SDL value.
    pub fn fromSdl(value: C.SDL_MouseID) ?ID {
        if (value == 0)
            return null;
        return .{ .value = value };
    }

    /// Get an SDL value.
    pub fn toSdl(self: ?ID) C.SDL_MouseID {
        if (self) |val| {
            return val.value;
        }
        return 0;
    }

    /// Get the name of a mouse.
    ///
    /// ## Function Parameters
    /// * `self`: The mouse instance ID.
    ///
    /// ## Return Value
    /// Returns the name of the mouse.
    ///
    /// ## Thread Safety
    /// This function should only be called on the main thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getName(
        self: ID,
    ) !?[]const u8 {
        const ret = try errors.wrapCallCString(C.SDL_GetMouseNameForID(self.value));
        if (std.mem.eql(u8, ret, ""))
            return null;
        return ret;
    }
};

/// Cursor types for `mouse.Cursor.initSystem()`.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const SystemCursor = enum(c_uint) {
    /// Default cursor. Usually an arrow.
    default = C.SDL_SYSTEM_CURSOR_DEFAULT,
    /// Text selection. Usually an I-beam.
    text = C.SDL_SYSTEM_CURSOR_TEXT,
    /// Wait. Usually an hourglass or watch or spinning ball.
    wait = C.SDL_SYSTEM_CURSOR_WAIT,
    /// Crosshair.
    crosshair = C.SDL_SYSTEM_CURSOR_CROSSHAIR,
    /// Program is busy but still interactive. Usually it's `mouse.SystemCursor.wait` with an arrow.
    progress = C.SDL_SYSTEM_CURSOR_PROGRESS,
    /// Double arrow pointing northwest and southeast.
    northwest_southeast_resize = C.SDL_SYSTEM_CURSOR_NWSE_RESIZE,
    /// Double arrow pointing northeast and southwest.
    northeast_southwest_resize = C.SDL_SYSTEM_CURSOR_NESW_RESIZE,
    /// Double arrow pointing west and east.
    east_west_resize = C.SDL_SYSTEM_CURSOR_EW_RESIZE,
    /// Double arrow pointing north and south.
    north_south_resize = C.SDL_SYSTEM_CURSOR_NS_RESIZE,
    /// Four pointed arrow pointing north, south, east, and west.
    move = C.SDL_SYSTEM_CURSOR_MOVE,
    /// Not permitted. Usually a slashed circle or crossbones.
    not_allowed = C.SDL_SYSTEM_CURSOR_NOT_ALLOWED,
    /// Pointer that indicates a link. Usually a pointing hand.
    pointer = C.SDL_SYSTEM_CURSOR_POINTER,
    /// Window resize top-left. This may be a single arrow or a double arrow like `mouse.SystemCursor.resize`.
    north_west_resize = C.SDL_SYSTEM_CURSOR_NW_RESIZE,
    /// Window resize top. May be `mouse.SystemCursor.north_south_resize`.
    north_resize = C.SDL_SYSTEM_CURSOR_N_RESIZE,
    /// Window resize top-right. May be `mouse.SystemCursor.northeast_southwest_resize`.
    north_east_resize = C.SDL_SYSTEM_CURSOR_NE_RESIZE,
    /// Window resize right. May be `mouse.SystemCursor.east_west_resize`.
    east_resize = C.SDL_SYSTEM_CURSOR_E_RESIZE,
    /// Window resize bottom-right. May be `mouse.SystemCursor.northwest_southeast_resize`.
    southeast_resize = C.SDL_SYSTEM_CURSOR_SE_RESIZE,
    /// Window resize bottom. May be `mouse.SystemCursor.north_south_resize`.
    south_resize = C.SDL_SYSTEM_CURSOR_S_RESIZE,
    /// Window resize bottom-left. May be `mouse.SystemCursor.northeast_southwest_resize`.
    southwest_resize = C.SDL_SYSTEM_CURSOR_SW_RESIZE,
    /// Window resize left. May be `mouse.SystemCursor.east_west_resize`.
    west_resize = C.SDL_SYSTEM_CURSOR_W_RESIZE,
};

/// Scroll direction types for the `events.Type.scroll` event.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const WheelDirection = enum(c_uint) {
    /// The scroll direction is normal.
    normal,
    /// The scroll direction is flipped/natural.
    flipped,
};

/// The structure used to identify an SDL cursor.
///
/// ## Remarks
/// This is opaque data.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Cursor = packed struct {
    value: *C.SDL_Cursor,

    /// Free a previously-created cursor.
    ///
    /// ## Function Parameters
    /// * `self`: The cursor to free.
    ///
    /// ## Remarks
    /// Remarks
    /// Use this function to free cursor resources created with `cursor.Cursor.init()`, `cursor.Cursor.initColor()`,
    /// or `cursor.Cursor.initSystem()`.
    ///
    /// ## Thread Safety
    /// This function should only be called on the main thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn deinit(
        self: Cursor,
    ) void {
        C.SDL_DestroyCursor(self.value);
    }

    /// Create a cursor using the specified bitmap data and mask (in MSB format).
    ///
    /// ## Function Parameters
    /// * `data`: The color value for each pixel of the cursor.
    /// * `mask`: The mask value for each pixel of the cursor.
    /// * `width`: The width of the cursor.
    /// * `height`: The height of the cursor.
    /// * `hot_x`: The x-axis offset from the left of the cursor image to the mouse x position, in the range of `0` to `width - 1`.
    /// * `hot_y`: The y-axis offset from the top of the cursor image to the mouse y position, in the range of `0` to `height - 1`.
    ///
    /// ## Return Value
    /// Returns a new cursor.
    ///
    /// ## Remarks
    /// `mask` has to be in MSB (Most Significant Bit) format.
    ///
    /// The cursor width (`width`) must be a multiple of 8 bits.
    ///
    /// The cursor is created in black and white according to the following:
    /// * data=0, mask=1: White.
    /// * data=1, mask=1: Black.
    /// * data=0, mask=0: Transparent.
    /// * data=1, mask=0: Inverted color if possible, black if not.
    ///
    /// Cursors created with this function must be freed with `mouse.Cursor.deinit()`.
    ///
    /// If you want to have a color cursor, or create your cursor from a `surface.Surface`, you should use `mouse.Cursor.initColor()`.
    /// Alternately, you can hide the cursor and draw your own as part of your game's rendering, but it will be bound to the framerate.
    ///
    /// Also, `mouse.Cursor.initSystem()` is available, which provides several readily-available system cursors to pick from.
    ///
    /// ## Thread Safety
    /// This function should only be called on the main thread.
    ///
    /// Version
    /// This function is available since SDL 3.2.0.
    ///
    /// ## Code Examples
    /// TODO!!!
    pub fn init(
        data: [*]const u8,
        mask: [*]const u8,
        width: usize,
        height: usize,
        hot_x: usize,
        hot_y: usize,
    ) !Cursor {
        return .{ .value = try errors.wrapNull(*C.SDL_Cursor, C.SDL_CreateCursor(
            data,
            mask,
            @intCast(width),
            @intCast(height),
            @intCast(hot_x),
            @intCast(hot_y),
        )) };
    }

    /// Create a color cursor.
    ///
    /// ## Function Parameters
    /// * `cursor_surface`: A `surface.Surface` structure representing the cursor image.
    /// * `hot_x`: The x position of the cursor hot spot.
    /// * `hot_y`: The y position of the cursor hot spot.
    ///
    /// ## Return Value
    /// Returns a new cursor.
    ///
    /// ## Remarks
    /// If this function is passed a surface with alternate representations,
    /// the surface will be interpreted as the content to be used for 100% display scale,
    /// and the alternate representations will be used for high DPI situations.
    /// For example, if the original surface is 32x32, then on a 2x macOS display or 200% display scale on Windows,
    /// a 64x64 version of the image will be used, if available.
    /// If a matching version of the image isn't available,
    /// the closest larger size image will be downscaled to the appropriate size and be used instead, if available.
    /// Otherwise, the closest smaller image will be upscaled and be used instead.
    ///
    /// ## Thread Safety
    /// This function should only be called on the main thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    ///
    /// ## Code Examples
    /// TODO!!!
    pub fn initColor(
        cursor_surface: surface.Surface,
        hot_x: usize,
        hot_y: usize,
    ) !Cursor {
        return .{ .value = try errors.wrapNull(*C.SDL_Cursor, C.SDL_CreateColorCursor(
            cursor_surface.value,
            @intCast(hot_x),
            @intCast(hot_y),
        )) };
    }

    /// Create a system cursor.
    ///
    /// ## Function Parameters
    /// * `id`: A system cursor enumeration value.
    ///
    /// ## Return Value
    /// Returns a new cursor.
    ///
    /// ## Thread Safety
    /// This function should only be called on the main thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    ///
    /// ## Code Examples
    /// ```zig
    /// const my_cursor = try cursor.Cursor.initSystem(.pointer);
    /// my_cursor.set();
    /// ```
    pub fn initSystem(
        id: SystemCursor,
    ) !Cursor {
        return .{ .value = try errors.wrapNull(
            *C.SDL_Cursor,
            C.SDL_CreateSystemCursor(@intFromEnum(id)),
        ) };
    }

    /// Return whether the cursor is currently being shown.
    ///
    /// ## Return Value
    /// Returns true if the cursor is being shown, or false if the cursor is hidden.
    ///
    /// ## Thread Safety
    /// This function should only be called on the main thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn visible(
        self: Cursor,
    ) bool {
        return C.SDL_CursorVisible(self.value);
    }
};

/// Capture the mouse and to track input outside an SDL window.
///
/// ## Function Parameters
/// * `enable`: True to enable capturing, false to disable.
///
/// ## Remarks
/// Capturing enables your app to obtain mouse events globally, instead of just within your window.
/// Not all video targets support this function.
/// When capturing is enabled, the current window will get all mouse events, but unlike relative mode,
/// no change is made to the cursor and it is not restrained to your window.
///
/// This function may also deny mouse input to other windows, both those in your application and others on the system,
/// so you should use this function sparingly, and in small bursts.
/// For example, you might want to track the mouse while the user is dragging something,
/// until the user releases a mouse button.
/// It is not recommended that you capture the mouse for long periods of time, such as the entire time your app is running.
/// For that, you should probably use `mouse.setWindowRelativeMode()` or `mouse.setWindowGrab()`, depending on your goals.
///
/// While captured, mouse events still report coordinates relative to the current (foreground) window,
/// but those coordinates may be outside the bounds of the window (including negative values).
/// Capturing is only allowed for the foreground window.
/// If the window loses focus while capturing, the capture will be disabled automatically.
///
/// While capturing is enabled, the current window will have the `video.WindowFlags.mouse_capture` flag set.
///
/// Please note that SDL will attempt to "auto capture" the mouse while the user is pressing a button;
/// this is to try and make mouse behavior more consistent between platforms,
/// and deal with the common case of a user dragging the mouse outside of the window.
/// This means that if you are calling `mouse.capture()` only to deal with this situation,
/// you do not have to (although it is safe to do so).
/// If this causes problems for your app, you can disable auto capture by setting the `hints.Type.mouse_auto_capture` hint to zero.
///
/// ## Thread Safety
/// This function should only be called on the main thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn capture(
    enable: bool,
) !void {
    return errors.wrapCallBool(C.SDL_CaptureMouse(enable));
}

/// Get the active cursor.
///
/// ## Return Value
/// Returns the active cursor or `null` if there is no mouse.
///
/// ## Remarks
/// This function returns a pointer to the current cursor which is owned by the library.
/// It is not necessary to free the cursor with `cursor.Cursor.deinit()`.
///
/// ## Thread Safety
/// This function should only be called on the main thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getCursor() ?Cursor {
    const ret = C.SDL_GetCursor();
    if (ret) |val| {
        return .{ .value = val };
    }
    return null;
}

/// Get the default cursor.
///
/// ## Return Value
/// Returns the default cursor.
///
/// ## Remarks
/// You do not have to call `cursor.Cursor.deinit()` on the returned value, but it is safe to do so.
///
/// ## Thread Safety
/// This function should only be called on the main thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getDefaultCursor() !Cursor {
    return .{
        .value = errors.wrapNull(*C.SDL_Cursor, C.SDL_GetDefaultCursor()),
    };
}

/// Get the window which currently has mouse focus.
///
/// ## Return Value
/// Returns the window with the mouse focus.
///
/// ## Thread Safety
/// This function should only be called on the main thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getFocus() ?video.Window {
    if (C.SDL_GetMouseFocus()) |val| {
        return .{
            .value = val,
        };
    }
    return null;
}

/// Query the platform for the asynchronous mouse button state and the desktop-relative platform-cursor position.
///
/// ## Return Value
/// Returns the mouse button state, as well as the x and y position from the desktop's top-left corner.
///
/// ## Remarks
/// This function immediately queries the platform for the most recent asynchronous state,
/// more costly than retrieving SDL's cached state in `mouse.getState()`.
///
/// In Relative Mode, the platform-cursor's position usually contradicts the SDL-cursor's position
/// as manually calculated from `mouse.getState()` and `video.Window.getPosition()`.
///
/// This function can be useful if you need to track the mouse outside of a specific window and `mouse.capture()` doesn't fit your needs.
/// For example, it could be useful if you need to track the mouse while dragging a window,
/// where coordinates relative to a window might not be in sync at all times.
///
/// ## Thread Safety
/// This function should only be called on the main thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getGlobalState() struct { flags: ButtonFlags, x: f32, y: f32 } {
    var x: f32 = undefined;
    var y: f32 = undefined;
    const flags = C.SDL_GetGlobalMouseState(&x, &y);
    return .{
        .flags = ButtonFlags.fromSdl(flags),
        .x = x,
        .y = y,
    };
}

/// Get a list of currently connected mice.
///
/// ## Return Value
/// Returns a list of mouse instance IDs, these should be freed with `stdinc.free()` when no longer needed.
///
/// ## Remarks
/// Note that this will include any device or virtual driver that includes mouse functionality,
/// including some game controllers, KVM switches, etc.
/// You should wait for input from a device before you consider it actively in use.
///
/// ## Thread Safety
/// This function should only be called on the main thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getMice() ![]ID {
    var len: c_int = undefined;
    const val = C.SDL_GetMice(&len);
    const ret: [*]ID = @ptrCast(try errors.wrapCallCPtr(u32, val));
    return ret[0..@intCast(len)];
}

/// Query SDL's cache for the synchronous mouse button state and the window-relative SDL-cursor position.
///
/// ## Return Value
/// Returns the mouse button state, as well as the x and y position from the desktop's top-left corner.
///
/// ## Remarks
/// This function returns the cached synchronous state as SDL understands it from the last pump of the event queue.
///
/// To query the platform for immediate asynchronous state, use `mouse.getGlobalState()`.
///
/// In Relative Mode, the platform-cursor's position usually contradicts the SDL-cursor's position
/// as manually calculated from `mouse.getState()` and `video.Window.getPosition()`.
///
/// ## Thread Safety
/// This function should only be called on the main thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getState() struct { flags: ButtonFlags, x: f32, y: f32 } {
    var x: f32 = undefined;
    var y: f32 = undefined;
    const flags = C.SDL_GetMouseState(&x, &y);
    return .{
        .flags = ButtonFlags.fromSdl(flags),
        .x = x,
        .y = y,
    };
}

// Mouse related tests.
test "Mouse" {
    comptime try std.testing.expectEqual(@sizeOf(C.SDL_MouseID), @sizeOf(ID));

    // capture
    // Cursor.initColor
    // Cursor.init
    // Cursor.initSystem
    // Cursor.visible
    // Cursor.deinit
    // getCursor
    // getDefaultCursor
    // getGlobalState
    // getMice
    // getFocus
    // ID.getName
    // getState
    // getRelativeState TODO
}
