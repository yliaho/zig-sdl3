const C = @import("c.zig").C;
const errors = @import("errors.zig");
const std = @import("std");

/// A callback used to free resources when a property is deleted.
///
/// * `user_data`: An app-defined pointer passed to the callback.
/// * `value`: The pointer assigned to the property to clean up.
///
/// This should release any resources associated with value that are no longer needed.
///
/// This callback is set per-property.
/// Different properties in the same group can have different cleanup callbacks.
///
/// This callback will be called during `properties.Group.setPointerPropertyWithCleanup()` if the function fails for any reason.
///
/// This callback may fire without any locks held; if this is a concern, the app should provide its own locking.
///
/// This datatype is available since SDL 3.2.0.
pub const CleanupCallback = *const fn (
    user_data: ?*anyopaque,
    value: ?*anyopaque,
) callconv(.C) void;

/// A callback used to enumerate all the properties in a group of properties.
///
/// * `user_data`: An app-defined pointer passed to the callback.
/// * `props`: The SDL_PropertiesID that is being enumerated.
/// * `name`: The next property name in the enumeration.
///
/// This callback is called from `properties.group.enumerateProperties()`, and is called once per property in the set.
///
/// `properties.group.enumerateProperties()` holds a lock on props during this callback.
///
/// This datatype is available since SDL 3.2.0.
pub const EnumerateCallback = *const fn (
    user_data: ?*anyopaque,
    props: C.SDL_PropertiesID,
    name: [*c]const u8,
) callconv(.C) void;

/// SDL properties type.
///
/// This enum is available since SDL 3.2.0.
pub const Type = enum(c_uint) {
    Pointer = C.SDL_PROPERTY_TYPE_POINTER,
    String = C.SDL_PROPERTY_TYPE_STRING,
    Number = C.SDL_PROPERTY_TYPE_NUMBER,
    Float = C.SDL_PROPERTY_TYPE_FLOAT,
    Boolean = C.SDL_PROPERTY_TYPE_BOOLEAN,
};

/// SDL properties group.
/// Properties can be added or removed at runtime.
///
/// This datatype is available since SDL 3.2.0.
pub const Group = packed struct {
    value: C.SDL_PropertiesID,

    /// Clear a property from a group of properties.
    ///
    /// * `self`: Properties group to modify.
    /// * `name`: The name of the property to clear.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn clear(
        self: Group,
        name: [:0]const u8,
    ) !void {
        const ret = C.SDL_ClearProperty(
            self.value,
            name.ptr,
        );
        return errors.wrapCallBool(ret);
    }

    /// Copy a group of properties.
    ///
    /// * `self`: Properties group to copy from.
    /// * `dest`: The destination properties.
    ///
    /// Copy all the properties from one group of properties to another,
    /// with the exception of properties requiring cleanup (set using `properties.Group.setPointerPropertyWithCleanup()`), which will not be copied.
    /// Any property that already exists on `dest` will be overwritten.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn copyTo(
        self: Group,
        dest: Group,
    ) !void {
        const ret = C.SDL_CopyProperties(
            self.value,
            dest.value,
        );
        return errors.wrapCallBool(ret);
    }

    /// Destroy a group of properties.
    ///
    /// * `self`: Properties to destroy.
    ///
    /// All properties are deleted and their cleanup functions will be called, if any.
    ///
    /// This function should not be called while these properties are locked or other threads might be setting or getting values from these properties.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn deinit(
        self: Group,
    ) void {
        C.SDL_DestroyProperties(
            self.value,
        );
    }

    /// Enumerate the properties contained in a group of properties.
    ///
    /// The callback function is called for each property in the group of properties. The properties are locked during enumeration.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn enumerateProperties(
        self: Group,
        callback: EnumerateCallback,
        user_data: ?*anyopaque,
    ) !void {
        const ret = C.SDL_EnumerateProperties(self.value, callback, user_data);
        return errors.wrapCallBool(ret);
    }

    /// Data for getting all properties.
    const GetAllData = struct {
        map: *std.StringHashMap(Property),
        err: ?std.mem.Allocator.Error,
    };

    /// Get a property from a group of properties.
    ///
    /// * `self`: The properties to query.
    /// * `name`: The name of the property to query.
    ///
    /// Returns the property, or `null` if it does not exist.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn get(
        self: Group,
        name: [:0]const u8,
    ) ?Property {
        return switch (C.SDL_GetPropertyType(self.value, name.ptr)) {
            C.SDL_PROPERTY_TYPE_POINTER => Property{ .Pointer = C.SDL_GetPointerProperty(self.value, name.ptr, null) },
            C.SDL_PROPERTY_TYPE_STRING => Property{ .String = std.mem.span(C.SDL_GetStringProperty(self.value, name.ptr, "")) },
            C.SDL_PROPERTY_TYPE_NUMBER => Property{ .Number = C.SDL_GetNumberProperty(self.value, name.ptr, 0) },
            C.SDL_PROPERTY_TYPE_FLOAT => Property{ .Float = C.SDL_GetFloatProperty(self.value, name.ptr, 0) },
            C.SDL_PROPERTY_TYPE_BOOLEAN => Property{ .Boolean = C.SDL_GetBooleanProperty(self.value, name.ptr, false) },
            else => null,
        };
    }

    /// Used for adding properties to a list.
    fn getAllEnumerateCallback(user_data: ?*anyopaque, id: C.SDL_PropertiesID, name: [*c]const u8) callconv(.C) void {
        const group = Group{ .value = id };
        const data_ptr: *GetAllData = @ptrCast(@alignCast(user_data));
        const spanned_name = std.mem.span(name);
        if (group.get(spanned_name)) |val|
            data_ptr.map.put(spanned_name, val) catch |err| {
                data_ptr.err = err;
            };
    }

    /// Utility function for getting all the properties in the group.
    ///
    /// * `self`: Properties group to get all properties from.
    /// * `allocator`: Memory allocator to use to gather properties into.
    ///
    /// Returns a string hash map of the property or an error.
    ///
    /// Resulting map is owned and needs to be freed.
    ///
    /// This is provided by the wrapper.
    pub fn getAll(
        self: Group,
        allocator: std.mem.Allocator,
    ) !std.StringHashMap(Property) {
        var map = std.StringHashMap(Property).init(allocator);
        var data = GetAllData{
            .map = &map,
            .err = null,
        };
        try self.enumerateProperties(getAllEnumerateCallback, &data);
        if (data.err) |err|
            return err;
        return map;
    }

    /// Get the type of a property in a group of properties.
    ///
    /// * `self`: The properties to query.
    /// * `name`: The name of the property to query.
    ///
    /// Returns null if the property is not found.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn getType(
        self: Group,
        name: [:0]const u8,
    ) ?Type {
        const ret = errors.wrapCall(C.SDL_PropertyType, C.SDL_GetPropertyType(
            self.value,
            name.ptr,
        ), C.SDL_PROPERTY_TYPE_INVALID) catch return null;
        return @enumFromInt(ret);
    }

    /// Return whether a property exists in a group of properties.
    ///
    /// * `self`: The properties to query.
    /// * `name`: The name of the property to query.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn has(
        self: Group,
        name: [:0]const u8,
    ) bool {
        const ret = C.SDL_HasProperty(
            self.value,
            name.ptr,
        );
        return ret;
    }

    /// Create a group of properties.
    ///
    /// All properties are automatically destroyed when `init.shutdown()` is called.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn init() !Group {
        const ret = C.SDL_CreateProperties();
        return Group{ .value = try errors.wrapCall(C.SDL_PropertiesID, ret, 0) };
    }

    /// Lock a group of properties.
    ///
    /// * `self`: The properties to lock.
    ///
    /// Obtain a multi-threaded lock for these properties.
    /// Other threads will wait while trying to lock these properties until they are unlocked.
    /// Properties must be unlocked before they are destroyed.
    ///
    /// The lock is automatically taken when setting individual properties,
    /// this function is only needed when you want to set several properties atomically or want to guarantee that properties being queried aren't freed in another thread.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn lock(
        self: Group,
    ) !void {
        const ret = C.SDL_LockProperties(
            self.value,
        );
        return errors.wrapCallBool(ret);
    }

    /// Set a property in the group.
    ///
    /// * `self`: Group of properties to set property in.
    /// * `name`: Name of property to set.
    /// * `value`: Value of the property to set.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn set(
        self: Group,
        name: [:0]const u8,
        value: Property,
    ) !void {
        const ret = switch (value) {
            .Pointer => |pt| C.SDL_SetPointerProperty(self.value, name, pt),
            .String => |str| C.SDL_SetStringProperty(self.value, name, str),
            .Number => |num| C.SDL_SetNumberProperty(self.value, name, num),
            .Float => |num| C.SDL_SetFloatProperty(self.value, name, num),
            .Boolean => |val| C.SDL_SetBooleanProperty(self.value, name, val),
        };
        return errors.wrapCallBool(ret);
    }

    /// Set a pointer property in a group of properties with a cleanup function that is called when the property is deleted.
    ///
    /// * `self`: The properties to modify.
    /// * `name`: The name of the property to modify.
    /// * `value`: The new value of the property, or `null` to delete the property.
    /// * `cleanup`: The function to call when this property is deleted, or NULL if no cleanup is necessary.
    /// * `user_data`: A pointer that is passed to the cleanup function.
    ///
    /// The cleanup function is also called if setting the property fails for any reason.
    ///
    /// For simply setting basic data types, like numbers, bools, or strings, use `properties.Group.set()` instead, as those functions will handle cleanup on your behalf.
    /// This function is only for more complex, custom data.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn setPointerPropertyWithCleanup(
        self: Group,
        name: [:0]const u8,
        value: ?*anyopaque,
        cleanup: CleanupCallback,
        user_data: ?*anyopaque,
    ) !void {
        const ret = C.SDL_SetPointerPropertyWithCleanup(
            self.value,
            name.ptr,
            value,
            cleanup,
            user_data,
        );
        return errors.wrapCallBool(ret);
    }

    /// Unlock a group of properties.
    ///
    /// * `self`: The properties to unlock.
    ///
    /// It is safe to call this function from any thread.
    ///
    /// This function is available since SDL 3.2.0.
    pub fn unlock(
        self: Group,
    ) void {
        C.SDL_UnlockProperties(
            self.value,
        );
    }
};

/// Property.
pub const Property = union(Type) {
    Pointer: ?*anyopaque,
    String: [:0]const u8,
    Number: i64,
    Float: f32,
    Boolean: bool,
};

/// Get the global SDL properties.
///
/// This function is available since SDL 3.2.0.
pub fn getGlobal() !Group {
    const ret = try errors.wrapCall(C.SDL_PropertiesID, C.SDL_GetGlobalProperties(), 0);
    return Group{ .value = ret };
}

fn testPropertiesCleanupCb(user_data: ?*anyopaque, value: ?*anyopaque) callconv(.C) void {
    _ = user_data;
    const ptr: *std.ArrayList(u32) = @ptrCast(@alignCast(value));
    ptr.deinit();
}

fn testEnumeratePropertiesCb(user_data: ?*anyopaque, id: C.SDL_PropertiesID, name: [*c]const u8) callconv(.C) void {
    _ = user_data;
    _ = id;
    _ = name;
}

// Test out properties.
test "Properties" {
    _ = try getGlobal();
    const group = try Group.init();
    defer group.deinit();
    try group.lock();
    group.unlock();

    try std.testing.expectEqual(false, group.has("trial"));
    try std.testing.expectEqual(null, group.getType("trial"));
    try std.testing.expectEqual(null, group.get("trial"));

    try group.set("trial", Property{ .Boolean = false });
    try std.testing.expectEqual(true, group.has("trial"));
    try std.testing.expectEqual(.Boolean, group.getType("trial"));
    try std.testing.expectEqual(Property{ .Boolean = false }, group.get("trial"));

    try group.set("trial", Property{ .Boolean = true });
    try std.testing.expectEqual(true, group.has("trial"));
    try std.testing.expectEqual(.Boolean, group.getType("trial"));
    try std.testing.expectEqual(Property{ .Boolean = true }, group.get("trial"));

    try group.clear("trial");
    try std.testing.expectEqual(false, group.has("trial"));
    try std.testing.expectEqual(null, group.getType("trial"));
    try std.testing.expectEqual(null, group.get("trial"));

    try group.set("trial", Property{ .String = "Hello World!" });
    try std.testing.expectEqual(true, group.has("trial"));
    try std.testing.expectEqual(.String, group.getType("trial"));
    try std.testing.expectEqualStrings("Hello World!", group.get("trial").?.String);

    try group.set("trial", Property{ .Number = -4 });
    try std.testing.expectEqual(true, group.has("trial"));
    try std.testing.expectEqual(.Number, group.getType("trial"));
    try std.testing.expectEqual(Property{ .Number = -4 }, group.get("trial"));

    try group.set("trial", Property{ .Float = 5.3 });
    try std.testing.expectEqual(true, group.has("trial"));
    try std.testing.expectEqual(.Float, group.getType("trial"));
    try std.testing.expectEqual(Property{ .Float = 5.3 }, group.get("trial"));

    var num: i32 = 3;
    try group.set("trial", Property{ .Pointer = &num });
    try std.testing.expectEqual(true, group.has("trial"));
    try std.testing.expectEqual(.Pointer, group.getType("trial"));
    try std.testing.expectEqual(Property{ .Pointer = &num }, group.get("trial"));

    try group.set("a", Property{ .Number = 5 });
    try group.set("b", Property{ .Boolean = false });
    var arr = std.ArrayList(u32).init(std.testing.allocator);
    try arr.append(8); // Ensure no memory leakage.
    try group.setPointerPropertyWithCleanup("c", &arr, testPropertiesCleanupCb, null);

    const copied = try Group.init();
    defer copied.deinit();
    try group.copyTo(copied);

    var map = try copied.getAll(std.testing.allocator);
    defer map.deinit();
    try std.testing.expectEqual(3, map.count());

    try std.testing.expectEqual(Property{ .Number = 5 }, map.get("a"));
    try std.testing.expectEqual(Property{ .Boolean = false }, map.get("b"));
    try std.testing.expectEqual(Property{ .Pointer = &num }, map.get("trial"));

    try group.enumerateProperties(testEnumeratePropertiesCb, null);
}
