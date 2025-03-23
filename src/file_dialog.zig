const C = @import("c.zig").C;
const errors = @import("errors.zig");
const std = @import("std");

/// Callback used by file dialog functions.
///
/// ## Function Parameters
/// * `user_data`: An app provided pointer for callback's use.
/// * `file_list`: The file(s) chosen by the user.
/// * `filter`: Index of the selected filter.
///
/// ## Remarks
/// The specific usage is described in each function.
///
/// If filelist is:
/// * `null`, an error occurred. Details can be obtained with `errors.get()`.
/// * A pointer to `null`, the user either didn't choose any file or canceled the dialog.
/// * A pointer to non-`null`, the user chose one or more files. The argument is a null-terminated array of pointers to UTF-8 encoded strings, each containing a path.
///
/// The filelist argument should not be freed; it will automatically be freed when the callback returns.
///
/// The filter argument is the index of the filter that was selected,
/// or `-1` if no filter was selected or if the platform or method doesn't support fetching the selected filter.
///
/// In Android, the `file_list` are `content://` URIs.
/// They should be opened using `io.fromFile()` with appropriate modes.
/// This applies both to open and save file dialog.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
///
/// ## Code Examples
/// TODO!!!
pub const FileCallback = *const fn (user_data: ?*anyopaque, file_list: [*c]const [*c]const u8, filter: c_int) void;

/// An entry for filters for file dialogs.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
///
/// ## Code Examples
/// This structure is most often used as an array:
///
/// ```zig
/// const filters = [_]FileFilter {
///     { .name = "PNG images",  .pattern = "png" },
///     { .name = "JPEG images", .pattern = "jpg;jpeg" },
///     { .name = "All images",  .pattern = "png;jpg;jpeg" },
///     { .name = "All files",   .pattern = "*" },
/// };
/// ```
pub const FileFilter = extern struct {
    /// A user-readable label for the filter (for example, "Office document").
    name: [*:0]const u8,
    /// A semicolon-separated list of file extensions (for example, "doc;docx").
    /// File extensions may only contain alphanumeric characters, hyphens, underscores and periods.
    /// Alternatively, the whole string can be a single asterisk ("*"), which serves as an "All files" filter.
    pattern: [*:0]const u8,
};

/// Various types of file dialogs.
///
/// ## Remarks
/// This is used by `file_dialog.showWithProperties()` to decide what kind of dialog to present to the user.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const Type = enum(c_uint) {
    open_file = C.SDL_FILEDIALOG_OPENFILE,
    save_file = C.SDL_FILEDIALOG_SAVEFILE,
    open_folder = C.SDL_FILEDIALOG_OPENFOLDER,
};

// File dialog related tests.
test "File Dialog" {
    comptime try std.testing.expectEqual(@sizeOf(C.SDL_DialogFileFilter), @sizeOf(FileFilter));
    comptime try std.testing.expectEqual(@offsetOf(C.SDL_DialogFileFilter, "name"), @offsetOf(FileFilter, "name"));
    comptime try std.testing.expectEqual(@sizeOf(@FieldType(C.SDL_DialogFileFilter, "name")), @sizeOf(@FieldType(FileFilter, "name")));
    comptime try std.testing.expectEqual(@offsetOf(C.SDL_DialogFileFilter, "pattern"), @offsetOf(FileFilter, "pattern"));
    comptime try std.testing.expectEqual(@sizeOf(@FieldType(C.SDL_DialogFileFilter, "pattern")), @sizeOf(@FieldType(FileFilter, "pattern")));
}
