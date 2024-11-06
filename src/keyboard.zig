// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Text input type.
pub const TextInputType = enum(c_uint) {
	/// The input is text.
	Text = C.SDL_TEXTINPUT_TYPE_TEXT,
	/// The input is a person's name.
	TextName = C.SDL_TEXTINPUT_TYPE_TEXT_NAME,
	/// The input is an e-mail address.
	TextEmail = C.SDL_TEXTINPUT_TYPE_TEXT_EMAIL,
	/// The input is a username.
	TextUsername = C.SDL_TEXTINPUT_TYPE_TEXT_USERNAME,
	/// he input is a secure password that is hidden.
	TextPasswordHidden = C.SDL_TEXTINPUT_TYPE_TEXT_PASSWORD_HIDDEN,
	/// The input is a secure password that is visible.
	TextPasswordVisible = C.SDL_TEXTINPUT_TYPE_TEXT_PASSWORD_VISIBLE,
	/// The input is a number.
	Number = C.SDL_TEXTINPUT_TYPE_NUMBER,
	/// The input is a secure PIN that is hidden.
	NumberPasswordHidden = C.SDL_TEXTINPUT_TYPE_NUMBER_PASSWORD_HIDDEN,
	/// The input is a secure PIN that is visible.
	NumberPasswordVisible = C.SDL_TEXTINPUT_TYPE_NUMBER_PASSWORD_VISIBLE,
};

/// Auto capitalization type.
pub const Capitalization = enum(c_uint) {
	/// The first letter of sentences will be capitalized.
	Sentences = C.SDL_CAPITALIZE_SENTENCES,
	/// The first letter of words will be capitalized.
	Words = C.SDL_CAPITALIZE_WORDS,
	/// All letters will be capitalized.
	Letters = C.SDL_CAPITALIZE_LETTERS,
};

/// This is a unique ID for a keyboard for the time it is connected to the system, and is never reused for the lifetime of the application.
pub const Keyboard = struct {
	value: C.SDL_KeyboardID,

	/// Get the name of a keyboard.
	pub fn getName(
		self: Keyboard,
	) ![]const u8 {
		const ret = C.SDL_GetKeyboardNameForID(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return std.mem.span(ret);
	}

	/// Return whether a keyboard is currently connected.
	pub fn has() bool {
		const ret = C.SDL_HasKeyboard();
		return ret;
	}

	/// Query the window which currently has keyboard focus.
	pub fn getFocus() video.Window {
		const ret = C.SDL_GetKeyboardFocus();
		return video.Window{ .value = ret.? };
	}

	/// Get a snapshot of the current state of the keyboard. This is indexed by scancodes. This is not to be freed.
	pub fn getState() []bool {
		var num_keys: c_int = undefined;
		const ret = C.SDL_GetKeyboardState(
			&num_keys,
		);
		return .{ .ptr = ret, .len = @intCast(num_keys) };
	}

	/// Clear the state of the keyboard.
	pub fn reset() void {
		const ret = C.SDL_ResetKeyboard();
		_ = ret;
	}

	/// Get the current key modifier state for the keyboard.
	pub fn getModState() keycode.KeyModifier {
		const ret = C.SDL_GetModState();
		return keycode.KeyModifier.fromSdl(ret);
	}

	/// Set the current key modifier state for the keyboard.
	pub fn setModState(
		modifiers: keycode.KeyModifier,
	) void {
		const ret = C.SDL_SetModState(
			modifiers.toSdl(),
		);
		_ = ret;
	}

	/// Get the key code corresponding to the given scancode according to the current keyboard layout.
	pub fn getKeyFromScancode(
		code: scancode.Scancode,
		modifier: keycode.KeyModifier,
		used_in_key_events: bool,
	) ?keycode.Keycode {
		const ret = C.SDL_GetKeyFromScancode(
			code.value,
			modifier.toSdl(),
			used_in_key_events,
		);
		if (ret == C.SDLK_UNKNOWN)
			return null;
		return keycode.Keycode{ .value = ret };
	}

	/// Get the scancode corresponding to the given key code according to the current keyboard layout. Keymod is the first one that matches.
	pub fn getScancodeFromKey(
		key: keycode.Keycode,
	) ?struct { code: scancode.Scancode, key_mod: keycode.KeyModifier } {
		var key_mod: C.SDL_Keymod = undefined;
		const ret = C.SDL_GetScancodeFromKey(
			key.value,
			&key_mod,
		);
		if (ret == C.SDL_SCANCODE_UNKNOWN)
			return null;
		return .{ .code = .{ .value = ret }, .key_mod = keycode.KeyModifier.fromSdl(key_mod) };
	}

	/// Set a human-readable name for a scancode. Note that the string given is not copied and must outlive SDL.
	pub fn setScancodeName(
		code: scancode.Scancode,
		name: [:0]const u8,
	) !void {
		const ret = C.SDL_SetScancodeName(
			code.value,
			name,
		);
		if (ret == false)
			return null;
	}

	/// Get a human-readable name for a scancode.
	pub fn getScancodeName(
		code: scancode.Scancode,
	) ?[]const u8 {
		const ret = C.SDL_GetScancodeName(
			code.value,
		);
		const converted_ret = std.mem.span(ret);
		if (std.mem.eql(u8, converted_ret, ""))
			return null;
		return converted_ret;
	}

	/// Get a scancode from a human-readable name.
	pub fn getScancodeFromName(
		name: [:0]const u8,
	) !scancode.Scancode {
		const ret = C.SDL_GetScancodeFromName(
			name,
		);
		if (ret == C.SDL_SCANCODE_UNKNOWN)
			return error.SdlError;
		return scancode.Scancode{ .value = ret };
	}

	/// Get a human-readable name for a key.
	pub fn getKeyName(
		key: keycode.Keycode,
	) ?[]const u8 {
		const ret = C.SDL_GetKeyName(
			key.value,
		);
		const converted_ret = std.mem.span(ret);
		if (std.mem.eql(u8, converted_ret, ""))
			return null;
		return converted_ret;
	}

	/// Get a key code from a human-readable name.
	pub fn getKeyFromName(
		name: [:0]const u8,
	) !keycode.Keycode {
		const ret = C.SDL_GetKeyFromName(
			name,
		);
		if (ret == C.SDLK_UNKNOWN)
			return error.SdlError;
		return keycode.Keycode{ .value = ret };
	}

	/// Start accepting Unicode text input events in a window.
	pub fn startTextInput(
		window: video.Window,
	) !void {
		const ret = C.SDL_StartTextInput(
			window.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Start accepting Unicode text input events in a window, with properties describing the input.
	pub fn startTextInputWithProperties(
		window: video.Window,
		input_properties: properties.Group,
	) !void {
		const ret = C.SDL_StartTextInputWithProperties(
			window.value,
			input_properties.value,
		);
		if (!ret)
			return error.SdlError;
	}

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
	pub fn hasScreenSupport() bool {
		const ret = C.SDL_HasScreenKeyboardSupport();
		return ret;
	}

	/// Check whether the screen keyboard is shown for given window.
	pub fn shownOnScreen(
		window: video.Window,
	) bool {
		const ret = C.SDL_ScreenKeyboardShown(
			window.value,
		);
		return ret;
	}

	/// Get a list of currently connected keyboard devices. Result must be freed.
    pub fn getAll(
        allocator: std.mem.Allocator,
    ) ![]Keyboard {
        var count: c_int = undefined;
        const ret = C.SDL_GetKeyboards(
            &count,
        );
        if (ret == null)
            return error.SdlError;
        defer C.SDL_free(ret);
        var converted_ret = try allocator.alloc(Keyboard, @intCast(count));
        for (0..count) |ind| {
            converted_ret[ind].value = ret[ind];
        }
        return converted_ret;
    }
};

const video = @import("video.zig");
const scancode = @import("scancode.zig");
const properties = @import("properties.zig");
const rect = @import("rect.zig");
const keycode = @import("keycode.zig");
