const C = @import("c.zig").C;
const errors = @import("errors.zig");
const filesystem = @import("filesystem.zig");
const properties = @import("properties.zig");
const std = @import("std");

// TODO: ADJUST DOCS!!!

/// Function interface for `Storage`.
///
/// ## Remarks
/// Apps that want to supply a custom implementation of `Storage` will fill in all the functions in this struct,
/// and then pass it to `Storage.init()` to create a custom `Storage` object.
///
/// It is not usually necessary to do this; SDL provides standard implementations for many things you might expect to do with a `Storage`.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Interface = struct {
    /// Called when storage is closed.
    deinit: *const fn (user_data: ?*anyopaque) callconv(.C) bool,
    /// Returns whether the storage is currently ready for access.
    ready: ?*const fn (user_data: ?*anyopaque) callconv(.C) bool,
    /// Enumerate a directory, optional for write-only storage.
    enumerate: ?*const fn (user_data: ?*anyopaque, path: [*c]const u8, callback: filesystem.EnumerateDirectoryCallback, callback_user_data: ?*anyopaque) callconv(.C) bool,
    /// Get path information, optional for write-only storage.
    info: ?*const fn (user_data: ?*anyopaque, path: [*c]const u8, info: [*c]C.SDL_PathInfo) callconv(.C) bool,
    /// Read a file from storage, optional for write-only storage.
    read_file: ?*const fn (user_data: ?*anyopaque, path: [*c]const u8, destination: ?*anyopaque, length: u64) callconv(.C) bool,
    /// Write a file to storage, optional for read-only storage.
    write_file: ?*const fn (user_data: ?*anyopaque, path: [*c]const u8, source: ?*const anyopaque, length: u64) callconv(.C) bool,
    /// Create a directory, optional for read-only storage.
    mkdir: ?*const fn (user_data: ?*anyopaque, path: [*c]const u8) callconv(.C) bool,
    /// Remove a file or empty directory, optional for read-only storage.
    remove: ?*const fn (user_data: ?*anyopaque, path: [*c]const u8) callconv(.C) bool,
    /// Rename a path, optional for read-only storage.
    rename: ?*const fn (user_data: ?*anyopaque, old_path: [*c]const u8, new_path: [*c]const u8) callconv(.C) bool,
    /// Copy a file, optional for read-only storage.
    copy: ?*const fn (user_data: ?*anyopaque, old_path: [*c]const u8, new_path: [*c]const u8) callconv(.C) bool,
    /// Get the space remaining, optional for read-only storage.
    space_remaining: ?*const fn (user_data: ?*anyopaque) callconv(.C) u64,
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

    /// Opens up a container using a client-provided storage interface.
    ///
    /// ## Function Parameters
    /// * `interface`: The interface that implements this storage.
    /// * `user_data`: The pointer that will be passed to the interface functions.
    ///
    /// ## Remarks
    /// Applications do not need to use this function unless they are providing their own `Storage` implementation.
    /// If you just need an `Storage`, you should use the built-in implementations in SDL, like `Storage.initTitle()` or `Storage.initUser()`.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn init(
        interface: Interface,
        user_data: ?*anyopaque,
    ) !Storage {
        const iface = C.SDL_StorageInterface{
            .close = interface.deinit,
            .ready = interface.ready,
            .enumerate = interface.enumerate,
            .info = interface.info,
            .read_file = interface.read_file,
            .write_file = interface.write_file,
            .mkdir = interface.mkdir,
            .remove = interface.remove,
            .rename = interface.rename,
            .copy = interface.copy,
            .space_remaining = interface.space_remaining,
        };
        return .{
            .value = try errors.wrapNull(*C.SDL_Storage, C.SDL_OpenStorage(&iface, user_data)),
        };
    }

    /// Opens up a container for local filesystem storage.
    ///
    /// ## Function Parameters
    /// * `path`: Base path prepended to all storage paths, or `null` for no base path.
    ///
    /// ## Return Value
    /// Returns a filesystem storage container.
    ///
    /// ## Remarks
    /// This is provided for development and tools.
    /// Portable applications should use `Storage.initTitle()` for access to game data and `Storage.initUser()` for access to user data.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn initFile(
        path: ?[:0]const u8,
    ) !Storage {
        return .{
            .value = try errors.wrapNull(*C.SDL_Storage, C.SDL_OpenFileStorage(if (path) |val| val.ptr else null)),
        };
    }

    /// Opens up a read-only container for the application's filesystem.
    ///
    /// ## Function Parameters
    /// * `override`: A path to override the backend's default title root.
    /// * `props`: A property list that may contain backend-specific information.
    ///
    /// ## Return Value
    /// Returns a title storage container
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn initTitle(
        override: ?[:0]const u8,
        props: ?properties.Group,
    ) !Storage {
        return .{
            .value = try errors.wrapNull(*C.SDL_Storage, C.SDL_OpenTitleStorage(if (override) |val| val.ptr else null, if (props) |val| val.value else 0)),
        };
    }

    /// Opens up a container for a user's unique read/write filesystem.
    ///
    /// ## Function Parameters
    /// * `org`: The name of your organization.
    /// * `app`: The name of your application.
    /// * `props`: A property list that may contain backend-specific information.
    ///
    /// ## Return Value
    /// Returns a user storage container.
    ///
    /// ## Remarks
    /// when the client is ready to read/write files.
    /// This allows the backend to properly batch file operations and flush them when the container has been closed; ensuring safe and optimal save I/O.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn initUser(
        org: [:0]const u8,
        app: [:0]const u8,
        props: ?properties.Group,
    ) !Storage {
        return .{
            .value = try errors.wrapNull(*C.SDL_Storage, C.SDL_OpenUserStorage(org.ptr, app.ptr, if (props) |val| val.value else 0)),
        };
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
        return errors.wrapCallBool(C.SDL_EnumerateStorageDirectory(storage.value, if (path) |val| val.ptr else null, callback, user_data));
    }

    /// Query the size of a file within a storage container.
    ///
    /// ## Function Parameters
    /// * `self`: A storage container to query.
    /// * `path`: The relative path of the file to query.
    ///
    /// ## Return Value
    /// Returns the file's length.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getFileSize(
        self: Storage,
        path: [:0]const u8,
    ) !u64 {
        var size: u64 = undefined;
        try errors.wrapCallBool(C.SDL_GetStorageFileSize(self.value, path.ptr, &size));
        return size;
    }

    /// Get information about if a filesystem path in a storage container exists.
    ///
    /// ## Function Parameters
    /// * `self`: A storage container to query.
    /// * `path`: The path to query.
    ///
    /// ## Return Value
    /// Returns if the path exists.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getPathExists(
        self: Storage,
        path: [:0]const u8,
    ) bool {
        return C.SDL_GetStoragePathInfo(self.value, path.ptr, null);
    }

    /// Get information about a filesystem path in a storage container.
    ///
    /// ## Function Parameters
    /// * `self`: A storage container to query.
    /// * `path`: The path to query.
    ///
    /// ## Return Value
    /// Returns the path info for the path.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getPathInfo(
        self: Storage,
        path: [:0]const u8,
    ) !filesystem.PathInfo {
        var info: filesystem.PathInfo = undefined;
        try errors.wrapCallBool(C.SDL_GetStoragePathInfo(self.value, path.ptr, &info));
        return .{
            .path_type = filesystem.PathType.fromSdl(info.type),
            .file_size = info.size,
            .create_time = .{ .value = info.create_time },
            .modify_time = .{ .value = info.modify_time },
            .access_time = .{ .value = info.access_time },
        };
    }

    /// Queries the remaining space in a storage container.
    ///
    /// ## Function Parameters
    /// * `self`: A storage container to query.
    ///
    /// ## Return Value
    /// Returns the amount of remaining space, in bytes.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getSpaceRemaining(
        self: Storage,
    ) u64 {
        return C.SDL_GetStorageSpaceRemaining(self.value);
    }

    /// Enumerate a directory tree, filtered by pattern, and return a list.
    ///
    /// ## Function Parameters
    /// * `storage`: A storage container.
    /// * `path`: The path of the directory to enumerate, or `null` for root.
    /// * `pattern`: The pattern that files in the directory must match. Can be `null`.
    /// * `flags`: Flags to effect the search.
    ///
    /// ## Return Value
    /// Returns a slice of strings on success.
    /// This should be freed with `stdinc.free()`
    ///
    /// ## Remarks
    /// Files are filtered out if they don't match the string in pattern, which may contain wildcard characters '*' (match everything) and '?' (match one character).
    /// If pattern is `null`, no filtering is done and all results are returned.
    /// Subdirectories are permitted, and are specified with a path separator of '/'.
    /// Wildcard characters '*' and '?' never match a path separator.
    ///
    /// The `flags` may have `case_insensitive` to `true` to make the pattern matching case-insensitive.
    ///
    /// If path is `null`, this is treated as a request to enumerate the root of the storage container's tree.
    /// An empty string also works for this.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn globDirectory(
        self: Storage,
        path: ?[:0]const u8,
        pattern: ?[:0]const u8,
        flags: filesystem.GlobFlags,
    ) ![][*:0]u8 {
        var count: c_int = undefined;
        const ret: [*][*:0]u8 = @ptrCast(try errors.wrapCallCPtr([*c]u8, C.SDL_GlobStorageDirectory(
            self.value,
            if (path) |val| val.ptr else null,
            if (pattern) |val| val.ptr else null,
            flags.toSdl(),
            &count,
        )));
        return ret[0..@intCast(count)];
    }

    /// Synchronously read a file from a storage container into a client-provided buffer.
    ///
    /// ## Function Parameters
    /// * `self`: A storage container to read from.
    /// * `path`: The relative path of the file to read.
    /// * `destination`: A client-provided buffer to read the file into.
    ///
    /// ## Remarks
    /// The value of length must match the length of the file exactly; call `Storage.getFileSize()` to get this value.
    /// This behavior may be relaxed in a future release.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn readFile(
        self: Storage,
        path: [:0]const u8,
        destination: []u8,
    ) !void {
        return errors.wrapCallBool(C.SDL_ReadStorageFile(self.value, path.ptr, destination.ptr, @intCast(destination.len)));
    }

    /// Remove a file or an empty directory in a writable storage container.
    ///
    /// ## Function Parameters
    /// * `self`: A storage container.
    /// * `path`: The path to remove.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn removePath(
        self: Storage,
        path: [:0]const u8,
    ) !void {
        return errors.wrapCallBool(C.SDL_RemoveStoragePath(self.value, path.ptr));
    }

    /// Rename a file or directory in a writable storage container.
    ///
    /// ## Function Parameters
    /// * `self`: A storage container.
    /// * `old_path`: The old path.
    /// * `new_path`: The new path.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn renamePath(
        self: Storage,
        old_path: [:0]const u8,
        new_path: [:0]const u8,
    ) !void {
        return errors.wrapCallBool(C.SDL_RenameStoragePath(self.value, old_path, new_path));
    }

    /// Checks if the storage container is ready to use.
    ///
    /// ## Function Parameters
    /// * `self`: A storage container to query.
    ///
    /// ## Return Value
    /// Returns true if the container is ready, false otherwise.
    ///
    /// ## Remarks
    /// This function should be called in regular intervals until it returns true - however, it is not recommended to spinwait on this call,
    /// as the backend may depend on a synchronous message loop.
    /// You might instead poll this in your game's main loop while processing events and drawing a loading screen.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn ready(
        self: Storage,
    ) bool {
        return C.SDL_StorageReady(self.value);
    }

    /// Synchronously write a file from client memory into a storage container.
    ///
    /// ## Function Parameters
    /// * `storage`: A storage container to write to.
    /// * `path`: The relative path of the file to write.
    /// * `source`: A client-provided buffer to write from.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn writeFile(
        self: Storage,
        path: [:0]const u8,
        source: []const u8,
    ) !void {
        return errors.wrapCallBool(C.SDL_WriteStorageFile(self.value, path.ptr, source.ptr, @intCast(source.len)));
    }
};

// Storage testing.
test "Storage" {
    // Storage.deinit
    // Storage.copyFile
    // Storage.createDirectory
    // Storage.enumerateDirectory
    // Storage.getFileSize
    // Storage.getPathExists
    // Storage.getPathInfo
    // Storage.getSpaceRemaining
    // Storage.globDirectory
    // Storage.init
    // Storage.initFile
    // Storage.initTitle
    // Storage.initUser
    // Storage.readFile
    // Storage.removePath
    // Storage.renamePath
    // Storage.ready
    // Storage.writeFile
}
