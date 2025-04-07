// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// An enum of some common joystick types.
pub const Type = enum(c_uint) {
    Gamepad = C.SDL_JOYSTICK_TYPE_GAMEPAD,
    Wheel = C.SDL_JOYSTICK_TYPE_WHEEL,
    ArcadeStick = C.SDL_JOYSTICK_TYPE_ARCADE_STICK,
    FlightStick = C.SDL_JOYSTICK_TYPE_FLIGHT_STICK,
    DancePad = C.SDL_JOYSTICK_TYPE_DANCE_PAD,
    Guitar = C.SDL_JOYSTICK_TYPE_GUITAR,
    DrumKit = C.SDL_JOYSTICK_TYPE_DRUM_KIT,
    ArcadePad = C.SDL_JOYSTICK_TYPE_ARCADE_PAD,
    Throttle = C.SDL_JOYSTICK_TYPE_THROTTLE,
};

/// Possible connection states for a joystick device.
pub const ConnectionState = enum(c_int) {
    Wired = C.SDL_JOYSTICK_CONNECTION_WIRED,
    Wireless = C.SDL_JOYSTICK_CONNECTION_WIRELESS,
};

/// Get the current state of a POV hat on a joystick.
pub const Hat = enum(u8) {
    Centered = C.SDL_HAT_CENTERED,
    Up = C.SDL_HAT_UP,
    Right = C.SDL_HAT_RIGHT,
    Down = C.SDL_HAT_DOWN,
    Left = C.SDL_HAT_LEFT,
    RightUp = C.SDL_HAT_RIGHTUP,
    RightDown = C.SDL_HAT_RIGHTDOWN,
    LeftUp = C.SDL_HAT_LEFTUP,
    LeftDown = C.SDL_HAT_LEFTDOWN,
};

/// This is a unique ID for a joystick for the time it is connected to the system, and is never reused for the lifetime of the application.
pub const ID = struct {
    value: C.SDL_JoystickID,

    /// Get the implementation dependent name of a joystick.
    pub fn getName(
        self: ID,
    ) [:0]const u8 {
        const ret = C.SDL_GetJoystickNameForID(
            self.value,
        );
        if (ret == null)
            return error.SdlError;
        return std.mem.span(ret);
    }

    /// Get the implementation dependent path of a joystick.
    pub fn getPath(
        self: ID,
    ) [:0]const u8 {
        const ret = C.SDL_GetJoystickPathForID(
            self.value,
        );
        if (ret == null)
            return error.SdlError;
        return std.mem.span(ret);
    }

    /// Get the player index of a joystick.
    pub fn getPlayerIndex(
        self: ID,
    ) ?u31 {
        const ret = C.SDL_GetJoystickPlayerIndexForID(
            self.value,
        );
        if (ret == -1)
            return null;
        return @intCast(ret);
    }

    /// Get the implementation-dependent GUID of a joystick.
    pub fn getGUID(
        self: ID,
    ) guid.GUID {
        const ret = C.SDL_GetJoystickGUIDForID(
            self.value,
        );
        return guid.GUID{ .value = ret };
    }

    /// Get the USB vendor ID of a joystick, if available.
    pub fn getVendor(
        self: ID,
    ) u16 {
        const ret = C.SDL_GetJoystickVendorForID(
            self.value,
        );
        return @intCast(ret);
    }

    /// Get the USB product ID of a joystick, if available.
    pub fn getProduct(
        self: ID,
    ) u16 {
        const ret = C.SDL_GetJoystickProductForID(
            self.value,
        );
        return @intCast(ret);
    }

    /// Get the product version of a joystick, if available.
    pub fn getProductVersion(
        self: ID,
    ) u16 {
        const ret = C.SDL_GetJoystickProductVersionForID(
            self.value,
        );
        return @intCast(ret);
    }

    /// Get the type of a joystick, if available.
    pub fn getType(
        self: ID,
    ) ?Type {
        const ret = C.SDL_GetJoystickTypeForID(
            self.value,
        );
        if (ret == C.SDL_JOYSTICK_TYPE_UNKNOWN)
            return null;
        return @enumFromInt(ret);
    }

    /// Get the SDL_Joystick associated with an instance ID, if it has been opened.
    pub fn getJoystick(
        self: ID,
    ) Joystick {
        const ret = C.SDL_GetJoystickFromID(
            self.value,
        );
        if (ret == null)
            return error.SdlError;
        return Joystick{ .value = ret.? };
    }

    /// Detach a virtual joystick.
    pub fn detachVirtual(
        self: ID,
    ) bool {
        const ret = C.SDL_DetachVirtualJoystick(
            self.value,
        );
        if (!ret)
            return error.SdlError;
        return ret;
    }

    /// Query whether or not a joystick is virtual.
    pub fn isVirtual(
        self: ID,
    ) bool {
        const ret = C.SDL_IsJoystickVirtual(
            self.value,
        );
        return ret;
    }

    /// Get a list of currently connected joysticks.
    pub fn getAll(allocator: std.mem.Allocator) ![]ID {
        var count: c_int = undefined;
        const ret = C.SDL_GetJoysticks(&count);
        if (ret == null)
            return error.SdlError;
        defer C.SDL_free(ret);
        var converted_ret = try allocator.alloc(ID, @intCast(count));
        for (0..count) |ind| {
            converted_ret[ind].value = ret[ind];
        }
        return converted_ret;
    }
};

/// The joystick structure used to identify an SDL joystick.
pub const Joystick = struct {
    value: *C.SDL_Joystick,

    /// Open a joystick for use.
    pub fn init(
        id: ID,
    ) Joystick {
        const ret = C.SDL_OpenJoystick(
            id.value,
        );
        if (ret == null)
            return error.SdlError;
        return Joystick{ .value = ret.? };
    }

    /// Get the SDL_Joystick associated with a player index.
    pub fn fromPlayerIndex(
        index: u31,
    ) Joystick {
        const ret = C.SDL_GetJoystickFromPlayerIndex(
            @intCast(index),
        );
        if (ret == null)
            return error.SdlError;
        return Joystick{ .value = ret.? };
    }

    /// Set the state of an axis on an opened virtual joystick.
    pub fn setVirtualAxis(
        self: Joystick,
        axis_index: u31,
        value: i16,
    ) !void {
        const ret = C.SDL_SetJoystickVirtualAxis(
            self.value,
            @intCast(axis_index),
            @intCast(value),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Generate ball motion on an opened virtual joystick.
    pub fn setVirtualBall(
        self: Joystick,
        ball_index: u31,
        x_rel: i16,
        y_rel: i16,
    ) !void {
        const ret = C.SDL_SetJoystickVirtualBall(
            self.value,
            @intCast(ball_index),
            @intCast(x_rel),
            @intCast(y_rel),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Set the state of a button on an opened virtual joystick.
    pub fn setVirtualButton(
        self: Joystick,
        button_index: u31,
        value: bool,
    ) !void {
        const ret = C.SDL_SetJoystickVirtualButton(
            self.value,
            @intCast(button_index),
            value,
        );
        if (!ret)
            return error.SdlError;
    }

    /// Set the state of a hat on an opened virtual joystick.
    pub fn setVirtualHat(
        self: Joystick,
        hat_index: u31,
        value: Hat,
    ) !void {
        const ret = C.SDL_SetJoystickVirtualHat(
            self.value,
            @intCast(hat_index),
            @intFromEnum(value),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Set touchpad finger state on an opened virtual joystick.
    pub fn setVirtualTouchpad(
        self: Joystick,
        touchpad_index: u31,
        finger_index: u31,
        down: bool,
        x: f32,
        y: f32,
        pressure: f32,
    ) !void {
        const ret = C.SDL_SetJoystickVirtualTouchpad(
            self.value,
            @intCast(touchpad_index),
            @intCast(finger_index),
            down,
            @floatCast(x),
            @floatCast(y),
            @floatCast(pressure),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Send a sensor update for an opened virtual joystick.
    pub fn sendVirtualSensorData(
        self: Joystick,
        sensor_type: sensor.Type,
        sensor_timestamp_nanoseconds: u64,
        data: []const f32,
    ) !void {
        const ret = C.SDL_SendJoystickVirtualSensorData(
            self.value,
            @intFromEnum(sensor_type),
            @intCast(sensor_timestamp_nanoseconds),
            data.ptr,
            @intCast(data.len),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Get the properties associated with a joystick.
    pub fn getProperties(
        self: Joystick,
    ) properties.Group {
        const ret = C.SDL_GetJoystickProperties(
            self.value,
        );
        if (ret == 0)
            return error.SdlError;
        return properties.Group{ .value = ret };
    }

    /// Get the implementation dependent name of a joystick.
    pub fn getName(
        self: Joystick,
    ) ![:0]const u8 {
        const ret = C.SDL_GetJoystickName(
            self.value,
        );
        if (ret == null)
            return error.SdlError;
        return std.mem.span(ret);
    }

    /// Get the implementation dependent path of a joystick.
    pub fn getPath(
        self: Joystick,
    ) ![:0]const u8 {
        const ret = C.SDL_GetJoystickPath(
            self.value,
        );
        if (ret == null)
            return error.SdlError;
        return std.mem.span(ret);
    }

    /// Get the player index of an opened joystick.
    pub fn getPlayerIndex(
        self: Joystick,
    ) ?u31 {
        const ret = C.SDL_GetJoystickPlayerIndex(
            self.value,
        );
        if (ret == -1)
            return null;
        return @intCast(ret);
    }

    /// Set the player index of an opened joystick.
    pub fn setPlayerIndex(
        self: Joystick,
        player_index: ?u31,
    ) !void {
        const ret = C.SDL_SetJoystickPlayerIndex(
            self.value,
            if (player_index) |val| @intCast(val) else -1,
        );
        if (!ret)
            return error.SdlError;
    }

    /// Get the implementation-dependent GUID for the joystick.
    pub fn getGUID(
        self: Joystick,
    ) ?guid.GUID {
        const ret = C.SDL_GetJoystickGUID(
            self.value,
        );
        if (ret == std.mem.containsAtLeast(u8, ret.data, ret.data.len, [_]u8{0}))
            return error.SdlError;
        return guid.GUID{ .value = ret };
    }

    /// Get the USB vendor ID of an opened joystick, if available.
    pub fn getVendorID(
        self: Joystick,
    ) ?u16 {
        const ret = C.SDL_GetJoystickVendor(
            self.value,
        );
        if (ret == 0)
            return null;
        return @intCast(ret);
    }

    /// Get the USB product ID of an opened joystick, if available.
    pub fn getProductID(
        self: Joystick,
    ) ?u16 {
        const ret = C.SDL_GetJoystickProduct(
            self.value,
        );
        if (ret == 0)
            return null;
        return @intCast(ret);
    }

    /// Get the product version of an opened joystick, if available.
    pub fn getProductVersion(
        self: Joystick,
    ) ?u16 {
        const ret = C.SDL_GetJoystickProductVersion(
            self.value,
        );
        if (ret == 0)
            return null;
        return @intCast(ret);
    }

    /// Get the firmware version of an opened joystick, if available.
    pub fn getFirmwareVersion(
        self: Joystick,
    ) ?u16 {
        const ret = C.SDL_GetJoystickFirmwareVersion(
            self.value,
        );
        if (ret == 0)
            return null;
        return @intCast(ret);
    }

    /// Get the serial number of an opened joystick, if available.
    pub fn getSerial(
        self: Joystick,
    ) ?[:0]const u8 {
        const ret = C.SDL_GetJoystickSerial(
            self.value,
        );
        if (ret == null)
            return null;
        return std.mem.span(ret);
    }

    /// Get the type of an opened joystick.
    pub fn getType(
        self: Joystick,
    ) ?Type {
        const ret = C.SDL_GetJoystickType(
            self.value,
        );
        if (ret == C.SDL_JOYSTICK_TYPE_UNKNOWN)
            return null;
        return @enumFromInt(ret);
    }

    /// Get the device information encoded in a GUID structure.
    pub fn getGUIDInfo(
        guid_val: guid.GUID,
    ) struct { vendor: ?u16, product: ?u16, version: ?u16, crc16: ?u16 } {
        var vendor: u16 = undefined;
        var product: u16 = undefined;
        var version: u16 = undefined;
        var crc16: u16 = undefined;
        const ret = C.SDL_GetJoystickGUIDInfo(
            guid_val.value,
            &vendor,
            &product,
            &version,
            &crc16,
        );
        _ = ret;
        return .{ .vendor = if (vendor == 0) null else vendor, .product = if (product == 0) null else product, .version = if (version == 0) null else version, .crc16 = if (crc16 == 0) null else crc16 };
    }

    /// Get the status of a specified joystick.
    pub fn connected(
        self: Joystick,
    ) !void {
        const ret = C.SDL_JoystickConnected(
            self.value,
        );
        if (!ret)
            return error.SdlError;
    }

    /// Get the instance ID of an opened joystick.
    pub fn getID(
        self: Joystick,
    ) !ID {
        const ret = C.SDL_GetJoystickID(
            self.value,
        );
        if (ret == 0)
            return error.SdlError;
        return ID{ .value = ret };
    }

    /// Get the number of general axis controls on a joystick.
    pub fn getNumAxes(
        self: Joystick,
    ) !u31 {
        const ret = C.SDL_GetNumJoystickAxes(
            self.value,
        );
        if (ret == -1)
            return error.SdlError;
        return @intCast(ret);
    }

    /// Get the number of trackballs on a joystick.
    pub fn getNumBalls(
        self: Joystick,
    ) !u31 {
        const ret = C.SDL_GetNumJoystickBalls(
            self.value,
        );
        if (ret == -1)
            return error.SdlError;
        return @intCast(ret);
    }

    /// Get the number of POV hats on a joystick.
    pub fn getNumHats(
        self: Joystick,
    ) !u31 {
        const ret = C.SDL_GetNumJoystickHats(
            self.value,
        );
        if (ret == -1)
            return error.SdlError;
        return @intCast(ret);
    }

    /// Get the number of buttons on a joystick.
    pub fn getNumButtons(
        self: Joystick,
    ) !u31 {
        const ret = C.SDL_GetNumJoystickButtons(
            self.value,
        );
        if (ret == -1)
            return error.SdlError;
        return @intCast(ret);
    }

    /// Set the state of joystick event processing.
    pub fn setEventsEnabled(
        events_enabled: bool,
    ) void {
        const ret = C.SDL_SetJoystickEventsEnabled(
            events_enabled,
        );
        _ = ret;
    }

    /// Query the state of joystick event processing.
    pub fn getEventsEnabled() bool {
        const ret = C.SDL_JoystickEventsEnabled();
        return ret;
    }

    /// Update the current state of the open joysticks.
    pub fn update() void {
        const ret = C.SDL_UpdateJoysticks();
        _ = ret;
    }

    /// Get the current state of an axis control on a joystick.
    pub fn getAxis(
        self: Joystick,
        axis_index: u31,
    ) !i16 {
        const ret = C.SDL_GetJoystickAxis(
            self.value,
            @intCast(axis_index),
        );
        if (ret == 0)
            return error.SdlError;
        return @intCast(ret);
    }

    /// Get the initial state of an axis control on a joystick.
    pub fn getAxisInitialState(
        self: Joystick,
        axis_index: u31,
    ) struct { has_initial_state: bool, state: i16 } {
        var state: i16 = undefined;
        const ret = C.SDL_GetJoystickAxisInitialState(
            self.value,
            @intCast(axis_index),
            &state,
        );
        if (!ret)
            return error.SdlError;
        return .{ .has_initial_state = ret, .state = state };
    }

    /// Get the ball axis change since the last poll.
    pub fn getBall(
        self: Joystick,
        ball_index: u31,
    ) !struct { dx: i32, dy: i32 } {
        var dx: i32 = undefined;
        var dy: i32 = undefined;
        const ret = C.SDL_GetJoystickBall(
            self.value,
            @intCast(ball_index),
            &dx,
            &dy,
        );
        if (!ret)
            return error.SdlError;
        return .{ .dx = @intCast(dx), .dy = @intCast(dy) };
    }

    /// Get the current state of a POV hat on a joystick.
    pub fn getHat(
        self: Joystick,
        hat_index: u31,
    ) Hat {
        const ret = C.SDL_GetJoystickHat(
            self.value,
            @intCast(hat_index),
        );
        return @enumFromInt(ret);
    }

    /// Get the current state of a button on a joystick.
    pub fn getButton(
        self: Joystick,
        button_index: u31,
    ) bool {
        const ret = C.SDL_GetJoystickButton(
            self.value,
            @intCast(button_index),
        );
        return ret;
    }

    /// Start a rumble effect.
    pub fn rumble(
        self: Joystick,
        left_rumble: u16,
        right_rumble: u16,
        duration_milliseconds: u32,
    ) !void {
        const ret = C.SDL_RumbleJoystick(
            self.value,
            @intCast(left_rumble),
            @intCast(right_rumble),
            @intCast(duration_milliseconds),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Start a rumble effect in the joystick's triggers.
    pub fn rumbleTriggers(
        self: Joystick,
        left_rumble: u16,
        right_rumble: u16,
        duration_milliseconds: u32,
    ) !void {
        const ret = C.SDL_RumbleJoystickTriggers(
            self.value,
            @intCast(left_rumble),
            @intCast(right_rumble),
            @intCast(duration_milliseconds),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Update a joystick's LED color.
    pub fn setLED(
        self: Joystick,
        r: u8,
        g: u8,
        b: u8,
    ) !void {
        const ret = C.SDL_SetJoystickLED(
            self.value,
            @intCast(r),
            @intCast(g),
            @intCast(b),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Send a joystick specific effect packet.
    pub fn sendEffect(
        self: Joystick,
        data: []const u8,
    ) !void {
        const ret = C.SDL_SendJoystickEffect(
            self.value,
            data.ptr,
            @intCast(data.len),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Close a joystick previously opened with init.
    pub fn deinit(
        self: Joystick,
    ) void {
        const ret = C.SDL_CloseJoystick(
            self.value,
        );
        _ = ret;
    }

    /// Get the connection state of a joystick.
    pub fn getConnectionState(
        self: Joystick,
    ) !?ConnectionState {
        const ret = C.SDL_GetJoystickConnectionState(
            self.value,
        );
        if (ret == C.SDL_JOYSTICK_CONNECTION_INVALID)
            return error.SdlError;
        if (ret == C.SDL_JOYSTICK_CONNECTION_UNKNOWN)
            return null;
        return @enumFromInt(ret);
    }

    /// Get the battery state of a joystick.
    pub fn getPowerInfo(
        self: Joystick,
    ) !struct { state: power.PowerState, percent: ?u7 } {
        var percent: c_int = undefined;
        const ret = C.SDL_GetJoystickPowerInfo(
            self.value,
            &percent,
        );
        if (ret == C.SDL_POWERSTATE_ERROR)
            return error.SdlError;
        return .{ .state = ret, .percent = if (percent == -1) null else @intCast(percent) };
    }

    /// Locking for atomic access to the joystick API.
    pub fn lockAll() void {
        const ret = C.SDL_LockJoysticks();
        _ = ret;
    }

    /// Unlocking for atomic access to the joystick API.
    pub fn unlockAll() void {
        const ret = C.SDL_UnlockJoysticks();
        _ = ret;
    }

    /// Return whether a joystick is currently connected.
    pub fn hasAnyConnected() bool {
        const ret = C.SDL_HasJoystick();
        return ret;
    }
};

/// Virtual joystick user data.
pub fn VirtualJoystickUserData(comptime UserData: type) type {
    return struct {
        update: *const fn (user_data: *UserData) void,
        set_player_index: *const fn (user_data: *UserData, player_index: u31) void,
        rumble: *const fn (user_data: *UserData, left_rumble: u16, right_rumble: u16) anyerror!void,
        rumble_triggers: *const fn (user_data: *UserData, left_rumble: u16, right_rumble: u16) anyerror!void,
        set_led: *const fn (user_data: *UserData, r: u8, g: u8, b: u8) anyerror!void,
        send_effect: *const fn (user_data: *UserData, data: []const u8) anyerror!void,
        set_sensors_enabled: *const fn (user_data: *UserData, enabled: bool) anyerror!void,
        cleanup: *const fn (user_data: *UserData) void,
        user_data: *UserData,
    };
}
fn virtualJoystickCleanup(user_data: ?*anyopaque) callconv(.C) void {
    const data: VirtualJoystickUserData(anyopaque) = @ptrCast(@alignCast(user_data));
    data.cleanup(data.user_data);
}
fn virtualJoystickRumble(user_data: ?*anyopaque, left_rumble: u16, right_rumble: u16) callconv(.C) bool {
    const data: VirtualJoystickUserData(anyopaque) = @ptrCast(@alignCast(user_data));
    data.rumble(data.user_data, left_rumble, right_rumble) catch return false;
    return true;
}
fn virtualJoystickRumbleTriggers(user_data: ?*anyopaque, left_rumble: u16, right_rumble: u16) callconv(.C) bool {
    const data: VirtualJoystickUserData(anyopaque) = @ptrCast(@alignCast(user_data));
    data.rumble_triggers(data.user_data, left_rumble, right_rumble) catch return false;
    return true;
}
/// Virtual joystick configuration.
pub fn VirtualJoystick(comptime UserData: type) type {
    return struct {
        joystick_type: Type,
        vendor_id: u16,
        product_id: u16,
        num_axes: u16,
        num_buttons: u16,
        num_balls: u16,
        num_hats: u16,
        // button_mask
        // axis_mask
        name: [:0]const u8,
        touchpads: []const struct { num_fingers: u16 },
        sensors: []const struct { sensor_type: sensor.Type, rate: f32 },
        user_data: VirtualJoystickUserData(UserData),
        /// Create a joystick.
        pub fn create() !ID {
            const desc = C.SDL_VirtualJoystickDesc{
                .Cleanup = virtualJoystickCleanup,
                .Rumble = virtualJoystickRumble,
                .RumbleTriggers = virtualJoystickRumbleTriggers,
            };
            const ret = C.SDL_AttachVirtualJoystick(&desc);
            if (ret == 0)
                return error.SdlError;
            return .{ .value = ret };
        }
    };
}

const guid = @import("guid.zig");
const sensor = @import("sensor.zig");
const properties = @import("properties.zig");
const power = @import("power.zig");
