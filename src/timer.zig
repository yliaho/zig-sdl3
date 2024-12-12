// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Call a callback function at a future time. Has the current callback time interval, returns the new one with 0 to disable.
pub fn MillisecondsTimerCallback(
	comptime UserData: type,
) type {
	return *const fn (
		user_data: *UserData,
		timer: Timer,
		millsecond_interval: u32,
	) u32;
}

/// Call a callback function at a future time. Has the current callback time interval, returns the new one with 0 to disable.
pub fn MillisecondsTimerCallbackData(comptime UserData: type) type {
	return struct {
		cb: *const fn (
			user_data: *UserData,
			timer: Timer,
			millsecond_interval: u32,
		) u32,
		data: *UserData,
	};
}

/// Call a callback function at a future time. Has the current callback time interval, returns the new one with 0 to disable.
pub fn millisecondsTimerCallback(
	user_data: ?*anyopaque,
	timer: C.SDL_TimerID,
	millsecond_interval: u32,
) callconv(.C) u32 {
	const cb_data: *MillisecondsTimerCallbackData(anyopaque) = @ptrCast(@alignCast(user_data));
	const ret = cb_data.cb(
		cb_data.data,
		Timer{ .value = timer },
		@intCast(millsecond_interval),
	);
	return @intCast(ret);
}

/// Call a callback function at a future time. Has the current callback time interval, returns the new one with 0 to disable.
pub fn NanosecondsTimerCallback(
	comptime UserData: type,
) type {
	return *const fn (
		user_data: *UserData,
		timer: Timer,
		nanosecond_interval: u64,
	) u32;
}

/// Call a callback function at a future time. Has the current callback time interval, returns the new one with 0 to disable.
pub fn NanosecondsTimerCallbackData(comptime UserData: type) type {
	return struct {
		cb: *const fn (
			user_data: *UserData,
			timer: Timer,
			nanosecond_interval: u64,
		) u32,
		data: *UserData,
	};
}

/// Call a callback function at a future time. Has the current callback time interval, returns the new one with 0 to disable.
pub fn nanosecondsTimerCallback(
	user_data: ?*anyopaque,
	timer: C.SDL_TimerID,
	nanosecond_interval: u64,
) callconv(.C) u32 {
	const cb_data: *NanosecondsTimerCallbackData(anyopaque) = @ptrCast(@alignCast(user_data));
	const ret = cb_data.cb(
		cb_data.data,
		Timer{ .value = timer },
		@intCast(nanosecond_interval),
	);
	return @intCast(ret);
}

/// For triggering timed callbacks.
pub const Timer = struct {
	value: C.SDL_TimerID,

	/// Call a callback function at a future time in milliseconds.
	pub fn initMilliseconds(
		UserData: type,
		interval_milliseconds: u32,
		callback_data: *MillisecondsTimerCallbackData(UserData),
	) !Timer {
		const ret = C.SDL_AddTimer(
			@intCast(interval_milliseconds),
			millisecondsTimerCallback,
			callback_data,
		);
		if (ret == 0)
			return null;
		return Timer{ .value = ret };
	}

	/// Call a callback function at a future time in nanoseconds.
	pub fn initNanoseconds(
		UserData: type,
		interval_nanoseconds: u64,
		callback_data: *NanosecondsTimerCallbackData(UserData),
	) !Timer {
		const ret = C.SDL_AddTimerNS(
			@intCast(interval_nanoseconds),
			nanosecondsTimerCallback,
			callback_data,
		);
		if (ret == 0)
			return null;
		return Timer{ .value = ret };
	}

	/// Remove a created timer.
	pub fn deinit(
		self: Timer,
	) !void {
		const ret = C.SDL_RemoveTimer(
			self.value,
		);
		if (!ret)
			return error.SdlError;
	}
};

/// Convert seconds into nanoseconds.
pub fn secondsToNanoseconds(
	seconds: u64,
) u64 {
	const ret = C.SDL_SECONDS_TO_NS(
		@intCast(seconds),
	);
	return @intCast(ret);
}

/// Convert nanoseconds into seconds.
pub fn nanosecondsToSeconds(
	nanoseconds: u64,
) u64 {
	const ret = C.SDL_NS_TO_SECONDS(
		@intCast(nanoseconds),
	);
	return @intCast(ret);
}

/// Convert millseconds into nanoseconds.
pub fn millisecondsToNanoseconds(
	millseconds: u64,
) u64 {
	const ret = C.SDL_MS_TO_NS(
		@intCast(millseconds),
	);
	return @intCast(ret);
}

/// Convert nanoseconds into millseconds.
pub fn nanosecondsToMilliseconds(
	nanoseconds: u64,
) u64 {
	const ret = C.SDL_NS_TO_MS(
		@intCast(nanoseconds),
	);
	return @intCast(ret);
}

/// Convert microseconds into nanoseconds.
pub fn microsecondsToNanoseconds(
	microseconds: u64,
) u64 {
	const ret = C.SDL_US_TO_NS(
		@intCast(microseconds),
	);
	return @intCast(ret);
}

/// Convert nanoseconds into microseconds.
pub fn nanosecondsToMicroseconds(
	nanoseconds: u64,
) u64 {
	const ret = C.SDL_NS_TO_US(
		@intCast(nanoseconds),
	);
	return @intCast(ret);
}

/// Get the number of milliseconds since SDL library initialization.
pub fn getMillisecondsSinceInit() u64 {
	const ret = C.SDL_GetTicks();
	return @intCast(ret);
}

/// Get the number of nanoseconds since SDL library initialization.
pub fn getNanosecondsSinceInit() u64 {
	const ret = C.SDL_GetTicksNS();
	return @intCast(ret);
}

/// Get the current value of the high resolution counter.
pub fn getPerformanceCounter() u64 {
	const ret = C.SDL_GetPerformanceCounter();
	return @intCast(ret);
}

/// Get the count per second of the high resolution counter.
pub fn getPerformanceFrequency() u64 {
	const ret = C.SDL_GetPerformanceFrequency();
	return @intCast(ret);
}

/// Wait a specified number of milliseconds before returning.
pub fn delayMilliseconds(
	milliseconds: u32,
) void {
	const ret = C.SDL_Delay(
		@intCast(milliseconds),
	);
	_ = ret;
}

/// Wait a specified number of nanoseconds before returning.
pub fn delayNanoseconds(
	nanoseconds: u64,
) void {
	const ret = C.SDL_DelayNS(
		@intCast(nanoseconds),
	);
	_ = ret;
}

pub const milliseconds_per_second = C.SDL_MS_PER_SECOND;

pub const microseconds_per_second = C.SDL_US_PER_SECOND;

pub const nanoseconds_per_second = C.SDL_NS_PER_SECOND;

pub const nanoseconds_per_millisecond = C.SDL_NS_PER_MS;

pub const nanoseconds_per_microsecond = C.SDL_NS_PER_US;
