const C = @import("c.zig").C;
const errors = @import("errors.zig");
const std = @import("std");

/// The prototype for the log output callback function.
///
/// ## Function Parameters
/// * `user_data`: What was passed as userdata to `log.setLogOutputFunction()`.
/// * `category`: The category of the message.
/// * `priority`: The priority of the message.
/// * `message`: The message being output.
///
/// ## Thread Safety
/// This function is called by SDL when there is new text to be logged.
/// A mutex is held so that this function is never called by more than one thread at once.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const LogOutputFunction = *const fn (
    user_data: ?*anyopaque,
    category: c_int,
    priority: C.SDL_LogPriority,
    message: [*c]const u8,
) callconv(.C) void;

/// The predefined log priorities.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const Priority = enum(c_uint) {
    trace = C.SDL_LOG_PRIORITY_TRACE,
    verbose = C.SDL_LOG_PRIORITY_VERBOSE,
    debug = C.SDL_LOG_PRIORITY_DEBUG,
    info = C.SDL_LOG_PRIORITY_INFO,
    warn = C.SDL_LOG_PRIORITY_WARN,
    err = C.SDL_LOG_PRIORITY_ERROR,
    critical = C.SDL_LOG_PRIORITY_CRITICAL,

    /// Make a priority from an SDL value.
    pub fn fromSdl(val: c_uint) ?Priority {
        if (val == C.SDL_LOG_PRIORITY_INVALID)
            return null;
        return @enumFromInt(val);
    }

    /// Set the text prepended to log messages of a given priority.
    ///
    /// ## Function Parameters
    /// * `self`: The priority to modify.
    /// * `prefix`: The prefix to use for that log priority, or `null` to use no prefix.
    ///
    /// ## Remarks
    /// By default `log.Priority.info` and below have no prefix, and `log.priority.warn` and higher have a prefix showing their priority, e.g. "WARNING: ".
    ///
    /// Note that prefixes will only effect the default log callback and not any custom ones.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
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
/// ## Remarks
/// By default the application and gpu categories are enabled at the INFO level,
/// the assert category is enabled at the WARN level,
/// test is enabled at the VERBOSE level,
/// and all other categories are enabled at the ERROR level.
///
/// ## Version
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
    /// ## Function Parameters
    /// * `self`: The category to query.
    ///
    /// ## Return Value
    /// Returns the `log.Priority` for the requested query.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getPriority(
        self: Category,
    ) Priority {
        return @enumFromInt(C.SDL_GetLogPriority(self.value));
    }

    /// Log a message with the specified category and priority.
    ///
    /// ## Function Parameters
    /// * `self`: The category of the message.
    /// * `priority`: The priority of the message.
    /// * `str`: String to log.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
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
    /// ## Function Parameters
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
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

    /// Log a message with `log.Priority.debug`.
    ///
    /// ## Function Parameters
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
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

    /// Log a message with `log.Priority.err`.
    ///
    /// ## Function Parameters
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
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

    /// Log a message with `log.Priority.info`.
    ///
    /// ## Function Parameters
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
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

    /// Log a message with `log.Priority.trace`.
    ///
    /// ## Function Parameters
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
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

    /// Log a message with `log.Priority.verbose`.
    ///
    /// ## Function Parameters
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
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

    /// Log a message with `log.Priority.warn`.
    ///
    /// ## Function Parameters
    /// * `self`: Category of the message.
    /// * `str`: String to log.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
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
    /// ## Function Parameters
    /// * `self`: The category to assign the priority to.
    /// * `priority`: The log priority to assign.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
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
/// ## Return Value
/// Returns the default log output callback.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getDefaultLogOutputFunction() LogOutputFunction {
    return C.SDL_GetDefaultLogOutputFunction().?;
}

/// Get the current log output function.
///
/// ## Return Value
/// * `callback`: A `log.LogOutputFunction` filled in with the current log `callback`.
/// * `user_data`: A pointer filled in with the pointer that is passed to `callback`.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
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

/// Log a message with `log.Category.application` and `log.Priority.info`.
///
/// ## Function Parameters
/// * `str`: The string to log.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
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
/// ## Remarks
/// This is called by `init.shutdown()`.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn resetAllPriorities() void {
    C.SDL_ResetLogPriorities();
}

/// Set the priority of all log categories.
///
/// ## Function Parameters
/// * `priority`: The priority to assign to all categories.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
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
/// ## Function Parameters
/// * `callback`: A `log.LogOutputFunction` to call instead of the default.
/// * `user_data`: A pointer that is passed to `callback`.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
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
    std.testing.refAllDeclsRecursive(@This());

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
    try std.testing.expectEqual(.info, data.last_priority);

    const category = Category.render;
    category.setPriority(.critical);
    try std.testing.expectEqual(.critical, category.getPriority());
    category.setPriority(.err);
    try std.testing.expectEqual(.err, category.getPriority());

    setAllPriorities(.trace);
    try std.testing.expectEqual(.trace, Category.application.getPriority());

    category.log(.verbose, "a");
    try std.testing.expectEqualStrings("a", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.verbose, data.last_priority);

    category.logCritical("b");
    try std.testing.expectEqualStrings("b", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.critical, data.last_priority);

    category.logDebug("c");
    try std.testing.expectEqualStrings("c", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.debug, data.last_priority);

    category.logError("d");
    try std.testing.expectEqualStrings("d", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.err, data.last_priority);

    category.logInfo("e");
    try std.testing.expectEqualStrings("e", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.info, data.last_priority);

    category.logTrace("f");
    try std.testing.expectEqualStrings("f", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.trace, data.last_priority);

    category.logVerbose("g");
    try std.testing.expectEqualStrings("g", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.verbose, data.last_priority);

    category.logWarn("h");
    try std.testing.expectEqualStrings("h", testGetLastMessage(data));
    try std.testing.expectEqual(category, data.last_category);
    try std.testing.expectEqual(.warn, data.last_priority);

    // Prefix only takes effect with default function for some reason? So we can not really test this.
    const pri = Priority.info;
    try pri.setPrefix("[INFO]: ");
    try pri.setPrefix(null);

    resetAllPriorities();
    try std.testing.expectEqual(.info, Category.application.getPriority());
    setLogOutputFunction(backup.callback, backup.user_data);
}
