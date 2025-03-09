const C = @import("c.zig").C;
const errors = @import("errors.zig");
const std = @import("std");
const video = @import("video.zig");

// TODO: REVIEW TO SEE IF ALL FUNCTION DOCS NAME CORRECT FUNCTIONS!

/// The type of action to request from `events.peep()`.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const Action = enum(c_uint) {
    /// Add events to the back of the queue.
    Add,
    /// Check but don't remove events from the queue front.
    Peek,
    /// Retrieve/remove events from the front of the queue.
    Get,
};

/// A function pointer used for callbacks that watch the event queue.
///
/// ## Function Parameters
/// * `user_data`: What was passed as `user_data` to `events.setFilter()` or `events.addWatch()`.
/// * `event`: The event that triggered the callback.
///
/// ## Return Value
/// Returns true to permit event to be added to the queue, and false to disallow it.
/// When used with `events.addWatch()`, the return value is ignored.
///
/// ## Thread Safety
/// SDL may call this callback at any time from any thread; the application is responsible for locking resources the callback touches that need to be protected.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const Filter = *const fn (user_data: ?*anyopaque, event: [*c]C.SDL_Event) callconv(.C) bool;

/// For clearing out a group of events.
///
/// ## Version
/// This enum is provided by zig-sdl3.
pub const Group = enum {
    /// Clear all events.
    all,
    /// Application based events.
    application,
    /// Display events.
    display,
    /// Window events.
    window,
    /// Keyboard events.
    keyboard,
    /// Mouse events.
    mouse,
    /// Joystick events.
    joystick,
    /// Gamepad events.
    gamepad,
    /// Touch events.
    touch,
    /// Clipboard events.
    clipboard,
    /// Drag and drop events.
    drag_and_drop,
    /// Audio hotplug events.
    audio,
    /// Sensor events.
    sensor,
    /// Pressure-sensitive pen events.
    pen,
    /// Camera hotplug events.
    camera,
    /// Render events.
    render,
    /// Reserved events for private platforms.
    reserved,
    /// Internal events.
    internal,
    /// User events.
    user,

    /// Check if an event type is in a group.
    ///
    /// ## Function Parameters
    /// * `self`: Group to check the event is in.
    /// * `event_type`: Type of the event to see if it is in a specified group.
    ///
    /// ## Return Value
    /// Returns if the `event_type` is in the `self` group.
    ///
    /// ## Thread Safety
    /// This function may be called from any thread.
    ///
    /// ## Version
    /// Provided by zig-sdl3.
    pub fn eventIn(
        self: Group,
        event_type: Type,
    ) bool {
        const raw: C.SDL_EventType = @intFromEnum(event_type);
        const minmax = self.minMax();
        return raw >= minmax.min and raw <= minmax.max;
    }

    /// Get the minimum and maximum `c.SDL_EventType` for the provided group.
    ///
    /// ## Function Parameters
    /// * `self`: Group to get the min and max types for.
    ///
    /// ## Return Value
    /// Returns the minimum and maximum SDL event types for its raw enum.
    ///
    /// ## Thread Safety
    /// This function may be called from any thread.
    ///
    /// ## Version
    /// Provided by zig-sdl3.
    pub fn minMax(
        self: Group,
    ) struct { min: C.SDL_EventType, max: C.SDL_EventType } {
        return switch (self) {
            .all => .{ .min = 0, .max = std.math.maxInt(C.SDL_EventType) },
            .application => .{ .min = C.SDL_EVENT_QUIT, .max = C.SDL_EVENT_SYSTEM_THEME_CHANGED },
            .display => .{ .min = C.SDL_EVENT_DISPLAY_FIRST, .max = C.SDL_EVENT_DISPLAY_LAST },
            .window => .{ .min = C.SDL_EVENT_WINDOW_FIRST, .max = C.SDL_EVENT_WINDOW_LAST },
            .keyboard => .{ .min = C.SDL_EVENT_KEY_DOWN, .max = C.SDL_EVENT_TEXT_EDITING_CANDIDATES },
            .mouse => .{ .min = C.SDL_EVENT_MOUSE_MOTION, .max = C.SDL_EVENT_MOUSE_REMOVED },
            .joystick => .{ .min = C.SDL_EVENT_JOYSTICK_AXIS_MOTION, .max = C.SDL_EVENT_JOYSTICK_UPDATE_COMPLETE },
            .gamepad => .{ .min = C.SDL_EVENT_GAMEPAD_AXIS_MOTION, .max = C.SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED },
            .touch => .{ .min = C.SDL_EVENT_FINGER_DOWN, .max = C.SDL_EVENT_FINGER_CANCELED },
            .clipboard => .{ .min = C.SDL_EVENT_CLIPBOARD_UPDATE, .max = C.SDL_EVENT_CLIPBOARD_UPDATE },
            .drag_and_drop => .{ .min = C.SDL_EVENT_DROP_FILE, .max = C.SDL_EVENT_DROP_POSITION },
            .audio => .{ .min = C.SDL_EVENT_AUDIO_DEVICE_ADDED, .max = C.SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED },
            .sensor => .{ .min = C.SDL_EVENT_SENSOR_UPDATE, .max = C.SDL_EVENT_SENSOR_UPDATE },
            .pen => .{ .min = C.SDL_EVENT_PEN_PROXIMITY_IN, .max = C.SDL_EVENT_PEN_AXIS },
            .camera => .{ .min = C.SDL_EVENT_CAMERA_DEVICE_ADDED, .max = C.SDL_EVENT_CAMERA_DEVICE_DENIED },
            .render => .{ .min = C.SDL_EVENT_RENDER_TARGETS_RESET, .max = C.SDL_EVENT_RENDER_DEVICE_LOST },
            .reserved => .{ .min = C.SDL_EVENT_PRIVATE0, .max = C.SDL_EVENT_PRIVATE3 },
            .internal => .{ .min = C.SDL_EVENT_POLL_SENTINEL, .max = C.SDL_EVENT_POLL_SENTINEL },
            .user => .{ .min = C.SDL_EVENT_USER, .max = C.SDL_EVENT_LAST },
        };
    }
};

/// The types of events that can be delivered.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const Type = enum(C.SDL_EventType) {
    /// User-requested quit.
    quit = C.SDL_EVENT_QUIT,
    // /// The application is being terminated by the OS.
    // /// This event must be handled in a callback set with `events.addWatch()`.
    // /// Called on iOS in `applicationWillTerminate()`.
    // /// Called on Android in `onDestroy()`.
    // terminating = C.SDL_EVENT_TERMINATING,
    // /// The application is low on memory, free memory if possible.
    // /// This event must be handled in a callback set with `events.addWatch()`.
    // low_memory = C.SDL_EVENT_LOW_MEMORY,
    // /// The application is about to enter the background.
    // /// This event must be handled in a callback set with `events.addWatch()`.
    // /// Called on iOS in `applicationWillResignActive()`.
    // /// Called on Android in `onPause()`.
    // WillEnterBackground = C.SDL_EVENT_WILL_ENTER_BACKGROUND,
    // DidEnterBackground,
    // WillEnterForeground,
    // DidEnterForeground,
    // LocaleChanged,
    // SystemThemeChanged,
    // DisplayOrientation,
    // DisplayAdded,
    // DisplayRemoved,
    // DisplayMoved,
    // DisplayDesktopModeChanged,
    // DisplayCurrentModeChanged,
    // DisplayContentScaleChanged,
    // WindowShown,
    // WindowHidden,
    // WindowExposed,
    // WindowMoved,
    // WindowResized,
    // WindowPixelSizeChanged,
    // WindowMetalViewResized,
    // WindowMinimized,
    // WindowMaximized,
    // WindowRestored,
    // WindowMouseEnter,
    // WindowMouseLeave,
    // WindowFocusGained,
    // WindowFocusLost,
    // WindowCloseRequested,
    // WindowHitTest,
    // WindowIccProfChanged,
    // WindowDisplayChanged,
    // WindowDisplayScaleChanged,
    // WindowSafeAreaChanged,
    // WindowOccluded,
    // WindowEnterFullscreen,
    // WindowLeaveFullscreen,
    // WindowDestroyed,
    // WindowHdrStateChanged,
    // KeyDown,
    // KeyUp,
    // TextEditing,
    // TextInput,
    // KeymapChanged,
    // KeyboardAdded,
    // KeyboardRemoved,
    // TextEditingCandidates,
    // MouseMotion,
    // MouseButtonDown,
    // MouseButtonUp,
    // MouseWheel,
    // MouseAdded,
    // MouseRemoved,
    // JoystickAxisMotion,
    // JoystickBallMotion,
    // JoystickHatMotion,
    // JoystickButtonDown,
    // JoystickButtonUp,
    // JoystickAdded,
    // JoystickRemoved,
    // JoystickBatteryUpdated,
    // JoystickUpdateComplete,
    // GamepadAxisMotion,
    // GamepadButtonDown,
    // GamepadButtonUp,
    // GamepadAdded,
    // GamepadRemoved,
    // GamepadRemapped,
    // GamepadTouchpadDown,
    // GamepadTouchpadMotion,
    // GamepadTouchpadUp,
    // GamepadSensorUpdate,
    // GamepadUpdateComplete,
    // GamepadSteamHandleUpdate,
    // FingerDown,
    // FingerUp,
    // FingerMotion,
    // FingerCanceled,
    // ClipboardUpdate,
    // DropFile,
    // DropText,
    // DropBegin,
    // DropComplete,
    // DropPosition,
    // AudioDeviceAdded,
    // AudioDeviceRemoved,
    // AudioDeviceFormatChanged,
    // SensorUpdate,
    // PenProximityIn,
    // PenProximityOut,
    // PenDown,
    // PenUp,
    // PenButtonDown,
    // PenButtonUp,
    // PenMotion,
    // PenAxis,
    // CameraDeviceAdded,
    // CameraDeviceRemoved,
    // CameraDeviceApproved,
    // CameraDeviceDenied,
    // RenderTargetsReset,
    // RenderDeviceReset,
    // RenderDeviceLost,
    // Private0,
    // Private1,
    // Private2,
    // Private3,
    /// An unknown event type.
    unknown = C.SDL_EVENT_FIRST,
    /// For padding out the union.
    padding = C.SDL_EVENT_ENUM_PADDING,
    // _,
};

/// Fields shared by every event.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Common = struct {
    /// In nanoseconds, populated using `timer.getNanosecondsSinceInit()`.
    timestamp: u64,

    /// Create a common event from an SDL one.
    fn fromSdl(event: *const C.SDL_Event) Common {
        return .{ .timestamp = event.common.timestamp };
    }
};

/// An unknown event.
pub const Unknown = struct {
    /// Common event information.
    common: Common,
    /// Event type that was not known.
    event_type: C.SDL_EventType,
};

/// The "quit requested" event.
pub const Quit = struct {
    /// Common event information.
    common: Common,
};

/// Needed to calculate padding.
const DummyEnum = enum(C.SDL_EventType) {
    empty,
};

/// Needed to calculate padding.
const DummyUnion = union(DummyEnum) {
    empty: void,
};

/// The structure for all events in SDL.
///
/// TODO!!!
pub const Event = union(Type) {
    /// Quit request event data.
    quit: Quit,
    /// An unknown event.
    unknown: Unknown,
    // Padding to make union the same size of a `C.SDL_Event`.
    padding: [@sizeOf(C.SDL_Event) - @sizeOf(DummyUnion)]u8,

    /// Create a managed event from an SDL event.
    ///
    /// ## Function Parameters
    /// * `event`: SDL event to manage.
    ///
    /// ## Return Value
    /// A managed event union.
    ///
    /// ## Remarks
    /// This makes a copy of the event provided.
    ///
    /// ## Version
    /// This function is provided by zig-sdl3.
    pub fn fromSdl(event: C.SDL_Event) Event {
        return switch (event.type) {
            C.SDL_EVENT_QUIT => .{ .quit = .{
                .common = Common.fromSdl(&event),
            } },
            else => .{ .unknown = .{
                .common = Common.fromSdl(&event),
                .event_type = event.type,
            } },
        };
    }

    /// Create a managed event from an SDL event in place.
    ///
    /// ## Function Parameters
    /// * `event`: SDL event to manage. The `event` passed in will be unusable after.
    ///
    /// ## Return Value
    /// A managed event union.
    ///
    /// ## Remarks
    /// This will modify memory in-place.
    /// This means that using the `event` passed into this afterwards will result in undefined behavior.
    ///
    /// ## Version
    /// This function is provided by zig-sdl3.
    pub fn fromSdlInPlace(event: *C.SDL_Event) *Event {
        const managed: *Event = @ptrCast(event);
        managed.* = fromSdl(event.*);
        return managed;
    }

    /// Get window associated with an event.
    ///
    /// ## Function Parameters
    /// * `self`: An event containing a window.
    ///
    /// ## Return Value
    /// Returns the associated window on success or `null` if there is none.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getWindow(
        self: Event,
    ) ?video.Window {
        const event = toSdl(self);
        const ret = C.SDL_GetWindowFromEvent(&event);
        if (ret) |val| {
            return .{ .value = val };
        }
        return null;
    }

    /// Create an unmanaged event from an SDL event.
    ///
    /// ## Function Parameters
    /// * `event`: Managed event to unmanage.
    ///
    /// ## Return Value
    /// Returns an unmanaged SDL event.
    ///
    /// ## Remarks
    /// This makes a copy of the event provided.
    ///
    /// ## Version
    /// This function is provided by zig-sdl3.
    pub fn toSdl(event: Event) C.SDL_Event {
        return switch (event) {
            .quit => |val| .{ .quit = .{ .type = C.SDL_EVENT_QUIT, .timestamp = val.common.timestamp } },
        };
    }

    /// Create an unmanaged event from an SDL event in place.
    ///
    /// ## Function Parameters
    /// * `event`: Managed event to unmanage. The `event` passed in will be unusable after.
    ///
    /// ## Return Value
    /// Returns an unmanaged SDL event.
    ///
    /// ## Remarks
    /// This will modify memory in-place.
    /// This means that using the `event` passed into this afterwards will result in undefined behavior.
    ///
    /// ## Version
    /// This function is provided by zig-sdl3.
    pub fn toSdlInPlace(event: *Event) *C.SDL_Event {
        const unmanaged: *C.SDL_Event = @ptrCast(event);
        unmanaged.* = toSdl(event.*);
        return unmanaged;
    }
};

/// Add a callback to be triggered when an event is added to the event queue.
///
/// ## Function Parameters
/// * `event_filter`: An `events.Filter` function to call when an event happens.
/// * `user_data`: A pointer that is passed to `event_filter`.
///
/// ## Remarks
/// The `event_filter` will be called when an event happens, and its return value is ignored.
///
/// WARNING: Be very careful of what you do in the event filter function, as it may run in a different thread!
///
/// If the quit event is generated by a signal (e.g. SIGINT), it will bypass the internal queue and be delivered to the watch callback immediately,
/// and arrive at the next event poll.
///
/// Note: the callback is called for events posted by the user through `events.push()`, but not for disabled events,
/// nor for events by a filter callback set with `events.setFilter()`, nor for events posted by the user through `events.peep()`.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn addWatch(
    event_filter: Filter,
    user_data: ?*anyopaque,
) !void {
    return errors.wrapCallBool(C.SDL_AddEventWatch(event_filter, user_data));
}

/// Query the state of processing events by type.
///
/// ## Function Parameters
/// * `event_type`: The type of event.
///
/// ## Return Value
/// Returns true if the event is being processed, false otherwise.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn enabled(
    event_type: Type,
) bool {
    return C.SDL_EventEnabled(@intFromEnum(event_type));
}

/// Run a specific filter function on the current event queue, removing any events for which the filter returns false.
///
/// ## Function Parameters
/// * `event_filter`: An `events.Filter` function to call when an event happens.
/// * `user_data`: A pointer that is passed to `event_filter`.
///
/// ## Remarks
/// See `events.setFilter()` for more information.
/// Unlike `events.setFilter()`, this function does not change the filter permanently, it only uses the supplied filter until this function returns.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn filter(
    event_filter: Filter,
    user_data: ?*anyopaque,
) void {
    C.SDL_FilterEvents(event_filter, user_data);
}

/// Clear events of a specific type from the event queue.
///
/// ## Function Parameters
/// * `event_type`: The type of event to be cleared.
///
/// ## Remarks
/// This will unconditionally remove any events from the queue that match type.
/// If you need to remove a range of event types, use `Group.flush()` instead.
///
/// It's also normal to just ignore events you don't care about in your event loop without calling this function.
///
/// This function only affects currently queued events.
/// If you want to make sure that all pending OS events are flushed, you can call `events.pump()` on the main thread immediately before the flush call.
///
/// If you have user events with custom data that needs to be freed,
/// you should use `events.peep()` to remove and clean up those events before calling this function.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn flush(
    event_type: Type,
) void {
    C.SDL_FlushEvent(@intFromEnum(event_type));
}

/// Clear events of a range of types from the event queue.
///
/// ## Function Parameters
/// * `group`: The group of event types to flush from the event queue.
///
/// ## Remarks
/// This will unconditionally remove any events from the queue that are in the range of the category.
/// If you need to remove a single event type, use `events.flush()` instead.
///
/// It's also normal to just ignore events you don't care about in your event loop without calling this function.
///
/// This function only affects currently queued events.
/// If you want to make sure that all pending OS events are flushed, you can call `events.pump()` on the main thread immediately before the flush call.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn flushGroup(
    group: Group,
) void {
    const minmax = group.minMax();
    C.SDL_FlushEvents(minmax.min, minmax.max);
}

/// Query the current event filter.
///
/// ## Return Value
/// Returns the current event filter and user data passed to it.
/// This will return `null` if no event filter has been set.
///
/// ## Remarks
/// This function can be used to "chain" filters, by saving the existing filter before replacing it with a function that will call that saved filter.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// This function is available since SDL 3.2.0.
pub fn getFilter() ?struct { event_filter: Filter, user_data: ?*anyopaque } {
    var event_filter: C.SDL_FunctionPointer = undefined;
    var user_data: ?*anyopaque = undefined;
    const ret = C.SDL_GetEventFilter(&event_filter, &user_data);
    if (!ret)
        return null;
    return .{ .event_filter = @ptrCast(event_filter), .user_data = user_data };
}

/// Check for the existence of a certain event type in the event queue.
///
/// ## Function Parameters
/// * `event_type`: The type of event to be queried.
///
/// ## Return Value
/// Returns true if events matching type are present, or false if events matching type are not present.
///
/// ## Remarks
/// If you need to check for a range of event types, use `events.hasGroup()` instead.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
pub fn has(
    event_type: Type,
) bool {
    return C.SDL_HasEvent(@enumFromInt(event_type));
}

/// Check for the existence of certain event types in the event queue.
///
/// ## Function Parameters
/// * `group`: The group to check for if present in the event queue.
///
/// ## Return Value
/// Returns true if events matching the group are present, or false if events matching the group are not present.
///
/// ## Remarks
/// If you need to check for a single event type, use `events.has()` instead.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn hasGroup(
    group: Group,
) bool {
    const minmax = group.minMax();
    return C.SDL_HasEvents(minmax.min, minmax.max);
}

// Test SDL events.
test "Events" {
    comptime try std.testing.expectEqual(@sizeOf(C.SDL_Event), @sizeOf(Event));

    // addWatch
    // enabled
    // filter
    // flush
    // flushGroup
    // Group.eventIn
    // Group.minMax
    // getFilter
    // Event.getWindow
    // has
    // hasGroup
}
