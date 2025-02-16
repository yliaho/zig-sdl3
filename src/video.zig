const C = @import("c.zig").C;
const errors = @import("errors.zig");
const properties = @import("properties.zig");
const rect = @import("rect.zig");
const std = @import("std");
const surface = @import("surface.zig");

/// System theme.
pub const SystemTheme = enum(c_uint) {
    Light = C.SDL_SYSTEM_THEME_LIGHT,
    Dark = C.SDL_SYSTEM_THEME_DARK,
};

/// Display orientation values; the way a display is rotated.
pub const DisplayOrientation = enum(c_uint) {
    /// The display is in landscape mode, with the right side up, relative to portrait mode.
    Landscape = C.SDL_ORIENTATION_LANDSCAPE,
    /// The display is in landscape mode, with the left side up, relative to portrait mode.
    LandscapeFlipped = C.SDL_ORIENTATION_LANDSCAPE_FLIPPED,
    /// The display is in portrait mode.
    Portrait = C.SDL_ORIENTATION_PORTRAIT,
    /// The display is in portrait mode, upside down.
    PortraitFlipped = C.SDL_ORIENTATION_PORTRAIT_FLIPPED,
};

/// A display.
pub const Display = struct {
    value: C.SDL_DisplayID,

    /// Return the primary display.
    pub fn getPrimaryDisplay() !Display {
        const ret = C.SDL_GetPrimaryDisplay();
        if (ret == 0)
            return error.SdlError;
        return Display{ .value = ret };
    }

    /// Get the name of a display in UTF-8 encoding.
    pub fn getName(
        self: Display,
    ) ![]const u8 {
        const ret = C.SDL_GetDisplayName(
            self.value,
        );
        if (ret == null)
            return error.SdlError;
        return std.mem.span(ret);
    }

    /// Get the desktop area represented by a display.
    pub fn getBounds(
        self: Display,
    ) !rect.IRect {
        var area: C.SDL_Rect = undefined;
        const ret = C.SDL_GetDisplayBounds(
            self.value,
            &area,
        );
        if (!ret)
            return error.SdlError;
        return ret.fromSdl();
    }

    /// Get the usable desktop area represented by a display, in screen coordinates.
    pub fn getUsableBounds(
        self: Display,
    ) !rect.IRect {
        var area: C.SDL_Rect = undefined;
        const ret = C.SDL_GetDisplayUsableBounds(
            self.value,
            &area,
        );
        if (!ret)
            return error.SdlError;
        return ret.fromSdl();
    }

    /// Get the orientation of a display when it is unrotated.
    pub fn getNaturalOrientation(
        self: Display,
    ) ?DisplayOrientation {
        const ret = C.SDL_GetNaturalDisplayOrientation(
            self.value,
        );
        if (ret == C.SDL_ORIENTATION_UNKNOWN)
            return null;
        return @enumFromInt(ret);
    }

    /// Get the orientation of a display.
    pub fn getCurrentOrientation(
        self: Display,
    ) ?DisplayOrientation {
        const ret = C.SDL_GetCurrentDisplayOrientation(
            self.value,
        );
        if (ret == C.SDL_ORIENTATION_UNKNOWN)
            return null;
        return @enumFromInt(ret);
    }

    /// Get the content scale of a display.
    pub fn getContentScale(
        self: Display,
    ) !f32 {
        const ret = C.SDL_GetDisplayContentScale(
            self.value,
        );
        if (ret == 0.0)
            return error.SdlError;
        return @floatCast(ret);
    }

    /// Get a list of currently connected displays.
    pub fn getAll(allocator: std.mem.Allocator) ![]Display {
        var count: c_int = undefined;
        const ret = C.SDL_GetDisplays(&count);
        if (ret == null)
            return error.SdlError;
        defer C.SDL_free(ret);
        const converted_ret = try allocator.alloc(Display, @intCast(count));
        for (0..count) |index| {
            converted_ret[index].value = ret[index];
        }
        return converted_ret;
    }
};

/// The struct used as an opaque handle to a window.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Window = packed struct {
    value: *C.SDL_Window,

    /// Supported properties for creating a window.
    ///
    /// ## Version
    /// This struct is available since SDL 3.2.0.
    pub const CreateProperties = struct {
        /// True if the window should always be on top.
        always_on_top: ?bool = null,
        /// True if the window has no window decoration.
        borderless: ?bool = null,
        /// True if the window will be used with an externally managed graphics context.
        external_graphics_context: ?bool = null,
        /// True if the window should accept keyboard input (defaults true).
        focusable: ?bool = null,
        /// True if the window should start in fullscreen mode in desktop resolution.
        fullscreen: ?bool = null,
        /// The height of the window.
        height: ?u32 = null,
        /// True if the window should start hidden.
        hidden: ?bool = null,
        /// True if the window uses a high pixel density buffer if possible.
        high_pixel_density: ?bool = null,
        /// True if the window should start maximized.
        maximized: ?bool = null,
        /// True if the window is a popup menu.
        menu: ?bool = null,
        /// True if the window will be used with metal rendering.
        metal: ?bool = null,
        /// True if the window should start minimized.
        minimized: ?bool = null,
        /// True if the window is modal to its parent.
        modal: ?bool = null,
        /// True if the window starts with grabbed mouse focus.
        mouse_grabbed: ?bool = null,
        /// True if the window will be used with OpenGL rendering.
        open_gl: ?bool = null,
        /// Window that will be the parent of this window, required for windows with the "tooltip", "menu", and "modal" properties.
        parent: ?Window = null,
        /// True if the window should be resizable.
        resizable: bool = null,
        /// The title of the window, in UTF-8 encoding.
        title: ?[:0]const u8 = null,
        /// True if the window shows transparent in the areas with alpha of 0.
        transparent: ?bool = null,
        /// True if the window is a tooltip.
        tooltip: ?bool = null,
        /// True if the window is a utility window, not showing in the task bar and window list.
        utility: ?bool = null,
        /// True if the window will be used with Vulkan rendering.
        vulkan: ?bool = null,
        /// The width of the window.
        width: ?u32 = null,
        /// The x position of the window.
        x: ?Position = null,
        /// The y position of the window.
        y: ?Position = null,
        /// MacOS only.
        /// The (`__unsafe_unretained`) `NSWindow` associated with the window, if you want to wrap an existing window.
        cocoa_window: ??*anyopaque = null,
        /// MacOS only.
        /// The (`__unsafe_unretained`) `NSView` associated  the window, defaults to `[window contentView]`
        cocoa_view: ??*anyopaque = null,
        /// Wayland only.
        /// True if the application wants to use the Wayland surface for a custom role and does not want it attached to an XDG toplevel window.
        /// See SDL3's README/wayland for more information on using custom surfaces.
        wayland_surface_role_custom: ?bool = null,
        /// Wayland only.
        /// True if the application wants an associated `wl_egl_window object` to be created and attached to the window,
        /// even if the window does not have the OpenGL property or `video.WindowFlags.open_gl` flag set.
        wayland_create_egl_window: ?bool = null,
        /// Wayland only.
        /// The `wl_surface` associated with the window, if you want to wrap an existing window.
        /// See README/wayland for more information on SDL3's github.
        wayland_create_wl_surface: ??*anyopaque = null,
        /// Windows only.
        /// The `HWND` associated with the window, if you want to wrap an existing window.
        win32_hwnd: ??*anyopaque = null,
        /// Windows only.
        /// Optional, another window to share pixel format with, useful for OpenGL windows.
        win32_pixel_format_hwnd: ??*anyopaque = null,
        /// x11 only.
        /// The X11 Window associated with the window, if you want to wrap an existing window.
        x11_window: ?i64 = null,

        /// Create SDL3 properties from this properties structure.
        ///
        /// Returned properties must be `deinit()` manually.
        pub fn toProperties(
            self: CreateProperties,
        ) !properties.Group {
            const ret = try properties.Group.init();
            if (self.always_on_top) |val|
                ret.set(C.SDL_PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN, .{ .Boolean = val });
            return ret;
        }
    };

    /// Position of a window.
    ///
    /// ## Version
    /// This union is provided without zig-sdl3.
    pub const Position = union(enum) {
        /// Specify the absolute position of the window.
        absolute: ?i32,
        /// Center the window on the display.
        centered: void,
        /// Put the window wherever I guess.
        undefined: void,
    };

    /// Create a child popup window of the specified parent window.
    ///
    /// ## Function Parameters
    /// * `self`: Parent window to make a popup for.
    /// * `offset_x`: The x position of the popup window relative to the origin of the parent.
    /// * `offset_y`: The y position of the popup window relative to the origin of the parent.
    /// * `width`: The width of the window.
    /// * `height`: The height of the window.
    /// * `flags`: Window flags that must contain `tooltip` or `popup_menu`.
    ///
    /// ## Returns
    /// Returns the window created.
    ///
    /// ## Remarks
    /// The flags parameter must contain at least one of the following:
    /// * `tooltip`: The popup window is a tooltip and will not pass any input events.
    /// * `popup_menu`: The popup window is a popup menu. The topmost popup menu will implicitly gain the keyboard focus.
    ///
    /// The following flags are not relevant to popup window creation and will be ignored:
    /// * `minimized`
    /// * `maximized`
    /// * `fullscreen`
    /// * `borderless`
    ///
    /// The following flags are incompatible with popup window creation and will cause it to fail:
    /// * `utility`
    /// * `modal`
    ///
    /// The parent of a popup window can be either a regular, toplevel window, or another popup window.
    ///
    /// Popup windows cannot be minimized, maximized, made fullscreen, raised, flash, be made a modal window,
    /// be the parent of a toplevel window, or grab the mouse and/or keyboard.
    /// Attempts to do so will fail.
    ///
    /// Popup windows implicitly do not have a border/decorations and do not appear on the taskbar/dock or in lists
    /// of windows such as alt-tab menus.
    ///
    /// If a parent window is hidden or destroyed, any child popup windows will be recursively hidden or destroyed as well.
    /// Child popup windows not explicitly hidden will be restored when the parent is shown.
    ///
    /// ## Thread Safety
    /// This function should only be called on the main thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn createPopup(
        self: Window,
        offset_x: i32,
        offset_y: i32,
        width: u32,
        height: u32,
        flags: WindowFlags,
    ) !Window {
        const ret = C.SDL_CreatePopupWindow(
            self.value,
            @intCast(offset_x),
            @intCast(offset_y),
            @intCast(width),
            @intCast(height),
            flags.toSdl(),
        );
        return .{
            .value = try errors.wrapNull(*C.SDL_Window, ret),
        };
    }

    /// Create a window with the specified dimensions and flags.
    ///
    /// ## Function Parameters
    /// * `title`: The title of the window, in UTF-8 encoding.
    /// * `width`: The width of the window.
    /// * `height`: The height of the window.
    /// * `flags`: Window flags.
    ///
    /// ## Return Value
    /// Returns the window that was created.
    ///
    /// ## Remarks
    /// The window is implicitly shown if `video.Window.WindowFlags.hidden` is not set.
    ///
    /// On Apple's macOS, you must set the `NSHighResolutionCapable` `Info.plist` property to `YES`,
    /// otherwise you will not receive a High-DPI OpenGL canvas.
    ///
    /// The window pixel size may differ from its window coordinate size if the window is on a high pixel density display.
    /// Use `video.Window.getSize()` to query the client area's size in window coordinates,
    /// and `video.Window.getSizeInPixels()` or `renderer.Renderer.getOutputSize()` to query the drawable size in pixels.
    /// Note that the drawable size can vary after the window is created and should be queried again
    /// if you get a `event.Window.pixel_size_changed` event.
    ///
    /// If the window is created with any of the `video.Window.WindowFlags.open_gl` or `video.Window.WindowFlags.vulkan` flags,
    /// then the corresponding LoadLibrary function (`video.gl_load_library()` or `video.vulkan_load_library()`) is called
    /// and the corresponding UnloadLibrary function is called by `video.Window.deinit()`.
    ///
    /// If `video.Window.WindowFlags.vulkan` is specified and there isn't a working Vulkan driver, `video.Window.init()` will fail,
    /// because `video.vulkan_load_library()` will fail.
    ///
    /// If `video.Window.WindowFlags.metal` is specified on an OS that does not support Metal, `video.Window.init()` will fail.
    ///
    /// If you intend to use this window with a `renderer.Renderer`,
    /// you should use `renderer.Render.initWithWindow()` instead of this function, to avoid window flicker.
    ///
    /// On non-Apple devices, SDL requires you to either not link to the Vulkan loader or link to a dynamic library version.
    /// This limitation may be removed in a future version of SDL.
    ///
    /// ## Thread Safety
    /// This function should only be called on the main thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    ///
    /// ## Code Examples
    /// ```zig
    /// const std = @import("std");
    /// const sdl3 = @import("sdl3");
    ///
    /// const SCREEN_WIDTH = 640;
    /// const SCREEN_HEIGHT = 480;
    ///
    /// pub fn main() !void {
    ///     defer sdl3.init.shutdown();
    ///
    ///     const init_flags = sdl3.init.Flags{ .video = true };
    ///     try sdl3.init.init(init_flags);
    ///     defer sdl3.init.quit(init_flags);
    ///
    ///     const window = try sdl3.video.Window.init("Hello SDL3", SCREEN_WIDTH, SCREEN_HEIGHT, .{});
    ///     defer window.deinit();
    ///
    ///     const surface = try window.getSurface();
    ///     try surface.fillRect(null, surface.mapRgb(128, 30, 255));
    ///     try window.updateSurface();
    ///
    ///     sdl3.timer.delayMilliseconds(5000);
    /// }
    /// ```
    ///
    /// TODO: Switch to example that also shows handling events!!!
    pub fn init(
        title: [:0]const u8,
        width: u32,
        height: u32,
        flags: WindowFlags,
    ) !Window {
        const ret = C.SDL_CreateWindow(
            title,
            @intCast(width),
            @intCast(height),
            flags.toSdl(),
        );
        return .{
            .value = try errors.wrapNull(*C.SDL_Window, ret),
        };
    }

    /// Get the SDL surface associated with the window.
    pub fn getSurface(
        self: Window,
    ) !surface.Surface {
        const ret = C.SDL_GetWindowSurface(
            self.value,
        );
        if (ret == null)
            return error.SdlError;
        return surface.Surface{ .value = ret };
    }

    /// Copy the window surface to the screen.
    pub fn updateSurface(
        self: Window,
    ) !void {
        const ret = C.SDL_UpdateWindowSurface(
            self.value,
        );
        if (!ret)
            return error.SdlError;
    }

    /// Confines the cursor to the specified area of a window.
    pub fn setMouseRect(
        self: Window,
        area: ?rect.IRect,
    ) !void {
        const area_sdl: ?C.SDL_Rect = if (area == null) null else area.?.toSdl();
        const ret = C.SDL_SetWindowMouseRect(
            self.value,
            if (area_sdl == null) null else &(area_sdl.?),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Destroy a window.
    pub fn deinit(
        self: Window,
    ) void {
        const ret = C.SDL_DestroyWindow(
            self.value,
        );
        _ = ret;
    }
};

/// The flags on a window.
///
/// ## Remarks
/// These cover a lot of true/false, or on/off, window state.
/// Some of it is immutable after being set through `video.Window.init()`,
/// some of it can be changed on existing windows by the app,
/// and some of it might be altered by the user or system outside of the app's control.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const WindowFlags = struct {
    /// Window is in fullscreen mode.
    fullscreen: bool = false,
    /// Window usable with OpenGL context.
    open_gl: bool = false,
    /// Window is occluded.
    occluded: bool = false,
    /// Window is neither mapped onto the desktop nor shown in the taskbar/dock/window list.
    /// The `video.Window.show()` function must be called for the window.
    hidden: bool = false,
    /// No window decoration.
    borderless: bool = false,
    /// Window can be resized.
    resizable: bool = false,
    /// Window is minimized.
    minimized: bool = false,
    /// Window is maximized.
    maximized: bool = false,
    /// Window has grabbed mouse input.
    mouse_grabbed: bool = false,
    /// Window has input focus.
    input_focus: bool = false,
    /// Window has mouse focus.
    mouse_focus: bool = false,
    /// Window not created by SDL.
    external: bool = false,
    /// Window is modal.
    modal: bool = false,
    /// Window uses high pixel density back buffer if possible.
    high_pixel_density: bool = false,
    /// Window has mouse captured (unrelated to `video.WindowFlags.mouse_grabbed`)
    mouse_capture: bool = false,
    /// Window has relative mode enabled.
    mouse_relative_mode: bool = false,
    /// Window should always be above others.
    always_on_top: bool = false,
    /// Window should be treated as a utility window, not showing in the task bar and window list.
    utility: bool = false,
    /// Window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window.
    tooltip: bool = false,
    /// Window should be treated as a popup menu, requires a parent window.
    popup_menu: bool = false,
    /// Window has grabbed keyboard input.
    keyboard_grabbed: bool = false,
    /// Window usable for Vulkan surface.
    vulkan: bool = false,
    /// Window usable for Metal view.
    metal: bool = false,
    /// Window with transparent buffer.
    transparent: bool = false,
    /// Window should not be focusable.
    not_focusable: bool = false,

    /// Convert from an SDL value.
    pub fn fromSdl(flags: C.SDL_WindowFlags) WindowFlags {
        return .{
            .fullscreen = (flags & C.SDL_WINDOW_FULLSCREEN) != 0,
            .open_gl = (flags & C.SDL_WINDOW_OPENGL) != 0,
            .occluded = (flags & C.SDL_WINDOW_OCCLUDED) != 0,
            .hidden = (flags & C.SDL_WINDOW_HIDDEN) != 0,
            .borderless = (flags & C.SDL_WINDOW_BORDERLESS) != 0,
            .resizable = (flags & C.SDL_WINDOW_RESIZABLE) != 0,
            .minimized = (flags & C.SDL_WINDOW_MINIMIZED) != 0,
            .maximized = (flags & C.SDL_WINDOW_MAXIMIZED) != 0,
            .mouse_grabbed = (flags & C.SDL_WINDOW_MOUSE_GRABBED) != 0,
            .input_focus = (flags & C.SDL_WINDOW_INPUT_FOCUS) != 0,
            .mouse_focus = (flags & C.SDL_WINDOW_MOUSE_FOCUS) != 0,
            .external = (flags & C.SDL_WINDOW_EXTERNAL) != 0,
            .modal = (flags & C.SDL_WINDOW_MODAL) != 0,
            .high_pixel_density = (flags & C.SDL_WINDOW_HIGH_PIXEL_DENSITY) != 0,
            .mouse_capture = (flags & C.SDL_WINDOW_MOUSE_CAPTURE) != 0,
            .mouse_relative_mode = (flags & C.SDL_WINDOW_MOUSE_RELATIVE_MODE) != 0,
            .always_on_top = (flags & C.SDL_WINDOW_ALWAYS_ON_TOP) != 0,
            .utility = (flags & C.SDL_WINDOW_UTILITY) != 0,
            .tooltip = (flags & C.SDL_WINDOW_TOOLTIP) != 0,
            .popup_menu = (flags & C.SDL_WINDOW_POPUP_MENU) != 0,
            .keyboard_grabbed = (flags & C.SDL_WINDOW_KEYBOARD_GRABBED) != 0,
            .vulkan = (flags & C.SDL_WINDOW_VULKAN) != 0,
            .metal = (flags & C.SDL_WINDOW_METAL) != 0,
            .transparent = (flags & C.SDL_WINDOW_TRANSPARENT) != 0,
            .not_focusable = (flags & C.SDL_WINDOW_NOT_FOCUSABLE) != 0,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: WindowFlags) C.SDL_WindowFlags {
        return (if (self.fullscreen) @as(C.SDL_WindowFlags, C.SDL_WINDOW_FULLSCREEN) else 0) |
            (if (self.open_gl) @as(C.SDL_WindowFlags, C.SDL_WINDOW_OPENGL) else 0) |
            (if (self.occluded) @as(C.SDL_WindowFlags, C.SDL_WINDOW_OCCLUDED) else 0) |
            (if (self.hidden) @as(C.SDL_WindowFlags, C.SDL_WINDOW_HIDDEN) else 0) |
            (if (self.borderless) @as(C.SDL_WindowFlags, C.SDL_WINDOW_BORDERLESS) else 0) |
            (if (self.resizable) @as(C.SDL_WindowFlags, C.SDL_WINDOW_RESIZABLE) else 0) |
            (if (self.minimized) @as(C.SDL_WindowFlags, C.SDL_WINDOW_MINIMIZED) else 0) |
            (if (self.maximized) @as(C.SDL_WindowFlags, C.SDL_WINDOW_MAXIMIZED) else 0) |
            (if (self.mouse_grabbed) @as(C.SDL_WindowFlags, C.SDL_WINDOW_MOUSE_GRABBED) else 0) |
            (if (self.input_focus) @as(C.SDL_WindowFlags, C.SDL_WINDOW_INPUT_FOCUS) else 0) |
            (if (self.mouse_focus) @as(C.SDL_WindowFlags, C.SDL_WINDOW_MOUSE_FOCUS) else 0) |
            (if (self.external) @as(C.SDL_WindowFlags, C.SDL_WINDOW_EXTERNAL) else 0) |
            (if (self.modal) @as(C.SDL_WindowFlags, C.SDL_WINDOW_MODAL) else 0) |
            (if (self.high_pixel_density) @as(C.SDL_WindowFlags, C.SDL_WINDOW_HIGH_PIXEL_DENSITY) else 0) |
            (if (self.mouse_capture) @as(C.SDL_WindowFlags, C.SDL_WINDOW_MOUSE_CAPTURE) else 0) |
            (if (self.mouse_relative_mode) @as(C.SDL_WindowFlags, C.SDL_WINDOW_MOUSE_RELATIVE_MODE) else 0) |
            (if (self.always_on_top) @as(C.SDL_WindowFlags, C.SDL_WINDOW_ALWAYS_ON_TOP) else 0) |
            (if (self.utility) @as(C.SDL_WindowFlags, C.SDL_WINDOW_UTILITY) else 0) |
            (if (self.tooltip) @as(C.SDL_WindowFlags, C.SDL_WINDOW_TOOLTIP) else 0) |
            (if (self.popup_menu) @as(C.SDL_WindowFlags, C.SDL_WINDOW_POPUP_MENU) else 0) |
            (if (self.keyboard_grabbed) @as(C.SDL_WindowFlags, C.SDL_WINDOW_KEYBOARD_GRABBED) else 0) |
            (if (self.vulkan) @as(C.SDL_WindowFlags, C.SDL_WINDOW_VULKAN) else 0) |
            (if (self.metal) @as(C.SDL_WindowFlags, C.SDL_WINDOW_METAL) else 0) |
            (if (self.transparent) @as(C.SDL_WindowFlags, C.SDL_WINDOW_TRANSPARENT) else 0) |
            (if (self.not_focusable) @as(C.SDL_WindowFlags, C.SDL_WINDOW_NOT_FOCUSABLE) else 0) |
            0;
    }
};

/// Get the number of video drivers compiled into SDL.
pub fn getNumDrivers() u31 {
    const ret = C.SDL_GetNumVideoDrivers();
    return @intCast(ret);
}

/// Get the name of a built in video driver.
pub fn getDriverName(
    index: u31,
) ?[]const u8 {
    const ret = C.SDL_GetVideoDriver(
        @intCast(index),
    );
    if (ret == null)
        return null;
    return std.mem.span(ret);
}

/// Get the name of the currently initialized video driver.
pub fn getCurrentDriverName() ?[]const u8 {
    const ret = C.SDL_GetCurrentVideoDriver();
    if (ret == null)
        return null;
    return std.mem.span(ret);
}

/// Get the current system theme.
pub fn getSystemTheme() ?SystemTheme {
    const ret = C.SDL_GetSystemTheme();
    if (ret == C.SDL_SYSTEM_THEME_UNKNOWN)
        return null;
    return @enumFromInt(ret);
}

// Tests for the video subsystem.
test "Video" {
    // Window.createPopup
    // Window.init
    // Window.initWithProperties
}
