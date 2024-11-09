// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// The access pattern allowed for a texture.
pub const TextureAccess = enum(c_uint) {
	/// Changes rarely, not lockable.
	Static = C.SDL_TEXTUREACCESS_STATIC,
	/// Changes frequently, lockable.
	Streaming = C.SDL_TEXTUREACCESS_STREAMING,
	/// Texture can be used as a render target.
	Target = C.SDL_TEXTUREACCESS_TARGET,
};

/// How the logical size is mapped to the output.
pub const LogicalPresentation = enum(c_uint) {
	/// The rendered content is stretched to the output resolution.
	Stretch = C.SDL_LOGICAL_PRESENTATION_STRETCH,
	/// The rendered content is fit to the largest dimension and the other dimension is letterboxed with black bars.
	LetterBox = C.SDL_LOGICAL_PRESENTATION_LETTERBOX,
	/// The rendered content is fit to the smallest dimension and the other dimension extends beyond the output bounds.
	Overscan = C.SDL_LOGICAL_PRESENTATION_OVERSCAN,
	/// The rendered content is scaled up by integer multiples to fit the output resolution.
	IntegerScale = C.SDL_LOGICAL_PRESENTATION_INTEGER_SCALE,
};

/// A structure representing rendering state.
pub const Renderer = struct {
	value: *C.SDL_Renderer,

	/// Get the number of 2D rendering drivers available for the current display.
	pub fn numDrivers() usize {
		const ret = C.SDL_GetNumRenderDrivers();
		return @intCast(ret);
	}

	/// Use this function to get the name of a built in 2D rendering driver.
	pub fn getDriverName(
		index: usize,
	) ?[]const u8 {
		const ret = C.SDL_GetRenderDriver(
			@intCast(index),
		);
		if (ret == null)
			return null;
		return std.mem.span(ret);
	}

	/// Create a window and default renderer.
	pub fn initWithWindow(
		title: [:0]const u8,
		width: usize,
		height: usize,
		window_flags: video.WindowFlags,
	) !struct { window: video.Window, renderer: Renderer } {
		var window: ?*C.SDL_Window = undefined;
		var renderer: ?*C.SDL_Renderer = undefined;
		const ret = C.SDL_CreateWindowAndRenderer(
			title,
			@intCast(width),
			@intCast(height),
			window_flags.toSdl(),
			&window,
			&renderer,
		);
		if (!ret)
			return error.SdlError;
		return .{ .window = .{ .value = window orelse return error.SdlError }, .renderer = .{ .value = renderer orelse return error.SdlError } };
	}

	/// Create a 2D rendering context for a window.
	pub fn init(
		window: video.Window,
		renderer_name: ?[:0]const u8,
	) !Renderer {
		const ret = C.SDL_CreateRenderer(
			window.value,
			if (renderer_name) |str_capture| str_capture.ptr else null,
		);
		if (ret == false)
			return error.SdlError;
		return Renderer{ .value = ret.? };
	}

	/// Create a 2D rendering context for a window, with the specified properties.
	pub fn initWithProperties(
		props: properties.Group,
	) !Renderer {
		const ret = C.SDL_CreateRendererWithProperties(
			props.value,
		);
		if (ret == null)
			return error.SdlError;
		return Renderer{ .value = ret.? };
	}

	/// Create a 2D software rendering context for a surface.
	pub fn initSoftwareRenderer(
		target_surface: surface.Surface,
	) !Renderer {
		const ret = C.SDL_CreateSoftwareRenderer(
			target_surface.value,
		);
		if (ret == null)
			return error.SdlError;
		return Renderer{ .value = ret.? };
	}

	/// Get the renderer associated with a window.
	pub fn getRenderer(
		window: video.Window,
	) !Renderer {
		const ret = C.SDL_GetRenderer(
			window.value,
		);
		if (ret == null)
			return error.SdlError;
		return Renderer{ .value = ret.? };
	}

	/// Get the window associated with a renderer.
	pub fn getWindow(
		self: Renderer,
	) !video.Window {
		const ret = C.SDL_GetRenderWindow(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return video.Window{ .value = ret.? };
	}

	/// Get the name of a renderer.
	pub fn getName(
		self: Renderer,
	) ![]const u8 {
		const ret = C.SDL_GetRendererName(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return std.mem.span(ret);
	}

	/// Get the properties associated with a renderer.
	pub fn getProperties(
		self: Renderer,
	) ![]properties.Group {
		const ret = C.SDL_GetRendererProperties(
			self.value,
		);
		if (ret == 0)
			return error.SdlError;
		return properties.Group{ .value = ret };
	}

	/// Get the output size in pixels of a rendering context.
	pub fn getOutputSize(
		self: Renderer,
	) !struct { width: usize, height: usize } {
		var w: c_int = undefined;
		var h: c_int = undefined;
		const ret = C.SDL_GetRenderOutputSize(
			self.value,
			&w,
			&h,
		);
		if (!ret)
			return error.SdlError;
		return .{ .width = @intCast(w), .height = @intCast(h) };
	}

	/// Get the current output size in pixels of a rendering context.
	pub fn getCurrentOutputSize(
		self: Renderer,
	) !struct { width: usize, height: usize } {
		var w: c_int = undefined;
		var h: c_int = undefined;
		const ret = C.SDL_GetCurrentRenderOutputSize(
			self.value,
			&w,
			&h,
		);
		if (!ret)
			return error.SdlError;
		return .{ .width = @intCast(w), .height = @intCast(h) };
	}

	/// Create a texture for a rendering context.
	pub fn createTexture(
		self: Renderer,
		format: pixels.Format,
		texture_access: TextureAccess,
		width: usize,
		height: usize,
	) !Texture {
		const ret = C.SDL_CreateTexture(
			self.value,
			format.value,
			@intFromEnum(texture_access),
			@intCast(width),
			@intCast(height),
		);
		if (ret == null)
			return error.SdlError;
		return Texture{ .value = ret };
	}

	/// Create a texture from an existing surface.
	pub fn createTextureFromSurface(
		self: Renderer,
		surface_to_copy: surface.Surface,
	) !Texture {
		const ret = C.SDL_CreateTextureFromSurface(
			self.value,
			surface_to_copy.value,
		);
		if (ret == null)
			return error.SdlError;
		return Texture{ .value = ret };
	}

	/// Create a texture for a rendering context with the specified properties.
	pub fn createTextureWithProperties(
		self: Renderer,
		props: properties.Group,
	) !Texture {
		const ret = C.SDL_CreateTextureWithProperties(
			self.value,
			props.value,
		);
		if (ret == null)
			return error.SdlError;
		return Texture{ .value = ret };
	}
};

/// An efficient driver-specific representation of pixel data.
pub const Texture = struct {
	value: C.SDL_Texture,

	/// Get the properties associated with a texture.
	pub fn getProperties(
		self: Texture,
	) !properties.Group {
		const ret = C.SDL_GetTextureProperties(
			&self.value,
		);
		if (ret == 0)
			return error.SdlError;
		return properties.Group{ .value = ret };
	}

	/// Get the renderer that created an SDL_Texture.
	pub fn getRenderer(
		self: Texture,
	) !Renderer {
		const ret = C.SDL_GetRendererFromTexture(
			&self.value,
		);
		if (ret == null)
			return error.SdlError;
		return Renderer{ .value = ret.? };
	}

	/// Get the size of a texture, as floating point values.
	pub fn getSize(
		self: Texture,
	) !struct { width: f32, height: f32 } {
		var w: f32 = undefined;
		var h: f32 = undefined;
		const ret = C.SDL_GetTextureSize(
			&self.value,
			&w,
			&h,
		);
		if (!ret)
			return error.SdlError;
		return .{ .width = @floatCast(w), .height = @floatCast(h) };
	}

	/// Set an additional color value multiplied into render copy operations.
	pub fn setColorMod(
		self: Texture,
		r: u8,
		g: u8,
		b: u8,
	) !void {
		const ret = C.SDL_SetTextureColorMod(
			&self.value,
			@intCast(r),
			@intCast(g),
			@intCast(b),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Set an additional color value multiplied into render copy operations.
	pub fn setColorModFloat(
		self: Texture,
		r: f32,
		g: f32,
		b: f32,
	) !void {
		const ret = C.SDL_SetTextureColorModFloat(
			&self.value,
			@floatCast(r),
			@floatCast(g),
			@floatCast(b),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Get the additional color value multiplied into render copy operations.
	pub fn getColorMod(
		self: Texture,
	) !struct { r: u8, g: u8, b: u8 } {
		var r: u8 = undefined;
		var g: u8 = undefined;
		var b: u8 = undefined;
		const ret = C.SDL_GetTextureColorMod(
			&self.value,
			&r,
			&g,
			&b,
		);
		if (!ret)
			return error.SdlError;
		return .{ .r = r, .g = g, .b = b };
	}

	/// Get the additional color value multiplied into render copy operations.
	pub fn getColorModFloat(
		self: Texture,
	) !struct { r: f32, g: f32, b: f32 } {
		var r: f32 = undefined;
		var g: f32 = undefined;
		var b: f32 = undefined;
		const ret = C.SDL_GetTextureColorModFloat(
			&self.value,
			&r,
			&g,
			&b,
		);
		if (!ret)
			return error.SdlError;
		return .{ .r = r, .g = g, .b = b };
	}

	/// Set an additional alpha value multiplied into render copy operations.
	pub fn setAlphaMod(
		self: Texture,
		alpha: u8,
	) !void {
		const ret = C.SDL_SetTextureAlphaMod(
			&self.value,
			@intCast(alpha),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Set an additional alpha value multiplied into render copy operations.
	pub fn setAlphaModFloat(
		self: Texture,
		alpha: f32,
	) !void {
		const ret = C.SDL_SetTextureAlphaModFloat(
			&self.value,
			@floatCast(alpha),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Get the additional alpha value multiplied into render copy operations.
	pub fn getAlphaMod(
		self: Texture,
	) !u8 {
		var alpha: u8 = undefined;
		const ret = C.SDL_GetTextureAlphaMod(
			&self.value,
			&alpha,
		);
		if (!ret)
			return error.SdlError;
		return alpha;
	}

	/// Get the additional alpha value multiplied into render copy operations.
	pub fn getAlphaModFloat(
		self: Texture,
	) !f32 {
		var alpha: f32 = undefined;
		const ret = C.SDL_GetTextureAlphaModFloat(
			&self.value,
			&alpha,
		);
		if (!ret)
			return error.SdlError;
		return alpha;
	}

	/// Set the blend mode for a texture, used by `renderer.renderTexture`.
	pub fn setBlendMode(
		self: Texture,
		mode: blend_mode.Mode,
	) !void {
		const ret = C.SDL_SetTextureBlendMode(
			&self.value,
			mode.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Get the blend mode used for texture copy operations.
	pub fn getBlendMode(
		self: Texture,
	) !?blend_mode.Mode {
		var mode: C.SDL_BlendMode = undefined;
		const ret = C.SDL_GetTextureBlendMode(
			&self.value,
			&mode,
		);
		if (!ret)
			return error.SdlError;
		if (mode == C.SDL_BLENDMODE_INVALID)
            return null;
		return .{ .value = mode };
	}

	/// Set the scale mode used for texture scale operations.
	pub fn setScaleMode(
		self: Texture,
		mode: surface.ScaleMode,
	) !void {
		const ret = C.SDL_SetTextureScaleMode(
			&self.value,
			@intFromEnum(mode),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Get the scale mode used for texture scale operations.
	pub fn getScaleMode(
		self: Texture,
	) !surface.ScaleMode {
		var mode: C.SDL_ScaleMode = undefined;
		const ret = C.SDL_GetTextureScaleMode(
			&self.value,
			&mode,
		);
		if (!ret)
			return error.SdlError;
		return @enumFromInt(mode);
	}

	/// Update the given texture rectangle with new pixel data.
	pub fn update(
		self: Texture,
		update_area: ?rect.IRect,
		data: []const u8,
	) !void {
		const update_area_sdl: ?C.SDL_Rect = if (update_area == null) null else update_area.?.toSdl();
		const ret = C.SDL_UpdateTexture(
			&self.value,
			if (update_area_sdl == null) null else &(update_area_sdl.?),
			data.ptr,
			@intCast(data.len / (if (update_area_sdl) |val| @as(usize, @intCast(val.h)) else self.getHeight())),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Get the pixel format for the texture.
    pub fn getPixelFormat(self: Texture) ?pixels.Format {
        return if (self.value.format == C.SDL_PIXELFORMAT_UNKNOWN) null else @enumFromInt(self.value.format);
    }

	/// Get the width of the texture.
    pub fn getWidth(self: Texture) usize {
        return @intCast(self.value.w);
    }

	/// Get the height of the texture.
    pub fn getHeight(self: Texture) usize {
        return @intCast(self.value.h);
    }

	/// Get the reference count of the texture.
    pub fn getRefCount(self: Texture) usize {
        return @intCast(self.value.refcount);
    }
};

// /// Vertex for rendering.
// pub const Vertex = extern struct {
//     /// Position in SDL renderer coordinates.
//     position: rect.FPoint,
//     /// Vertex color.
//     color: pixels.FColor,
//     /// Normalize texture coordinates.
//     tex_coord: rect.FPoint,
// };

/// The name of the software renderer.
pub const software_renderer_name = C.SDL_SOFTWARE_RENDERER;

const blend_mode = @import("blend_mode.zig");
const video = @import("video.zig");
const properties = @import("properties.zig");
const rect = @import("rect.zig");
const surface = @import("surface.zig");
const pixels = @import("pixels.zig");
