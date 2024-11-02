// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// This is a unique ID for a keyboard for the time it is connected to the system, and is never reused for the lifetime of the application.
pub const ID = struct {
	value: C.SDL_KeyboardID,

	/// Get the name of a keyboard.
	pub fn getName(
		self: ID,
	) ![]const u8 {
		const ret = C.SDL_GetKeyboardNameForID(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return std.mem.span(ret);
	}

	/// Get a list of currently connected camera devices. Result must be freed.
    pub fn getAll(
        allocator: std.mem.Allocator,
    ) ![]ID {
        var count: c_int = undefined;
        const ret = C.SDL_GetKeyboards(
            &count,
        );
        if (ret == null)
            return error.SdlError;
        defer C.SDL_free(ret);
        var converted_ret = try allocator.alloc(ID, @intCast(count));
        for (0..count) |ind| {
            converted_ret[ind].value = ret[ind];
        }
        return converted_ret;
    }
};

/// Check whether or not Unicode text input events are enabled for a window.
pub fn textInputActive(
	window: video.Window,
) bool {
	const ret = C.SDL_TextInputActive(
		window.value,
	);
	return ret;
}

/// Stop receiving any text input events in a window.
pub fn stopTextInput(
	window: video.Window,
) !void {
	const ret = C.SDL_StopTextInput(
		window.value,
	);
	if (!ret)
		return error.SdlError;
}

/// Dismiss the composition window/IME without disabling the subsystem.
pub fn clearComposition(
	window: video.Window,
) !void {
	const ret = C.SDL_ClearComposition(
		window.value,
	);
	if (!ret)
		return error.SdlError;
}

/// Set the area used to type Unicode text input.
pub fn setTextInputArea(
	window: video.Window,
	input_area: ?rect.IRect,
	cursor: i32,
) !void {
	const input_area_sdl: ?C.SDL_Rect = if (input_area == null) null else input_area.?.toSdl();
	const ret = C.SDL_SetTextInputArea(
		window.value,
		if (input_area_sdl == null) null else &(input_area_sdl.?),
		@intCast(cursor),
	);
	if (!ret)
		return error.SdlError;
}

/// Get the area used to type Unicode text input.
pub fn getTextInputArea(
	window: video.Window,
) struct { input_area: rect.IRect, cursor_offset: i32 } {
	var input_area: C.SDL_Rect = undefined;
	var cursor_offset: c_int = undefined;
	const ret = C.SDL_GetTextInputArea(
		window.value,
		&input_area,
		&cursor_offset,
	);
	if (!ret)
		return error.SdlError;
	return .{ .input_area = rect.IRect.fromSdl(input_area), .cursor_offset = @intCast(cursor_offset) };
}

/// Check whether the platform has screen keyboard support.
pub fn hasScreenKeyboardSupport() bool {
	const ret = C.SDL_HasScreenKeyboardSupport();
	return ret;
}

/// Check whether the screen keyboard is shown for given window.
pub fn screenKeyboardShown(
	window: video.Window,
) bool {
	const ret = C.SDL_ScreenKeyboardShown(
		window.value,
	);
	return ret;
}

const video = @import("video.zig");
const rect = @import("rect.zig");
