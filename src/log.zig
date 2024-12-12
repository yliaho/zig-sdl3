// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// The prototype for the log output callback function.
pub fn LogOutputFunction(
	comptime UserData: type,
) type {
	return *const fn (
		user_data: *UserData,
		category: Category,
		priority: Priority,
		message: []const u8,
	) void;
}

/// The prototype for the log output callback function.
pub fn LogOutputFunctionData(comptime UserData: type) type {
	return struct {
		cb: *const fn (
			user_data: *UserData,
			category: Category,
			priority: Priority,
			message: []const u8,
		) void,
		data: *UserData,
	};
}

/// The prototype for the log output callback function.
pub fn logOutputFunction(
	user_data: ?*anyopaque,
	category: c_int,
	priority: C.SDL_LogPriority,
	message: [*c]const u8,
) callconv(.C) void {
	const cb_data: *LogOutputFunctionData(anyopaque) = @ptrCast(@alignCast(user_data));
	const ret = cb_data.cb(
		cb_data.data,
		Category{ .value = category },
		@enumFromInt(priority),
		std.mem.span(message),
	);
	_ = ret;
}

/// The predefined log priorities.
pub const Priority = enum(c_uint) {
	Trace = C.SDL_LOG_PRIORITY_TRACE,
	Verbose = C.SDL_LOG_PRIORITY_VERBOSE,
	Debug = C.SDL_LOG_PRIORITY_DEBUG,
	Info = C.SDL_LOG_PRIORITY_INFO,
	Warn = C.SDL_LOG_PRIORITY_WARN,
	Error = C.SDL_LOG_PRIORITY_ERROR,
	Critical = C.SDL_LOG_PRIORITY_CRITICAL,

	/// Set the text prepended to log messages of a given priority.
	pub fn setPrefix(
		self: Priority,
		prefix: [:0]const u8,
	) !void {
		const ret = C.SDL_SetLogPriorityPrefix(
			@intFromEnum(self),
			prefix,
		);
		if (!ret)
			return error.SdlError;
	}
};

/// The predefined log categories
pub const Category = struct {
	value: c_int,
	pub const application = Category{ .value = C.SDL_LOG_CATEGORY_APPLICATION };
	pub const errors = Category{ .value = C.SDL_LOG_CATEGORY_ERROR };
	pub const assert = Category{ .value = C.SDL_LOG_CATEGORY_ASSERT };
	pub const system = Category{ .value = C.SDL_LOG_CATEGORY_SYSTEM };
	pub const audio = Category{ .value = C.SDL_LOG_CATEGORY_AUDIO };
	pub const video = Category{ .value = C.SDL_LOG_CATEGORY_VIDEO };
	pub const render = Category{ .value = C.SDL_LOG_CATEGORY_RENDER };
	pub const input = Category{ .value = C.SDL_LOG_CATEGORY_INPUT };
	pub const testing = Category{ .value = C.SDL_LOG_CATEGORY_TEST };
	pub const gpu = Category{ .value = C.SDL_LOG_CATEGORY_GPU };
	/// First value to use for custom log categories.
	pub const custom = Category{ .value = C.SDL_LOG_CATEGORY_CUSTOM };

	/// Set the priority of all log categories.
	pub fn setAllPriorities(
		priority: Priority,
	) void {
		const ret = C.SDL_SetLogPriorities(
			@intFromEnum(priority),
		);
		_ = ret;
	}

	/// Set the priority of a particular log category.
	pub fn setPriority(
		self: Category,
		priority: Priority,
	) void {
		const ret = C.SDL_SetLogPriority(
			self.value,
			@intFromEnum(priority),
		);
		_ = ret;
	}

	/// Reset all priorities to default.
	pub fn resetAllPriorities() void {
		const ret = C.SDL_ResetLogPriorities();
		_ = ret;
	}

	/// Log a message with trace priority.
	pub fn logTrace(
		self: Category,
		str: [:0]const u8,
	) void {
		const ret = C.SDL_LogTrace(
			self.value,
			"%s",
			str.ptr,
		);
		_ = ret;
	}

	/// Log a message with verbose priority.
	pub fn logVerbose(
		self: Category,
		str: [:0]const u8,
	) void {
		const ret = C.SDL_LogVerbose(
			self.value,
			"%s",
			str.ptr,
		);
		_ = ret;
	}

	/// Log a message with debug priority.
	pub fn logDebug(
		self: Category,
		str: [:0]const u8,
	) void {
		const ret = C.SDL_LogDebug(
			self.value,
			"%s",
			str.ptr,
		);
		_ = ret;
	}

	/// Log a message with info priority.
	pub fn logInfo(
		self: Category,
		str: [:0]const u8,
	) void {
		const ret = C.SDL_LogInfo(
			self.value,
			"%s",
			str.ptr,
		);
		_ = ret;
	}

	/// Log a message with warn priority.
	pub fn logWarn(
		self: Category,
		str: [:0]const u8,
	) void {
		const ret = C.SDL_LogWarn(
			self.value,
			"%s",
			str.ptr,
		);
		_ = ret;
	}

	/// Log a message with error priority.
	pub fn logError(
		self: Category,
		str: [:0]const u8,
	) void {
		const ret = C.SDL_LogError(
			self.value,
			"%s",
			str.ptr,
		);
		_ = ret;
	}

	/// Log a message with critical priority.
	pub fn logCritical(
		self: Category,
		str: [:0]const u8,
	) void {
		const ret = C.SDL_LogCritical(
			self.value,
			"%s",
			str.ptr,
		);
		_ = ret;
	}

	/// Log a message with a given priority.
	pub fn log(
		self: Category,
		priority: Priority,
		str: [:0]const u8,
	) void {
		const ret = C.SDL_LogMessage(
			self.value,
			@intFromEnum(priority),
			"%s",
			str.ptr,
		);
		_ = ret;
	}
};

/// Log a message with the application category and info priority.
pub fn log(
	str: [:0]const u8,
) void {
	const ret = C.SDL_Log(
		"%s",
		str.ptr,
	);
	_ = ret;
}

/// Get the current log output function.
pub fn getLogOutputFunction() C.SDL_LogOutputFunction {
	var callback: C.SDL_LogOutputFunction = undefined;
	var user_data: ?*anyopaque = undefined;
	const ret = C.SDL_GetLogOutputFunction(
		&callback,
		&user_data,
	);
	_ = ret;
	return callback;
}

/// Replace the default log output function with one of your own.
pub fn setLogOutputFunction(
	UserData: type,
	callback_data: *LogOutputFunctionData(UserData),
) void {
	const ret = C.SDL_SetLogOutputFunction(
		logOutputFunction,
		callback_data,
	);
	_ = ret;
}
