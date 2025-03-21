const C = @import("c.zig").C;
const errors = @import("errors.zig");
const std = @import("std");
const stdinc = @import("stdinc.zig");

/// An enum that describes the type of a touch device.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const DeviceType = enum(c_uint) {
    /// Touch screen with window-relative coordinates.
    direct = C.SDL_TOUCH_DEVICE_DIRECT,
    /// Trackpad with absolute device coordinates.
    indirect_absolute = C.SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE,
    /// Trackpad with screen cursor-relative coordinates.
    indirect_relative = C.SDL_TOUCH_DEVICE_INDIRECT_RELATIVE,
};

/// Data about a single finger in a multitouch event.
///
/// ## Remarks
/// Each touch event is a collection of fingers that are simultaneously in contact with the touch device (so a "touch" can be a "multitouch", in reality),
/// and this struct reports details of the specific fingers.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Finger = extern struct {
    /// The finger ID.
    id: FingerID,
    /// The x-axis location of the touch event, normalized (0...1).
    x: f32,
    /// The y-axis location of the touch event, normalized (0...1).
    y: f32,
    /// The quantity of pressure applied, normalized (0...1).
    pressure: f32,
};

/// A unique ID for a single finger on a touch device.
///
/// ## This ID is valid for the time the finger (stylus, etc) is touching and will be unique for all fingers currently in contact,
/// so this ID tracks the lifetime of a single continuous touch.
/// This value may represent an index, a pointer, or some other unique ID, depending on the platform.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const FingerID = packed struct {
    value: C.SDL_FingerID,

    /// The SDL_TouchID for touch events simulated with mouse input.
    ///
    /// ## Version
    /// This constant is available since SDL 3.2.0.
    pub const mouse = FingerID{ .value = C.SDL_MOUSE_TOUCHID };
};

/// A unique ID for a touch device.
///
/// ## Remarks
/// This ID is valid for the time the device is connected to the system, and is never reused for the lifetime of the application.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const ID = packed struct {
    value: C.SDL_TouchID,

    /// Get a list of active fingers for a given touch device.
    ///
    /// ## Function Parameters
    /// * `self`: The touch device instance.
    ///
    /// ## Return Value
    /// Returns a slice of fingers.
    /// This should be freed with `stdinc.free()` when finished with it.
    ///
    /// ## Value
    /// This function is available since SDL 3.2.0.
    pub fn getFingers(
        self: ID,
    ) ![]*Finger {
        var count: c_int = undefined;
        const val = C.SDL_GetTouchFingers(self.value, &count);
        const ret: [*]*Finger = @ptrCast(try errors.wrapCallCPtr([*c]C.SDL_Finger, val));
        return ret[0..@intCast(count)];
    }

    /// Get the touch device name as reported from the driver.
    ///
    /// ## Function Parameters
    /// * `self`: The touch device instance.
    ///
    /// ## Return Value
    /// Returns the touch device name.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getName(
        self: ID,
    ) ![]const u8 {
        return errors.wrapCallCString(C.SDL_GetTouchDeviceName(self.value));
    }

    /// Get the type of the given touch device.
    ///
    /// ## Function Parameters
    /// * `self`: The touch device instance.
    ///
    /// ## Return Value
    /// Returns touch device type, or `null` if invalid.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getType(
        self: ID,
    ) ?DeviceType {
        const ret = C.SDL_GetTouchDeviceType(self.value);
        if (ret == C.SDL_TOUCH_DEVICE_INVALID)
            return null;
        return @enumFromInt(ret);
    }
};

/// Get a list of registered touch devices.
///
/// ## Return Value
/// Returns a slice of touch device IDs.
/// This should be freed with `stdinc.free()` when no longer needed.
///
/// ## Remarks
/// On some platforms SDL first sees the touch device if it was actually used.
/// Therefore the returned list might be empty, although devices are available.
/// After using all devices at least once the number will be correct.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getDevices() ![]ID {
    var count: c_int = undefined;
    const val = C.SDL_GetTouchDevices(&count);
    const ret: [*]ID = @ptrCast(try errors.wrapCallCPtr(C.SDL_TouchID, val));
    return ret[0..@intCast(count)];
}

// Touching tests.
test "Touch" {
    comptime try std.testing.expectEqual(@sizeOf(C.SDL_Finger), @sizeOf(Finger));
    comptime try std.testing.expectEqual(@offsetOf(C.SDL_Finger, "id"), @offsetOf(Finger, "id"));
    comptime try std.testing.expectEqual(@sizeOf(@FieldType(C.SDL_Finger, "id")), @sizeOf(@FieldType(Finger, "id")));
    comptime try std.testing.expectEqual(@offsetOf(C.SDL_Finger, "x"), @offsetOf(Finger, "x"));
    comptime try std.testing.expectEqual(@sizeOf(@FieldType(C.SDL_Finger, "x")), @sizeOf(@FieldType(Finger, "x")));
    comptime try std.testing.expectEqual(@offsetOf(C.SDL_Finger, "y"), @offsetOf(Finger, "y"));
    comptime try std.testing.expectEqual(@sizeOf(@FieldType(C.SDL_Finger, "y")), @sizeOf(@FieldType(Finger, "y")));
    comptime try std.testing.expectEqual(@offsetOf(C.SDL_Finger, "pressure"), @offsetOf(Finger, "pressure"));
    comptime try std.testing.expectEqual(@sizeOf(@FieldType(C.SDL_Finger, "pressure")), @sizeOf(@FieldType(Finger, "pressure")));

    const devices = try getDevices();
    defer stdinc.free(devices);
    for (devices) |device| {
        _ = try device.getName();
        _ = device.getType();
        const fingers = try device.getFingers();
        defer stdinc.free(fingers);
    }
}
