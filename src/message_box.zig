const C = @import("c.zig").C;
const errors = @import("errors.zig");
const std = @import("std");
const video = @import("video.zig");

/// MessageBox structure containing title, text, window, etc.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const BoxData = struct {
    flags: BoxFlags,
    parent_window: ?video.Window,
    title: [:0]const u8,
    message: [:0]const u8,
    buttons: []const Button,
    color_scheme: ?ColorScheme,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_MessageBoxData) BoxData {
        return .{
            .flags = BoxFlags.fromSdl(value.flags),
            .parent_window = if (value.window) |window| .{ .value = window } else null,
            .title = std.mem.span(value.title),
            .message = std.mem.span(value.message),
            .buttons = @as(*const Button, value.buttons)[0..@intCast(value.numbuttons)],
            .color_scheme = if (value.colorScheme) |color_scheme| ColorScheme.fromSdl(color_scheme) else null,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: BoxData, color_scheme_out: *C.SDL_MessageBoxColorScheme) C.SDL_MessageBoxData {
        if (self.color_scheme) |val|
            color_scheme_out.* = val.toSdl();
        return .{
            .flags = self.flags.toSdl(),
            .window = if (self.parent_window) |window| window.value else null,
            .title = self.title.ptr,
            .message = self.message.ptr,
            .numbuttons = @intCast(self.buttons.len),
            .buttons = @ptrCast(self.buttons.ptr),
            .colorScheme = if (self.color_scheme != null) color_scheme_out else null,
        };
    }
};

/// Message box flags.
///
/// ## Remarks
/// If supported will display warning icon, etc.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const BoxFlags = struct {
    /// Error dialog.
    error_dialog: bool = false,
    /// Warning dialog.
    warning_dialog: bool = false,
    /// Informational dialog.
    information_dialog: bool = false,
    /// Buttons placed left to right.
    buttons_left_to_right: bool = false,
    /// Buttons placed right to left.
    buttons_right_to_left: bool = false,

    /// Convert from an SDL value.
    pub fn fromSdl(flags: C.SDL_MessageBoxFlags) BoxFlags {
        return .{
            .error_dialog = (flags & C.SDL_MESSAGEBOX_ERROR) != 0,
            .warning_dialog = (flags & C.SDL_MESSAGEBOX_WARNING) != 0,
            .information_dialog = (flags & C.SDL_MESSAGEBOX_INFORMATION) != 0,
            .buttons_left_to_right = (flags & C.SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT) != 0,
            .buttons_right_to_left = (flags & C.SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT) != 0,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: BoxFlags) C.SDL_MessageBoxFlags {
        return (if (self.error_dialog) @as(C.SDL_MessageBoxFlags, C.SDL_MESSAGEBOX_ERROR) else 0) |
            (if (self.warning_dialog) @as(C.SDL_MessageBoxFlags, C.SDL_MESSAGEBOX_WARNING) else 0) |
            (if (self.information_dialog) @as(C.SDL_MessageBoxFlags, C.SDL_MESSAGEBOX_INFORMATION) else 0) |
            (if (self.buttons_left_to_right) @as(C.SDL_MessageBoxFlags, C.SDL_MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT) else 0) |
            (if (self.buttons_right_to_left) @as(C.SDL_MessageBoxFlags, C.SDL_MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT) else 0) |
            0;
    }
};

/// Individual button data.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Button = extern struct {
    flags: ButtonFlags = .{},
    /// User defined button id (value returned via `message_box.show()`).
    value: c_int,
    /// The UTF-8 button text.
    text: [*:0]const u8,

    // Size tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_MessageBoxButtonData) == @sizeOf(Button));
        std.debug.assert(@offsetOf(C.SDL_MessageBoxButtonData, "flags") == @offsetOf(Button, "flags"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_MessageBoxButtonData, "flags")) == @sizeOf(@FieldType(Button, "flags")));
        std.debug.assert(@offsetOf(C.SDL_MessageBoxButtonData, "buttonID") == @offsetOf(Button, "value"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_MessageBoxButtonData, "buttonID")) == @sizeOf(@FieldType(Button, "value")));
        std.debug.assert(@offsetOf(C.SDL_MessageBoxButtonData, "text") == @offsetOf(Button, "text"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_MessageBoxButtonData, "text")) == @sizeOf(@FieldType(Button, "text")));
    }

    /// Convert from an SDL value.
    pub fn fromSdl(data: C.SDL_MessageBoxButtonData) Button {
        return .{
            .flags = ButtonFlags.fromSdl(data.flags),
            .value = @intCast(data.buttonID),
            .text = @ptrCast(data.text),
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: Button) C.SDL_MessageBoxButtonData {
        return .{
            .flags = self.flags.toSdl(),
            .buttonID = @intCast(self.value),
            .text = self.text,
        };
    }
};

/// Message box button flags.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const ButtonFlags = packed struct(u32) { // Need to be packed to fit into data struct exactly.
    mark_default_with_return_key: bool = false,
    mark_default_with_escape_key: bool = false,
    _: u30 = 0,

    // Button flag tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_MessageBoxButtonFlags) == @sizeOf(ButtonFlags));
        std.debug.assert(C.SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT == @as(C.SDL_MessageBoxButtonFlags, @bitCast(ButtonFlags{ .mark_default_with_return_key = true })));
        std.debug.assert(C.SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT == @as(C.SDL_MessageBoxButtonFlags, @bitCast(ButtonFlags{ .mark_default_with_escape_key = true })));
    }

    /// Convert from an SDL value.
    pub fn fromSdl(flags: C.SDL_MessageBoxButtonFlags) ButtonFlags {
        return .{
            .mark_default_with_return_key = (flags & C.SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT) != 0,
            .mark_default_with_escape_key = (flags & C.SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT) != 0,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: ButtonFlags) C.SDL_MessageBoxButtonFlags {
        return (if (self.mark_default_with_return_key) @as(C.SDL_MessageBoxButtonFlags, C.SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT) else 0) |
            (if (self.mark_default_with_escape_key) @as(C.SDL_MessageBoxButtonFlags, C.SDL_MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT) else 0) |
            0;
    }
};

/// RGB value used in a message box color scheme.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Color = struct {
    r: u8,
    g: u8,
    b: u8,

    /// Convert from an SDL value.
    pub fn fromSdl(data: C.SDL_MessageBoxColor) Color {
        return .{
            .r = @intCast(data.r),
            .g = @intCast(data.g),
            .b = @intCast(data.b),
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: Color) C.SDL_MessageBoxColor {
        return .{
            .r = @intCast(self.r),
            .g = @intCast(self.g),
            .b = @intCast(self.b),
        };
    }

    /// Create a color from a hex code.
    pub fn fromHex(hex_code: *const [6:0]u8) !Color {
        return .{
            .r = try std.fmt.parseInt(u8, hex_code[0..2], 16),
            .g = try std.fmt.parseInt(u8, hex_code[2..4], 16),
            .b = try std.fmt.parseInt(u8, hex_code[4..6], 16),
        };
    }
};

/// A set of colors to use for message box dialogs.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const ColorScheme = struct {
    background: Color,
    text: Color,
    button_border: Color,
    button_background: Color,
    button_selected: Color,

    /// Convert from an SDL value.
    pub fn fromSdl(data: C.SDL_MessageBoxColorScheme) ColorScheme {
        return .{
            .background = Color.fromSdl(data.colors[C.SDL_MESSAGEBOX_COLOR_BACKGROUND]),
            .text = Color.fromSdl(data.colors[C.SDL_MESSAGEBOX_COLOR_TEXT]),
            .button_border = Color.fromSdl(data.colors[C.SDL_MESSAGEBOX_COLOR_BUTTON_BORDER]),
            .button_background = Color.fromSdl(data.colors[C.SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND]),
            .button_selected = Color.fromSdl(data.colors[C.SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED]),
        };
    }
    /// Convert to an SDL value.
    pub fn toSdl(self: ColorScheme) C.SDL_MessageBoxColorScheme {
        var ret: C.SDL_MessageBoxColorScheme = undefined;
        ret.colors[C.SDL_MESSAGEBOX_COLOR_BACKGROUND] = self.background.toSdl();
        ret.colors[C.SDL_MESSAGEBOX_COLOR_TEXT] = self.text.toSdl();
        ret.colors[C.SDL_MESSAGEBOX_COLOR_BUTTON_BORDER] = self.button_border.toSdl();
        ret.colors[C.SDL_MESSAGEBOX_COLOR_BUTTON_BACKGROUND] = self.button_background.toSdl();
        ret.colors[C.SDL_MESSAGEBOX_COLOR_BUTTON_SELECTED] = self.button_selected.toSdl();
        return ret;
    }
};

/// Create a modal message box.
///
/// ## Function Parameters
/// * `data`: Message box data parameters.
///
/// ## Return Value
/// Returns the hit button value, or `-1` if cancelled.
///
/// ## Remarks
/// If your needs aren't complex, it might be easier to use `message_box.showSimple()`.
///
/// This function should be called on the thread that created the parent window, or on the main thread if the messagebox has no parent.
/// It will block execution of that thread until the user clicks a button or closes the messagebox.
///
/// This function may be called at any time, even before `init.init()`.
/// This makes it useful for reporting errors like a failure to create a renderer or OpenGL context.
///
/// On X11, SDL rolls its own dialog box with X11 primitives instead of a formal toolkit like GTK+ or Qt.
///
/// Note that if `init.init()` would fail because there isn't any available video target, this function is likely to fail for the same reasons.
/// If this is a concern, check the return value from this function and fall back to writing to stderr if you can.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn show(
    data: BoxData,
) !c_int {
    var color_scheme: C.SDL_MessageBoxColorScheme = undefined;
    const button_data = data.toSdl(&color_scheme);
    var button_id: c_int = undefined;
    const ret = C.SDL_ShowMessageBox(&button_data, &button_id);
    try errors.wrapCallBool(ret);
    return @intCast(button_id);
}

/// Display a simple modal message box.
///
/// ## Function Parameters
/// * `flags`: Message box flag values.
/// * `title`: UTF-8 title text.
/// * `message`: UTF-8 message text.
/// * `parent_window`: The parent window, or `null` for none.
///
/// ## Remarks
/// If your needs aren't complex, this function is preferred over `message_box.show()`.
///
/// This function should be called on the thread that created the parent window, or on the main thread if the messagebox has no parent.
/// It will block execution of that thread until the user clicks a button or closes the messagebox.
///
/// This function may be called at any time, even before `init.init()`.
/// This makes it useful for reporting errors like a failure to create a renderer or OpenGL context.
///
/// On X11, SDL rolls its own dialog box with X11 primitives instead of a formal toolkit like GTK+ or Qt.
///
/// Note that if `init.init()` would fail because there isn't any available video target, this function is likely to fail for the same reasons.
/// If this is a concern, check the return value from this function and fall back to writing to stderr if you can.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn showSimple(
    flags: BoxFlags,
    title: [:0]const u8,
    message: [:0]const u8,
    parent_window: ?video.Window,
) !void {
    const ret = C.SDL_ShowSimpleMessageBox(
        flags.toSdl(),
        title,
        message,
        if (parent_window) |parent_window_val| parent_window_val.value else null,
    );
    return errors.wrapCallBool(ret);
}
