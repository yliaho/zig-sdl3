const C = @import("c.zig").C;
const errors = @import("errors.zig");

// TODO: UPDATE IO DOCS!!!

/// Description of where standard I/O should be directed when creating a process.
///
/// ## Remarks
/// If a standard I/O stream is set to `process.IO.Inherited`, it will go to the same place as the application's I/O stream.
/// This is the default for standard output and standard error.
///
/// If a standard I/O stream is set to `process.IO.Ignored`, it is connected to `NUL` on Windows and `/dev/null` on POSIX systems.
/// This is the default for standard input.
///
/// If a standard I/O stream is set to `process.IO.App`, it is connected to a new `io_stream.Stream` that is available to the application.
/// Standard input will be available as SDL_PROP_PROCESS_STDIN_POINTER and allows SDL_GetProcessInput(),
/// standard output will be available as SDL_PROP_PROCESS_STDOUT_POINTER and allows SDL_ReadProcess() and SDL_GetProcessOutput(),
/// and standard error will be available as SDL_PROP_PROCESS_STDERR_POINTER in the properties for the created process.
///
/// If a standard I/O stream is set to SDL_PROCESS_STDIO_REDIRECT, it is connected to an existing SDL_IOStream provided by the application.
/// Standard input is provided using SDL_PROP_PROCESS_CREATE_STDIN_POINTER, standard output is provided using SDL_PROP_PROCESS_CREATE_STDOUT_POINTER,
/// and standard error is provided using SDL_PROP_PROCESS_CREATE_STDERR_POINTER in the creation properties.
/// These existing streams should be closed by the application once the new process is created.
///
/// In order to use an SDL_IOStream with `process.IO.Redirect`, it must have SDL_PROP_IOSTREAM_WINDOWS_HANDLE_POINTER or SDL_PROP_IOSTREAM_FILE_DESCRIPTOR_NUMBER set.
/// This is true for streams representing files and process I/O.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const IO = enum(c_uint) {
    /// The I/O stream is inherited from the application.
    Inherited = C.SDL_PROCESS_STDIO_INHERITED,
    /// The I/O stream is ignored.
    Ignored = C.SDL_PROCESS_STDIO_NULL,
    /// The I/O stream is connected to a new `io_stream.Stream` that the application can read or write.
    App = C.SDL_PROCESS_STDIO_APP,
    /// The I/O stream is redirected to an existing `io_stream.Stream`.
    Redirect = C.SDL_PROCESS_STDIO_REDIRECT,
};

/// An opaque handle representing a system process.
///
/// This datatype is available since SDL 3.2.0.
pub const Process = packed struct {
    value: *C.SDL_Process,

    /// Process creation properties.
    ///
    /// ## Version
    /// Provided by zig-sdl3.
    pub const CreateProperties = struct {
        /// A slice of strings containing the program to run, any arguments, and a `null` pointer,
        /// e.g. const char *args[] = { "myprogram", "argument", null }.
        args: [:null]const ?[*:0]const u8,
    };

    /// Create a new process.
    ///
    /// ## Function Parameters
    /// * `init`: The path and arguments for the new process.
    /// * `pipe_stdio`: True to create pipes to the process's standard input and from the process's standard output, false for the process to have no input and inherit the application's standard output.
    ///
    /// ## Return Value
    /// Returns the newly created and running process.
    ///
    /// ## Remarks
    /// The path to the executable is supplied in args[0]. args[1..N] are additional arguments passed on the command line of the new process, and the argument list should be terminated with a NULL, e.g.:
    ///
    /// const char *args[] = { "myprogram", "argument", NULL };
    /// Setting pipe_stdio to true is equivalent to setting SDL_PROP_PROCESS_CREATE_STDIN_NUMBER and SDL_PROP_PROCESS_CREATE_STDOUT_NUMBER to SDL_PROCESS_STDIO_APP, and will allow the use of SDL_ReadProcess() or SDL_GetProcessInput() and SDL_GetProcessOutput().
    ///
    /// See SDL_CreateProcessWithProperties() for more details.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn init(
        args: []const [*:0]u8,
        pipe_stdio: bool,
    ) !Process {
        const ret = C.SDL_CreateProcess(
            @ptrCast(args.ptr),
            pipe_stdio,
        );
        return .{ .value = try errors.wrapNull(*C.SDL_Process, ret) };
    }
};

// Process creation and such.
test "Process" {
    // Process.init
}
