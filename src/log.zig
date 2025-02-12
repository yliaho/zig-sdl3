const C = @import("c.zig").C;
const errors = @import("errors.zig");
const std = @import("std");

/// The prototype for the log output callback function.
///
/// * `user_data`: What was passed as userdata to `log.setLogOutputFunction()`.
/// * `category`: The category of the message.
/// * `priority`: The priority of the message.
/// * `message`: The message being output.
///
/// This function is called by SDL when there is new text to be logged.
/// A mutex is held so that this function is never called by more than one thread at once.
///
/// This datatype is available since SDL 3.2.0.
pub const LogOutputFunction = *const fn (user_data: ?*anyopaque, category: c_int, priority: C.SDL_LogPriority, message: [*c]const u8) callconv(.C) void;

/// The predefined log priorities.
///
/// This enum is available since SDL 3.2.0.
pub const Priority = enum(c_uint) {
    Trace = C.SDL_LOG_PRIORITY_TRACE,
    Verbose = C.SDL_LOG_PRIORITY_VERBOSE,
    Debug = C.SDL_LOG_PRIORITY_DEBUG,
    Info = C.SDL_LOG_PRIORITY_INFO,
    Warn = C.SDL_LOG_PRIORITY_WARN,
    Error = C.SDL_LOG_PRIORITY_ERROR,
    Critical = C.SDL_LOG_PRIORITY_CRITICAL,

    /// Make a priority from an SDL value.
    pub fn fromSdl(val: c_uint) ?Priority {
        if (val == C.SDL_LOG_PRIORITY_INVALID)
            return null;
        return @enumFromInt(val);
    }

    /// Set the text prepended to log messages of a given priority.
    ///
    /// * `self`: The priority to modify.
    /// * `prefix`: The prefix to use for that log priority, or `null` to use no prefix.
    ///
    /// By default SDL_LOG_PRIORITY_INFO and below have no prefix, and SDL_LOG_PRIORITY_WARN and higher have a prefix showing their priority, e.g. "WARNING: ".
    ///
    /// Note that prefixes will only effect the default log callback and not any custom ones.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn setPrefix(
        self: Priority,
        prefix: ?[:0]const u8,
    ) !void {
        const ret = C.SDL_SetLogPriorityPrefix(
            @intFromEnum(self),
            if (prefix) |val| val.ptr else null,
        );
        return errors.wrapCallBool(ret);
    }
};

/// The predefined log categories.
///
/// By default the application and gpu categories are enabled at the INFO level,
/// the assert category is enabled at the WARN level,
/// test is enabled at the VERBOSE level,
/// and all other categories are enabled at the ERROR level.
///
/// This is available since SDL 3.2.0.
pub const Category = packed struct {
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

    /// Get zig representation of a category.
    pub fn fromSdl(val: c_int) ?Category {
        if (val == C.SDL_LOG_CATEGORY_ERROR)
            return null;
        return .{ .value = val };
    }

    /// Get the priority of a particular log category.
    ///
    /// * `self`: The category to query.
    ///
    /// Returns the `log.Priority` for the requested query.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn getPriority(
        self: Category,
    ) Priority {
        return @enumFromInt(C.SDL_GetLogPriority(self.value));
    }

    /// Log a message with the specified category and priority.
    ///
    /// * `self`: The category of the message.
    /// * `priority`: The priority of the message.
    /// * `str`: String to log.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn log(
        self: Category,
        priority: Priority,
        str: [:0]const u8,
    ) void {
        C.SDL_LogMessage(
            self.value,
            @intFromEnum(priority),
            "%s",
            str.ptr,
        );
    }

    /// Log a message with `log.Priority.Critical`.
    ///
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn logCritical(
        self: Category,
        str: [:0]const u8,
    ) void {
        C.SDL_LogCritical(
            self.value,
            "%s",
            str.ptr,
        );
    }

    /// Log a message with `log.Priority.Debug`.
    ///
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn logDebug(
        self: Category,
        str: [:0]const u8,
    ) void {
        C.SDL_LogDebug(
            self.value,
            "%s",
            str.ptr,
        );
    }

    /// Log a message with `log.Priority.Error`.
    ///
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn logError(
        self: Category,
        str: [:0]const u8,
    ) void {
        C.SDL_LogError(
            self.value,
            "%s",
            str.ptr,
        );
    }

    /// Log a message with `log.Priority.Info`.
    ///
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn logInfo(
        self: Category,
        str: [:0]const u8,
    ) void {
        C.SDL_LogInfo(
            self.value,
            "%s",
            str.ptr,
        );
    }

    /// Log a message with `log.Priority.Trace`.
    ///
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn logTrace(
        self: Category,
        str: [:0]const u8,
    ) void {
        C.SDL_LogTrace(
            self.value,
            "%s",
            str.ptr,
        );
    }

    /// Log a message with `log.Priority.Verbose`.
    ///
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn logVerbose(
        self: Category,
        str: [:0]const u8,
    ) void {
        C.SDL_LogVerbose(
            self.value,
            "%s",
            str.ptr,
        );
    }

    /// Log a message with `log.Priority.Warn`.
    ///
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn logWarn(
        self: Category,
        str: [:0]const u8,
    ) void {
        C.SDL_LogWarn(
            self.value,
            "%s",
            str.ptr,
        );
    }

    /// Set the priority of a particular log category.
    ///
    /// * `self`: The category to assign the priority to.
    /// * `priority`: The log priority to assign.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
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
};

/// Get the default log output function.
///
/// Returns the default log output callback.
///
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn getDefaultLogOutputFunction() LogOutputFunction {
    return C.SDL_GetDefaultLogOutputFunction().?;
}

/// Get the current log output function.
///
/// Return struct:
/// * `callback`: A `log.LogOutputFunction` filled in with the current log `callback`.
/// * `user_data`: A pointer filled in with the pointer that is passed to `callback`.
///
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn getLogOutputFunction() struct { callback: LogOutputFunction, user_data: ?*anyopaque } {
    var callback: C.SDL_LogOutputFunction = undefined;
    var user_data: ?*anyopaque = undefined;
    C.SDL_GetLogOutputFunction(
        &callback,
        &user_data,
    );
    return .{ .callback = callback.?, .user_data = user_data };
}

/// Log a message with `log.Category.application` and `log.Priority.Info`.
///
/// * `str`: The string to log.
///
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn log(
    str: [:0]const u8,
) void {
    C.SDL_Log(
        "%s",
        str.ptr,
    );
}

/// Reset all priorities to default.
///
/// This is called by `init.shutdown()`.
///
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn resetAllPriorities() void {
    C.SDL_ResetLogPriorities();
}

/// Set the priority of all log categories.
///
/// * `priority`: The priority to assign to all categories.
///
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn setAllPriorities(
    priority: Priority,
) void {
    C.SDL_SetLogPriorities(
        @intFromEnum(priority),
    );
}

/// Replace the default log output function with one of your own.
///
/// * `callback`: A `log.LogOutputFunction` to call instead of the default.
/// * `user_data`: A pointer that is passed to `callback`.
///
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn setLogOutputFunction(
    callback: LogOutputFunction,
    user_data: ?*anyopaque,
) void {
    C.SDL_SetLogOutputFunction(
        callback,
        user_data,
    );
}

const TestLogCallbackData = struct {
    buf: *std.ArrayList(u8),
    last_str: usize = 0,
    last_category: ?Category = null,
    last_priority: ?Priority = null,
};

fn testLogCallback(user_data: ?*anyopaque, category: c_int, priority: C.SDL_LogPriority, message: [*c]const u8) callconv(.C) void {
    var data: *TestLogCallbackData = @ptrCast(@alignCast(user_data));
    data.last_str = data.buf.items.len;
    data.last_category = Category.fromSdl(category);
    data.last_priority = Priority.fromSdl(priority);
    data.buf.appendSlice(std.mem.span(message)) catch {};
}

fn testGetLastMessage(data: TestLogCallbackData) []const u8 {
    return data.buf.items[data.last_str..];
}

// Test logging functionality.
test "Log" {
    const backup = getLogOutputFunction();
    try std.testing.expectEqual(getDefaultLogOutputFunction(), backup.callback);

    var log_arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer log_arena.deinit();
    const allocator = log_arena.allocator();

    var log_out = std.ArrayList(u8).init(allocator);
    var data = TestLogCallbackData{
        .buf = &log_out,
    };

    setLogOutputFunction(testLogCallback, &data);
    log("Hello World!");
    try std.testing.expectEqualStrings("Hello World!", testGetLastMessage(data));
    try std.testing.expectEqual(Category.application, data.last_category);
    try std.testing.expectEqual(.Info, data.last_priority);

    const category = Category.render;
    category.setPriority(.Critical);
    try std.testing.expectEqual(.Critical, category.getPriority());
    category.setPriority(.Error);
    try std.testing.expectEqual(.Error, category.getPriority());

    setAllPriorities(.Trace);
    try std.testing.expectEqual(.Trace, Category.application.getPriority());

    category.log(.Verbose, "a");
    try std.testing.expectEqualStrings("a", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.Verbose, data.last_priority);

    category.logCritical("b");
    try std.testing.expectEqualStrings("b", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.Critical, data.last_priority);

    category.logDebug("c");
    try std.testing.expectEqualStrings("c", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.Debug, data.last_priority);

    category.logError("d");
    try std.testing.expectEqualStrings("d", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.Error, data.last_priority);

    category.logInfo("e");
    try std.testing.expectEqualStrings("e", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.Info, data.last_priority);

    category.logTrace("f");
    try std.testing.expectEqualStrings("f", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.Trace, data.last_priority);

    category.logVerbose("g");
    try std.testing.expectEqualStrings("g", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.Verbose, data.last_priority);

    category.logWarn("h");
    try std.testing.expectEqualStrings("h", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.Warn, data.last_priority);

    // Prefix only takes effect with default function for some reason? So we can not really test this.
    const pri = Priority.Info;
    try pri.setPrefix("[INFO]: ");
    try pri.setPrefix(null);

    resetAllPriorities();
    try std.testing.expectEqual(.Info, Category.application.getPriority());
    setLogOutputFunction(backup.callback, backup.user_data);
}
