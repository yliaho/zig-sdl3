const C = @import("c.zig").C;
const std = @import("std");

/// Callback for when an SDL error occurs.
///
/// This is per-thread.
threadlocal var error_callback: ?*const fn (
    err: ?[]const u8,
) void = null;

/// An SDL error.
pub const Error = error{
    SdlError,
};

/// Clear any previous error message for this thread.
///
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn clear() void {
    _ = C.SDL_ClearError();
}

/// Standardize error reporting on unsupported operations.
///
/// This simply calls `errors.set()` with a standardized error string, for convenience, consistency, and clarity.
///
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn invalidParamError(err: [:0]const u8) !void {
    _ = C.SDL_InvalidParamError(err.ptr);
    return error.SdlError;
}

/// Returns a message with information about the specific error that occurred,
/// or null if there hasn't been an error message set since the last call to `errors.clear()`.
///
/// It is possible for multiple errors to occur before calling `errors.get()`.
/// Only the last error is returned.
///
/// The standard way of getting errors is replaced with the zig method.
/// Rely on standard zig error handling, and use the `errors.error_callback` in case callbacks for when an error is encountered.
///
/// SDL will not clear the error string for successful API calls.
/// You must check return values for failure cases before you can assume the error string applies.
///
/// Error strings are set per-thread, so an error set in a different thread will not interfere with the current thread's operation.
///
/// The returned value is a thread-local string which will remain valid until the current thread's error string is changed.
/// The caller should make a copy if the value is needed after the next SDL API call.
///
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn get() ?[]const u8 {
    const ret = C.SDL_GetError();
    const converted_ret = std.mem.span(ret);
    if (std.mem.eql(u8, converted_ret, ""))
        return null;
    return converted_ret;
}

/// Set the SDL error message for the current thread.
///
/// Calling this function will replace any previous error message that was set.
///
/// This function will always return an error.
///
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn set(
    err: [:0]const u8,
) !void {
    _ = C.SDL_SetError(
        "%s",
        err.ptr,
    );
    return error.SdlError;
}

/// Set an error indicating that memory allocation failed.
///
/// This will always return an error.
///
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn signalOutOfMemory() !void {
    _ = C.SDL_OutOfMemory();
    return error.SdlError;
}

/// Standardize error reporting on unsupported operations.
///
/// This simply calls `errors.set()` with a standardized error string, for convenience, consistency, and clarity.
///
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn unsupported() !void {
    _ = C.SDL_Unsupported();
    return error.SdlError;
}

/// Wrap an SDL call with an error check.
/// If the result of the call matches the error_condition, call the error callback and return an error.
/// If the result does not match, then return the result.
///
/// It is safe to call this function from any thread.
///
/// This is provided by zig-sdl3.
pub fn wrapCall(comptime Result: type, result: Result, error_condition: Result) !Result {
    if (result != error_condition)
        return result;
    if (@This().error_callback) |cb| {
        cb(get());
    }
    return error.SdlError;
}

/// Wrap an SDL call that returns a success with an error check.
/// Returns an error if the result is false, otherwise returns void.
///
/// It is safe to call this function from any thread.
///
/// This is provided by zig-sdl3.
pub fn wrapCallBool(result: bool) !void {
    _ = try wrapCall(bool, result, false);
}

// Make sure error getting and setting works properly.
test "Error" {
    clear();
    try std.testing.expectEqual(null, get());
    try std.testing.expectError(error.SdlError, invalidParamError("Hello world"));
    try std.testing.expectEqualStrings("Parameter 'Hello world' is invalid", get().?);
    try std.testing.expectError(error.SdlError, signalOutOfMemory());
    try std.testing.expectEqualStrings("Out of memory", get().?);
    try std.testing.expectError(error.SdlError, set("Hello world"));
    try std.testing.expectEqualStrings("Hello world", get().?);
    try std.testing.expectError(error.SdlError, unsupported());
    try std.testing.expectEqualStrings("That operation is not supported", get().?);
    try std.testing.expectEqual(0, try wrapCall(u8, 0, 1));
    try std.testing.expectError(error.SdlError, wrapCall(u8, 1, 1));
    try wrapCallBool(true);
    try std.testing.expectError(error.SdlError, wrapCallBool(false));
    clear();
    try std.testing.expectEqual(null, get());
}
