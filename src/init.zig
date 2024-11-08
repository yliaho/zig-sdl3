// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// Used for initializing a subsystem.
pub const Flags = struct {
	audio: bool = false,
	video: bool = false,
	joystick: bool = false,
	haptic: bool = false,
	gamepad: bool = false,
	events: bool = false,
	sensor: bool = false,
	camera: bool = false,
	/// Initializes all subsystems.
	pub const everything = Flags{
		.audio = true,
		.video = true,
		.joystick = true,
		.haptic = true,
		.gamepad = true,
		.events = true,
		.sensor = true,
		.camera = true,
	};

	/// Convert from an SDL value.
	pub fn fromSdl(flags: C.SDL_InitFlags) Flags {
		return .{
			.audio = (flags & C.SDL_INIT_AUDIO) != 0,
			.video = (flags & C.SDL_INIT_VIDEO) != 0,
			.joystick = (flags & C.SDL_INIT_JOYSTICK) != 0,
			.haptic = (flags & C.SDL_INIT_HAPTIC) != 0,
			.gamepad = (flags & C.SDL_INIT_GAMEPAD) != 0,
			.events = (flags & C.SDL_INIT_EVENTS) != 0,
			.sensor = (flags & C.SDL_INIT_SENSOR) != 0,
			.camera = (flags & C.SDL_INIT_CAMERA) != 0,
		};
	}

	/// Convert to an SDL value.
	pub fn toSdl(self: Flags) C.SDL_InitFlags {
		return (if (self.audio) @as(C.SDL_InitFlags, C.SDL_INIT_AUDIO) else 0) |
			(if (self.video) @as(C.SDL_InitFlags, C.SDL_INIT_VIDEO) else 0) |
			(if (self.joystick) @as(C.SDL_InitFlags, C.SDL_INIT_JOYSTICK) else 0) |
			(if (self.haptic) @as(C.SDL_InitFlags, C.SDL_INIT_HAPTIC) else 0) |
			(if (self.gamepad) @as(C.SDL_InitFlags, C.SDL_INIT_GAMEPAD) else 0) |
			(if (self.events) @as(C.SDL_InitFlags, C.SDL_INIT_EVENTS) else 0) |
			(if (self.sensor) @as(C.SDL_InitFlags, C.SDL_INIT_SENSOR) else 0) |
			(if (self.camera) @as(C.SDL_InitFlags, C.SDL_INIT_CAMERA) else 0) |
			0;
	}
};

/// An app's metadata property to get or set.
pub const AppMetadataProperty = enum {
	Name,
	Version,
	Identifier,
	Creator,
	Copyright,
	Url,
	Type,

	/// Convert from an SDL string.
	pub fn fromSdl(val: [:0]const u8) AppMetadataProperty {
		if (std.mem.eql(u8, C.SDL_PROP_APP_METADATA_NAME_STRING, val))
			return .Name;
		if (std.mem.eql(u8, C.SDL_PROP_APP_METADATA_VERSION_STRING, val))
			return .Version;
		if (std.mem.eql(u8, C.SDL_PROP_APP_METADATA_IDENTIFIER_STRING, val))
			return .Identifier;
		if (std.mem.eql(u8, C.SDL_PROP_APP_METADATA_CREATOR_STRING, val))
			return .Creator;
		if (std.mem.eql(u8, C.SDL_PROP_APP_METADATA_COPYRIGHT_STRING, val))
			return .Copyright;
		if (std.mem.eql(u8, C.SDL_PROP_APP_METADATA_URL_STRING, val))
			return .Url;
		if (std.mem.eql(u8, C.SDL_PROP_APP_METADATA_TYPE_STRING, val))
			return .Type;
		return .Name;
	}

	/// Convert to an SDL string.
	pub fn toSdl(self: AppMetadataProperty) [:0]const u8 {
		return switch (self) {
			.Name => C.SDL_PROP_APP_METADATA_NAME_STRING,
			.Version => C.SDL_PROP_APP_METADATA_VERSION_STRING,
			.Identifier => C.SDL_PROP_APP_METADATA_IDENTIFIER_STRING,
			.Creator => C.SDL_PROP_APP_METADATA_CREATOR_STRING,
			.Copyright => C.SDL_PROP_APP_METADATA_COPYRIGHT_STRING,
			.Url => C.SDL_PROP_APP_METADATA_URL_STRING,
			.Type => C.SDL_PROP_APP_METADATA_TYPE_STRING,
		};
	}
};

/// Initialize the SDL systems. Each system is ref-counted so init and quit each one, then call shutdown.
pub fn init(
	flags: Flags,
) !void {
	const ret = C.SDL_Init(
		flags.toSdl(),
	);
	if (!ret)
		return error.SdlError;
}

/// Quit SDL systems. Note that shutdown is still needed after all systems have been quit.
pub fn quit(
	flags: Flags,
) void {
	const ret = C.SDL_QuitSubSystem(
		flags.toSdl(),
	);
	_ = ret;
}

/// Shutdown SDL. This is needed. Each system is ref-counted so init and quit each one, then call this.
pub fn shutdown() void {
	const ret = C.SDL_Quit();
	_ = ret;
}

/// Get which given systems have been initialized.
pub fn wasInit(
	flags: Flags,
) Flags {
	const ret = C.SDL_WasInit(
		flags.toSdl(),
	);
	return Flags.fromSdl(ret);
}

/// Get which given systems have been initialized.
pub fn setAppMetadata(
	app_name: ?[:0]const u8,
	app_version: ?[:0]const u8,
	app_identifier: ?[:0]const u8,
) !void {
	const ret = C.SDL_SetAppMetadata(
		if (app_name) |str_capture| str_capture.ptr else null,
		if (app_version) |str_capture| str_capture.ptr else null,
		if (app_identifier) |str_capture| str_capture.ptr else null,
	);
	if (!ret)
		return error.SdlError;
}

/// Set a metadata property for the app. Note that the value can be null to clear it.
pub fn setAppMetadataProperty(
	property: AppMetadataProperty,
	value: ?[:0]const u8,
) !void {
	const ret = C.SDL_SetAppMetadataProperty(
		property.toSdl(),
		if (value) |str_capture| str_capture.ptr else null,
	);
	if (!ret)
		return error.SdlError;
}

/// Get a metadata property for the app.
pub fn getAppMetadataProperty(
	property: AppMetadataProperty,
) ?[]const u8 {
	const ret = C.SDL_GetAppMetadataProperty(
		property.toSdl(),
	);
	if (ret == null)
		return null;
	return std.mem.span(ret);
}

// Ensure initialization and shutdown works as expected. Also app properties for some reason.
test "Init" {
	defer shutdown();
	const flags = Flags{
	    .video = true,
	    .events = true,
	    .camera = true,
	};
	try setAppMetadata("SDL3 Test", null, "!Testing");
	try init(flags);
	defer quit(flags);
	try std.testing.expect(std.meta.eql(flags, wasInit(flags)));
	try std.testing.expect(std.mem.eql(u8, getAppMetadataProperty(.Name).?, "SDL3 Test"));
	try std.testing.expect(getAppMetadataProperty(.Version) == null);
	try std.testing.expect(std.mem.eql(u8, getAppMetadataProperty(.Identifier).?, "!Testing"));
	try setAppMetadataProperty(.Creator, "Gota7");
	try std.testing.expect(std.mem.eql(u8, getAppMetadataProperty(.Creator).?, "Gota7"));
	try setAppMetadataProperty(.Creator, null);
	try std.testing.expect(getAppMetadataProperty(.Creator) == null);
	try std.testing.expect(getAppMetadataProperty(.Url) == null);
}
