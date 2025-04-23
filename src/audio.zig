const C = @import("c.zig").C;
const errors = @import("errors.zig");
const std = @import("std");

/// A callback that fires when data is about to be fed to an audio device.
///
/// ## Function Parameters
/// * `user_data`: A pointer provided by the app through `audio.setPostmixCallback()`, for its own use.
/// * `spec`: The current format of audio that is to be submitted to the audio device.
/// * `buffer`: The buffer of audio samples to be submitted. The callback can inspect and/or modify this data.
/// * `buffer_len`: The size of `buffer` in bytes.
///
/// ## Remarks
/// This is useful for accessing the final mix,
/// perhaps for writing a visualizer or applying a final effect to the audio data before playback.
///
/// This callback should run as quickly as possible and not block for any significant time,
/// as this callback delays submission of data to the audio device, which can cause audio playback problems.
///
/// The postmix callback must be able to handle any audio data format specified in spec,
/// which can change between callbacks if the audio device changed.
/// However, this only covers frequency and channel count; data is always provided here in `audio.Format.floating_32_bit` format.
///
/// The postmix callback runs after logical device gain and audiostream gain have been applied,
/// which is to say you can make the output data louder at this point than the gain settings would suggest.
///
/// ## Thread Safety
/// This will run from a background thread owned by SDL.
/// The application is responsible for locking resources the callback touches that need to be protected.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const PostmixCallback = *const fn (user_data: ?*anyopaque, spec: *const C.SDL_AudioSpec, buffer: [*]f32, buffer_len: c_int) callconv(.C) void;

/// A callback that fires when data passes through a `Stream`.
///
/// ## Function Parameters
/// * `user_data`: An opaque pointer provided by the app for their personal use.
/// * `stream`: The SDL audio stream associated with this callback.
/// * `additional_amount`: The amount of data, in bytes, that is needed right now.
/// * `total_amount`: The total amount of data requested, in bytes, that is requested or available.
///
/// ## Remarks
/// Apps can (optionally) register a callback with an audio stream that is called when data is added with
/// `audio.Stream.putData()`, or requested with `audio.Stream.getData()`.
///
/// Two values are offered here: one is the amount of additional data needed to satisfy the immediate request
/// (which might be zero if the stream already has enough data queued) and the other is the total amount being requested.
/// In a Get call triggering a Put callback, these values can be different.
/// In a Put call triggering a Get callback, these values are always the same.
///
/// Byte counts might be slightly overestimated due to buffering or resampling, and may change from call to call.
///
/// This callback is not required to do anything.
/// Generally this is useful for adding/reading data on demand, and the app will often put/get data as appropriate,
/// but the system goes on with the data currently available to it if this callback does nothing.
///
/// ## Thread Safety
/// This callbacks may run from any thread, so if you need to protect shared data,
/// you should use SDL_LockAudioStream to serialize access; this lock will be held before your callback is called,
/// so your callback does not need to manage the lock explicitly.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const StreamCallback = *const fn (user_data: ?*anyopaque, stream: *C.SDL_AudioStream, additional_amount: c_int, total_amount: c_int) callconv(.C) void;

/// Audio format.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const Format = struct {
    value: c_uint,
    pub const unsigned_8_bit = Format{ .value = C.SDL_AUDIO_U8 };
    pub const signed_8_bit = Format{ .value = C.SDL_AUDIO_S8 };
    pub const signed_16_bit_little_endian = Format{ .value = C.SDL_AUDIO_S16LE };
    pub const signed_16_bit_big_endian = Format{ .value = C.SDL_AUDIO_S16BE };
    pub const signed_32_bit_little_endian = Format{ .value = C.SDL_AUDIO_S32LE };
    pub const signed_32_bit_big_endian = Format{ .value = C.SDL_AUDIO_S32BE };
    pub const floating_32_bit_little_endian = Format{ .value = C.SDL_AUDIO_F32LE };
    pub const floating_32_bit_big_endian = Format{ .value = C.SDL_AUDIO_F32BE };
    pub const signed_16_bit = Format{ .value = C.SDL_AUDIO_S16 };
    pub const signed_32_bit = Format{ .value = C.SDL_AUDIO_S32 };
    pub const floating_32_bit = Format{ .value = C.SDL_AUDIO_F32 };

    /// Define an audio format.
    ///
    /// ## Function Parameters
    /// * `signed`: True for signed, false for unsigned.
    /// * `big_endian`: True for big endian, false for little endian.
    /// * `float`: True for floating point data, false for integer data.
    /// * `bit_width`: Number of bits per sample.
    ///
    /// ## Return Value
    /// Returns a format value in the style of `audio.Format`.
    ///
    /// ## Remarks
    /// SDL does not support custom audio formats, so this function is not of much use externally,
    /// but it can be illustrative as to what the various bits of an `audio.Format` mean.
    ///
    /// For example, `audio.Format.signed_32_bit_little_endian` looks like this:
    /// ```zig
    /// audio.Format.define(true, false, false, 32)
    /// ```
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn define(
        signed: bool,
        big_endian: bool,
        float: bool,
        bit_width: u8,
    ) Format {
        const ret = C.SDL_DEFINE_AUDIO_FORMAT(
            @intFromBool(signed),
            @intFromBool(big_endian),
            @intFromBool(float),
            @intCast(bit_width),
        );
        return Format{ .value = ret };
    }

    /// Retrieve the size in bits.
    ///
    /// ## Function Parameters
    /// * `self`: The audio format.
    ///
    /// ## Return Value
    /// Returns data size in bits.
    ///
    /// ## Remarks
    /// For example, calling this on `audio.Format.signed_16_bit` returns 16.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getBitwidth(
        self: Format,
    ) u8 {
        const ret = C.SDL_AUDIO_BITSIZE(
            self.value,
        );
        return @intCast(ret);
    }

    /// Get the byte size of the format.
    ///
    /// ## Function Parameters
    /// * `self`: The audio format.
    ///
    /// ## Return Value
    /// Returns data size in bytes.
    ///
    /// ## Remarks
    /// For example, calling this on `audio.Format.signed_16_bit` returns `2`.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getByteSize(
        self: Format,
    ) u8 {
        const ret = C.SDL_AUDIO_BYTESIZE(
            self.value,
        );
        return @intCast(ret);
    }

    /// Get the human readable name of an audio format.
    ///
    /// ## Function Parameters
    /// * `self`: The audio format to query.
    ///
    /// ## Return Value
    /// Returns the human readable name of the specified audio format or `null` if the format is not recognized.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getName(
        self: Format,
    ) ?[:0]const u8 {
        const ret: [:0]const u8 = std.mem.span(C.SDL_GetAudioFormatName(self.value));
        if (std.mem.eql(u8, ret, "SDL_AUDIO_UNKNOWN"))
            return null;
        return ret;
    }

    /// If the format is big endian.
    ///
    /// ## Function Parameters
    /// * `self`: The format value.
    ///
    /// ## Return Value
    /// Returns if the format is big endian.
    ///
    /// ## Remarks
    /// For example, calling this on `audio.Format.signed_16_bit_little_endian` returns `false`.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn isBigEndian(
        self: Format,
    ) bool {
        const ret = C.SDL_AUDIO_ISBIGENDIAN(
            self.value,
        );
        return ret != 0;
    }

    /// If the format is floating point data.
    ///
    /// ## Function Parameters
    /// * `self`: The format value.
    ///
    /// ## Return Value
    /// Returns if the format is floating point.
    ///
    /// ## Remarks
    /// For example, calling this on `audio.Format.signed_16_bit` returns `false`.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn isFloat(
        self: Format,
    ) bool {
        const ret = C.SDL_AUDIO_ISFLOAT(
            self.value,
        );
        return ret != 0;
    }

    /// If the format is integer data.
    ///
    /// ## Function Parameters
    /// * `self`: The format value.
    ///
    /// ## Return Value
    /// Returns if the format is an integer.
    ///
    /// ## Remarks
    /// For example, calling this on `audio.Format.floating_32_bit` returns `false`.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn isInt(
        self: Format,
    ) bool {
        const ret = C.SDL_AUDIO_ISINT(
            self.value,
        );
        return ret > 0;
    }

    /// If the format represents little-endian data.
    ///
    /// ## Function Parameters
    /// * `self`: The format value.
    ///
    /// ## Return Value
    /// Returns if the format is little-endian.
    ///
    /// ## Remarks
    /// For example, calling this on `audio.Format.signed_16_bit_big_endian` returns `false`.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn isLittleEndian(
        self: Format,
    ) bool {
        const ret = C.SDL_AUDIO_ISLITTLEENDIAN(
            self.value,
        );
        return ret != 0;
    }

    /// If the format represents signed data.
    ///
    /// ## Function Parameters
    /// * `self`: The format value.
    ///
    /// ## Return Value
    /// Returns if the format is signed.
    ///
    /// ## Remarks
    /// For example, calling this on `audio.Format.unsigned_8_bit` returns `false`.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn isSigned(
        self: Format,
    ) bool {
        const ret = C.SDL_AUDIO_ISSIGNED(
            self.value,
        );
        return ret != 0;
    }

    /// If the format represents unsigned data.
    ///
    /// ## Function Parameters
    /// * `self`: The format value.
    ///
    /// ## Return Value
    /// Returns if the format is unsigned.
    ///
    /// ## Remarks
    /// For example, calling this on `audio.Format.signed_16_bit` returns `false`.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn isUnsigned(
        self: Format,
    ) bool {
        const ret = C.SDL_AUDIO_ISUNSIGNED(
            self.value,
        );
        return ret != 0;
    }
};

/// SDL Audio Device instance.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const Device = packed struct {
    value: C.SDL_AudioDeviceID,
    /// A value used to request a default playback audio device.
    pub const default_playback = Device{ .value = C.SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK };
    /// A value used to request a default recording audio device.
    pub const default_recording = Device{ .value = C.SDL_AUDIO_DEVICE_DEFAULT_RECORDING };

    // Test sizes.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_AudioDeviceID) == @sizeOf(Device));
    }

    /// Bind a single audio stream to an audio device.
    ///
    /// ## Function Parameters
    /// * `self`: An audio device to bind a stream to.
    /// * `stream`: An audio stream to bind to a device.
    ///
    /// ## Remarks
    /// This is a convenience function, equivalent to calling `audio.Device.bindStreams(devid, &.{stream})`.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindStream(
        self: Device,
        stream: Stream,
    ) !void {
        const ret = C.SDL_BindAudioStream(
            self.value,
            stream.value,
        );
        return errors.wrapCallBool(ret);
    }

    /// Bind a list of audio streams to an audio device.
    ///
    /// ## Function Parameters
    /// * `self`: An audio device to bind a stream to.
    /// * `streams: A slice of audio streams to bind.
    ///
    /// ## Remarks
    /// Audio data will flow through any bound streams.
    /// For a playback device, data for all bound streams will be mixed together and fed to the device.
    /// For a recording device, a copy of recorded data will be provided to each bound stream.
    ///
    /// Audio streams can only be bound to an open device.
    /// This operation is atomic--all streams bound in the same call will start processing at the same time, so they can stay in sync.
    /// Also: either all streams will be bound or none of them will be.
    ///
    /// It is an error to bind an already-bound stream; it must be explicitly unbound first.
    ///
    /// Binding a stream to a device will set its output format for playback devices, and its input format for recording devices,
    /// so they match the device's settings.
    /// The caller is welcome to change the other end of the stream's format at any time with `audio.Stream.setFormat()`.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindStreams(
        self: Device,
        streams: []Stream,
    ) !void {
        const ret = C.SDL_BindAudioStreams(
            self.value,
            @ptrCast(streams.ptr),
            @intCast(streams.len),
        );
        return errors.wrapCallBool(ret);
    }

    /// Close a previously-opened audio device.
    ///
    /// ## Function Parameters
    /// * `self`: An audio device id previously returned by `audio.Device.open()`.
    ///
    /// ## Remarks
    /// The application should close open audio devices once they are no longer needed.
    ///
    /// This function may block briefly while pending audio data is played by the hardware, so that applications don't drop the last buffer of data they supplied if terminating immediately afterwards.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    ///
    /// ## Code Examples
    /// TODO!!!
    pub fn close(
        self: Device,
    ) void {
        const ret = C.SDL_CloseAudioDevice(
            self.value,
        );
        _ = ret;
    }

    /// Get the current audio format of a specific audio device.
    ///
    /// ## Function Parameters
    /// * `self`: The device instance to query.
    ///
    /// ## Return Value
    /// Returns the audio specification of the device as long as the buffer size in sample frames.
    ///
    /// ## Remarks
    /// For an opened device, this will report the format the device is currently using.
    /// If the device isn't yet opened, this will report the device's preferred format (or a reasonable default if this can't be determined).
    ///
    /// You may also specify `audio.Device.default_playback` or `audio.Device.default_recording` here,
    /// which is useful for getting a reasonable recommendation before opening the system-recommended default device.
    ///
    /// You can also use this to request the current device buffer size.
    /// This is specified in sample frames and represents the amount of data SDL will feed to the physical hardware in each chunk.
    /// This can be converted to milliseconds of audio with the following equation:
    /// `const ms = val.buffer_size_frames * 1000 / val.spec.sample_rate`.
    ///
    /// Buffer size is only important if you need low-level control over the audio playback timing.
    /// Most apps do not need this.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getFormat(
        self: Device,
    ) !struct { spec: Spec, buffer_size_frames: usize } {
        var spec: C.SDL_AudioSpec = undefined;
        var buffer_size_frames: c_int = undefined;
        const ret = C.SDL_GetAudioDeviceFormat(
            self.value,
            &spec,
            &buffer_size_frames,
        );
        try errors.wrapCallBool(ret);
        return .{ .spec = Spec.fromSdl(spec), .device_sample_frames = @intCast(buffer_size_frames) };
    }

    /// Get the current channel map of an audio device.
    ///
    /// ## Function Parameters
    /// * `self`: The device instant to query.
    ///
    /// ## Return Value
    /// Returns a slice of the current channel mapping, with as many elements as the current output spec's channels, or `null` if default/no remapping.
    /// This should be freed with `stdinc.free()` when it is no longer needed.
    ///
    /// ## Remarks
    /// Channel maps are optional; most things do not need them, instead passing data in the order that SDL expects.
    ///
    /// Audio devices usually have no remapping applied.
    /// This is represented by returning `null`.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getChannelMap(
        self: Device,
    ) ?[]c_int {
        var count: c_int = undefined;
        const ret = C.SDL_GetAudioDeviceChannelMap(
            self.value,
            &count,
        );
        if (ret == null)
            return null;
        return ret[0..@intCast(count)];
    }

    /// Get the gain of an audio device.
    ///
    /// ## Function Parameters
    /// * `self`: The audio device to query.
    ///
    /// ## Return Value
    /// Returns the gain of the device.
    ///
    /// ## Remarks
    /// The gain of a device is its volume; a larger gain means a louder output, with a gain of zero being silence.
    ///
    /// Audio devices default to a gain of 1 (no change in output).
    ///
    /// Physical devices may not have their gain changed, only logical devices, physical devices will always return an error.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getGain(
        self: Device,
    ) !f32 {
        const ret = C.SDL_GetAudioDeviceGain(
            self.value,
        );
        return @floatCast(try errors.wrapCall(f32, ret, -1));
    }

    /// Get the human-readable name of a specific audio device.
    ///
    /// ## Function Parameters
    /// * `self`: The instance of the device to query.
    ///
    /// ## Return Value
    /// Returns the name of the audio device.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getName(
        self: Device,
    ) ![:0]const u8 {
        const ret = C.SDL_GetAudioDeviceName(
            self.value,
        );
        return errors.wrapCallCString(ret);
    }

    /// Use this function to query if an audio device is paused.
    ///
    /// ## Function Parameters
    /// * `self`: A device opened by `audio.Device.open()`.
    ///
    /// ## Return Value
    /// Returns true if device is valid and paused, false otherwise.
    ///
    /// ## Remarks
    /// Unlike in SDL2, audio devices start in an unpaused state, since an app has to bind a stream before any audio will flow.
    ///
    /// Physical devices can not be paused or unpaused, only logical devices created through `audio.Device.open()` can be.
    /// Physical and invalid device IDs will report themselves as unpaused here.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getPaused(
        self: Device,
    ) bool {
        const ret = C.SDL_AudioDevicePaused(
            self.value,
        );
        return ret;
    }

    /// Open a specific audio device.
    pub fn open(
        self: Device,
        spec: ?Spec,
    ) !Device {
        const spec_sdl: ?C.SDL_AudioSpec = if (spec == null) null else spec.?.toSdl();
        const ret = C.SDL_OpenAudioDevice(
            self.value,
            if (spec_sdl == null) null else &(spec_sdl.?),
        );
        if (ret == 0)
            return error.SdlError;
        return Device{ .value = ret };
    }

    /// Use this function to pause audio playback on a specified device.
    pub fn pausePlayback(
        self: Device,
    ) !void {
        const ret = C.SDL_PauseAudioDevice(
            self.value,
        );
        if (!ret)
            return error.SdlError;
    }

    /// Use this function to unpause audio playback on a specified device.
    pub fn resumePlayback(
        self: Device,
    ) !void {
        const ret = C.SDL_ResumeAudioDevice(
            self.value,
        );
        if (!ret)
            return error.SdlError;
    }

    /// Change the gain of an audio device.
    pub fn setGain(
        self: Device,
        gain: f32,
    ) !void {
        const ret = C.SDL_SetAudioDeviceGain(
            self.value,
            @floatCast(gain),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Get a list of audio playback devices. Result must be freed.
    pub fn getAllPlaybackDevices(
        allocator: std.mem.Allocator,
    ) ![]Device {
        var count: c_int = undefined;
        const ret = C.SDL_GetAudioPlaybackDevices(
            &count,
        );
        if (ret == null)
            return error.SdlError;
        defer C.SDL_free(ret);
        var converted_ret = try allocator.alloc(Device, @intCast(count));
        for (0..count) |ind| {
            converted_ret[ind].value = ret[ind];
        }
        return converted_ret;
    }

    /// Get a list of audio recording devices. Result must be freed.
    pub fn getAllRecordingDevices(
        allocator: std.mem.Allocator,
    ) ![]Device {
        var count: c_int = undefined;
        const ret = C.SDL_GetAudioRecordingDevices(
            &count,
        );
        if (ret == null)
            return error.SdlError;
        defer C.SDL_free(ret);
        var converted_ret = try allocator.alloc(Device, @intCast(count));
        for (0..count) |ind| {
            converted_ret[ind].value = ret[ind];
        }
        return converted_ret;
    }
};

/// The opaque handle that represents an audio stream.
///
/// ## Remarks
/// This is an audio conversion interface:
/// * It can handle resampling data in chunks without generating artifacts, when it doesn't have the complete buffer available.
/// * It can handle incoming data in any variable size.
/// * It can handle input/output format changes on the fly.
/// * It can remap audio channels between inputs and outputs.
/// * You push data as you have it, and pull it when you need it
/// * It can also function as a basic audio data queue even if you just have sound that needs to pass from one place to another.
/// * You can hook callbacks up to them when more data is added or requested, to manage data on-the-fly.
///
/// Audio streams are the core of the SDL3 audio interface.
/// You create one or more of them, bind them to an opened audio device, and feed data to them (or for recording, consume data from them).
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Stream = packed struct {
    value: *C.SDL_AudioStream,

    // Size tests.
    comptime {
        std.debug.assert(@sizeOf(*C.SDL_AudioStream), @sizeOf(Stream));
    }

    /// Clear any pending data in the stream.
    ///
    /// ## Function Parameters
    /// * `self`: The audio stream to clear.
    ///
    /// ## Remarks
    /// This drops any queued data, so there will be nothing to read from the stream until more is added.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn clear(
        self: Stream,
    ) !void {
        return errors.wrapCallBool(C.SDL_ClearAudioStream(self.value));
    }

    /// Free an audio stream.
    ///
    /// ## Function Parameters
    /// * `self`: The audio stream to destroy.
    ///
    /// ## Remarks
    /// This will release all allocated data, including any audio that is still queued.
    /// You do not need to manually clear the stream first.
    ///
    /// If this stream was bound to an audio device, it is unbound during this call.
    /// If this stream was created with `audio.Device.open()`, the audio device that was opened alongside this stream's creation will be closed, too.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn deinit(
        self: Stream,
    ) void {
        C.SDL_DestroyAudioStream(self.value);
    }

    /// Tell the stream that you're done sending data, and anything being buffered should be converted/resampled and made available immediately.
    ///
    /// ## Function Parameters
    /// * `self`: The audio stream to flush.
    ///
    /// ## Remarks
    /// It is legal to add more data to a stream after flushing, but there may be audio gaps in the output.
    /// Generally this is intended to signal the end of input, so the complete output becomes available.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn flush(
        self: Stream,
    ) !void {
        return errors.wrapCallBool(C.SDL_FlushAudioStream(self.value));
    }

    /// Get the number of converted/resampled bytes available.
    ///
    /// ## Function Parameters
    /// * `self`: The audio stream to query.
    ///
    /// ## Return Value
    /// Returns the number of converted/resampled bytes available.
    ///
    /// ## Remarks
    /// The stream may be buffering data behind the scenes until it has enough to resample correctly, so this number might be lower than what you expect, or even be zero.
    /// Add more data or flush the stream if you need the data now.
    ///
    /// If the stream has so much data that it would overflow, the return value is clamped to a maximum value, but no queued data is lost; if there are gigabytes of data queued,
    /// the app might need to read some of it with `audio.Stream.getData()` before this function's return value is no longer clamped.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getAvailable(
        self: Stream,
    ) usize {}

    /// Use this function to query if an audio device associated with a stream is paused.
    ///
    /// ## Function Parameters
    /// * `self`: The audio stream associated with the audio device to query.
    ///
    /// ## Return Value
    /// Returns true if device is valid and paused, false otherwise.
    ///
    /// ## Remarks
    /// Unlike in SDL2, audio devices start in an *unpaused* state, since an app has to bind a stream before any audio will flow.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getDevicePaused(
        self: Stream,
    ) bool {
        return C.SDL_AudioStreamDevicePaused(self.value);
    }

    /// Create a new audio stream.
    ///
    /// ## Function Parameters
    /// * `src_spec`: The format details of the input audio.
    /// * `dst_spec`: The format details of the output audio.
    ///
    /// ## Return Value
    /// Returns a new audio stream.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn init(
        src_spec: Spec,
        dst_spec: Spec,
    ) !Stream {
        const src_spec_sdl = src_spec.toSdl();
        const dst_spec_sdl = dst_spec.toSdl();
        return .{
            .value = errors.wrapNull(*C.SDL_AudioStream, C.SDL_CreateAudioStream(&src_spec_sdl, &dst_spec_sdl)),
        };
    }

    /// Lock an audio stream for serialized access.
    ///
    /// ## Function Parameters
    /// * `self`: The audio stream to lock.
    ///
    /// ## Remarks
    /// Each `audio.Stream` has an internal mutex it uses to protect its data structures from threading conflicts.
    /// This function allows an app to lock that mutex, which could be useful if registering callbacks on this stream.
    ///
    /// One does not need to lock a stream to use in it most cases, as the stream manages this lock internally.
    /// However, this lock is held during callbacks, which may run from arbitrary threads at any time,
    /// so if an app needs to protect shared data during those callbacks, locking the stream guarantees that the callback is not running while the lock is held.
    ///
    /// As this is just a wrapper over `mutex.Lock` for an internal lock; it has all the same attributes (recursive locks are allowed, etc).
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn lock(
        self: Stream,
    ) !void {
        return errors.wrapCallBool(C.SDL_LockAudioStream(self.value));
    }

    /// Unlock an audio stream for serialized access.
    ///
    /// ## Function Parameters
    /// * `self`: The audio stream to unlock.
    ///
    /// ## Remarks
    /// This unlocks an audio stream after a call to `audio.Stream.lock()`.
    ///
    /// ## Thread Safety
    /// You should only call this from the same thread that previously called `audio.Stream.lock()`.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn unlock(
        self: Stream,
    ) !void {
        return errors.wrapCallBool(C.SDL_UnlockAudioStream(self.value));
    }
};

/// Format specifier for audio data.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Spec = struct {
    /// Audio data format.
    format: Format,
    /// Number of channels.
    num_channels: usize,
    /// Sample frames per second.
    sample_rate: usize,

    /// Convert from an SDL value.
    pub fn fromSdl(data: C.SDL_AudioSpec) Spec {
        return .{
            .format = Format{ .value = data.format },
            .num_channels = @intCast(data.channels),
            .sample_rate = @intCast(data.freq),
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: Spec) C.SDL_AudioSpec {
        return .{
            .format = self.format.value,
            .channels = @intCast(self.num_channels),
            .freq = @intCast(self.sample_rate),
        };
    }

    /// Convert some audio data of one format to another format.
    ///
    /// ## Function Parameters
    /// * `self`: The format details of the input audio.
    /// * `src_data`: The audio data to be converted.
    /// * `dst_spec`: The format details of the output audio.
    ///
    /// ## Return Value
    /// Returns the converted audio samples.
    /// This should be freed with `stdinc.free()`.
    ///
    /// ## Remarks
    /// Please note that this function is for convenience, but should not be used to resample audio in blocks,
    /// as it will introduce audio artifacts on the boundaries.
    /// You should only use this function if you are converting audio data in its entirety in one call.
    /// If you want to convert audio in smaller chunks, use an `audio.Stream`, which is designed for this situation.
    ///
    /// Internally, this function creates and destroys an `audio.Stream` on each use, so it's also less efficient than using one directly,
    /// if you need to convert multiple times.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn convertSamples(
        self: Spec,
        src_data: []const u8,
        dst_spec: Spec,
    ) ![]u8 {
        const src_spec_sdl = self.toSdl();
        const dst_spec_sdl = dst_spec.toSdl();
        var dst_data: *u8 = undefined;
        var dst_len: c_int = undefined;
        try errors.wrapCallBool(C.SDL_ConvertAudioSamples(
            &src_spec_sdl,
            src_data.ptr,
            @intCast(src_data.len),
            &dst_spec_sdl,
            &dst_data,
            &dst_len,
        ));
        return dst_data[0..@intCast(dst_len)];
    }

    /// Get converted/resampled data from the stream.
    ///
    /// ## Function Parameters
    /// * `self`: The stream the audio is being requested from.
    /// * `buf`: The buffer to fill with audio data.
    ///
    /// ## Return Value
    /// Returns the data actually filled.
    /// Note that the returned `ret` reuses `data.ptr`, just that `ret.len <= data.len`.
    ///
    /// ## Remarks
    /// The input/output data format/channels/samplerate is specified when creating the stream, and can be changed after creation by calling `audio.Stream.setFormat()`
    ///
    /// Note that any conversion and resampling necessary is done during this call, and `audio.Stream.putData()` simply queues unconverted data for later.
    /// This is different than SDL2, where that work was done while inputting new data to the stream and requesting the output just copied the converted data.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread, but if the stream has a callback set, the caller might need to manage extra locking.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getData(
        self: Stream,
        data: []u8,
    ) ![]u8 {
        const ret = errors.wrapCall(c_int, C.SDL_GetAudioStreamData(self.value, data.ptr, @intCast(data.len)), -1);
        return data.ptr[0..@intCast(ret)];
    }

    /// Calculate the size of each audio frame (in bytes) from an audio spec.
    ///
    /// ## Function Parameters
    /// * `self`: The audio spec to query.
    ///
    /// ## Return Value
    /// Returns the number of bytes used per sample frame.
    ///
    /// ## Remarks
    /// This reports on the size of an audio sample frame: stereo signed 16-bit data (2 channels of 2 bytes each) would be 4 bytes per frame, for example.
    ///
    /// ## Thread Safety
    /// It is safe to call this function from any thread.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn getFrameSize(
        self: Spec,
    ) usize {
        const ret = C.SDL_AUDIO_FRAMESIZE(
            self.toSdl(),
        );
        return @intCast(ret);
    }
};

/// Get the name of the current audio driver.
///
/// ## Return Value
/// Returns the name of the current audio driver or `null` if no driver has been initialized.
///
/// ## Remarks
/// The names of drivers are all simple, low-ASCII identifiers, like "alsa", "coreaudio" or "wasapi".
/// These never have Unicode characters, and are not meant to be proper names.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getCurrentDriverName() ?[:0]const u8 {
    const ret = C.SDL_GetCurrentAudioDriver();
    if (ret == null)
        return null;
    return std.mem.span(ret);
}

/// Use this function to get the name of a built in audio driver.
///
/// ## Function Parameters
/// * `index`: The index of the audio driver; the value ranges from 0 to `audio.getNumDrivers() - 1`.
///
/// ## Return Value
/// Returns the name of the audio driver at the requested index, or `null` if an invalid index was specified.
///
/// ## Remarks
/// The list of audio drivers is given in the order that they are normally initialized by default;
/// the drivers that seem more reasonable to choose first (as far as the SDL developers believe) are earlier in the list.
///
/// The names of drivers are all simple, low-ASCII identifiers, like "alsa", "coreaudio" or "wasapi".
/// These never have Unicode characters, and are not meant to be proper names.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getDriverName(
    index: usize,
) ?[:0]const u8 {
    const ret = C.SDL_GetAudioDriver(
        @intCast(index),
    );
    if (ret == null)
        return null;
    return std.mem.span(ret);
}

/// Use this function to get the number of built-in audio drivers.
///
/// ## Return Value
/// Returns the number of built-in audio drivers.
///
/// ## Remarks
/// This function returns a hardcoded number.
/// If there are no drivers compiled into this build of SDL, this function returns zero.
/// The presence of a driver in this list does not mean it will function, it just means SDL is capable of interacting with that interface.
/// For example, a build of SDL might have esound support, but if there's no esound server available, SDL's esound driver would fail if used.
///
/// By default, SDL tries all drivers, in its preferred order, until one is found to be usable.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getNumDrivers() usize {
    const ret = C.SDL_GetNumAudioDrivers();
    return @intCast(ret);
}

/// Get a list of currently-connected audio playback devices.
///
/// ## Return Value
/// Returns a slice of device instances.
/// This should be freed with `stdinc.free()`.
///
/// ## Remarks
/// This returns of list of available devices that play sound, perhaps to speakers or headphones ("playback" devices).
/// If you want devices that record audio, like a microphone ("recording" devices), use `audio.getRecordingDevices()` instead.
///
/// This only returns a list of physical devices; it will not have any device IDs returned by `audio.Device.open()`.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getPlaybackDevices() ![]Device {
    var count: c_int = undefined;
    const ret = try errors.wrapCallCPtr(C.SDL_AudioDeviceID, C.SDL_GetAudioPlaybackDevices(&count));
    return ret[0..@intCast(count)];
}

/// Get a list of currently-connected audio recording devices.
///
/// ## Return Value
/// Returns a slice of device instances.
/// This should be freed with `stdinc.free()`.
///
/// ## Remarks
/// This returns of list of available devices that record audio, like a microphone ("recording" devices).
/// If you want devices that play sound, perhaps to speakers or headphones ("playback" devices), use `audio.Device.getPlaybackDevices()` instead.
///
/// This only returns a list of physical devices; it will not have any device IDs returned by `audio.Device.open()`.
///
/// ## Thread Safety
/// It is safe to call this function from any thread.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub fn getRecordingDevices() ![]Device {
    var count: c_int = undefined;
    const ret = try errors.wrapCallCPtr(C.SDL_AudioDeviceID, C.SDL_GetAudioRecordingDevices(&count));
    return ret[0..@intCast(count)];
}
