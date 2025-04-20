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
pub const Device = struct {
    value: C.SDL_AudioDeviceID,
    /// A value used to request a default playback audio device.
    pub const default_playback = Device{ .value = C.SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK };
    /// A value used to request a default recording audio device.
    pub const default_recording = Device{ .value = C.SDL_AUDIO_DEVICE_DEFAULT_RECORDING };

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

    /// Get the human-readable name of a specific audio device.
    pub fn getName(
        self: Device,
    ) ![:0]const u8 {
        const ret = C.SDL_GetAudioDeviceName(
            self.value,
        );
        if (ret == null)
            return error.SdlError;
        return std.mem.span(ret);
    }

    /// For an opened device, this will report the format the device is currently using. If the device isn't yet opened, this will report the device's preferred format (or a reasonable default if this can't be determined).
    pub fn getFormat(
        self: Device,
    ) !struct { spec: Spec, device_sample_frames: usize } {
        var spec: C.SDL_AudioSpec = undefined;
        var device_sample_frames: c_int = undefined;
        const ret = C.SDL_GetAudioDeviceFormat(
            self.value,
            &spec,
            &device_sample_frames,
        );
        if (!ret)
            return error.SdlError;
        return .{ .spec = Spec.fromSdl(spec), .device_sample_frames = @intCast(device_sample_frames) };
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

    /// Get the gain of an audio device.
    pub fn getGain(
        self: Device,
    ) !f32 {
        const ret = C.SDL_GetAudioDeviceGain(
            self.value,
        );
        if (ret == -1)
            return error.SdlError;
        return @floatCast(ret);
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

    /// Close a previously-opened audio device.
    pub fn close(
        self: Device,
    ) void {
        const ret = C.SDL_CloseAudioDevice(
            self.value,
        );
        _ = ret;
    }

    /// Bind a list of audio streams to an audio device.
    pub fn bindStreams(
        self: Device,
        streams: []*C.SDL_AudioStream,
    ) !void {
        const ret = C.SDL_BindAudioStreams(
            self.value,
            streams.ptr,
            @intCast(streams.len),
        );
        if (!ret)
            return error.SdlError;
    }

    /// Bind a single audio stream to an audio device.
    pub fn bindStream(
        self: Device,
        stream: Stream,
    ) !void {
        const ret = C.SDL_BindAudioStream(
            self.value,
            stream.value,
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

    /// Get the current channel map of an audio device if needed. Result must be freed.
    pub fn getChannelMap(
        self: Device,
        allocator: std.mem.Allocator,
    ) ![]usize {
        var count: c_int = undefined;
        const ret = C.SDL_GetAudioDeviceChannelMap(
            self.value,
            &count,
        );
        if (ret == null)
            return error.SdlError;
        defer C.SDL_free(ret);
        var converted_ret = try allocator.alloc(usize, @intCast(count));
        for (0..count) |ind| {
            converted_ret[ind] = @intCast(ret[ind]);
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
pub const Stream = struct {
    value: *C.SDL_AudioStream,
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

/// Use this function to get the number of built-in audio drivers.
pub fn getNumDrivers() usize {
    const ret = C.SDL_GetNumAudioDrivers();
    return @intCast(ret);
}

/// Use this function to get the name of a built in audio driver.
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

/// Get the name of the current audio driver.
pub fn getCurrentDriverName() ?[:0]const u8 {
    const ret = C.SDL_GetCurrentAudioDriver();
    if (ret == null)
        return null;
    return std.mem.span(ret);
}
