const C = @import("c.zig").C;
const errors = @import("errors.zig");

/// The SDL thread priority.
///
/// ## Remarks
/// SDL will make system changes as necessary in order to apply the thread priority.
/// Code which attempts to control thread state related to priority should be aware that calling `thread.setCurrentPriority()` may alter such state.
/// `hints.Type.thread_priority_policy` can be used to control aspects of this behavior.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const Priority = enum(c_uint) {
    low = C.SDL_THREAD_PRIORITY_LOW,
    normal = C.SDL_THREAD_PRIORITY_NORMAL,
    high = C.SDL_THREAD_PRIORITY_HIGH,
    time_critical = C.SDL_THREAD_PRIORITY_TIME_CRITICAL,
};

/// The SDL thread state.
///
/// ## Remarks
/// The current state of a thread can be checked by calling `thread.Thread.getState()`.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const State = enum(c_uint) {
    /// The thread is currently running.
    alive,
    /// The thread is detached and can't be waited on.
    detached,
    /// The thread has finished and should be cleaned up with `thread.Thread.wait()`.
    complete,

    /// From and SDL value.
    pub fn fromSdl(value: C.SDL_ThreadState) ?State {
        if (value == C.SDL_THREAD_UNKNOWN)
            return null;
        return @enumFromInt(value);
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: ?State) C.SDL_ThreadState {
        if (self) |val|
            return @intFromEnum(val);
        return C.SDL_THREAD_UNKNOWN;
    }
};
