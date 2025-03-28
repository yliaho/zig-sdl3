const C = @import("c.zig").C;
const errors = @import("errors.zig");
const filesystem = @import("filesystem.zig");
const std = @import("std");

// TODO: ADJUST DOCS!!!

/// Function interface for `storage.Storage`.
///
/// ## Remarks
/// Apps that want to supply a custom implementation of `storage.Storage` will fill in all the functions in this struct,
/// and then pass it to `storage.open()` to create a custom `storage.Storage` object.
///
/// It is not usually necessary to do this; SDL provides standard implementations for many things you might expect to do with a `storage.Storage`.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Interface = struct {
    /// Called when storage is closed.
    close: *const fn (user_data: ?*anyopaque) callconv(.C) bool,
    /// Returns whether the storage is currently ready for access.
    ready: ?*const fn (user_data: ?*anyopaque) callconv(.C) bool,
    // TODO: REST OF ITEMS!!!
};

/// An abstract interface for filesystem access.
///
/// ## Remarks
/// This is an opaque datatype.
/// One can create this object using standard SDL functions like `storage.openTitle()` or `storage.openUser()`, etc,
/// or create an object with a custom implementation using `storage.open()`.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Storage = packed struct {
    value: *C.SDL_Storage,

    /// Copy a file in a writable storage container.
    ///
    /// ## Function Parameters
    /// * `self`: A storage container.
    /// * `old_path`: The old path.
    /// * `new_path`: The new path.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn copyFile(
        self: Storage,
        old_path: [:0]const u8,
        new_path: [:0]const u8,
    ) !void {
        return errors.wrapCallBool(C.SDL_CopyStorageFile(self.value, old_path.ptr, new_path.ptr));
    }

    /// Create a directory in a writable storage container.
    ///
    /// ## Function Parameters
    /// * `storage`: A storage container.
    /// * `path`: The path of the directory to create.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn createDirectory(
        self: Storage,
        path: [:0]const u8,
    ) !void {
        return errors.wrapCallBool(C.SDL_CreateStorageDirectory(self.value, path.ptr));
    }

    /// Enumerate a directory in a storage container through a callback function.
    ///
    /// ## Function Parameters
    /// * `self`: A storage container.
    /// * `path`: The path of the directory to enumerate or `null` for root.
    /// * `callback`: A function that is called for each entry in the directory.
    /// * `user_data`: A pointer that is passed to callback.
    ///
    /// ## Remarks
    /// This function provides every directory entry through an app-provided callback, called once for each directory entry,
    /// until all results have been provided or the callback returns either `filesystem.EnumerationResult.success` or `filesystem.EnumerationResult.failure`.
    ///
    /// This will return and error if there was a system problem in general, or if a callback returns `filesystem.EnumerationResult.failure`.
    /// A successful return means a callback returned `filesystem.EnumerationResult.success` to halt enumeration, or all directory entries were enumerated.
    ///
    /// If path is `null`, this is treated as a request to enumerate the root of the storage container's tree.
    /// An empty string also works for this.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn enumerateDirectory(
        storage: Storage,
        path: ?[:0]const u8,
        callback: filesystem.EnumerateDirectoryCallback,
        user_data: ?*anyopaque,
    ) !void {
        return errors.wrapCallBool(C.SDL_EnumerateStorageDirectory(storage, if (path) |val| val.ptr else null, callback, user_data));
    }

    /// Closes and frees a storage container.
    ///
    /// ## Function Parameters
    /// * `self`: A storage container to close.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn deinit(
        self: Storage,
    ) !void {
        return errors.wrapCallBool(C.SDL_CloseStorage(self.value));
    }
};

// Storage testing.
test "Storage" {
    // Storage.deinit
    // Storage.copyFile
    // Storage.createDirectory
    // Storage.enumerateDirectory
}
