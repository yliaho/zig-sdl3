const C = @import("c.zig").C;
const io_stream = @import("io_stream.zig");
const errors = @import("errors.zig");

// TODO: UPDATE IO DOCS!!!

/// An opaque handle representing a system process.
///
/// This datatype is available since SDL 3.2.0.
pub const Process = packed struct {
    value: *C.SDL_Process,

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

    /// Process creation properties.
    ///
    /// ## Version
    /// Provided by zig-sdl3.
    pub const CreateProperties = struct {
        /// A slice of strings containing the program to run, any arguments, and a `null` pointer,
        /// e.g. const char *args[] = { "myprogram", "argument", null }.
        args: [:null]const ?[*:0]const u8,
    };

    /// Process properties.
    ///
    /// ## Version
    /// Provided by zig-sdl3.
    pub const Properties = struct {
        pid: i64,
        // TODO!!!
    };

    /// Destroy a previously created process object.
    ///
    /// ## Function Parameters
    /// * `self`: The process object to destroy.
    ///
    /// ## Remarks
    /// Note that this does not stop the process, just destroys the SDL object used to track it.
    /// If you want to stop the process you should use `Process.kill()`.
    ///
    /// ## Thread Safety
    /// This function is not thread safe.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn deinit(
        self: Process,
    ) void {
        C.SDL_DestroyProcess(self.value);
    }

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

    /// Get the `io_stream.Stream` associated with process standard input.
    ///
    /// ## Function Parameters
    /// * `self`: The process to get the input stream for.
    ///
    /// ## Return Value
    /// Returns the input stream.
    ///
    /// ## Remarks
    /// The process must have been created with `Process.init()` and `pipe_stdio` set to true,
    /// or with `Process.initWithProperties()` and `stdin` set to `Process.Stdio.app`.
    ///
    /// Writing to this stream can return less data than expected if the process hasn't read its input.
    /// It may be blocked waiting for its output to be read, if so you may need to call `Process.getOutput()` and read the output in parallel with writing input.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getInput(
        self: Process,
    ) !io_stream.Stream {
        return .{ .value = try errors.wrapNull(*C.SDL_IOStream, C.SDL_GetProcessOutput(self.value)) };
    }

    /// Get the `io_stream.Stream` associated with process standard output.
    ///
    /// ## Function Parameters
    /// * `self`: The process to get the output stream for.
    ///
    /// ## Return Value
    /// Returns the output stream.
    ///
    /// ## Remarks
    /// The process must have been created with `Process.init()` and `pipe_stdio` set to true,
    /// or with `Process.initWithProperties()` and `stdout` set to `Process.Stdio.app`.
    ///
    /// Reading from this stream can return 0 with `io_stream.Stream.getStatus()` returning `io_stream.Status.not_ready` if no output is available yet.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getOutput(
        self: Process,
    ) !io_stream.Stream {
        return .{ .value = try errors.wrapNull(*C.SDL_IOStream, C.SDL_GetProcessOutput(self.value)) };
    }

    /// Stop a process.
    ///
    /// ## Function Parameters
    /// * `self`: The process to stop.
    /// * `force`: True to terminate the process immediately, false to try to stop the process gracefully. In general you should try to stop the process gracefully first as terminating a process may leave it with half-written data or in some other unstable state.
    ///
    /// ## Thread Safety
    /// This function is not thread safe.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn kill(
        self: Process,
        force: bool,
    ) !void {
        return errors.wrapCallBool(C.SDL_KillProcess(self.value, force));
    }

    /// Read all the output from a process.
    ///
    /// ## Function Parameters
    /// * `self`: The process to read.
    ///
    /// ## Return Value
    /// Returns the data read, must be freed with `stdinc.free()`.
    /// Also returns the exit code if the process exited.
    ///
    /// ## Remarks
    /// If a process was created with I/O enabled, you can use this function to read the output.
    /// This function blocks until the process is complete, capturing all output, and providing the process exit code.
    ///
    /// The data is allocated with a zero byte at the end (null terminated) for convenience.
    /// This extra byte is not included in the value reported via datasize.
    ///
    /// The data should be freed with `stdinc.free()`.
    ///
    /// ## Thread Safety
    /// This function is not thread safe.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn read(
        self: Process,
    ) !struct { data: []u8, exit_code: c_int } {
        var size: usize = undefined;
        var exit_code: c_int = undefined;
        const ret = C.SDL_ReadProcess(self.value, &size, &exit_code);
        return .{
            .data = @as([*]u8, @alignCast(@ptrCast(try errors.wrapCallNull(*anyopaque, ret))))[0..@intCast(size)],
            .exit_code = exit_code,
        };
    }

    /// Wait for a process to finish.
    ///
    /// ## Function Parameters
    /// * `self`: The process to wait for.
    /// * `block`: If true, block until the process finishes; otherwise, report on the process' status.
    ///
    /// ## Return Value
    /// Returns the process exit code if the process exited, or `null` otherwise.
    pub fn wait(
        self: Process,
        block: bool,
    ) ?c_int {
        var exit_code: c_int = undefined;
        const ret = C.SDL_WaitProcess(self.value, block, &exit_code);
        if (!ret)
            return null;
        return exit_code;
    }
};

// Process creation and such.
test "Process" {
    // Process.init // TODO!!!
    // Process.initWithProperties // TODO!!!
    // Process.deinit()
    // Process.getInput
    // Process.getOutput
    // Process.getProperties // TODO!!!
    // Process.kill()
    // Process.read()
    // Process.wait()
}
