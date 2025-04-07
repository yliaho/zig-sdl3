// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Audio format.
pub const Format = struct {
    value: c_uint,
    pub const Unsigned_8_bit = Format{ .value = C.SDL_AUDIO_U8 };
    pub const Signed_8_bit = Format{ .value = C.SDL_AUDIO_S8 };
    pub const Signed_16_bit_little_endian = Format{ .value = C.SDL_AUDIO_S16LE };
    pub const Signed_16_bit_big_endian = Format{ .value = C.SDL_AUDIO_S16BE };
    pub const Signed_32_bit_little_endian = Format{ .value = C.SDL_AUDIO_S32LE };
    pub const Signed_32_bit_big_endian = Format{ .value = C.SDL_AUDIO_S32BE };
    pub const Floating_32_bit_little_endian = Format{ .value = C.SDL_AUDIO_F32LE };
    pub const Floating_32_bit_big_endian = Format{ .value = C.SDL_AUDIO_F32BE };
    pub const Signed_16_bit = Format{ .value = C.SDL_AUDIO_S16 };
    pub const Signed_32_bit = Format{ .value = C.SDL_AUDIO_S32 };
    pub const Floating_32_bit = Format{ .value = C.SDL_AUDIO_F32 };

    /// Define an audio format.
    pub fn define(
        signed: bool,
        big_endian: bool,
        float: bool,
        bitwidth: u8,
    ) Format {
        const ret = C.SDL_DEFINE_AUDIO_FORMAT(
            @intFromBool(signed),
            @intFromBool(big_endian),
            @intFromBool(float),
            @intCast(bitwidth),
        );
        return Format{ .value = ret };
    }

    /// Get the bitwidth of the format.
    pub fn getBitwidth(
        self: Format,
    ) u8 {
        const ret = C.SDL_AUDIO_BITSIZE(
            self.value,
        );
        return @intCast(ret);
    }

    /// Get the byte size of the format.
    pub fn getByteSize(
        self: Format,
    ) u8 {
        const ret = C.SDL_AUDIO_BYTESIZE(
            self.value,
        );
        return @intCast(ret);
    }

    /// If the format using floating point numbers.
    pub fn isFloat(
        self: Format,
    ) bool {
        const ret = C.SDL_AUDIO_ISFLOAT(
            self.value,
        );
        return ret > 0;
    }

    /// If the format is big endian.
    pub fn isBigEndian(
        self: Format,
    ) bool {
        const ret = C.SDL_AUDIO_ISBIGENDIAN(
            self.value,
        );
        return ret > 0;
    }

    /// If the format is little endian.
    pub fn isLittleEndian(
        self: Format,
    ) bool {
        const ret = C.SDL_AUDIO_ISLITTLEENDIAN(
            self.value,
        );
        return ret > 0;
    }

    /// If the format is signed.
    pub fn isSigned(
        self: Format,
    ) bool {
        const ret = C.SDL_AUDIO_ISSIGNED(
            self.value,
        );
        return ret > 0;
    }

    /// If the format is an integer.
    pub fn isInt(
        self: Format,
    ) bool {
        const ret = C.SDL_AUDIO_ISINT(
            self.value,
        );
        return ret > 0;
    }

    /// If the format is unsigned.
    pub fn isUnsigned(
        self: Format,
    ) bool {
        const ret = C.SDL_AUDIO_ISUNSIGNED(
            self.value,
        );
        return ret > 0;
    }
};

/// SDL Audio Device instance.
pub const Device = struct {
    value: C.SDL_AudioDeviceID,
    /// A value used to request a default playback audio device.
    pub const default_playback = Device{ .value = C.SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK };
    /// A value used to request a default recording audio device.
    pub const default_recording = Device{ .value = C.SDL_AUDIO_DEVICE_DEFAULT_RECORDING };

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

    /// Use this function to query if an audio device is paused.
    pub fn getPaused(
        self: Device,
    ) bool {
        const ret = C.SDL_AudioDevicePaused(
            self.value,
        );
        return ret;
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

/// Audio streams is an audio conversion interface.
pub const Stream = struct {
    value: *C.SDL_AudioStream,
};

/// Format specifier for audio data.
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
