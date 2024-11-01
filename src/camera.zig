// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// If camera is approved by user.
pub const PermissionState = enum(c_int) {
	Denied = -1,
	Awaiting = 0,
	Approved = 1,
};

/// The position of camera in relation to system device.
pub const Position = enum(c_uint) {
	FrontFacing = C.SDL_CAMERA_POSITION_FRONT_FACING,
	BackFacing = C.SDL_CAMERA_POSITION_BACK_FACING,
};

/// This is a unique ID for a camera device for the time it is connected to the system, and is never reused for the lifetime of the application.
pub const ID = struct {
	value: C.SDL_CameraID,

	/// Get the human-readable device name for a camera.
	pub fn getName(
		self: ID,
	) ![]const u8 {
		const ret = C.SDL_GetCameraName(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return std.mem.span(ret);
	}

	/// Get the position of the camera in relation to the system.
	pub fn getPosition(
		self: ID,
	) ?Position {
		const ret = C.SDL_GetCameraPosition(
			self.value,
		);
		if (ret == C.SDL_CAMERA_POSITION_UNKNOWN)
			return null;
		return @enumFromInt(ret);
	}

	/// Get a list of currently connected camera devices. Result must be freed.
    pub fn getAll(
        allocator: std.mem.Allocator,
    ) ![]ID {
        var count: c_int = undefined;
        const ret = C.SDL_GetCameras(
            &count,
        );
        if (ret == null)
            return error.SdlError;
        defer C.SDL_free(ret);
        var converted_ret = try allocator.alloc(ID, @intCast(count));
        for (0..count) |ind| {
            converted_ret[ind].value = ret[ind];
        }
        return converted_ret;
    }

	/// Get the list of native formats/sizes a camera supports. Result Must be freed.
    pub fn getSupportedFormats(
        self: ID,
        allocator: std.mem.Allocator,
    ) ![]Specification {
        var count: c_int = undefined;
        const ret = C.SDL_GetCameraSupportedFormats(
            self.value,
            &count,
        );
        if (ret == null)
            return error.SdlError;
        defer C.SDL_free(ret);
        var converted_ret = try allocator.alloc(Specification, @intCast(count));
        for (0..count) |ind| {
            converted_ret[ind] = Specification.fromSdl(ret[ind].*);
        }
        return converted_ret;
    }
};

/// The opaque structure used to identify an opened SDL camera.
pub const Camera = struct {
	value: *C.SDL_Camera,

	/// Open a video recording device (a camera).
	pub fn init(
		id: ID,
		specification: Specification,
	) !Camera {
		const specification_sdl: C.SDL_CameraSpec = specification.toSdl();
		const ret = C.SDL_OpenCamera(
			id.value,
			&specification_sdl,
		);
		if (ret == null)
			return error.SdlError;
		return Camera{ .value = ret.? };
	}

	/// Query if camera access has been approved by the user.
	pub fn getPermissionState(
		self: Camera,
	) PermissionState {
		const ret = C.SDL_GetCameraPermissionState(
			self.value,
		);
		return @enumFromInt(ret);
	}

	/// Get the instance ID of an opened camera.
	pub fn getID(
		self: Camera,
	) !ID {
		const ret = C.SDL_GetCameraID(
			self.value,
		);
		if (ret == 0)
			return error.SdlError;
		return ID{ .value = ret };
	}

	/// Get the properties associated with an opened camera.
	pub fn getProperties(
		self: Camera,
	) !properties.Group {
		const ret = C.SDL_GetCameraProperties(
			self.value,
		);
		if (ret == 0)
			return error.SdlError;
		return properties.Group{ .value = ret };
	}

	/// Get the spec that a camera is using when generating images.
	pub fn getFormat(
		self: Camera,
	) !Specification {
		var specification: C.SDL_CameraSpec = undefined;
		const ret = C.SDL_GetCameraFormat(
			self.value,
			&specification,
		);
		if (!ret)
			return error.SdlError;
		return Specification.fromSdl(specification);
	}

	/// Acquire a frame.
	pub fn acquireFrame(
		self: Camera,
	) struct { frame: ?surface.Surface, timestamp_nanoseconds: ?u64 } {
		var timestamp_nanoseconds: u64 = undefined;
		const ret = C.SDL_AcquireCameraFrame(
			self.value,
			&timestamp_nanoseconds,
		);
		return .{ .frame = if (ret != null) .{ .value = ret } else null, .timestamp_nanoseconds = if (timestamp_nanoseconds == 0) null else timestamp_nanoseconds };
	}

	/// Release a frame of video acquired from a camera.
	pub fn releaseFrame(
		self: Camera,
		frame: surface.Surface,
	) void {
		const ret = C.SDL_ReleaseCameraFrame(
			self.value,
			frame.value,
		);
		_ = ret;
	}

	/// Use this function to shut down camera processing and close the camera device.
	pub fn deinit(
		self: Camera,
	) void {
		const ret = C.SDL_CloseCamera(
			self.value,
		);
		_ = ret;
	}
};

/// The details of an output format for a camera device.
pub const Specification = struct {
	format: ?pixels.Format,
	colorspace: ?pixels.Colorspace,
	width: usize,
	height: usize,
	framerate_numerator: usize,
	framerate_denominator: usize,

	/// Convert from an SDL value.
	pub fn fromSdl(data: C.SDL_CameraSpec) Specification {
		return .{
			.format = if (data.format == C.SDL_PIXELFORMAT_UNKNOWN) null else pixels.Format{ .value = data.format },
			.colorspace = if (data.colorspace == C.SDL_COLORSPACE_UNKNOWN) null else pixels.Format{ .value = data.colorspace },
			.width = @intCast(data.width),
			.height = @intCast(data.height),
			.framerate_numerator = @intCast(data.framerate_numerator),
			.framerate_denominator = @intCast(data.framerate_denominator),
		};
	}

	/// Convert to an SDL value.
	pub fn toSdl(self: Specification) C.SDL_CameraSpec {
		return .{
			.format = if (self.format) |val| val.value else C.SDL_PIXELFORMAT_UNKNOWN,
			.colorspace = if (self.colorspace) |val| val.value else C.SDL_COLORSPACE_UNKNOWN,
			.width = @intCast(self.width),
			.height = @intCast(self.height),
			.framerate_numerator = @intCast(self.framerate_numerator),
			.framerate_denominator = @intCast(self.framerate_denominator),
		};
	}
};

/// Use this function to get the number of built-in camera drivers.
pub fn getNumDrivers() usize {
	const ret = C.SDL_GetNumCameraDrivers();
	return @intCast(ret);
}

/// Use this function to get the name of a built in camera driver.
pub fn getDriverName(
	driver_index: usize,
) ?[]const u8 {
	const ret = C.SDL_GetCameraDriver(
		@intCast(driver_index),
	);
	if (ret == null)
		return null;
	return std.mem.span(ret);
}

/// Get the name of the current camera driver.
pub fn getCurrentDriverName() ?[]const u8 {
	const ret = C.SDL_GetCurrentCameraDriver();
	if (ret == null)
		return null;
	return std.mem.span(ret);
}

const properties = @import("properties.zig");
const surface = @import("surface.zig");
const pixels = @import("pixels.zig");
