// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// The scaling mode.
pub const ScaleMode = enum(c_uint) {
	/// Nearest pixel sampling.
	Nearest = C.SDL_SCALEMODE_NEAREST,
	/// Linear pixel sampling.
	Linear = C.SDL_SCALEMODE_LINEAR,

	/// Copy a block of pixels of one format to another format.
	pub fn convertPixels(
		width: u31,
		height: u31,
		src_format: pixels.Format,
		src: []const u8,
		dst_format: pixels.Format,
		dst: []const u8,
	) !void {
		const ret = C.SDL_ConvertPixels(
			@intCast(width),
			@intCast(height),
			src_format.value,
			src.ptr,
			@intCast(src.len / height),
			dst_format.value,
			dst.ptr,
			@intCast(dst.len / height),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Copy a block of pixels of one format and colorspace to another format and colorspace.
	pub fn convertPixelsAndColorspace(
		width: u31,
		height: u31,
		src_format: pixels.Format,
		src_colorspace: pixels.Colorspace,
		src_properties: properties.Group,
		src: []const u8,
		dst_format: pixels.Format,
		dst_colorspace: pixels.Colorspace,
		dst_properties: properties.Group,
		dst: []const u8,
	) !void {
		const ret = C.SDL_ConvertPixelsAndColorspace(
			@intCast(width),
			@intCast(height),
			src_format.value,
			src_colorspace.value,
			src_properties.value,
			src.ptr,
			@intCast(src.len / height),
			dst_format.value,
			dst_colorspace.value,
			dst_properties.value,
			dst.ptr,
			@intCast(dst.len / height),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Premultiply the alpha on a block of pixels.
	pub fn premultiplyAlpha(
		width: u31,
		height: u31,
		src_format: pixels.Format,
		src: []const u8,
		dst_format: pixels.Format,
		dst: []const u8,
		linear: bool,
	) !void {
		const ret = C.SDL_PremultiplyAlpha(
			@intCast(width),
			@intCast(height),
			src_format.value,
			src.ptr,
			@intCast(src.len / height),
			dst_format.value,
			dst.ptr,
			@intCast(dst.len / height),
			linear,
		);
		if (!ret)
			return error.SdlError;
	}
};

/// The flipping mode.
pub const FlipMode = enum(c_uint) {
	/// Flip horizontally.
	Horizontal = C.SDL_FLIP_HORIZONTAL,
	/// Flip vertically.
	Vertical = C.SDL_FLIP_VERTICAL,
};

/// A collection of pixels used in software blitting.
pub const Surface = struct {
	value: *C.SDL_Surface,

	/// Allocate a new surface with a specific pixel format.
	pub fn init(
		width: u31,
		height: u31,
		format: pixels.Format,
	) !Surface {
		const ret = C.SDL_CreateSurface(
			@intCast(width),
			@intCast(height),
			format.value,
		);
		if (ret == null)
			return error.SdlError;
		return Surface{ .value = ret };
	}

	/// Allocate a new surface with a specific pixel format and data in the format.
	pub fn initFrom(
		width: u31,
		height: u31,
		format: pixels.Format,
		pixel_data: []const u8,
	) !Surface {
		const ret = C.SDL_CreateSurfaceFrom(
			@intCast(width),
			@intCast(height),
			format.value,
			pixel_data.ptr,
			@intCast(pixel_data.len / height),
		);
		if (ret == null)
			return error.SdlError;
		return Surface{ .value = ret };
	}

	/// Free a surface.
	pub fn deinit(
		self: Surface,
	) void {
		const ret = C.SDL_DestroySurface(
			self.value,
		);
		_ = ret;
	}

	/// Get the properties associated with a surface.
	pub fn getProperties(
		self: Surface,
	) !properties.Group {
		const ret = C.SDL_GetSurfaceProperties(
			self.value,
		);
		if (ret == 0)
			return error.SdlError;
		return properties.Group{ .value = ret };
	}

	/// Set the colorspace used by a surface.
	pub fn setColorspace(
		self: Surface,
		colorspace: pixels.Colorspace,
	) !void {
		const ret = C.SDL_SetSurfaceColorspace(
			self.value,
			colorspace.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Get the colorspace used by a surface.
	pub fn getColorspace(
		self: Surface,
	) ?pixels.Colorspace {
		const ret = C.SDL_GetSurfaceColorspace(
			self.value,
		);
		if (ret == C.SDL_COLORSPACE_UNKNOWN)
			return null;
		return pixels.Colorspace{ .value = ret };
	}

	/// Create a palette and associate it with a surface. Returned palette does not need to be freed.
	pub fn createPalette(
		self: Surface,
	) !pixels.Palette {
		const ret = C.SDL_CreateSurfacePalette(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return pixels.Palette{ .value = ret };
	}

	/// Set the palette used by a surface.
	pub fn setPalette(
		self: Surface,
		palette: pixels.Palette,
	) !void {
		const ret = C.SDL_SetSurfacePalette(
			self.value,
			palette.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Get the palette used by a surface.
	pub fn getPalette(
		self: Surface,
	) ?pixels.Palette {
		const ret = C.SDL_GetSurfacePalette(
			self.value,
		);
		if (ret == null)
			return null;
		return pixels.Palette{ .value = ret };
	}

	/// Add an alternate version of a surface.
	pub fn addAlternateImage(
		self: Surface,
		image: Surface,
	) !void {
		const ret = C.SDL_AddSurfaceAlternateImage(
			self.value,
			image.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Return whether a surface has alternate versions available.
	pub fn hasAlternateImage(
		self: Surface,
	) bool {
		const ret = C.SDL_SurfaceHasAlternateImages(
			self.value,
		);
		return ret;
	}

	/// Remove all alternate versions of a surface.
	pub fn removeAlternateImages(
		self: Surface,
	) void {
		const ret = C.SDL_RemoveSurfaceAlternateImages(
			self.value,
		);
		_ = ret;
	}

	/// Set up a surface for directly accessing the pixels. Not all surfaces need locking.
	pub fn lock(
		self: Surface,
	) !void {
		const ret = C.SDL_LockSurface(
			self.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Release a surface after directly accessing the pixels.
	pub fn unlock(
		self: Surface,
	) void {
		const ret = C.SDL_UnlockSurface(
			self.value,
		);
		_ = ret;
	}

	/// Create a surface from a BMP image from a seekable stream.
	pub fn initFromBmpIo(
		stream: io_stream.Stream,
		close_stream_after: bool,
	) !Surface {
		const ret = C.SDL_LoadBMP_IO(
			stream.value,
			close_stream_after,
		);
		if (ret == null)
			return error.SdlError;
		return Surface{ .value = ret };
	}

	/// Load a BMP image from a file.
	pub fn initFromBmpFile(
		file: [:0]const u8,
	) !Surface {
		const ret = C.SDL_LoadBMP(
			file,
		);
		if (ret == null)
			return error.SdlError;
		return Surface{ .value = ret };
	}

	/// Save a surface to a seekable SDL data stream in BMP format.
	pub fn saveBmpIo(
		self: Surface,
		stream: io_stream.Stream,
		close_stream_after: bool,
	) !void {
		const ret = C.SDL_SaveBMP_IO(
			self.value,
			stream.value,
			close_stream_after,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Save a surface to a file.
	pub fn saveBmpFile(
		self: Surface,
		file: [:0]const u8,
	) !void {
		const ret = C.SDL_SaveBMP(
			self.value,
			file,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Set the RLE acceleration hint for a surface.
	pub fn setRLE(
		self: Surface,
		enabled: bool,
	) !void {
		const ret = C.SDL_SetSurfaceRLE(
			self.value,
			enabled,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Returns whether the surface is RLE enabled.
	pub fn hasRLE(
		self: Surface,
	) bool {
		const ret = C.SDL_SurfaceHasRLE(
			self.value,
		);
		return ret;
	}

	/// Set the color key (transparent pixel) in a surface.
	pub fn setColorKey(
		self: Surface,
		pixel: ?pixels.Pixel,
	) !void {
		const ret = C.SDL_SetSurfaceColorKey(
			self.value,
			pixel != null,
			if (pixel == null) 0 else pixel.?.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Returns whether the surface has a color key.
	pub fn hasColorKey(
		self: Surface,
	) bool {
		const ret = C.SDL_SurfaceHasColorKey(
			self.value,
		);
		return ret;
	}

	/// Get the color key (transparent pixel) for a surface.
	pub fn getColorKey(
		self: Surface,
	) !pixels.Pixel {
		var key: u32 = undefined;
		const ret = C.SDL_GetSurfaceColorKey(
			self.value,
			&key,
		);
		if (!ret)
			return error.SdlError;
		return pixels.Pixel{ .value = ret };
	}

	/// Set an additional color value multiplied into blit operations.
	pub fn setColorMod(
		self: Surface,
		color: pixels.Color,
	) !void {
		const ret = C.SDL_SetSurfaceColorMod(
			self.value,
			color.r,
			color.g,
			color.b,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Get the additional color value multiplied into blit operations.
	pub fn getColorMod(
		self: Surface,
	) !pixels.Color {
		var r: u8 = undefined;
		var g: u8 = undefined;
		var b: u8 = undefined;
		const ret = C.SDL_GetSurfaceColorMod(
			self.value,
			&r,
			&g,
			&b,
		);
		if (!ret)
			return error.SdlError;
		return pixels.Color{ .r = r, .g = g, .b = b };
	}

	/// Set an additional alpha value used in blit operations.
	pub fn setAlphaMod(
		self: Surface,
		alpha: u8,
	) !void {
		const ret = C.SDL_SetSurfaceAlphaMod(
			self.value,
			@intCast(alpha),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Get the additional alpha value used in blit operations.
	pub fn getAlphaMod(
		self: Surface,
	) u8 {
		var alpha: u8 = undefined;
		const ret = C.SDL_GetSurfaceAlphaMod(
			self.value,
			&alpha,
		);
		if (!ret)
			return error.SdlError;
		return alpha;
	}

	/// Set the blend mode used for blit operations.
	pub fn setBlendMode(
		self: Surface,
		mode: blend_mode.Mode,
	) !void {
		const ret = C.SDL_SetSurfaceBlendMode(
			self.value,
			mode.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Get the blend mode used for blit operations.
	pub fn getBlendMode(
		self: Surface,
	) !blend_mode.Mode {
		var mode: C.SDL_BlendMode = undefined;
		const ret = C.SDL_GetSurfaceBlendMode(
			self.value,
			&mode,
		);
		if (!ret)
			return error.SdlError;
		return mode;
	}

	/// Set the clipping rectangle for a surface.
	pub fn setClipRect(
		self: Surface,
		val: ?rect.IRect,
	) !void {
		const val_sdl: ?C.SDL_Rect = if (val == null) null else val.?.toSdl();
		const ret = C.SDL_SetSurfaceClipRect(
			self.value,
			if (val_sdl == null) null else &(val_sdl.?),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Get the clipping rectangle for a surface.
	pub fn getClipRect(
		self: Surface,
	) !rect.IRect {
		var val: C.SDL_Rect = undefined;
		const ret = C.SDL_GetSurfaceClipRect(
			self.value,
			&val,
		);
		if (!ret)
			return error.SdlError;
		return rect.IRect.fromSdl(val);
	}

	/// Flip a surface vertically or horizontally.
	pub fn flip(
		self: Surface,
		flip_mode: ?FlipMode,
	) !void {
		const ret = C.SDL_FlipSurface(
			self.value,
			if (flip_mode == null) C.SDL_FLIP_NONE else @intFromEnum(flip_mode.?),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Creates a new surface identical to the existing surface.
	pub fn duplicate(
		self: Surface,
	) !Surface {
		const ret = C.SDL_DuplicateSurface(
			self.value,
		);
		if (ret == null)
			return error.SdlError;
		return Surface{ .value = ret };
	}

	/// Creates a new surface identical to the existing surface, scaled to the desired size.
	pub fn scale(
		self: Surface,
		width: u31,
		height: u31,
		scale_mode: ScaleMode,
	) !Surface {
		const ret = C.SDL_ScaleSurface(
			self.value,
			@intCast(width),
			@intCast(height),
			@intFromEnum(scale_mode),
		);
		if (ret == null)
			return error.SdlError;
		return Surface{ .value = ret };
	}

	/// Copy an existing surface to a new surface of the specified format.
	pub fn convertFormat(
		self: Surface,
		format: pixels.Format,
	) !Surface {
		const ret = C.SDL_ConvertSurface(
			self.value,
			format.value,
		);
		if (ret == null)
			return error.SdlError;
		return Surface{ .value = ret };
	}

	/// Copy an existing surface to a new surface of the specified format and colorspace.
	pub fn convertFormatAndColorspace(
		self: Surface,
		format: pixels.Format,
		palette: ?pixels.Palette,
		colorspace: pixels.Colorspace,
		color_properties: properties.Group,
	) !Surface {
		const ret = C.SDL_ConvertSurfaceAndColorspace(
			self.value,
			format.value,
			if (palette) |palette_val| palette_val.value else null,
			colorspace.value,
			color_properties.value,
		);
		if (ret == null)
			return error.SdlError;
		return Surface{ .value = ret };
	}

	/// Premultiply the alpha in a surface.
	pub fn premultiplySurfaceAlpha(
		self: Surface,
		linear: bool,
	) !void {
		const ret = C.SDL_PremultiplySurfaceAlpha(
			self.value,
			linear,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Clear a surface with a specific color, with floating point precision.
	pub fn clear(
		self: Surface,
		color: pixels.FColor,
	) !void {
		const ret = C.SDL_ClearSurface(
			self.value,
			color.r,
			color.g,
			color.b,
			color.a,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Perform a fast fill of a rectangle with a specific color.
	pub fn fillRect(
		self: Surface,
		val: ?rect.IRect,
		color: pixels.Pixel,
	) !void {
		const val_sdl: ?C.SDL_Rect = if (val == null) null else val.?.toSdl();
		const ret = C.SDL_FillSurfaceRect(
			self.value,
			if (val_sdl == null) null else &(val_sdl.?),
			color.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Perform a fast fill of a set of rectangles with a specific color.
	pub fn fillRects(
		self: Surface,
		rects: []rect.Rect(c_int),
		color: pixels.Pixel,
	) !void {
		const ret = C.SDL_FillSurfaceRects(
			self.value,
			@ptrCast(rects.ptr),
			@intCast(rects.len),
			color.value,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Performs a fast blit from the source surface to the destination surface.
	pub fn blit(
		self: Surface,
		area_to_copy: ?rect.IRect,
		dest: Surface,
		area_to_copy_to: ?rect.IRect,
	) !void {
		const area_to_copy_sdl: ?C.SDL_Rect = if (area_to_copy == null) null else area_to_copy.?.toSdl();
		const area_to_copy_to_sdl: ?C.SDL_Rect = if (area_to_copy_to == null) null else area_to_copy_to.?.toSdl();
		const ret = C.SDL_BlitSurface(
			self.value,
			if (area_to_copy_sdl == null) null else &(area_to_copy_sdl.?),
			dest.value,
			if (area_to_copy_to_sdl == null) null else &(area_to_copy_to_sdl.?),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Perform low-level surface blitting only, assumes surface rectangles have already been clipped.
	pub fn blitUnchecked(
		self: Surface,
		area_to_copy: rect.IRect,
		dest: Surface,
		area_to_copy_to: rect.IRect,
	) !void {
		const area_to_copy_sdl: C.SDL_Rect = area_to_copy.toSdl();
		const area_to_copy_to_sdl: C.SDL_Rect = area_to_copy_to.toSdl();
		const ret = C.SDL_BlitSurfaceUnchecked(
			self.value,
			&area_to_copy_sdl,
			dest.value,
			&area_to_copy_to_sdl,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Perform a scaled blit to a destination surface, which may be of a different format.
	pub fn blitScaled(
		self: Surface,
		area_to_copy: ?rect.IRect,
		dest: Surface,
		area_to_copy_to: ?rect.IRect,
		scale_mode: ScaleMode,
	) !void {
		const area_to_copy_sdl: ?C.SDL_Rect = if (area_to_copy == null) null else area_to_copy.?.toSdl();
		const area_to_copy_to_sdl: ?C.SDL_Rect = if (area_to_copy_to == null) null else area_to_copy_to.?.toSdl();
		const ret = C.SDL_BlitSurfaceScaled(
			self.value,
			if (area_to_copy_sdl == null) null else &(area_to_copy_sdl.?),
			dest.value,
			if (area_to_copy_to_sdl == null) null else &(area_to_copy_to_sdl.?),
			@intFromEnum(scale_mode),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Perform low-level surface scaled blitting only, assumes surface rectangles have already been clipped.
	pub fn blitScaledUnchecked(
		self: Surface,
		area_to_copy: rect.IRect,
		dest: Surface,
		area_to_copy_to: rect.IRect,
		scale_mode: ScaleMode,
	) !void {
		const area_to_copy_sdl: C.SDL_Rect = area_to_copy.toSdl();
		const area_to_copy_to_sdl: C.SDL_Rect = area_to_copy_to.toSdl();
		const ret = C.SDL_BlitSurfaceUncheckedScaled(
			self.value,
			&area_to_copy_sdl,
			dest.value,
			&area_to_copy_to_sdl,
			@intFromEnum(scale_mode),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Perform a tiled blit to a destination surface, which may be of a different format.
	pub fn blitTiled(
		self: Surface,
		area_to_copy: ?rect.IRect,
		dest: Surface,
		area_to_copy_to: ?rect.IRect,
	) !void {
		const area_to_copy_sdl: ?C.SDL_Rect = if (area_to_copy == null) null else area_to_copy.?.toSdl();
		const area_to_copy_to_sdl: ?C.SDL_Rect = if (area_to_copy_to == null) null else area_to_copy_to.?.toSdl();
		const ret = C.SDL_BlitSurfaceTiled(
			self.value,
			if (area_to_copy_sdl == null) null else &(area_to_copy_sdl.?),
			dest.value,
			if (area_to_copy_to_sdl == null) null else &(area_to_copy_to_sdl.?),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Perform a scaled and tiled blit to a destination surface, which may be of a different format.
	pub fn blitTiledWithScale(
		self: Surface,
		area_to_copy: ?rect.IRect,
		scale_amount: f32,
		scale_mode: ScaleMode,
		dest: Surface,
		area_to_copy_to: ?rect.IRect,
	) !void {
		const area_to_copy_sdl: ?C.SDL_Rect = if (area_to_copy == null) null else area_to_copy.?.toSdl();
		const area_to_copy_to_sdl: ?C.SDL_Rect = if (area_to_copy_to == null) null else area_to_copy_to.?.toSdl();
		const ret = C.SDL_BlitSurfaceTiledWithScale(
			self.value,
			if (area_to_copy_sdl == null) null else &(area_to_copy_sdl.?),
			@floatCast(scale_amount),
			@intFromEnum(scale_mode),
			dest.value,
			if (area_to_copy_to_sdl == null) null else &(area_to_copy_to_sdl.?),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Perform a scaled blit using the 9-grid algorithm to a destination surface, which may be of a different format.
	pub fn blit9Grid(
		self: Surface,
		area_to_copy: ?rect.IRect,
		left_width: u31,
		right_width: u31,
		top_height: u31,
		bottom_height: u31,
		scale_amount: f32,
		scale_mode: ScaleMode,
		dest: Surface,
		area_to_copy_to: ?rect.IRect,
	) !void {
		const area_to_copy_sdl: ?C.SDL_Rect = if (area_to_copy == null) null else area_to_copy.?.toSdl();
		const area_to_copy_to_sdl: ?C.SDL_Rect = if (area_to_copy_to == null) null else area_to_copy_to.?.toSdl();
		const ret = C.SDL_BlitSurface9Grid(
			self.value,
			if (area_to_copy_sdl == null) null else &(area_to_copy_sdl.?),
			@intCast(left_width),
			@intCast(right_width),
			@intCast(top_height),
			@intCast(bottom_height),
			@floatCast(scale_amount),
			@intFromEnum(scale_mode),
			dest.value,
			if (area_to_copy_to_sdl == null) null else &(area_to_copy_to_sdl.?),
		);
		if (!ret)
			return error.SdlError;
	}

	/// Map an RGB triple to an opaque pixel value for a surface.
	pub fn mapRgb(
		self: Surface,
		r: u8,
		g: u8,
		b: u8,
	) pixels.Pixel {
		const ret = C.SDL_MapSurfaceRGB(
			self.value,
			@intCast(r),
			@intCast(g),
			@intCast(b),
		);
		return pixels.Pixel{ .value = ret };
	}

	/// Map an RGBA quadruple to a pixel value for a surface.
	pub fn mapRgba(
		self: Surface,
		r: u8,
		g: u8,
		b: u8,
		a: u8,
	) pixels.Pixel {
		const ret = C.SDL_MapSurfaceRGBA(
			self.value,
			@intCast(r),
			@intCast(g),
			@intCast(b),
			@intCast(a),
		);
		return pixels.Pixel{ .value = ret };
	}

	/// Retrieves a single pixel from a surface. Is better for correctness, not speed. Best for testing.
	pub fn readPixel(
		self: Surface,
		x: u31,
		y: u31,
	) !pixels.Color {
		var r: u8 = undefined;
		var g: u8 = undefined;
		var b: u8 = undefined;
		var a: u8 = undefined;
		const ret = C.SDL_ReadSurfacePixel(
			self.value,
			@intCast(x),
			@intCast(y),
			&r,
			&g,
			&b,
			&a,
		);
		if (!ret)
			return error.SdlError;
		return .{ .r = r, .g = g, .b = b, .a = a };
	}

	/// Retrieves a single pixel from a surface. Is better for correctness, not speed. Best for testing.
	pub fn readPixelFloat(
		self: Surface,
		x: u31,
		y: u31,
	) !pixels.FColor {
		var r: f32 = undefined;
		var g: f32 = undefined;
		var b: f32 = undefined;
		var a: f32 = undefined;
		const ret = C.SDL_ReadSurfacePixelFloat(
			self.value,
			@intCast(x),
			@intCast(y),
			&r,
			&g,
			&b,
			&a,
		);
		if (!ret)
			return error.SdlError;
		return .{ .r = r, .g = g, .b = b, .a = a };
	}

	/// Writes a single pixel to a surface. Is better for correctness, not speed. Best for testing.
	pub fn writePixel(
		self: Surface,
		x: u31,
		y: u31,
		color: pixels.Color,
	) !void {
		const ret = C.SDL_WriteSurfacePixel(
			self.value,
			@intCast(x),
			@intCast(y),
			color.r,
			color.g,
			color.b,
			color.a,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Writes a single pixel to a surface. Is better for correctness, not speed. Best for testing.
	pub fn writePixelFloat(
		self: Surface,
		x: u31,
		y: u31,
		color: pixels.FColor,
	) !void {
		const ret = C.SDL_WriteSurfacePixelFloat(
			self.value,
			@intCast(x),
			@intCast(y),
			color.r,
			color.g,
			color.b,
			color.a,
		);
		if (!ret)
			return error.SdlError;
	}

	/// Get the surface flags.
    pub fn getFlags(
        self: Surface,
    ) Flags {
        return Flags.fromSdl(self.value.flags);
    }

	/// Get the surface format.
    pub fn getFormat(
        self: Surface,
    ) ?pixels.Format {
        if (self.value.format == C.SDL_PIXELFORMAT_UNKNOWN)
            return null;
        return pixels.Format.fromSdl(self.value.format);
    }

	/// Get the surface width.
    pub fn getWidth(
        self: Surface,
    ) u32 {
        return @intCast(self.value.w);
    }

	/// Get the surface height.
    pub fn getHeight(
        self: Surface,
    ) u32 {
        return @intCast(self.value.h);
    }

	/// Get the byte distance between rows of pixels.
    pub fn getPitch(
        self: Surface,
    ) u32 {
        return @intCast(self.value.pitch);
    }

	/// Get a slice to writable pixels. If the pixels are not writeable, null is returned.
    pub fn getPixels(
        self: Surface,
    ) ?[]u8 {
        if (self.value.pixels) |pixel|
            return .{ .ptr = @ptrCast(pixel), .len = @intCast(self.value.h * self.value.pitch) };
        return null;
    }

	/// Get a slice including all versions of a surface. Result is to be freed.
    pub fn getImages(
        self: Surface,
        allocator: std.mem.Allocator,
    ) ![]Surface {
        var num: c_int = undefined;
        const ret = C.SDL_GetSurfaceImages(self.value, &num);
        if (ret == null)
            return error.SdlError;
        defer C.SDL_free(ret);
        const converted_ret = try allocator.alloc(Surface, @intCast(num));
        for (converted_ret, 0..num) |surface, index| {
            surface.value = ret[index];
        }
        return converted_ret;
    }
};

/// The flags on an SDL Surface.
pub const Flags = struct {
	/// Surface uses preallocated pixel memory.
	preallocated: bool,
	/// Surface needs to be locked to access pixels.
	lock_needed: bool,
	/// Surface is currently locked.
	locked: bool,
	/// Surface uses pixel memory allocated with aligned allocator.
	simd_aligned: bool,

	/// Convert from an SDL value.
	pub fn fromSdl(flags: C.SDL_SurfaceFlags) Flags {
		return .{
			.preallocated = (flags & C.SDL_SURFACE_PREALLOCATED) != 0,
			.lock_needed = (flags & C.SDL_SURFACE_LOCK_NEEDED) != 0,
			.locked = (flags & C.SDL_SURFACE_LOCKED) != 0,
			.simd_aligned = (flags & C.SDL_SURFACE_SIMD_ALIGNED) != 0,
		};
	}

	/// Convert to an SDL value.
	pub fn toSdl(self: Flags) C.SDL_SurfaceFlags {
		return (if (self.preallocated) @as(C.SDL_SurfaceFlags, C.SDL_SURFACE_PREALLOCATED) else 0) |
			(if (self.lock_needed) @as(C.SDL_SurfaceFlags, C.SDL_SURFACE_LOCK_NEEDED) else 0) |
			(if (self.locked) @as(C.SDL_SurfaceFlags, C.SDL_SURFACE_LOCKED) else 0) |
			(if (self.simd_aligned) @as(C.SDL_SurfaceFlags, C.SDL_SURFACE_SIMD_ALIGNED) else 0) |
			0;
	}
};

const io_stream = @import("io_stream.zig");
const properties = @import("properties.zig");
const blend_mode = @import("blend_mode.zig");
const rect = @import("rect.zig");
const pixels = @import("pixels.zig");
