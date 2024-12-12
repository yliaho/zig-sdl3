// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// A callback used to send notifications of hint value changes.
pub fn Callback(
	comptime UserData: type,
) type {
	return *const fn (
		user_data: *UserData,
		hint: Type,
		old_value: [:0]const u8,
		new_value: [:0]const u8,
	) void;
}

/// A callback used to send notifications of hint value changes.
pub fn CallbackData(comptime UserData: type) type {
	return struct {
		cb: *const fn (
			user_data: *UserData,
			hint: Type,
			old_value: [:0]const u8,
			new_value: [:0]const u8,
		) void,
		data: *UserData,
	};
}

/// A callback used to send notifications of hint value changes.
pub fn callback(
	user_data: ?*anyopaque,
	hint: [:0]const u8,
	old_value: [*c]const u8,
	new_value: [*c]const u8,
) callconv(.C) void {
	const cb_data: *CallbackData(anyopaque) = @ptrCast(@alignCast(user_data));
	const ret = cb_data.cb(
		cb_data.data,
		Type.fromSdl(hint),
		std.mem.span(old_value),
		std.mem.span(new_value),
	);
	_ = ret;
}

/// An enumeration of hint priorities.
pub const Priority = enum(c_uint) {
	Default = C.SDL_HINT_DEFAULT,
	Normal = C.SDL_HINT_NORMAL,
	Override = C.SDL_HINT_OVERRIDE,

	/// Set a hint with a specific priority. Will only set if the hint was previously set with a lower priority.
	pub fn setWithPriority(
		hint: Type,
	) !void {
		const ret = C.SDL_SetHintWithPriority(
			hint.toSdl(),
		);
		if (!ret)
			return error.SdlError;
	}
};

/// Configuration hints for the library. May or may not be useful depending on the platform.
pub const Type = enum {
	/// 0 - Sdl does not handle Alt+Tab, 1 - Sdl will minimize window on Alt+Tab (default).
	AllowAltTabWhileGrabbed,

	/// Convert from an SDL string.
	pub fn fromSdl(val: [:0]const u8) Type {
		if (std.mem.eql(u8, C.SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED, val))
			return .AllowAltTabWhileGrabbed;
		return .AllowAltTabWhileGrabbed;
	}

	/// Convert to an SDL string.
	pub fn toSdl(self: Type) [:0]const u8 {
		return switch (self) {
			.AllowAltTabWhileGrabbed => C.SDL_HINT_ALLOW_ALT_TAB_WHILE_GRABBED,
		};
	}
};

/// Set a hint with a specific priority. Will only set if the hint was previously set with a lower priority.
pub fn setWithPriority(
	hint: Type,
	value: [:0]const u8,
	priority: Priority,
) !void {
	const ret = C.SDL_SetHintWithPriority(
		hint.toSdl(),
		value,
		@intFromEnum(priority),
	);
	if (!ret)
		return error.SdlError;
}

/// Set a hint with normal priority.
pub fn set(
	hint: Type,
	value: [:0]const u8,
) !void {
	const ret = C.SDL_SetHint(
		hint.toSdl(),
		value,
	);
	if (!ret)
		return error.SdlError;
}

/// Reset a hint to its default value.
pub fn reset(
	hint: Type,
) !void {
	const ret = C.SDL_ResetHint(
		hint.toSdl(),
	);
	if (!ret)
		return error.SdlError;
}

/// Reset all hints.
pub fn resetAll() void {
	const ret = C.SDL_ResetHints();
	_ = ret;
}

/// Get a hint's value, or null if the hint is not set.
pub fn get(
	hint: Type,
) ?[]const u8 {
	const ret = C.SDL_GetHint(
		hint.toSdl(),
	);
	if (ret == null)
		return null;
	return std.mem.span(ret);
}

/// Get a hint's boolean value.
pub fn getBoolean(
	hint: Type,
) ?bool {
	const ret = C.SDL_GetHintBoolean(
		hint.toSdl(),
	);
	if (get(hint) == null) return null;
	return ret;
}

/// Add a function to watch a particular hint.
pub fn addCallback(
	UserData: type,
	hint: Type,
	callback_data: *CallbackData(UserData),
) !void {
	const ret = C.SDL_AddHintCallback(
		hint.toSdl(),
		callback,
		callback_data,
	);
	if (!ret)
		return error.SdlError;
}

/// Remove a function to watch a particular hint.
pub fn removeCallback(
	UserData: type,
	hint: Type,
	callback_data: *CallbackData(UserData),
) void {
	const ret = C.SDL_RemoveHintCallback(
		hint.toSdl(),
		callback,
		callback_data,
	);
	_ = ret;
}
