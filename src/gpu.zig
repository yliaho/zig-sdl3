const C = @import("c.zig").C;
const errors = @import("errors.zig");
const pixels = @import("pixels.zig");
const properties = @import("properties.zig");
const rect = @import("rect.zig");
const std = @import("std");
const surface = @import("surface.zig");
const video = @import("video.zig");

/// Specifies a blending factor to be used when pixels in a render target are blended with existing pixels in the texture.
///
/// ## Remarks
/// The source color is the value written by the fragment shader.
/// The destination color is the value currently existing in the texture.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const BlendFactor = enum(c_uint) {
    /// 0.
    zero = C.SDL_GPU_BLENDFACTOR_ZERO,
    /// 1.
    one = C.SDL_GPU_BLENDFACTOR_ONE,
    /// Source color.
    src_color = C.SDL_GPU_BLENDFACTOR_SRC_COLOR,
    /// 1 - Source color.
    one_minus_src_color = C.SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_COLOR,
    /// Destination color.
    dst_color = C.SDL_GPU_BLENDFACTOR_DST_COLOR,
    /// 1 - Destination color.
    one_minus_dst_color = C.SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_COLOR,
    /// Source alpha.
    src_alpha = C.SDL_GPU_BLENDFACTOR_SRC_ALPHA,
    /// 1 - Source alpha.
    one_minus_src_alpha = C.SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_ALPHA,
    /// Destination alpha.
    dst_alpha = C.SDL_GPU_BLENDFACTOR_DST_ALPHA,
    /// 1 - Destination alpha.
    one_minus_dst_alpha = C.SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_ALPHA,
    /// Blend constant.
    constant_color = C.SDL_GPU_BLENDFACTOR_CONSTANT_COLOR,
    /// 1 - Blend constant.
    one_minus_constant_color = C.SDL_GPU_BLENDFACTOR_ONE_MINUS_CONSTANT_COLOR,
    /// Min(Source alpha, Destination alpha).
    src_alpha_saturate = C.SDL_GPU_BLENDFACTOR_SRC_ALPHA_SATURATE,

    /// Make a blend factor from SDL.
    pub fn fromSdl(val: C.SDL_GPUBlendFactor) ?BlendFactor {
        if (val == C.SDL_GPU_BLENDFACTOR_INVALID) {
            return null;
        }
        return @enumFromInt(val);
    }

    /// Convert a blend factor to an SDL value.
    pub fn toSdl(val: ?BlendFactor) C.SDL_GPUBlendFactor {
        if (val) |tmp| {
            return @intFromEnum(tmp);
        }
        return C.SDL_GPU_BLENDFACTOR_INVALID;
    }
};

/// Specifies the operator to be used when pixels in a render target are blended with existing pixels in the texture.
///
/// ## Remarks
/// The source color is the value written by the fragment shader.
/// The destination color is the value currently existing in the texture.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const BlendOperation = enum(c_uint) {
    /// (Source * Source Factor) + (Destination * Destination Factor).
    add = C.SDL_BLENDOPERATION_ADD,
    /// (Source * Source Factor) - (Destination * Destination Factor).
    subtract = C.SDL_BLENDOPERATION_SUBTRACT,
    /// (Destination * Destination Factor) - (Source * Source Factor).
    reverse_subtract = C.SDL_BLENDOPERATION_REV_SUBTRACT,
    /// Min(Source, Destination).
    min = C.SDL_BLENDOPERATION_MINIMUM,
    /// Max(Source, Destination).
    max = C.SDL_BLENDOPERATION_MAXIMUM,

    /// Create from SDL.
    pub fn fromSdl(val: C.SDL_GPUBlendOp) ?BlendOperation {
        if (val == C.SDL_GPU_BLENDOP_INVALID) {
            return null;
        }
        return @enumFromInt(val);
    }

    /// Convert to an SDL value.
    pub fn toSdl(val: ?BlendOperation) C.SDL_GPUBlendOp {
        if (val) |tmp| {
            return @intFromEnum(tmp);
        }
        return C.SDL_GPU_BLENDOP_INVALID;
    }
};

/// A structure containing parameters for a blit command.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const BlitInfo = struct {
    /// The source region for the blit.
    source: BlitRegion,
    /// The destination region for the blit.
    destination: BlitRegion,
    /// What is done with the contents of the destination before the blit.
    load_op: LoadOperation,
    /// The color to clear the destination region to before the blit.
    /// Ignored if `load_op` is not `gpu.LoadOperation.clear`.
    clear_color: pixels.FColor,
    /// The flip mode for the source region.
    flip_mode: ?surface.FlipMode,
    /// The filter mode used when blitting.
    filter: Filter,
    /// True cycles the destination texture if it is already bound.
    cycle: bool,

    /// Convert from SDL.
    pub fn fromSdl(value: C.SDL_GPUBlitInfo) BlitInfo {
        return .{
            .source = BlitRegion.fromSdl(value.source),
            .destination = BlitRegion.fromSdl(value.destination),
            .load_op = @enumFromInt(value.load_op),
            .clear_color = value.clear_color,
            .flip_mode = surface.FlipMode.fromSdl(value.flip_mode),
            .filter = @enumFromInt(value.filter),
            .cycle = value.cycle,
        };
    }

    /// Convert to SDL.
    pub fn toSdl(self: BlitInfo) C.SDL_GPUBlitInfo {
        return .{
            .source = self.source.toSdl(),
            .destination = self.destination.toSdl(),
            .load_op = @intFromEnum(self.load_op),
            .clear_color = self.clear_color,
            .flip_mode = surface.FlipMode.toSdl(self.flip_mode),
            .filter = @intFromEnum(self.filter),
            .cycle = self.cycle,
        };
    }
};

/// A structure specifying a region of a texture used in the blit operation.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const BlitRegion = struct {
    /// The texture.
    texture: Texture,
    /// The mip level index of the region.
    mip_level: u32,
    /// The layer index or depth plane of the region.
    /// This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures.
    layer_or_depth_plane: u32,
    /// The region.
    region: rect.Rect(u32),

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUBlitRegion) BlitRegion {
        return .{
            .texture = .{ .value = value.texture.? },
            .mip_level = value.mip_level,
            .layer_or_depth_plane = value.layer_or_depth_plane,
            .region = .{
                .x = value.x,
                .y = value.y,
                .w = value.w,
                .h = value.h,
            },
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: BlitRegion) C.SDL_GPUBlitRegion {
        return .{
            .texture = self.texture.value,
            .mip_level = self.mip_level,
            .layer_or_depth_plane = self.layer_or_depth_plane,
            .x = self.region.x,
            .y = self.region.y,
            .w = self.region.w,
            .h = self.region.h,
        };
    }
};

/// An opaque handle representing a buffer.
///
/// ## Remarks
/// Used for vertices, indices, indirect draw commands, and general compute data.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Buffer = packed struct {
    value: *C.SDL_GPUBuffer,
};

/// A structure specifying parameters in a buffer binding call.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const BufferBinding = extern struct {
    /// The buffer to bind. Must have been created with `gpu.BufferUsageFlags.vertex` for `gpu.RenderPass.bindVertexBuffers()`,
    /// or `gpu.BufferUsageFlags.index` for S`gpu.RenderPass.bindIndexBuffers()`.
    buffer: Buffer,
    /// The starting byte of the data to bind in the buffer.
    offset: u32,

    // Binding tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_GPUBufferBinding) == @sizeOf(BufferBinding));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUBufferBinding, "buffer")) == @sizeOf(@FieldType(BufferBinding, "buffer")));
        std.debug.assert(@offsetOf(C.SDL_GPUBufferBinding, "buffer") == @offsetOf(BufferBinding, "buffer"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUBufferBinding, "offset")) == @sizeOf(@FieldType(BufferBinding, "offset")));
        std.debug.assert(@offsetOf(C.SDL_GPUBufferBinding, "offset") == @offsetOf(BufferBinding, "offset"));
    }
};

/// A structure specifying the parameters of a buffer.
///
/// ## Remarks
/// Note that certain combinations of usage flags are invalid, for example `gpu.BufferUsageFlags.vertex` and `gpu.BufferUsageFlags.index`.
pub const BufferCreateInfo = struct {
    /// How the buffer is intended to be used by the client.
    usage: BufferUsageFlags,
    /// The size in bytes of the buffer.
    size: u32,
    /// Properties for extensions.
    props: ?properties.Group,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUBufferCreateInfo) BufferCreateInfo {
        return .{
            .usage = BufferUsageFlags.fromSdl(value.usage),
            .size = value.size,
            .props = if (value.props == 0) null else .{ .value = value.props },
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: BufferCreateInfo) C.SDL_GPUBufferCreateInfo {
        return .{
            .usage = self.usage.toSdl(),
            .size = self.size,
            .props = if (self.props) |val| val.value else 0,
        };
    }
};

/// A structure specifying a location in a buffer.
///
/// ## Remarks
/// Used when copying data between buffers.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const BufferLocation = struct {
    /// The buffer.
    buffer: Buffer,
    /// The starting byte within the buffer.
    offset: u32,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUBufferLocation) BufferLocation {
        return .{
            .buffer = .{ .value = value.buffer.? },
            .offset = value.offset,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: BufferLocation) C.SDL_GPUBufferLocation {
        return .{
            .buffer = self.buffer.value,
            .offset = self.offset,
        };
    }
};

/// A structure specifying a region of a buffer.
///
/// ## Remarks
/// Used when transferring data to or from buffers.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const BufferRegion = struct {
    /// The buffer.
    buffer: Buffer,
    /// The starting byte within the buffer.
    offset: u32,
    /// The size in bytes of the region.
    size: u32,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUBufferRegion) BufferRegion {
        return .{
            .buffer = .{ .value = value.buffer.? },
            .offset = value.offset,
            .size = value.size,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: BufferRegion) C.SDL_GPUBufferRegion {
        return .{
            .buffer = self.buffer.value,
            .offset = self.offset,
            .size = self.size,
        };
    }
};

/// Specifies how a buffer is intended to be used by the client.
///
/// ## Remarks
/// A buffer must have at least one usage flag.
/// Note that some usage flag combinations are invalid.
///
/// Unlike textures, specifying both a "read" and "write" can be used for simultaneous read-write usage.
/// The same data synchronization concerns as textures apply.
///
/// If you use a "storage" flag, the data in the buffer must respect std140 layout conventions.
/// In practical terms this means you must ensure that vec3 and vec4 fields are 16-byte aligned.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const BufferUsageFlags = struct {
    /// Buffer is a vertex buffer.
    vertex: bool = false,
    /// Buffer is an index buffer.
    index: bool = false,
    /// Buffer is an indirect buffer.
    indirect: bool = false,
    /// Buffer supports storage reads in graphics stages.
    graphics_storage_read: bool = false,
    /// Buffer supports storage reads in the compute stage.
    compute_storage_read: bool = false,
    /// Buffer supports storage writes in the compute stage.
    compute_storage_write: bool = false,

    /// Convert flags from SDL.
    pub fn fromSdl(val: C.SDL_GPUBufferUsageFlags) BufferUsageFlags {
        return .{
            .vertex = val & C.SDL_GPU_BUFFERUSAGE_VERTEX,
            .index = val & C.SDL_GPU_BUFFERUSAGE_INDEX,
            .indirect = val & C.SDL_GPU_BUFFERUSAGE_INDIRECT,
            .graphics_storage_read = val & C.SDL_GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ,
            .compute_storage_read = val & C.SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_READ,
            .compute_storage_write = val & C.SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE,
        };
    }

    /// Get the SDL flags.
    pub fn toSdl(self: BufferUsageFlags) C.SDL_GPUBufferUsageFlags {
        const ret: C.SDL_GPUBufferUsageFlags = 0;
        if (self.vertex)
            ret |= C.SDL_GPU_BUFFERUSAGE_VERTEX;
        if (self.index)
            ret |= C.SDL_GPU_BUFFERUSAGE_INDEX;
        if (self.indirect)
            ret |= C.SDL_GPU_BUFFERUSAGE_INDIRECT;
        if (self.graphics_storage_read)
            ret |= C.SDL_GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ;
        if (self.compute_storage_read)
            ret |= C.SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_READ;
        if (self.compute_storage_write)
            ret |= C.SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE;
        return ret;
    }
};

/// Specifies which color components are written in a graphics pipeline.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const ColorComponentFlags = packed struct(C.SDL_GPUColorComponentFlags) {
    red: bool = false,
    green: bool = false,
    blue: bool = false,
    alpha: bool = false,
    _: u4 = 0,

    // Flag tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_GPUColorComponentFlags) == @sizeOf(ColorComponentFlags));
        std.debug.assert(C.SDL_GPU_COLORCOMPONENT_R == @as(C.SDL_GPUColorComponentFlags, @bitCast(ColorComponentFlags{ .red = true })));
        std.debug.assert(C.SDL_GPU_COLORCOMPONENT_G == @as(C.SDL_GPUColorComponentFlags, @bitCast(ColorComponentFlags{ .green = true })));
        std.debug.assert(C.SDL_GPU_COLORCOMPONENT_B == @as(C.SDL_GPUColorComponentFlags, @bitCast(ColorComponentFlags{ .blue = true })));
        std.debug.assert(C.SDL_GPU_COLORCOMPONENT_A == @as(C.SDL_GPUColorComponentFlags, @bitCast(ColorComponentFlags{ .alpha = true })));
    }
};

/// A structure specifying the blend state of a color target.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const ColorTargetBlendState = extern struct {
    /// The value to be multiplied by the source RGB value.
    source_color: BlendFactor,
    /// The value to be multiplied by the destination RGB value.
    destination_color: BlendFactor,
    /// The blend operation for the RGB components.
    color_blend: BlendOperation,
    /// The value to be multiplied by the source alpha.
    source_alpha: BlendFactor,
    /// The value to be multiplied by the destination alpha.
    destination_alpha: BlendFactor,
    /// The blend operation for the alpha component.
    alpha_blend: BlendOperation,
    /// A bitmask specifying which of the RGBA components are enabled for writing.
    /// Writes to all channels if `enable_color_write_mask` is false.
    color_write_mask: ColorComponentFlags,
    /// Whether blending is enabled for the color target.
    enable_blend: bool,
    /// Whether the color write mask is enabled.
    enable_color_write_mask: bool,
    _1: u8 = 0,
    _2: u8 = 0,

    // Size tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_GPUColorTargetBlendState) == @sizeOf(ColorTargetBlendState));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetBlendState, "src_color_blendfactor") == @offsetOf(ColorTargetBlendState, "source_color"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetBlendState, "src_color_blendfactor")) == @sizeOf(@FieldType(ColorTargetBlendState, "source_color")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetBlendState, "dst_color_blendfactor") == @offsetOf(ColorTargetBlendState, "destination_color"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetBlendState, "dst_color_blendfactor")) == @sizeOf(@FieldType(ColorTargetBlendState, "destination_color")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetBlendState, "color_blend_op") == @offsetOf(ColorTargetBlendState, "color_blend"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetBlendState, "color_blend_op")) == @sizeOf(@FieldType(ColorTargetBlendState, "color_blend")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetBlendState, "src_alpha_blendfactor") == @offsetOf(ColorTargetBlendState, "source_alpha"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetBlendState, "src_alpha_blendfactor")) == @sizeOf(@FieldType(ColorTargetBlendState, "source_alpha")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetBlendState, "dst_alpha_blendfactor") == @offsetOf(ColorTargetBlendState, "destination_alpha"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetBlendState, "dst_alpha_blendfactor")) == @sizeOf(@FieldType(ColorTargetBlendState, "destination_alpha")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetBlendState, "alpha_blend_op") == @offsetOf(ColorTargetBlendState, "alpha_blend"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetBlendState, "alpha_blend_op")) == @sizeOf(@FieldType(ColorTargetBlendState, "alpha_blend")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetBlendState, "color_write_mask") == @offsetOf(ColorTargetBlendState, "color_write_mask"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetBlendState, "color_write_mask")) == @sizeOf(@FieldType(ColorTargetBlendState, "color_write_mask")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetBlendState, "enable_blend") == @offsetOf(ColorTargetBlendState, "enable_blend"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetBlendState, "enable_blend")) == @sizeOf(@FieldType(ColorTargetBlendState, "enable_blend")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetBlendState, "enable_color_write_mask") == @offsetOf(ColorTargetBlendState, "enable_color_write_mask"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetBlendState, "enable_color_write_mask")) == @sizeOf(@FieldType(ColorTargetBlendState, "enable_color_write_mask")));
    }
};

/// A structure specifying the parameters of color targets used in a graphics pipeline.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const ColorTargetDescription = extern struct {
    /// The pixel format of the texture to be used as a color target.
    format: TextureFormat,
    /// The blend state to be used for the color target.
    blend_state: ColorTargetBlendState,

    // Size tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_GPUColorTargetDescription) == @sizeOf(ColorTargetDescription));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetDescription, "format") == @offsetOf(ColorTargetDescription, "format"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetDescription, "format")) == @sizeOf(@FieldType(ColorTargetDescription, "format")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetDescription, "blend_state") == @offsetOf(ColorTargetDescription, "blend_state"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetDescription, "blend_state")) == @sizeOf(@FieldType(ColorTargetDescription, "blend_state")));
    }
};

/// A structure specifying the parameters of a color target used by a render pass.
///
/// ## Remarks
/// The `load` field determines what is done with the texture at the beginning of the render pass:
/// * `gpu.LoadOperation.load`: Loads the data currently in the texture. Not recommended for multisample textures as it requires significant memory bandwidth.
/// * `gpu.LoadOperation.clear`: Clears the texture to a single color.
/// * `gpu.LoadOperation.do_not_care`: The driver will do whatever it wants with the texture memory. This is a good option if you know that every single pixel will be touched in the render pass.
///
/// The store_op field determines what is done with the color results of the render pass:
/// * `gpu.StoreOperation.store`: Stores the results of the render pass in the texture. Not recommended for multisample textures as it requires significant memory bandwidth.
/// * `gpu.StoreOperation.do_not_care`: The driver will do whatever it wants with the texture memory. This is often a good option for depth/stencil textures.
/// * `gpu.StoreOperation.resolve`: Resolves a multisample texture into `resolve_texture`, which must have a sample count of 1. Then the driver may discard the multisample texture memory. This is the most performant method of resolving a multisample target.
/// * `gpu.StoreOperation.resolve_and_store`: Resolves a multisample texture into the `resolve_texture`, which must have a sample count of 1. Then the driver stores the multisample texture's contents. Not recommended as it requires significant memory bandwidth.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const ColorTargetInfo = extern struct {
    /// The texture that will be used as a color target by a render pass.
    texture: Texture,
    /// The mip level to use as a color target.
    mip_level: u32,
    /// The layer index or depth plane to use as a color target.
    /// This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures.
    layer_or_depth_plane: u32,
    /// The color to clear the color target to at the start of the render pass.
    /// Ignored if `gpu.LoadOperation.clear` for `load` is not used.
    clear_color: pixels.FColor,
    /// What is done with the contents of the color target at the beginning of the render pass.
    load: LoadOperation,
    /// What is done with the results of the render pass.
    store: StoreOperation,
    /// The texture that will receive the results of a multisample resolve operation.
    /// Ignored if a `gpu.StoreOperation.resolve` for `store` is not used.
    resolve_texture: Texture,
    /// The mip level of the resolve texture to use for the resolve operation.
    /// Ignored if a `gpu.StoreOperation.resolve` for `store` is not used.
    resolve_mip_level: u32,
    /// The layer index of the resolve texture to use for the resolve operation.
    /// Ignored if a `gpu.StoreOperation.resolve` for `store` is not used.
    resolve_layer: u32,
    /// If `true` cycles the texture if the texture is bound and `load` is not `gpu.LoadOperation.load`.
    cycle: bool,
    /// If `true` cycles the resolve texture if the resolve texture is bound.
    /// Ignored if a `gpu.StoreOperation.resolve` for `store` is not used.
    cycle_resolve_texture: bool,
    _1: u8 = 0,
    _2: u8 = 0,

    // Size tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_GPUColorTargetInfo) == @sizeOf(ColorTargetInfo));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetInfo, "texture")) == @sizeOf(@FieldType(ColorTargetInfo, "texture")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetInfo, "texture") == @offsetOf(ColorTargetInfo, "texture"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetInfo, "mip_level")) == @sizeOf(@FieldType(ColorTargetInfo, "mip_level")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetInfo, "mip_level") == @offsetOf(ColorTargetInfo, "mip_level"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetInfo, "layer_or_depth_plane")) == @sizeOf(@FieldType(ColorTargetInfo, "layer_or_depth_plane")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetInfo, "layer_or_depth_plane") == @offsetOf(ColorTargetInfo, "layer_or_depth_plane"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetInfo, "clear_color")) == @sizeOf(@FieldType(ColorTargetInfo, "clear_color")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetInfo, "clear_color") == @offsetOf(ColorTargetInfo, "clear_color"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetInfo, "load_op")) == @sizeOf(@FieldType(ColorTargetInfo, "load")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetInfo, "load_op") == @offsetOf(ColorTargetInfo, "load"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetInfo, "store_op")) == @sizeOf(@FieldType(ColorTargetInfo, "store")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetInfo, "store_op") == @offsetOf(ColorTargetInfo, "store"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetInfo, "resolve_texture")) == @sizeOf(@FieldType(ColorTargetInfo, "resolve_texture")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetInfo, "resolve_texture") == @offsetOf(ColorTargetInfo, "resolve_texture"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetInfo, "resolve_mip_level")) == @sizeOf(@FieldType(ColorTargetInfo, "resolve_mip_level")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetInfo, "resolve_mip_level") == @offsetOf(ColorTargetInfo, "resolve_mip_level"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetInfo, "resolve_layer")) == @sizeOf(@FieldType(ColorTargetInfo, "resolve_layer")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetInfo, "resolve_layer") == @offsetOf(ColorTargetInfo, "resolve_layer"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetInfo, "cycle")) == @sizeOf(@FieldType(ColorTargetInfo, "cycle")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetInfo, "cycle") == @offsetOf(ColorTargetInfo, "cycle"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUColorTargetInfo, "cycle_resolve_texture")) == @sizeOf(@FieldType(ColorTargetInfo, "cycle_resolve_texture")));
        std.debug.assert(@offsetOf(C.SDL_GPUColorTargetInfo, "cycle_resolve_texture") == @offsetOf(ColorTargetInfo, "cycle_resolve_texture"));
    }
};

/// An opaque handle representing a command buffer.
///
/// ## Remarks
/// Most state is managed via command buffers.
/// When setting state using a command buffer, that state is local to the command buffer.
///
/// Commands only begin execution on the GPU once `gpu.CommandBuffer.submit()` is called.
/// Once the command buffer is submitted, it is no longer valid to use it.
///
/// Command buffers are executed in submission order.
/// If you submit command buffer A and then command buffer B all commands in A will begin executing before any command in B begins executing.
///
/// In multi-threading scenarios, you should only access a command buffer on the thread you acquired it from.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const CommandBuffer = packed struct {
    value: *C.SDL_GPUCommandBuffer,

    /// Acquire a texture to use in presentation.
    ///
    /// ## Function Parameters
    /// * `self`: A command buffer.
    /// * `window`: A window that has been claimed.
    ///
    /// ## Return Value
    /// Returns the swapchain texture along with its width and height.
    ///
    /// ## Remarks
    /// When a swapchain texture is acquired on a command buffer, it will automatically be submitted for presentation when the command buffer is submitted.
    /// The swapchain texture should only be referenced by the command buffer used to acquire it.
    ///
    /// This function will fill the swapchain texture handle with `null` if too many frames are in flight.
    /// This is not an error.
    ///
    /// If you use this function, it is possible to create a situation where many command buffers are allocated while the rendering context waits for the GPU to catch up,
    /// which will cause memory usage to grow.
    /// You should use `gpu.CommandBuffer.waitAndAcquireSwapchainTexture()` unless you know what you are doing with timing.
    ///
    /// The swapchain texture is managed by the implementation and must not be freed by the user.
    /// You MUST NOT call this function from any thread other than the one that created the window.
    ///
    /// ## Thread Safety
    /// This function should only be called from the thread that created the window.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn acquireSwapchainTexture(
        self: CommandBuffer,
        window: video.Window,
    ) !struct { texture: ?Texture, width: u32, height: u32 } {
        var width: u32 = undefined;
        var height: u32 = undefined;
        var texture: ?*C.SDL_GPUTexture = undefined;
        try errors.wrapCallBool(C.SDL_AcquireGPUSwapchainTexture(self.value, window.value, &texture, &width, &height));
        return .{
            .texture = texture,
            .width = width,
            .height = height,
        };
    }

    /// Begins a compute pass on a command buffer.
    ///
    /// ## Function Parameters
    /// * `self`: A command buffer.
    /// * `storage_texture_bindings`: Writeable storage texture binding structs.
    /// * `storage_buffer_bindings`: Writeable storage buffer binding structs.
    ///
    /// ## Return Value
    /// Returns a compute pass handle.
    ///
    /// ## Remarks
    /// A compute pass is defined by a set of texture subresources and buffers that may be written to by compute pipelines.
    /// These textures and buffers must have been created with the `compute_storage_write` bit or the `compute_storage_simultaneous_read_write` bit.
    /// If you do not create a texture with `compute_storage_simultaneous_read_write`, you must not read from the texture in the compute pass.
    /// All operations related to compute pipelines must take place inside of a compute pass.
    /// You must not begin another compute pass, or a render pass or copy pass before ending the compute pass.
    ///
    /// A VERY IMPORTANT NOTE - Reads and writes in compute passes are NOT implicitly synchronized.
    /// This means you may cause data races by both reading and writing a resource region in a compute pass, or by writing multiple times to a resource region.
    /// If your compute work depends on reading the completed output from a previous dispatch,
    /// you MUST end the current compute pass and begin a new one before you can safely access the data.
    /// Otherwise you will receive unexpected results.
    /// Reading and writing a texture in the same compute pass is only supported by specific texture formats.
    /// Make sure you check the format support!
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn beginComputePass(
        self: CommandBuffer,
        storage_texture_bindings: []const StorageTextureReadWriteBinding,
        storage_buffer_bindings: []const StorageBufferReadWriteBinding,
    ) ComputePass {
        return .{
            .value = C.SDL_BeginGPUComputePass(
                self.value,
                @ptrCast(storage_texture_bindings.ptr),
                @intCast(storage_texture_bindings.len),
                @ptrCast(storage_buffer_bindings.ptr),
                @intCast(storage_buffer_bindings.len),
            ).?,
        };
    }

    /// Begins a copy pass on a command buffer.
    ///
    /// ## Function Parameters
    /// * `self`: A command buffer.
    ///
    /// ## Return Value
    /// Returns a copy pass handle.
    ///
    /// ## Remarks
    /// All operations related to copying to or from buffers or textures take place inside a copy pass.
    /// You must not begin another copy pass, or a render pass or compute pass before ending the copy pass.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn beginCopyPass(
        self: CommandBuffer,
    ) CopyPass {
        return .{
            .value = C.SDL_BeginGPUCopyPass(self.value).?,
        };
    }

    /// Begins a render pass on a command buffer.
    ///
    /// ## Function Parameters
    /// * `self`: A command buffer.
    /// * `color_target_infos`: Texture subresources with corresponding clear values and load/store ops.
    /// * `depth_stencil_target_info`: Texture subresource with corresponding clear value and load/store ops.
    ///
    /// ## Return Value
    /// Returns a render pass handle.
    ///
    /// ## Remarks
    /// A render pass consists of a set of texture subresources (or depth slices in the 3D texture case) which will be rendered to during the render pass,
    /// along with corresponding clear values and load/store operations.
    /// All operations related to graphics pipelines must take place inside of a render pass.
    /// A default viewport and scissor state are automatically set when this is called.
    /// You cannot begin another render pass, or begin a compute pass or copy pass until you have ended the render pass.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    ///
    /// ## D3D12 Warnings
    /// See: https://wiki.libsdl.org/SDL3/SDL_BeginGPURenderPass
    /// TODO!!! Port this documentation here.
    pub fn beginRenderPass(
        self: CommandBuffer,
        color_target_infos: []const ColorTargetInfo,
        depth_stencil_target_info: ?DepthStencilTargetInfo,
    ) RenderPass {
        const depth_stencil = if (depth_stencil_target_info) |val| val.toSdl() else undefined;
        return .{
            .value = C.SDL_BeginGPURenderPass(
                self.value,
                @ptrCast(color_target_infos.ptr),
                @intCast(color_target_infos.len),
                if (depth_stencil_target_info == null) null else &depth_stencil,
            ),
        };
    }

    /// Blits from a source texture region to a destination texture region.
    ///
    /// ## Function Parameters
    /// * `self`: A command buffer.
    /// * `info`: The blit info struct containing the blit parameters.
    ///
    /// ## Remarks
    /// This function must not be called inside of any pass.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn blitTexture(
        self: CommandBuffer,
        blit_info: BlitInfo,
    ) void {
        const blit_info_sdl = blit_info.toSdl();
        C.SDL_BlitGPUTexture(
            self.value,
            &blit_info_sdl,
        );
    }

    /// Cancels a command buffer.
    ///
    /// ## Function Parameters
    /// * `self`: A command buffer.
    ///
    /// ## Remarks
    /// None of the enqueued commands are executed.
    ///
    /// It is an error to call this function after a swapchain texture has been acquired.
    ///
    /// This must be called from the thread the command buffer was acquired on.
    ///
    /// You must not reference the command buffer after calling this function.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn cancel(
        self: CommandBuffer,
    ) !void {
        return errors.wrapCallBool(C.SDL_CancelGPUCommandBuffer(self.value));
    }

    /// Pushes data to a uniform slot on the command buffer.
    ///
    /// ## Function Parameters
    /// * `self`: A command buffer.
    /// * `slot_index: The uniform slot to push data to.
    /// * `data`: Client data to write.
    ///
    /// ## Remarks
    /// Subsequent draw calls will use this uniform data.
    ///
    /// The data being pushed must respect std140 layout conventions.
    /// In practical terms this means you must ensure that vec3 and vec4 fields are 16-byte aligned.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn pushComputeUniformData(
        self: CommandBuffer,
        slot_index: u32,
        data: []const u8,
    ) void {
        C.SDL_PushGPUComputeUniformData(
            self.value,
            slot_index,
            data.ptr,
            @intCast(data.len),
        );
    }

    /// Submits a command buffer so its commands can be processed on the GPU.
    ///
    /// ## Function Parameters
    /// * `self`: A command buffer.
    ///
    /// ## Remarks
    /// It is invalid to use the command buffer after this is called.
    ///
    /// This must be called from the thread the command buffer was acquired on.
    ///
    /// All commands in the submission are guaranteed to begin executing before any command in a subsequent submission begins executing.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn submit(
        self: CommandBuffer,
    ) !void {
        return errors.wrapCallBool(C.SDL_SubmitGPUCommandBuffer(self.value));
    }
};

/// Specifies a comparison operator for depth, stencil and sampler operations.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const CompareOperation = enum(c_uint) {
    /// The comparison always evaluates false.
    never = C.SDL_GPU_COMPAREOP_NEVER,
    /// The comparison evaluates reference < test.
    less = C.SDL_GPU_COMPAREOP_LESS,
    /// The comparison evaluates reference == test.
    equal = C.SDL_GPU_COMPAREOP_EQUAL,
    /// The comparison evaluates reference <= test.
    less_or_equal = C.SDL_GPU_COMPAREOP_LESS_OR_EQUAL,
    /// The comparison evaluates reference > test.
    greater = C.SDL_GPU_COMPAREOP_GREATER,
    /// The comparison evaluates reference != test.
    not_equal = C.SDL_GPU_COMPAREOP_NOT_EQUAL,
    /// The comparison evaluates reference >= test.
    greater_or_equal = C.SDL_GPU_COMPAREOP_GREATER_OR_EQUAL,
    /// The comparison always evaluates true.
    always = C.SDL_GPU_COMPAREOP_ALWAYS,

    /// Create from SDL.
    pub fn fromSdl(val: C.SDL_GPUCompareOp) ?CompareOperation {
        if (val == C.SDL_GPU_COMPAREOP_INVALID) {
            return null;
        }
        return @enumFromInt(val);
    }

    /// Convert to an SDL value.
    pub fn toSdl(val: ?CompareOperation) C.SDL_GPUCompareOp {
        if (val) |tmp| {
            return @intFromEnum(tmp);
        }
        return C.SDL_GPU_COMPAREOP_INVALID;
    }
};

/// An opaque handle representing a compute pass.
///
/// ## Remarks
/// This handle is transient and should not be held or referenced after `gpu.ComputePass.end()` is called.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const ComputePass = packed struct {
    value: *C.SDL_GPUComputePass,

    /// Binds a compute pipeline on a command buffer for use in compute dispatch.
    ///
    /// ## Function Parameters
    /// * `self`: A compute pass handle.
    /// * `compute_pipeline`: A compute pipeline to bind.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindPipeline(
        self: ComputePass,
        compute_pipeline: ComputePipeline,
    ) void {
        C.SDL_BindGPUComputePipeline(self.value, compute_pipeline.value);
    }

    /// Binds texture-sampler pairs for use on the compute shader.
    ///
    /// ## Function Parameters
    /// * `self`: A compute pass handle.
    /// * `first_slot`: The compute sampler slot to begin binding from.
    /// * `texture_sampler_bindings`: Texture-sampler binding structs.
    ///
    /// ## Remarks
    /// The textures must have been created with `gpu.TextureUsageFlags.sampler`.
    ///
    /// Be sure your shader is set up according to the requirements documented in `gpu.Device.createShader()`.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindSamplers(
        self: ComputePass,
        first_slot: u32,
        texture_sampler_bindings: []const TextureSamplerBinding,
    ) void {
        C.SDL_BindGPUComputeSamplers(
            self.value,
            first_slot,
            @ptrCast(texture_sampler_bindings.ptr),
            @intCast(texture_sampler_bindings.len),
        );
    }

    /// Binds storage buffers as readonly for use on the compute pipeline.
    ///
    /// ## Function Parameters
    /// * `self`: A compute pass handle.
    /// * `first_slot`: The compute storage buffer slot to begin binding from.
    /// * `storage_buffers`: Storage buffer binding structs.
    ///
    /// ## Remarks
    /// These buffers must have been created with `gpu.BufferStorageFlags.compute_storage_read`.
    ///
    /// Be sure your shader is set up according to the requirements documented in `gpu.Device.createShader()`.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindStorageBuffers(
        self: ComputePass,
        first_slot: u32,
        storage_buffers: []const Buffer,
    ) void {
        C.SDL_BindGPUComputeStorageBuffers(
            self.value,
            first_slot,
            @ptrCast(storage_buffers.ptr),
            @intCast(storage_buffers.len),
        );
    }

    /// Binds storage textures as readonly for use on the compute pipeline.
    ///
    /// ## Function Parameters
    /// * `self`: A compute pass handle.
    /// * `first_slot`: The compute storage texture slot to begin binding from.
    /// * `storage_textures`: Storage textures.
    ///
    /// ## Remarks
    /// These textures must have been created with `gpu.TextureStorageFlags.compute_storage_read`.
    ///
    /// Be sure your shader is set up according to the requirements documented in `gpu.Device.createShader()`.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindStorageTextures(
        self: ComputePass,
        first_slot: u32,
        storage_textures: []const Texture,
    ) void {
        C.SDL_BindGPUComputeStorageTextures(
            self.value,
            first_slot,
            @ptrCast(storage_textures.ptr),
            @intCast(storage_textures.len),
        );
    }

    /// Dispatches compute work.
    ///
    /// ## Function Parameters
    /// * `self`: A compute pass handle.
    /// * `group_count_x`: Number of local workgroups to dispatch in the X dimension.
    /// * `group_count_y`: Number of local workgroups to dispatch in the Y dimension.
    /// * `group_count_z`: Number of local workgroups to dispatch in the Z dimension.
    ///
    /// ## Remarks
    /// You must not call this function before binding a compute pipeline.
    ///
    /// A VERY IMPORTANT NOTE If you dispatch multiple times in a compute pass, and the dispatches write to the same resource region as each other,
    /// there is no guarantee of which order the writes will occur.
    /// If the write order matters, you MUST end the compute pass and begin another one.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn dispatch(
        self: ComputePass,
        group_count_x: u32,
        group_count_y: u32,
        group_count_z: u32,
    ) void {
        C.SDL_DispatchGPUCompute(
            self.value,
            group_count_x,
            group_count_y,
            group_count_z,
        );
    }

    /// Dispatches compute work with parameters set from a buffer.
    ///
    /// ## Function Parameters
    /// * `self`: A compute pass handle.
    /// * `buffer`: A buffer containing dispatch parameters.
    /// * `offset`: The offset to start reading from the dispatch buffer.
    ///
    /// ## Remarks
    /// The buffer layout should match the layout of `gpu.IndirectDispatchCommand`.
    /// You must not call this function before binding a compute pipeline.
    ///
    /// A VERY IMPORTANT NOTE If you dispatch multiple times in a compute pass, and the dispatches write to the same resource region as each other,
    /// there is no guarantee of which order the writes will occur.
    /// If the write order matters, you MUST end the compute pass and begin another one.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn dispatchIndirect(
        self: ComputePass,
        buffer: Buffer,
        offset: u32,
    ) void {
        C.SDL_DispatchGPUComputeIndirect(
            self.value,
            buffer.value,
            offset,
        );
    }

    /// Ends the current compute pass.
    ///
    /// ## Function Parameters
    /// * `self`: A compute pass handle.
    ///
    /// ## Remarks
    /// All bound compute state on the command buffer is unset.
    /// The compute pass handle is now invalid.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn end(
        self: ComputePass,
    ) void {
        C.SDL_EndGPUComputePass(self.value);
    }
};

/// An opaque handle representing a compute pipeline.
///
/// ## Remarks
/// Used during compute passes.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const ComputePipeline = packed struct {
    value: *C.SDL_GPUComputePipeline,
};

/// A structure specifying the parameters of a compute pipeline state.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const ComputePipelineCreateInfo = struct {
    /// Compute shader code.
    code: []const u8,
    /// A UTF-8 string specifying the entry point function name for the shader.
    entry_point: [:0]const u8,
    /// The format of the compute shader code.
    format: ?ShaderFormatFlags,
    /// The number of samplers defined in the shader.
    num_samplers: u32,
    /// The number of readonly storage textures defined in the shader.
    num_readonly_storage_textures: u32,
    /// The number of readonly storage buffers defined in the shader.
    num_readonly_storage_buffers: u32,
    /// The number of read-write storage textures defined in the shader.
    num_readwrite_storage_textures: u32,
    /// The number of read-write storage buffers defined in the shader.
    num_readwrite_storage_buffers: u32,
    /// The number of uniform buffers defined in the shader.
    num_uniform_buffers: u32,
    /// The number of threads in the X dimension.
    /// This should match the value in the shader.
    thread_count_x: u32,
    /// The number of threads in the Y dimension.
    /// This should match the value in the shader.
    thread_count_y: u32,
    /// The number of threads in the Z dimension.
    /// This should match the value in the shader.
    thread_count_z: u32,
    /// A properties group for extensions.
    /// Should be `null` if no extensions are needed.
    props: ?properties.Group,

    /// From an SDL value.
    pub fn fromSdl(value: C.SDL_GPUComputePipelineCreateInfo) ComputePipelineCreateInfo {
        return .{
            .code = value.code[0..value.code_size],
            .entry_point = std.mem.span(value.entrypoint),
            .format = ShaderFormatFlags.fromSdl(value.format),
            .num_samplers = value.num_samplers,
            .num_readonly_storage_textures = value.num_readonly_storage_textures,
            .num_readonly_storage_buffers = value.num_readonly_storage_buffers,
            .num_readwrite_storage_textures = value.num_readwrite_storage_textures,
            .num_readwrite_storage_buffers = value.num_readwrite_storage_buffers,
            .num_uniform_buffers = value.num_uniform_buffers,
            .thread_count_x = value.threadcount_x,
            .thread_count_y = value.threadcount_y,
            .thread_count_z = value.threadcount_z,
            .props = if (value.props == 0) null else .{ .value = value.props },
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: ComputePipelineCreateInfo) C.SDL_GPUComputePipelineCreateInfo {
        return .{
            .code = self.code.ptr,
            .code_size = self.code.len,
            .format = ShaderFormatFlags.toSdl(self.format),
            .num_samplers = self.num_samplers,
            .num_readonly_storage_textures = self.num_readonly_storage_textures,
            .num_readonly_storage_buffers = self.num_readonly_storage_buffers,
            .num_readwrite_storage_textures = self.num_readwrite_storage_textures,
            .num_readwrite_storage_buffers = self.num_readwrite_storage_buffers,
            .num_uniform_buffers = self.num_uniform_buffers,
            .threadcount_x = self.thread_count_x,
            .threadcount_y = self.thread_count_y,
            .threadcount_z = self.thread_count_z,
            .props = if (self.props) |val| val.value else 0,
        };
    }
};

/// An opaque handle representing a copy pass.
///
/// ## Remarks
/// This handle is transient and should not be held or referenced after `gpu.CopyPass.end()` is called.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const CopyPass = packed struct {
    value: *C.SDL_GPUCopyPass,

    /// Performs a buffer-to-buffer copy.
    ///
    /// ## Function Parameters
    /// * `self`: A copy pass handle.
    /// * `source`: The buffer and offset to copy from.
    /// * `destination`: The buffer and offset to copy to.
    /// * `size`: The length of the buffer to copy.
    /// * `cycle`: If true, cycles the destination buffer if it is already bound, otherwise overwrites the data.
    ///
    /// ## Remarks
    /// This copy occurs on the GPU timeline.
    /// You may assume the copy has finished in subsequent commands.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bufferToBuffer(
        self: CopyPass,
        source: BufferLocation,
        destination: BufferLocation,
        size: u32,
        cycle: bool,
    ) void {
        const source_sdl = source.toSdl();
        const destination_sdl = destination.toSdl();
        C.SDL_CopyGPUBufferToBuffer(
            self.value,
            &source_sdl,
            &destination_sdl,
            size,
            cycle,
        );
    }

    /// Performs a buffer-to-buffer copy.
    ///
    /// ## Function Parameters
    /// * `self`: A copy pass handle.
    /// * `source`: A source texture region.
    /// * `destination`: A destination texture region.
    /// * `width`: The width of the region to copy.
    /// * `height`: The height of the region to copy.
    /// * `depth`: The depth of the region to copy.
    /// * `cycle`: If true, cycles the destination buffer if it is already bound, otherwise overwrites the data.
    ///
    /// ## Remarks
    /// This copy occurs on the GPU timeline.
    /// You may assume the copy has finished in subsequent commands.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn textureToTexture(
        self: CopyPass,
        source: TextureLocation,
        destination: TextureLocation,
        width: u32,
        height: u32,
        depth: u32,
        cycle: bool,
    ) void {
        const source_sdl = source.toSdl();
        const destination_sdl = destination.toSdl();
        C.SDL_CopyGPUTextureToTexture(
            self.value,
            &source_sdl,
            &destination_sdl,
            width,
            height,
            depth,
            cycle,
        );
    }
};

/// Specifies the face of a cube map.
///
/// ## Remarks
/// Can be passed in as the layer field in texture-related structs.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const CubeMap = enum(c_uint) {
    positive_x = C.SDL_GPU_CUBEMAPFACE_POSITIVEX,
    negative_x = C.SDL_GPU_CUBEMAPFACE_NEGATIVEX,
    positive_y = C.SDL_GPU_CUBEMAPFACE_POSITIVEY,
    negative_y = C.SDL_GPU_CUBEMAPFACE_NEGATIVEY,
    positive_z = C.SDL_GPU_CUBEMAPFACE_POSITIVEZ,
    negative_z = C.SDL_GPU_CUBEMAPFACE_NEGATIVEZ,
};

/// Specifies the facing direction in which triangle faces will be culled.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const CullMode = enum(c_uint) {
    /// No triangles are culled.
    none = C.SDL_GPU_CULLMODE_NONE,
    /// Front-facing triangles are culled.
    front = C.SDL_GPU_CULLMODE_FRONT,
    /// Back-facing triangles are culled.
    back = C.SDL_GPU_CULLMODE_BACK,
};

/// A structure specifying the parameters of the graphics pipeline depth stencil state. TODO!!!
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const DepthStencilState = struct {
    /// The comparison operator used for depth testing.
    compare: CompareOperation,
    /// The stencil op state for back-facing triangles.
    back_stencil_state: StencilOperationState,
    /// The stencil op state for front-facing triangles.
    front_stencil_state: StencilOperationState,
    /// Selects the bits of the stencil values participating in the stencil test.
    compare_mask: u8,
    /// Selects the bits of the stencil values updated by the stencil test.
    write_mask: u8,
    /// True enables the depth test.
    enable_depth_test: bool,
    /// True enables depth writes. Depth writes are always disabled when `enable_depth_test` is false.
    enable_depth_write: bool,
    /// True enables the stencil test.
    enable_stencil_test: bool,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUDepthStencilState) DepthStencilState {
        return .{
            .compare = @enumFromInt(value.compare_op),
            .back_stencil_state = StencilOperationState.fromSdl(value.back_stencil_state),
            .front_stencil_state = StencilOperationState.fromSdl(value.front_stencil_state),
            .compare_mask = value.compare_mask,
            .write_mask = value.write_mask,
            .enable_depth_test = value.enable_depth_test,
            .enable_depth_write = value.enable_depth_write,
            .enable_stencil_test = value.enable_stencil_test,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: DepthStencilState) C.SDL_GPUDepthStencilState {
        return .{
            .compare_op = @intFromEnum(self.compare),
            .back_stencil_state = self.back_stencil_state.toSdl(),
            .front_stencil_state = self.front_stencil_state.toSdl(),
            .compare_mask = self.compare_mask,
            .write_mask = self.write_mask,
            .enable_depth_test = self.enable_depth_test,
            .enable_depth_write = self.enable_depth_write,
            .enable_stencil_test = self.enable_stencil_test,
        };
    }
};

/// A structure specifying the parameters of a depth-stencil target used by a render pass.
///
/// ## Remarks
/// The `load` field determines what is done with the depth contents of the texture at the beginning of the render pass:
/// * `gpu.LoadOperation.load`: Loads the depth values currently in the texture.
/// * `gpu.LoadOperation.clear`: Clears the texture to a single depth.
/// * `gpu.LoadOperation.do_not_care`: The driver will do whatever it wants with the memory. This is a good option if you know that every single pixel will be touched in the render pass.
///
/// The `store` field determines what is done with the depth results of the render pass:
/// * `gpu.StoreOperation.store`: Stores the depth results in the texture.
/// * `gpu.StoreOperation.do_not_care`: The driver will do whatever it wants with the depth results. This is often a good option for depth/stencil textures that don't need to be reused again.
///
/// The `stencil_load` field determines what is done with the stencil contents of the texture at the beginning of the render pass:
/// * `gpu.LoadOperation.load`: Loads the stencil values currently in the texture.
/// * `gpu.LoadOperation.clear`: Clears the stencil values to a single value.
/// * `gpu.LoadOperation.do_not_care`: The driver will do whatever it wants with the memory. This is a good option if you know that every single pixel will be touched in the render pass.
///
/// The `stencil_store` field determines what is done with the stencil results of the render pass:
/// * `gpu.StoreOperation.store`: Stores the stencil results in the texture.
/// * `gpu.StoreOperation.do_not_care`: The driver will do whatever it wants with the stencil results. This is often a good option for depth/stencil textures that don't need to be reused again.
///
/// Note that depth/stencil targets do not support multisample resolves.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const DepthStencilTargetInfo = struct {
    /// The texture that will be used as the depth stencil target by the render pass.
    texture: Texture,
    /// The value to clear the depth component to at the beginning of the render pass.
    /// Ignored if `gpu.LoadOperation.clear` is not used.
    clear_depth: f32,
    /// What is done with the depth contents at the beginning of the render pass.
    load: LoadOperation,
    /// What is done with the depth results of the render pass.
    store: StoreOperation,
    /// What is done with the stencil contents at the beginning of the render pass.
    stencil_load: LoadOperation,
    /// What is done with the stencil results of the render pass.
    stencil_store: StoreOperation,
    /// True cycles the texture if the texture is bound and any load ops are not `gpu.LoadOperation.load`.
    cycle: bool,
    /// The value to clear the stencil component to at the beginning of the render pass.
    /// Ignored if `gpu.LoadOperation.clear` is not used.
    clear_stencil: u8,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUDepthStencilTargetInfo) DepthStencilTargetInfo {
        return .{
            .texture = .{ .value = value.texture.? },
            .clear_depth = value.clear_depth,
            .load = @enumFromInt(value.load_op),
            .store = @enumFromInt(value.store_op),
            .stencil_load = @enumFromInt(value.stencil_load_op),
            .stencil_store = @enumFromInt(value.stencil_store_op),
            .cycle = value.cycle,
            .clear_stencil = value.clear_stencil,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: DepthStencilTargetInfo) C.SDL_GPUDepthStencilTargetInfo {
        return .{
            .texture = self.texture.value,
            .clear_depth = self.clear_depth,
            .load_op = @intFromEnum(self.load),
            .store_op = @intFromEnum(self.store),
            .stencil_load_op = @intFromEnum(self.stencil_load),
            .stencil_store_op = @intFromEnum(self.stencil_store),
            .cycle = self.cycle,
            .clear_stencil = self.clear_stencil,
        };
    }
};

/// An opaque handle representing the SDL_GPU context.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Device = packed struct {
    value: *C.SDL_GPUDevice,

    /// Acquire a command buffer.
    ///
    /// ## Function Parameters
    /// * `self`: A GPU context.
    ///
    /// ## Return Value
    /// Returns a command buffer.
    ///
    /// ## Remarks
    /// This command buffer is managed by the implementation and should not be freed by the user.
    /// The command buffer may only be used on the thread it was acquired on.
    /// The command buffer should be submitted on the thread it was acquired on.
    ///
    /// It is valid to acquire multiple command buffers on the same thread at once.
    /// In fact a common design pattern is to acquire two command buffers per frame where one is dedicated to render and compute passes
    /// and the other is dedicated to copy passes and other preparatory work such as generating mipmaps.
    /// Interleaving commands between the two command buffers reduces the total amount of passes overall which improves rendering performance.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn aquireCommandBuffer(
        self: Device,
    ) !CommandBuffer {
        return .{
            .value = try errors.wrapNull(*C.SDL_GPUCommandBuffer, C.SDL_AcquireGPUCommandBuffer(self.value)),
        };
    }

    /// Claims a window, creating a swapchain structure for it.
    ///
    /// ## Function Parameters
    /// * `self`: A GPU context.
    /// * `window`: An SDL window.
    ///
    /// ## Remarks
    /// This must be called before `gpu.CommandBuffer.aquireSwapchainTexture()` is called using the window.
    /// You should only call this function from the thread that created the window.
    ///
    /// The swapchain will be created with `gpu.SwapChainComposition.sdr` and `gpu.PresentMode.vsync`.
    /// If you want to have different swapchain parameters, you must call `gpu.Device.setSwapchainParameters()` after claiming the window.
    ///
    /// ## Thread Safety
    /// This function should only be called from the thread that created the window.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn claimWindow(
        self: Device,
        window: video.Window,
    ) !void {
        return errors.wrapCallBool(C.SDL_ClaimWindowForGPUDevice(
            self.value,
            window.value,
        ));
    }

    /// Creates a buffer object to be used in graphics or compute workflows.
    ///
    /// ## Function Parameters
    /// * `self`: A GPU Context.
    /// * `create_info`: Struct describing the state of the buffer to create.
    ///
    /// ## Return Value
    /// Creates a buffer object.
    ///
    /// ## Remarks
    /// The contents of this buffer are undefined until data is written to the buffer.
    ///
    /// Note that certain combinations of usage flags are invalid.
    /// For example, a buffer cannot have both the `gpu.BufferUsageFlags.vertex` and `gpu.BufferUsageFlags.index` flags.
    ///
    /// If you use a `gpu.BufferUsageFlags.storage` flag, the data in the buffer must respect std140 layout conventions.
    /// In practical terms this means you must ensure that `vec3` and `vec4` fields are 16-byte aligned.
    ///
    /// For better understanding of underlying concepts and memory management with SDL GPU API, you may refer [this blog post](https://moonside.games/posts/sdl-gpu-concepts-cycling/).
    ///
    /// There are optional properties that can be provided through props.
    /// These are the supported properties:
    /// * `SDL_PROP_GPU_BUFFER_CREATE_NAME_STRING`: a name that can be displayed in debugging tools.
    /// TODO: Dedicated creation properties?
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn createBuffer(
        self: Device,
        create_info: BufferCreateInfo,
    ) !Buffer {
        const create_info_sdl = create_info.toSdl();
        return .{
            .value = try errors.wrapNull(
                *C.SDL_GPUBuffer,
                C.SDL_CreateGPUBuffer(self.value, &create_info_sdl),
            ),
        };
    }

    /// Creates a pipeline object to be used in a compute workflow.
    ///
    /// ## Function Parameters
    /// * `self`: A GPU Context.
    /// * `create_info`: A struct describing the state of the compute pipeline to create.
    ///
    /// ## Return Value
    /// Returns a compute pipeline object.
    ///
    /// ## Remarks
    /// Shader resource bindings must be authored to follow a particular order depending on the shader format.
    ///
    /// For SPIR-V shaders, use the following resource sets:
    /// * `0`: Sampled textures, followed by read-only storage textures, followed by read-only storage buffers.
    /// * `1`: Read-write storage textures, followed by read-write storage buffers.
    /// * `2`: Uniform buffers.
    ///
    /// For DXBC and DXIL shaders, use the following register order:
    /// * `(t[n], space0)`: Sampled textures, followed by read-only storage textures, followed by read-only storage buffers.
    /// * `(u[n], space1)`: Read-write storage textures, followed by read-write storage buffers.
    /// * `(b[n], space2)`: Uniform buffers.
    ///
    /// For MSL/metallib, use the following order:
    /// * `[[buffer]]`: Uniform buffers, followed by read-only storage buffers, followed by read-write storage buffers.
    /// * `[[texture]]`: Sampled textures, followed by read-only storage textures, followed by read-write storage textures.
    ///
    /// There are optional properties that can be provided through `props`.
    /// These are the supported properties:
    /// * `SDL_PROP_GPU_COMPUTEPIPELINE_CREATE_NAME_STRING`: a name that can be displayed in debugging tools.
    /// TODO: PROPER PROPERTY WRAPPING?
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn createComputePipeline(
        self: Device,
        create_info: ComputePipelineCreateInfo,
    ) !ComputePipeline {
        const create_info_sdl = create_info.toSdl();
        return .{
            .value = errors.wrapNull(*C.SDL_GPUComputePipeline, C.SDL_CreateGPUComputePipeline(self.value, &create_info_sdl)),
        };
    }

    /// Creates a pipeline object to be used in a graphics workflow.
    ///
    /// ## Function Parameters
    /// * `self`: A GPU Context.
    /// * `create_info`: A struct describing the state of the graphics pipeline to create.
    ///
    /// ## Return Value
    /// Returns a graphics pipeline object.
    ///
    /// ## Remarks
    /// There are optional properties that can be provided through `props`.
    /// These are the supported properties:
    /// * `SDL_PROP_GPU_GRAPHICSPIPELINE_CREATE_NAME_STRING`: A name that can be displayed in debugging tools.
    /// TODO: PROPER PROPERTY WRAPPING?
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn createGraphicsPipeline(
        self: Device,
        create_info: GraphicsPipelineCreateInfo,
    ) !GraphicsPipeline {
        return .{
            .value = errors.wrapNull(*C.SDL_GPUGraphicsPipeline, C.SDL_CreateGPUGraphicsPipeline(
                self.value,
                create_info.toSdl(),
            )),
        };
    }

    /// Creates a sampler object to be used when binding textures in a graphics workflow.
    ///
    /// ## Function Parameters
    /// * `self`: A GPU Context.
    /// * `create_info`: A struct describing the state of the sampler to create.
    ///
    /// ## Return Value
    /// Returns a sampler object.
    ///
    /// ## Remarks
    /// There are optional properties that can be provided through `props`.
    /// These are the supported properties:
    /// * `SDL_PROP_GPU_SAMPLER_CREATE_NAME_STRING`: a name that can be displayed in debugging tools.
    /// TODO: PROPER PROPERTY WRAPPING?
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn createSampler(
        self: Device,
        create_info: SamplerCreateInfo,
    ) !Sampler {
        const create_info_sdl = create_info.toSdl();
        return .{
            .value = try errors.wrapNull(*C.SDL_GPUSampler, C.SDL_CreateGPUSampler(
                self.value,
                &create_info_sdl,
            )),
        };
    }

    /// Creates a shader to be used when creating a graphics pipeline.
    ///
    /// ## Function Parameters
    /// * `self`: A GPU Context.
    /// * `create_info`: A struct describing the state of the shader to create.
    ///
    /// ## Return Value
    /// Returns a shader object.
    ///
    /// ## Remarks
    /// Shader resource bindings must be authored to follow a particular order depending on the shader format.
    ///
    /// For SPIR-V shaders, use the following resource sets:
    ///
    /// For vertex shaders:
    /// * `0`: Sampled textures, followed by storage textures, followed by storage buffers.
    /// * `1`: Uniform buffers.
    ///
    /// For fragment shaders:
    /// * `2`: Sampled textures, followed by storage textures, followed by storage buffers.
    /// * `3`: Uniform buffers.
    ///
    /// For DXBC and DXIL shaders, use the following register order:
    ///
    /// For vertex shaders:
    /// * `(t[n], space0)`: Sampled textures, followed by storage textures, followed by storage buffers.
    /// * `(s[n], space0)`: Samplers with indices corresponding to the sampled textures.
    /// * `(b[n], space1)`: Uniform buffers.
    ///
    /// For pixel shaders:
    /// * `(t[n], space2)`: Sampled textures, followed by storage textures, followed by storage buffers.
    /// * `(s[n], space2)`: Samplers with indices corresponding to the sampled textures.
    /// * `(b[n], space3)`: Uniform buffers.
    ///
    /// For MSL/metallib, use the following order:
    /// * `[[texture]]`: Sampled textures, followed by storage textures.
    /// * `[[sampler]]`: Samplers with indices corresponding to the sampled textures.
    /// * `[[buffer]]`: Uniform buffers, followed by storage buffers.
    /// Vertex buffer `0` is bound at `[[buffer(14)]]`, vertex buffer `1` at `[[buffer(15)]]`, and so on.
    /// Rather than manually authoring vertex buffer indices, use the `[[stage_in]]` attribute which will automatically use the vertex input information from the `gpu.GraphicsPipeline`.
    /// Shader semantics other than system-value semantics do not matter in D3D12 and for ease of use the SDL implementation assumes that
    /// non system-value semantics will all be `TEXCOORD`.
    /// If you are using HLSL as the shader source language, your vertex semantics should start at `TEXCOORD0` and increment like so: `TEXCOORD1`, `TEXCOORD2`, etc.
    /// If you wish to change the semantic prefix to something other than `TEXCOORD` you can use `gpu.Device.Properties.d3d12_semantic_name_string` with `gpu.Device.initWithProperties()`.
    ///
    /// There are optional properties that can be provided through props. These are the supported properties:
    /// * `SDL_PROP_GPU_SHADER_CREATE_NAME_STRING`: a name that can be displayed in debugging tools.
    /// TODO: PROPER PROPERTY WRAPPING?
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn createShader(
        self: Device,
        create_info: ShaderCreateInfo,
    ) !ShaderCreateInfo {
        const create_info_sdl = create_info.toSdl();
        return .{
            .value = try errors.wrapNull(*C.SDL_GPUShader, C.SDL_CreateGPUSampler(
                self.value,
                &create_info_sdl,
            )),
        };
    }

    /// Destroys a GPU context previously returned by `gpu.Device.init().
    ///
    /// ## Function Parameters
    /// * `self`: A GPU Context to destroy.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn deinit(
        self: Device,
    ) void {
        return C.SDL_DestroyGPUDevice(
            self.value,
        );
    }

    /// Creates a GPU context.
    ///
    /// ## Function Parameters
    /// * `shader_format`: A bitflag indicating which shader formats the app is able to provide.
    /// * `debug_mode`: Enable debug mode properties and validations.
    /// * `name`: The preferred GPU driver, or `null` to let SDL pick the optimal driver.
    ///
    /// ## Return Value
    /// Returns a GPU context.
    ///
    /// ## Remarks
    /// The GPU driver name can be one of the following:
    /// * `"vulkan"`: [Vulkan](https://wiki.libsdl.org/SDL3/CategoryGPU#vulkan).
    /// * `"direct3d12"`: [D3D12](https://wiki.libsdl.org/SDL3/CategoryGPU#d3d12).
    /// * `"metal"`: [Metal](https://wiki.libsdl.org/SDL3/CategoryGPU#metal).
    /// * `null`: Let SDL pick the optimal driver.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn init(
        shader_format: ShaderFormatFlags,
        debug_mode: bool,
        name: ?[:0]const u8,
    ) !Device {
        return .{
            .value = errors.wrapNull(*C.SDL_GPUDevice, C.SDL_CreateGPUDevice(
                ShaderFormatFlags.toSdl(shader_format),
                debug_mode,
                if (name) |val| val.ptr else null,
            )),
        };
    }

    /// Frees the given compute pipeline as soon as it is safe to do so.
    ///
    /// ## Function Parameters
    /// * `self`: A GPU context.
    /// * `compute_pipeline`: A compute pipeline to be destroyed.
    ///
    /// ## Remarks
    /// You must not reference the compute pipeline after calling this function.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn releaseComputePipeline(
        self: Device,
        compute_pipeline: ComputePipeline,
    ) void {
        C.SDL_ReleaseGPUComputePipeline(
            self.value,
            compute_pipeline.value,
        );
    }

    /// Frees the given graphics pipeline as soon as it is safe to do so.
    ///
    /// ## Function Parameters
    /// * `self`: A GPU context.
    /// * `graphics_pipeline`: A graphics pipeline to be destroyed.
    ///
    /// ## Remarks
    /// You must not reference the graphics pipeline after calling this function.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn releaseGraphicsPipeline(
        self: Device,
        graphics_pipeline: GraphicsPipeline,
    ) void {
        C.SDL_ReleaseGPUGraphicsPipeline(
            self.value,
            graphics_pipeline.value,
        );
    }

    /// Frees the given sampler as soon as it is safe to do so.
    ///
    /// ## Function Parameters
    /// * `self`: A GPU context.
    /// * `sampler`: A sampler to be destroyed.
    ///
    /// ## Remarks
    /// You must not reference the sampler after calling this function.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn releaseSampler(
        self: Device,
        sampler: Sampler,
    ) void {
        C.SDL_ReleaseGPUSampler(
            self.value,
            sampler.value,
        );
    }

    /// Frees the given shader as soon as it is safe to do so.
    ///
    /// ## Function Parameters
    /// * `self`: A GPU context.
    /// * `shader`: A shader to be destroyed.
    ///
    /// ## Remarks
    /// You must not reference the shader after calling this function.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn releaseShader(
        self: Device,
        shader: Shader,
    ) void {
        C.SDL_ReleaseGPUShader(
            self.value,
            shader.value,
        );
    }
};

/// An opaque handle representing a fence.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Fence = packed struct {
    value: *C.SDL_GPUFence,
};

/// Specifies the fill mode of the graphics pipeline.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const FillMode = enum(c_uint) {
    /// Polygons will be rendered via rasterization.
    fill = C.SDL_GPU_FILLMODE_FILL,
    /// Polygon edges will be drawn as line segments.
    line = C.SDL_GPU_FILLMODE_LINE,
};

/// Specifies a filter operation used by a sampler.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const Filter = enum(c_uint) {
    /// Point filtering.
    nearest = C.SDL_GPU_FILTER_NEAREST,
    /// Linear filtering.
    linear = C.SDL_GPU_FILTER_LINEAR,
};

/// Specifies the vertex winding that will cause a triangle to be determined to be front-facing.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const FrontFace = enum(c_uint) {
    /// A triangle with counter-clockwise vertex winding will be considered front-facing.
    counter_clockwise = C.SDL_GPU_FRONTFACE_COUNTER_CLOCKWISE,
    /// A triangle with clockwise vertex winding will be considered front-facing.
    clockwise = C.SDL_GPU_FRONTFACE_CLOCKWISE,
};

/// An opaque handle representing a graphics pipeline.
///
/// ## Remarks
/// Used during render passes.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const GraphicsPipeline = packed struct {
    value: *C.SDL_GPUGraphicsPipeline,
};

/// A structure specifying the parameters of a graphics pipeline state.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const GraphicsPipelineCreateInfo = struct {
    /// The vertex shader used by the graphics pipeline.
    vertex_shader: Shader,
    /// The fragment shader used by the graphics pipeline.
    fragment_shader: Shader,
    /// The vertex layout of the graphics pipeline.
    vertex_input_state: VertexInputState,
    /// The primitive topology of the graphics pipeline.
    primitive_type: PrimitiveType,
    /// The rasterizer state of the graphics pipeline.
    rasterizer_state: RasterizerState,
    /// The multisample state of the graphics pipeline.
    multisample_state: MultisampleState,
    /// The depth-stencil state of the graphics pipeline.
    depth_stencil_state: DepthStencilState,
    /// Formats and blend modes for the render targets of the graphics pipeline.
    target_info: GraphicsPipelineTargetInfo,
    /// Extra properties for extensions.
    props: ?properties.Group,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUGraphicsPipelineCreateInfo) GraphicsPipelineCreateInfo {
        return .{
            .vertex_shader = .{ .value = value.vertex_shader.? },
            .fragment_shader = .{ .value = value.fragment_shader.? },
            .vertex_input_state = VertexInputState.fromSdl(value.vertex_input_state),
            .primitive_type = @enumFromInt(value.primitive_type),
            .rasterizer_state = RasterizerState.fromSdl(value.rasterizer_state),
            .multisample_state = MultisampleState.fromSdl(value.multisample_state),
            .depth_stencil_state = DepthStencilState.fromSdl(value.depth_stencil_state),
            .target_info = GraphicsPipelineTargetInfo.fromSdl(value.target_info),
            .props = if (value.props == 0) null else .{ .value = value.props },
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: GraphicsPipelineCreateInfo) C.SDL_GPUGraphicsPipelineCreateInfo {
        return .{
            .vertex_shader = self.vertex_shader.value,
            .fragment_shader = self.fragment_shader.value,
            .vertex_input_state = self.vertex_input_state.toSdl(),
            .primitive_type = @intFromEnum(self.primitive_type),
            .rasterizer_state = self.rasterizer_state.toSdl(),
            .multisample_state = self.multisample_state.toSdl(),
            .depth_stencil_state = self.depth_stencil_state.toSdl(),
            .target_info = self.target_info.toSdl(),
            .props = if (self.props) |val| val.value else 0,
        };
    }
};

/// A structure specifying the descriptions of render targets used in a graphics pipeline.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const GraphicsPipelineTargetInfo = struct {
    /// Color target descriptions.
    color_target_descriptions: []const ColorTargetDescription,
    /// The pixel format of the depth-stencil target if used.
    depth_stencil_format: ?TextureFormat,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUGraphicsPipelineTargetInfo) GraphicsPipelineTargetInfo {
        return .{
            .color_target_descriptions = @as([*]const ColorTargetDescription, @ptrCast(value.color_target_descriptions))[0..@intCast(value.num_color_targets)],
            .depth_stencil_format = if (value.has_depth_stencil_target) @enumFromInt(value.depth_stencil_format) else null,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: GraphicsPipelineTargetInfo) C.SDL_GPUGraphicsPipelineTargetInfo {
        return .{
            .color_target_descriptions = @ptrCast(self.color_target_descriptions.ptr),
            .num_color_targets = @intCast(self.color_target_descriptions.len),
            .has_depth_stencil_target = self.depth_stencil_format != null,
            .depth_stencil_format = if (self.depth_stencil_format) |val| @intFromEnum(val) else 0,
        };
    }
};

/// Specifies the size of elements in an index buffer.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const IndexElementSize = enum(c_uint) {
    /// The index elements are 16-bit.
    indices_16bit = C.SDL_GPU_INDEXELEMENTSIZE_16BIT,
    /// The index elements are 32-bit.
    indices_32bit = C.SDL_GPU_INDEXELEMENTSIZE_32BIT,
};

/// A structure specifying the parameters of an indexed dispatch command.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const IndirectDispatchCommand = extern struct {
    /// The number of local workgroups to dispatch in the X dimension.
    group_count_x: u32,
    /// The number of local workgroups to dispatch in the Y dimension.
    group_count_y: u32,
    /// The number of local workgroups to dispatch in the Z dimension.
    group_count_z: u32,

    // Size tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_GPUIndirectDispatchCommand) == @sizeOf(IndirectDispatchCommand));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUIndirectDispatchCommand, "groupcount_x")) == @sizeOf(@FieldType(IndirectDispatchCommand, "group_count_x")));
        std.debug.assert(@offsetOf(C.SDL_GPUIndirectDispatchCommand, "groupcount_x") == @offsetOf(IndirectDispatchCommand, "group_count_x"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUIndirectDispatchCommand, "groupcount_y")) == @sizeOf(@FieldType(IndirectDispatchCommand, "group_count_y")));
        std.debug.assert(@offsetOf(C.SDL_GPUIndirectDispatchCommand, "groupcount_y") == @offsetOf(IndirectDispatchCommand, "group_count_y"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUIndirectDispatchCommand, "groupcount_z")) == @sizeOf(@FieldType(IndirectDispatchCommand, "group_count_z")));
        std.debug.assert(@offsetOf(C.SDL_GPUIndirectDispatchCommand, "groupcount_z") == @offsetOf(IndirectDispatchCommand, "group_count_z"));
    }
};

/// Specifies how the contents of a texture attached to a render pass are treated at the beginning of the render pass.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const LoadOperation = enum(c_uint) {
    /// The previous contents of the texture will be preserved.
    load = C.SDL_GPU_LOADOP_LOAD,
    /// The contents of the texture will be cleared to a color.
    clear = C.SDL_GPU_LOADOP_CLEAR,
    /// The previous contents of the texture need not be preserved.
    /// The contents will be undefined.
    do_not_care = C.SDL_GPU_LOADOP_DONT_CARE,
};

/// A structure specifying the parameters of the graphics pipeline multisample state.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const MultisampleState = struct {
    /// The number of samples to be used in rasterization.
    sample_count: SampleCount,
    /// Reserved for future use.
    /// Must be set to 0.
    sample_mask: u32 = 0,
    /// Reserved for future use.
    /// Must be set to false.
    enable_mask: bool = false,
    // /// True enables the alpha-to-coverage feature.
    // enable_alpha_to_coverage: bool,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUMultisampleState) MultisampleState {
        return .{
            .sample_count = @enumFromInt(value.sample_count),
            .sample_mask = value.sample_mask,
            .enable_mask = value.enable_mask,
            // .enable_alpha_to_coverage = value.enable_alpha_to_coverage,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: MultisampleState) C.SDL_GPUMultisampleState {
        return .{
            .sample_count = @intFromEnum(self.sample_count),
            .sample_mask = self.sample_mask,
            .enable_mask = self.enable_mask,
            // .enable_alpha_to_coverage = self.enable_alpha_to_coverage,
        };
    }
};

/// Specifies the timing that will be used to present swapchain textures to the OS.
///
/// ## Remarks
/// `gpu.PresentMode.vsync` mode will always be supported.
/// `gpu.PresentMode.immediate` and `gpu.PresentMode.mailbox` modes may not be supported on certain systems.
///
/// It is recommended to query `video.Window.supportsGpuPresentMode()` after claiming the window
/// if you wish to change the present mode to `gpu.PresentMode.immediate` or `gpu.PresentMode.mailbox`.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const PresentMode = enum(c_uint) {
    /// Waits for vblank before presenting.
    /// No tearing is possible.
    /// If there is a pending image to present, the new image is enqueued for presentation.
    /// Disallows tearing at the cost of visual latency.
    vsync = C.SDL_GPU_PRESENTMODE_VSYNC,
    /// Immediately presents.
    /// Lowest latency option, but tearing may occur.
    immediate = C.SDL_GPU_PRESENTMODE_IMMEDIATE,
    /// Waits for vblank before presenting.
    /// No tearing is possible.
    /// If there is a pending image to present, the pending image is replaced by the new image.
    /// Similar to `gpu.PresentMode.vsync`, but with reduced visual latency.
    mailbox = C.SDL_GPU_PRESENTMODE_MAILBOX,
};

/// Specifies the primitive topology of a graphics pipeline.
///
/// ## Remarks
/// If you are using `gpu.PrimitiveType.point_list` you must include a point size output in the vertex shader:
/// * For HLSL compiling to SPIRV you must decorate a float output with `[[vk::builtin("PointSize")]]`.
/// * For GLSL you must set the `gl_PointSize` builtin.
/// * For MSL you must include a float output with the `[[point_size]]` decorator.
///
/// Note that sized point topology is totally unsupported on D3D12.
/// Any size other than 1 will be ignored.
/// In general, you should avoid using point topology for both compatibility and performance reasons.
/// You WILL regret using it.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const PrimitiveType = enum(c_uint) {
    /// A series of separate triangles.
    triangle_list = C.SDL_GPU_PRIMITIVETYPE_TRIANGLELIST,
    /// A series of connected triangles.
    triangle_strip = C.SDL_GPU_PRIMITIVETYPE_TRIANGLESTRIP,
    /// A series of separate lines.
    line_list = C.SDL_GPU_PRIMITIVETYPE_LINELIST,
    /// A series of connected lines.
    line_strip = C.SDL_GPU_PRIMITIVETYPE_LINESTRIP,
    /// A series of separate points.
    point_list = C.SDL_GPU_PRIMITIVETYPE_POINTLIST,
};

/// A structure specifying the parameters of the graphics pipeline rasterizer state.
///
/// ## Remarks
/// Note that `gpu.FillMode.line` is not supported on many Android devices.
/// For those devices, the fill mode will automatically fall back to `gpu.FillMode.fill`.
///
/// Also note that the D3D12 driver will enable depth clamping even if `enable_depth_clip` is true.
/// If you need this clamp + clip behavior, consider enabling depth clip and then manually clamping depth in your fragment shaders on Metal and Vulkan.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const RasterizerState = struct {
    /// Whether polygons will be filled in or drawn as lines.
    fill_mode: FillMode,
    /// The facing direction in which triangles will be culled.
    cull_mode: CullMode,
    /// The vertex winding that will cause a triangle to be determined as front-facing.
    front_face: FrontFace,
    /// A scalar factor controlling the depth value added to each fragment.
    depth_bias_constant_factor: f32,
    /// The maximum depth bias of a fragment.
    depth_bias_clamp: f32,
    /// A scalar factor applied to a fragment's slope in depth calculations.
    depth_bias_slope_factor: f32,
    /// True to bias fragment depth values.
    enable_depth_bias: bool,
    /// True to enable depth clip, false to enable depth clamp.
    enable_depth_clip: bool,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPURasterizerState) RasterizerState {
        return .{
            .fill_mode = @enumFromInt(value.fill_mode),
            .cull_mode = @enumFromInt(value.cull_mode),
            .front_face = @enumFromInt(value.front_face),
            .depth_bias_constant_factor = value.depth_bias_constant_factor,
            .depth_bias_clamp = value.depth_bias_clamp,
            .depth_bias_slope_factor = value.depth_bias_slope_factor,
            .enable_depth_bias = value.enable_depth_bias,
            .enable_depth_clip = value.enable_depth_clip,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: RasterizerState) C.SDL_GPURasterizerState {
        return .{
            .fill_mode = @intFromEnum(self.fill_mode),
            .cull_mode = @intFromEnum(self.cull_mode),
            .front_face = @intFromEnum(self.front_face),
            .depth_bias_constant_factor = self.depth_bias_constant_factor,
            .depth_bias_clamp = self.depth_bias_clamp,
            .depth_bias_slope_factor = self.depth_bias_slope_factor,
            .enable_depth_bias = self.enable_depth_bias,
            .enable_depth_clip = self.enable_depth_clip,
        };
    }
};

/// An opaque handle representing a render pass.
///
/// ## Remarks
/// This handle is transient and should not be held or referenced after `gpu.RenderPass.end()` is called.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const RenderPass = packed struct {
    value: *C.SDL_GPURenderPass,

    /// Binds texture-sampler pairs for use on the fragment shader.
    ///
    /// ## Function Parameters
    /// * `self`: A render pass handle.
    /// * `first_slot`: The fragment sampler slot to begin binding from.
    /// * `texture_sampler_bindings`: Texture-sampler binding structs.
    ///
    /// ## Remarks
    /// The textures must have been created with `gpu.TextureUsageFlags.sampler`.
    ///
    /// Be sure your shader is set up according to the requirements documented in `gpu.Device.createShader()`.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindFragmentSamplers(
        self: RenderPass,
        first_slot: u32,
        texture_sampler_bindings: []const TextureSamplerBinding,
    ) void {
        C.SDL_BindGPUFragmentSamplers(
            self.value,
            first_slot,
            @ptrCast(texture_sampler_bindings.ptr),
            @intCast(texture_sampler_bindings.len),
        );
    }

    /// Binds storage buffers for use on the fragment shader.
    ///
    /// ## Function Parameters
    /// * `self`: A render pass handle.
    /// * `first_slot`: The fragment storage buffer slot to begin binding from.
    /// * `storage_buffers`: Storage buffers.
    ///
    /// ## Remarks
    /// These textures must have been created with `gpu.BufferUsageFlags.graphics_storage_read`.
    ///
    /// Be sure your shader is set up according to the requirements documented in `gpu.Device.createShader()`.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindFragmentStorageBuffers(
        self: RenderPass,
        first_slot: u32,
        storage_buffers: []const Buffer,
    ) void {
        C.SDL_BindGPUFragmentStorageBuffers(
            self.value,
            first_slot,
            @ptrCast(storage_buffers.ptr),
            @intCast(storage_buffers.len),
        );
    }

    /// Binds storage textures for use on the fragment shader.
    ///
    /// ## Function Parameters
    /// * `self`: A render pass handle.
    /// * `first_slot`: The fragment storage texture slot to begin binding from.
    /// * `storage_textures`: Storage textures.
    ///
    /// ## Remarks
    /// These textures must have been created with `gpu.TextureUsageFlags.graphics_storage_read`.
    ///
    /// Be sure your shader is set up according to the requirements documented in `gpu.Device.createShader()`.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindFragmentStorageTextures(
        self: RenderPass,
        first_slot: u32,
        storage_textures: []const Texture,
    ) void {
        C.SDL_BindGPUFragmentStorageTextures(
            self.value,
            first_slot,
            @ptrCast(storage_textures.ptr),
            @intCast(storage_textures.len),
        );
    }

    /// Binds a graphics pipeline on a render pass to be used in rendering.
    ///
    /// ## Function Parameters
    /// * `self`: A render pass handle.
    /// * `graphics_pipeline`: The graphics pipeline to bind.
    ///
    /// ## Remarks
    /// A graphics pipeline must be bound before making any draw calls.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindGraphicsPipeline(
        self: RenderPass,
        graphics_pipeline: GraphicsPipeline,
    ) void {
        C.SDL_BindGPUGraphicsPipeline(
            self.value,
            graphics_pipeline.value,
        );
    }

    /// Binds an index buffer on a command buffer for use with subsequent draw calls.
    ///
    /// ## Function Parameters
    /// * `self`: A render pass handle.
    /// * `binding`: Struct containing an index buffer and offset.
    /// * `index_element_size`: Whether the index values in the buffer are 16-bit or 32-bit.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindIndexBuffer(
        self: RenderPass,
        binding: BufferBinding,
        index_element_size: IndexElementSize,
    ) void {
        C.SDL_BindGPUIndexBuffer(
            self.value,
            @ptrCast(&binding),
            @intFromEnum(index_element_size),
        );
    }

    /// Binds vertex buffers on a command buffer for use with subsequent draw calls.
    ///
    /// ## Function Parameters
    /// * `self`: A render pass handle.
    /// * `first_slot`: The vertex buffer slot to begin binding from.
    /// * `bindings`: Structs containing vertex buffers and offset values.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindVertexBuffers(
        self: RenderPass,
        first_slot: u32,
        bindings: []const BufferBinding,
    ) void {
        C.SDL_BindGPUVertexBuffers(
            self.value,
            first_slot,
            @ptrCast(bindings.ptr),
            @intCast(bindings.len),
        );
    }

    /// Binds texture-sampler pairs for use on the vertex shader.
    ///
    /// ## Function Parameters
    /// * `self`: A render pass handle.
    /// * `first_slot`: The vertex sampler slot to begin binding from.
    /// * `texture_sampler_bindings`: Texture-sampler binding structs.
    ///
    /// ## Remarks
    /// The textures must have been created with `gpu.TextureUsageFlags.sampler`.
    ///
    /// Be sure your shader is set up according to the requirements documented in `gpu.Device.createShader()`.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindVertexSamplers(
        self: RenderPass,
        first_slot: u32,
        texture_sampler_bindings: []const TextureSamplerBinding,
    ) void {
        C.SDL_BindGPUVertexSamplers(
            self.value,
            first_slot,
            @ptrCast(texture_sampler_bindings.ptr),
            @intCast(texture_sampler_bindings.len),
        );
    }

    /// Binds storage buffers for use on the vertex shader.
    ///
    /// ## Function Parameters
    /// * `self`: A render pass handle.
    /// * `first_slot`: The vertex storage buffer slot to begin binding from.
    /// * `storage_buffers`: Buffers.
    ///
    /// ## Remarks
    /// These buffers must have been created with `gpu.BufferUsageFlags.graphics_storage_read`.
    ///
    /// Be sure your shader is set up according to the requirements documented in `gpu.Device.createShader()`.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindVertexStorageBuffers(
        self: RenderPass,
        first_slot: u32,
        storage_buffers: []const Buffer,
    ) void {
        C.SDL_BindGPUVertexStorageBuffers(
            self.value,
            first_slot,
            @ptrCast(storage_buffers.ptr),
            @intCast(storage_buffers.len),
        );
    }

    /// Binds storage textures for use on the vertex shader.
    ///
    /// ## Function Parameters
    /// * `self`: A render pass handle.
    /// * `first_slot`: The vertex storage texture slot to begin binding from.
    /// * `storage_textures`: Storage textures.
    ///
    /// ## Remarks
    /// These textures must have been created with `gpu.TextureUsageFlags.graphics_storage_read`.
    ///
    /// Be sure your shader is set up according to the requirements documented in `gpu.Device.createShader()`.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn bindVertexStorageTextures(
        self: RenderPass,
        first_slot: u32,
        storage_textures: []const Texture,
    ) void {
        C.SDL_BindGPUVertexStorageTextures(
            self.value,
            first_slot,
            @ptrCast(storage_textures.ptr),
            @intCast(storage_textures.len),
        );
    }
};

/// Specifies the sample count of a texture.
///
/// ## Remarks
/// Used in multisampling.
/// Note that this value only applies when the texture is used as a render target.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const SampleCount = enum(c_uint) {
    no_multisampling = C.SDL_GPU_SAMPLECOUNT_1,
    msaa_2x = C.SDL_GPU_SAMPLECOUNT_2,
    msaa_4x = C.SDL_GPU_SAMPLECOUNT_4,
    msaa_8x = C.SDL_GPU_SAMPLECOUNT_8,
};

/// An opaque handle representing a sampler.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Sampler = packed struct {
    value: *C.SDL_GPUSampler,
};

/// Specifies behavior of texture sampling when the coordinates exceed the 0-1 range.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const SamplerAddressMode = enum(c_uint) {
    /// Specifies that the coordinates will wrap around.
    repeat = C.SDL_GPU_SAMPLERADDRESSMODE_REPEAT,
    /// Specifies that the coordinates will wrap around mirrored.
    mirrored_repeat = C.SDL_GPU_SAMPLERADDRESSMODE_MIRRORED_REPEAT,
    /// Specifies that the coordinates will clamp to the 0-1 range.
    clamp_to_edge = C.SDL_GPU_SAMPLERADDRESSMODE_CLAMP_TO_EDGE,
};

/// A structure specifying the parameters of a sampler.
///
/// ## Remarks
/// Note that `mip_lod_bias` is a no-op for the Metal driver.
/// For Metal, LOD bias must be applied via shader instead.
///
/// ## Version
/// This function is available since SDL 3.2.0.
pub const SamplerCreateInfo = struct {
    /// The minification filter to apply to lookups.
    min_filter: Filter,
    /// The magnification filter to apply to lookups.
    max_filter: Filter,
    /// The mipmap filter to apply to lookups.
    mipmap_mode: SamplerMipmapMode,
    /// The addressing mode for U coordinates outside [0, 1).
    address_mode_u: SamplerAddressMode,
    /// The addressing mode for V coordinates outside [0, 1).
    address_mode_v: SamplerAddressMode,
    /// The addressing mode for W coordinates outside [0, 1).
    address_mode_w: SamplerAddressMode,
    /// The bias to be added to mipmap LOD calculation.
    mip_lod_bias: f32,
    /// The anisotropy value clamp used by the sampler.
    max_anisotropy: ?f32,
    /// The comparison operator to apply to fetched data before filtering.
    compare: ?CompareOperation,
    /// Clamps the minimum of the computed LOD value.
    min_lod: f32,
    /// Clamps the maximum of the computed LOD value.
    max_lod: f32,
    /// Properties for extensions.
    props: ?properties.Group,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUSamplerCreateInfo) SamplerCreateInfo {
        return .{
            .min_filter = @enumFromInt(value.min_filter),
            .max_filter = @enumFromInt(value.max_filter),
            .mipmap_mode = @enumFromInt(value.mipmap_mode),
            .address_mode_u = @enumFromInt(value.address_mode_u),
            .address_mode_v = @enumFromInt(value.address_mode_v),
            .address_mode_w = @enumFromInt(value.address_mode_w),
            .mip_lod_bias = value.mip_lod_bias,
            .max_anisotrophy = if (value.enable_anisotropy) value.max_anisotropy else null,
            .compare = if (value.enable_compare) @enumFromInt(value.compare_op) else null,
            .min_lod = value.min_lod,
            .max_lod = value.max_lod,
            .props = if (value.props != 0) .{ .value = value.props } else null,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: SamplerCreateInfo) C.SDL_GPUSamplerCreateInfo {
        return .{
            .min_filter = @intFromEnum(self.min_filter),
            .max_filter = @intFromEnum(self.max_filter),
            .mipmap_mode = @intFromEnum(self.mipmap_mode),
            .address_mode_u = @intFromEnum(self.address_mode_u),
            .address_mode_v = @intFromEnum(self.address_mode_v),
            .address_mode_w = @intFromEnum(self.address_mode_w),
            .mip_lod_bias = self.mip_lod_bias,
            .enable_anisotrophy = self.max_anisotrophy != null,
            .max_anisotrophy = if (self.max_anisotropy) |val| val else 0,
            .enable_compare = self.compare != null,
            .compare_op = if (self.enable_compare) @intFromEnum(self.compare) else null,
            .min_lod = self.min_lod,
            .max_lod = self.max_lod,
            .props = if (self.props) |val| val.value else 0,
        };
    }
};

/// Specifies a mipmap mode used by a sampler.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const SamplerMipmapMode = enum(c_uint) {
    /// Point filtering.
    nearest = C.SDL_GPU_SAMPLERMIPMAPMODE_NEAREST,
    /// Linear filtering.
    linear = C.SDL_GPU_SAMPLERMIPMAPMODE_LINEAR,
};

/// An opaque handle representing a compiled shader object.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Shader = packed struct {
    value: *C.SDL_GPUShader,
};

/// A structure specifying code and metadata for creating a shader object.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const ShaderCreateInfo = struct {
    /// Shader code.
    code: []const u8,
    /// UTF-8 string specifying entry point name.
    entry_point: [:0]const u8,
    /// The format of the shader code.
    format: ShaderFormatFlags,
    /// The stage the shader program corresponds to.
    stage: ShaderStage,
    /// The number of samplers defined in the shader.
    num_samplers: u32,
    /// The number of storage textures defined in the shader.
    num_storage_textures: u32,
    /// The number of storage buffers defined in the shader.
    num_storage_buffers: u32,
    /// The number of uniform buffers defined in the shader.
    num_uniform_buffers: u32,
    /// Properties for extensions.
    props: ?properties.Group,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUShaderCreateInfo) ShaderCreateInfo {
        return .{
            .code = value.code[0..value.code_size],
            .entry_point = std.mem.span(value.entrypoint),
            .format = ShaderFormatFlags.fromSdl(value.format),
            .stage = @enumFromInt(value.stage),
            .num_samplers = value.num_samplers,
            .num_storage_textures = value.num_storage_textures,
            .num_storage_buffers = value.num_storage_buffers,
            .num_uniform_buffers = value.num_uniform_buffers,
            .props = if (value.props == 0) null else .{ .value = value.props },
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: ShaderCreateInfo) C.SDL_GPUShaderCreateInfo {
        return .{
            .code = self.code.ptr,
            .code_size = self.code.len,
            .entrypoint = self.entry_point.ptr,
            .format = self.format.toSdl(),
            .stage = @intFromEnum(self.stage),
            .num_samplers = self.num_samplers,
            .num_storage_textures = self.num_storage_textures,
            .num_storage_buffers = self.num_storage_buffers,
            .num_uniform_buffers = self.num_uniform_buffers,
            .props = if (self.props) |val| val.value else 0,
        };
    }
};

/// Specifies the format of shader code.
///
/// ## Remarks
/// Each format corresponds to a specific backend that accepts it.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const ShaderFormatFlags = struct {
    /// Shaders for NDA'd platforms.
    private: bool,
    /// SPIR-V shaders for Vulkan.
    spirv: bool,
    /// DXBC SM5_1 shaders for D3D12.
    dxbc: bool,
    /// DXIL SM6_0 shaders for D3D12.
    dxil: bool,
    /// MSL shaders for Metal.
    msl: bool,
    /// Precompiled metallib shaders for Metal.
    metal_lib: bool,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUShaderFormat) ?ShaderFormatFlags {
        if (value == C.SDL_GPU_SHADERFORMAT_INVALID)
            return null;
        return .{
            .private = value & C.SDL_GPU_SHADERFORMAT_PRIVATE > 0,
            .spirv = value & C.SDL_GPU_SHADERFORMAT_SPIRV > 0,
            .dxbc = value & C.SDL_GPU_SHADERFORMAT_DXBC > 0,
            .dxil = value & C.SDL_GPU_SHADERFORMAT_DXIL > 0,
            .msl = value & C.SDL_GPU_SHADERFORMAT_MSL > 0,
            .metal_lib = value & C.SDL_GPU_SHADERFORMAT_METALLIB > 0,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: ?ShaderFormatFlags) C.SDL_GPUShaderFormat {
        if (self) |val| {
            var ret = 0;
            if (val.private)
                ret |= C.SDL_GPU_SHADERFORMAT_PRIVATE;
            if (val.spirv)
                ret |= C.SDL_GPU_SHADERFORMAT_SPIRV;
            if (val.dxbc)
                ret |= C.SDL_GPU_SHADERFORMAT_DXBC;
            if (val.dxil)
                ret |= C.SDL_GPU_SHADERFORMAT_DXIL;
            if (val.msl)
                ret |= C.SDL_GPU_SHADERFORMAT_MSL;
            if (val.metal_lib)
                ret |= C.SDL_GPU_SHADERFORMAT_METALLIB;
            return ret;
        }
        return C.SDL_GPU_SHADERFORMAT_INVALID;
    }
};

/// Specifies which stage a shader program corresponds to.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const ShaderStage = enum(c_uint) {
    vertex = C.SDL_GPU_SHADERSTAGE_VERTEX,
    fragment = C.SDL_GPU_SHADERSTAGE_FRAGMENT,
};

/// Specifies what happens to a stored stencil value if stencil tests fail or pass.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const StencilOperation = enum(c_uint) {
    /// Keeps the current value.
    keep = C.SDL_GPU_STENCILOP_KEEP,
    /// Sets the value to 0.
    zero = C.SDL_GPU_STENCILOP_ZERO,
    /// Sets the value to reference.
    replace = C.SDL_GPU_STENCILOP_REPLACE,
    /// Increments the current value and clamps to the maximum value.
    increment_and_clamp = C.SDL_GPU_STENCILOP_INCREMENT_AND_CLAMP,
    /// Decrements the current value and clamps to 0.
    decrement_and_clamp = C.SDL_GPU_STENCILOP_DECREMENT_AND_CLAMP,
    /// Bitwise-inverts the current value.
    invert = C.SDL_GPU_STENCILOP_INVERT,
    /// Increments the current value and wraps back to 0.
    increment_and_wrap = C.SDL_GPU_STENCILOP_INCREMENT_AND_WRAP,
    /// Decrements the current value and wraps to the maximum value.
    decrement_and_wrap = C.SDL_GPU_STENCILOP_DECREMENT_AND_WRAP,

    /// Create from SDL.
    pub fn fromSdl(val: C.SDL_GPUStencilOp) ?StencilOperation {
        if (val == C.SDL_GPU_STENCILOP_INVALID) {
            return null;
        }
        return @enumFromInt(val);
    }

    /// Convert to an SDL value.
    pub fn toSdl(val: ?StencilOperation) C.SDL_GPUStencilOp {
        if (val) |tmp| {
            return @intFromEnum(tmp);
        }
        return C.SDL_GPU_STENCILOP_INVALID;
    }
};

/// A structure specifying the stencil operation state of a graphics pipeline.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const StencilOperationState = struct {
    /// The action performed on samples that fail the stencil test.
    fail: StencilOperation,
    /// The action performed on samples that pass the depth and stencil tests.
    pass: StencilOperation,
    /// The action performed on samples that pass the stencil test and fail the depth test.
    depth_fail: StencilOperation,
    /// The comparison operator used in the stencil test.
    compare: CompareOperation,

    /// Convert from an SDL value.
    pub fn fromSdl(value: C.SDL_GPUStencilOpState) StencilOperationState {
        return .{
            .fail = StencilOperation.fromSdl(value.fail_op).?,
            .pass = StencilOperation.fromSdl(value.pass_op).?,
            .depth_fail = StencilOperation.fromSdl(value.depth_fail_op).?,
            .compare = CompareOperation.fromSdl(value.compare_op).?,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: StencilOperationState) C.SDL_GPUStencilOpState {
        return .{
            .fail = StencilOperation.toSdl(self.fail),
            .pass = StencilOperation.toSdl(self.pass),
            .depth_fail = StencilOperation.toSdl(self.depth_fail),
            .compare = CompareOperation.toSdl(self.compare),
        };
    }
};

/// A structure specifying parameters related to binding buffers in a compute pass.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const StorageBufferReadWriteBinding = extern struct {
    /// The buffer to bind.
    /// Must have been created with `gpu.BufferUsageFlags.compute_storage_write`.
    buffer: Buffer,
    /// If true, cycles the buffer if it is already bound.
    cycle: bool,
    _1: u8 = 0,
    _2: u8 = 0,
    _3: u8 = 0,

    // Size tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_GPUStorageBufferReadWriteBinding) == @sizeOf(StorageBufferReadWriteBinding));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUStorageBufferReadWriteBinding, "buffer")) == @sizeOf(@FieldType(StorageBufferReadWriteBinding, "buffer")));
        std.debug.assert(@offsetOf(C.SDL_GPUStorageBufferReadWriteBinding, "buffer") == @offsetOf(StorageBufferReadWriteBinding, "buffer"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUStorageBufferReadWriteBinding, "cycle")) == @sizeOf(@FieldType(StorageBufferReadWriteBinding, "cycle")));
        std.debug.assert(@offsetOf(C.SDL_GPUStorageBufferReadWriteBinding, "cycle") == @offsetOf(StorageBufferReadWriteBinding, "cycle"));
    }
};

/// A structure specifying parameters related to binding textures in a compute pass.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const StorageTextureReadWriteBinding = extern struct {
    /// The texture to bind. Must have been created with `gpu.TextureUsageFlags.compute_storage_write` or `gpu.TextureUsageFlags.compute_storage_simultaneous_read_write`.
    texture: Texture,
    /// The mip level index to bind.
    mip_level: u32,
    /// The layer index to bind.
    layer: u32,
    /// If true, cycles the buffer if it is already bound.
    cycle: bool,
    _1: u8 = 0,
    _2: u8 = 0,
    _3: u8 = 0,

    // Size tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_GPUStorageTextureReadWriteBinding) == @sizeOf(StorageTextureReadWriteBinding));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUStorageTextureReadWriteBinding, "texture")) == @sizeOf(@FieldType(StorageTextureReadWriteBinding, "texture")));
        std.debug.assert(@offsetOf(C.SDL_GPUStorageTextureReadWriteBinding, "texture") == @offsetOf(StorageTextureReadWriteBinding, "texture"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUStorageTextureReadWriteBinding, "mip_level")) == @sizeOf(@FieldType(StorageTextureReadWriteBinding, "mip_level")));
        std.debug.assert(@offsetOf(C.SDL_GPUStorageTextureReadWriteBinding, "mip_level") == @offsetOf(StorageTextureReadWriteBinding, "mip_level"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUStorageTextureReadWriteBinding, "layer")) == @sizeOf(@FieldType(StorageTextureReadWriteBinding, "layer")));
        std.debug.assert(@offsetOf(C.SDL_GPUStorageTextureReadWriteBinding, "layer") == @offsetOf(StorageTextureReadWriteBinding, "layer"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUStorageTextureReadWriteBinding, "cycle")) == @sizeOf(@FieldType(StorageTextureReadWriteBinding, "cycle")));
        std.debug.assert(@offsetOf(C.SDL_GPUStorageTextureReadWriteBinding, "cycle") == @offsetOf(StorageTextureReadWriteBinding, "cycle"));
    }
};

/// Specifies how the contents of a texture attached to a render pass are treated at the end of the render pass.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const StoreOperation = enum(c_uint) {
    /// The contents generated during the render pass will be written to memory.
    store = C.SDL_GPU_STOREOP_STORE,
    /// The contents generated during the render pass are not needed and may be discarded.
    /// The contents will be undefined.
    do_not_care = C.SDL_GPU_STOREOP_DONT_CARE,
    /// The multisample contents generated during the render pass will be resolved to a non-multisample texture.
    /// The contents in the multisample texture may then be discarded and will be undefined.
    resolve = C.SDL_GPU_STOREOP_RESOLVE,
    /// The multisample contents generated during the render pass will be resolved to a non-multisample texture.
    /// The contents in the multisample texture will be written to memory.
    resolve_and_store = C.SDL_GPU_STOREOP_RESOLVE_AND_STORE,
};

/// Specifies the texture format and colorspace of the swapchain textures.
///
/// ## Remarks
/// `gpu.SwapchainComposition.sdr` will always be supported.
/// Other compositions may not be supported on certain systems.
///
/// It is recommended to query `video.Window.supportsGpuSwapchainComposition()` after claiming the window
/// if you wish to change the swapchain composition from `gpu.SwapchainComposition.sdr`.
pub const SwapchainComposition = enum(c_uint) {
    /// B8G8R8A8 or R8G8B8A8 swapchain.
    /// Pixel values are in sRGB encoding.
    sdr = C.SDL_GPU_SWAPCHAINCOMPOSITION_SDR,
    /// B8G8R8A8_SRGB or R8G8B8A8_SRGB swapchain.
    /// Pixel values are stored in memory in sRGB encoding but accessed in shaders in "linear sRGB" encoding which is sRGB but with a linear transfer function.
    sdr_linear = C.SDL_GPU_SWAPCHAINCOMPOSITION_SDR_LINEAR,
    /// R16G16B16A16_FLOAT swapchain.
    /// Pixel values are in extended linear sRGB encoding and permits values outside of the [0, 1] range.
    hdr_extended_linear = C.SDL_GPU_SWAPCHAINCOMPOSITION_HDR_EXTENDED_LINEAR,
    /// A2R10G10B10 or A2B10G10R10 swapchain.
    /// Pixel values are in BT.2020 ST2084 (PQ) encoding.
    hdr10_st2084 = C.SDL_GPU_SWAPCHAINCOMPOSITION_HDR10_ST2084,
};

/// An opaque handle representing a texture.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const Texture = packed struct {
    value: *C.SDL_GPUTexture,
};

/// Specifies the pixel format of a texture.
///
/// ## Remarks
/// Texture format support varies depending on driver, hardware, and usage flags.
/// In general, you should use `gpu.Device.textureSupportsFormat()` to query if a format is supported before using it.
/// However, there are a few guaranteed formats.
///
/// For `gpu.TextureUsageFlags.sampler` usage, the following formats are universally supported:
/// * r8g8b8a8_unorm
/// * b8g8r8a8_unorm
/// * r8_unorm
/// * r8_snorm
/// * r8g8_unorm
/// * r8g8_snorm
/// * r8g8b8a8_snorm
/// * r16_float
/// * r16g16_float
/// * r16g16b16a16_float
/// * r32_float
/// * r32g32_float
/// * r32g32b32a32_float
/// * r11g11b10_ufloat
/// * r8g8b8a8_unorm_srgb
/// * b8g8r8a8_unorm_srgb
/// * depth16_unorm
///
/// For `gpu.TextureUsageFlags.color_target` usage, the following formats are universally supported:
/// * r8g8b8a8_unorm
/// * b8g8r8a8_unorm
/// * r8_unorm
/// * r16_float
/// * r16g16_float
/// * r16g16b16a16_float
/// * r32_float
/// * r32g32_float
/// * r32g32b32a32_float
/// * r8_uint
/// * r8g8_uint
/// * r8g8b8a8_uint
/// * r16_uint
/// * r16g16_uint
/// * r16g16b16a16_uint
/// * r8_int
/// * r8g8_int
/// * r8g8b8a8_int
/// * r16_int
/// * r16g16_int
/// * r16g16b16a16_int
/// * r8g8b8a8_unorm_srgb
/// * b8g8r8a8_unorm_srgb
///
/// For `gpu.TextureUsageFlags.storage` usages, the following formats are universally supported:
/// * r8g8b8a8_unorm
/// * r8g8b8a8_snorm
/// * r16g16b16a16_float
/// * r32_float
/// * r32g32_float
/// * r32g32b32a32_float
/// * r8g8b8a8_uint
/// * r16g16b16a16_uint
/// * r8g8b8a8_int
/// * r16g16b16a16_int
///
/// For `gpu.TextureUsageFlags.depth_stencil_target` usage, the following formats are universally supported:
/// * depth16_unorm
/// * Either (but not necessarily both!) depth24_unorm or depth32_float
/// * Either (but not necessarily both!) depth24_unorm_s8_uint or depth32_float_s8_uint
///
/// Unless `gpu.TextureFormat.depth16_unorm` is sufficient for your purposes, always check which of depth24/depth32 is supported before creating a depth-stencil texture!
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const TextureFormat = enum(c_uint) {
    a8_unorm = C.SDL_GPU_TEXTUREFORMAT_A8_UNORM,
    r8_unorm = C.SDL_GPU_TEXTUREFORMAT_R8_UNORM,
    r8g8_unorm = C.SDL_GPU_TEXTUREFORMAT_R8G8_UNORM,
    r8g8b8a8_unorm = C.SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM,
    r16_unorm = C.SDL_GPU_TEXTUREFORMAT_R16_UNORM,
    r16g16_unorm = C.SDL_GPU_TEXTUREFORMAT_R16G16_UNORM,
    r16g16b16a16_unorm = C.SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UNORM,
    r10g10b10a2_unorm = C.SDL_GPU_TEXTUREFORMAT_R10G10B10A2_UNORM,
    b5g6r5_unorm = C.SDL_GPU_TEXTUREFORMAT_B5G6R5_UNORM,
    b5g5r5a1_unorm = C.SDL_GPU_TEXTUREFORMAT_B5G5R5A1_UNORM,
    b4g4r4a4_unorm = C.SDL_GPU_TEXTUREFORMAT_B4G4R4A4_UNORM,
    b8g8r8a8_unorm = C.SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM,
    bc1_rgba_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM,
    bc2_rgba_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM,
    bc3_rgba_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM,
    bc4_r_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_BC4_R_UNORM,
    bc5_rg_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_BC5_RG_UNORM,
    bc7_rgba_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM,
    bc6h_rgb_float_compressed = C.SDL_GPU_TEXTUREFORMAT_BC6H_RGB_FLOAT,
    bc6h_rgb_ufloat_compressed = C.SDL_GPU_TEXTUREFORMAT_BC6H_RGB_UFLOAT,
    r8_snorm = C.SDL_GPU_TEXTUREFORMAT_R8_SNORM,
    r8g8_snorm = C.SDL_GPU_TEXTUREFORMAT_R8G8_SNORM,
    r8g8b8a8_snorm = C.SDL_GPU_TEXTUREFORMAT_R8G8B8A8_SNORM,
    r16_snorm = C.SDL_GPU_TEXTUREFORMAT_R16_SNORM,
    r16g16_snorm = C.SDL_GPU_TEXTUREFORMAT_R16G16_SNORM,
    r16g16b16a16_snorm = C.SDL_GPU_TEXTUREFORMAT_R16G16B16A16_SNORM,
    r16_float = C.SDL_GPU_TEXTUREFORMAT_R16_FLOAT,
    r16g16_float = C.SDL_GPU_TEXTUREFORMAT_R16G16_FLOAT,
    r16g16b16a16_float = C.SDL_GPU_TEXTUREFORMAT_R16G16B16A16_FLOAT,
    r32_float = C.SDL_GPU_TEXTUREFORMAT_R32_FLOAT,
    r32g32_float = C.SDL_GPU_TEXTUREFORMAT_R32G32_FLOAT,
    r32g32b32a32_float = C.SDL_GPU_TEXTUREFORMAT_R32G32B32A32_FLOAT,
    r11g11b10_ufloat = C.SDL_GPU_TEXTUREFORMAT_R11G11B10_UFLOAT,
    r8_uint = C.SDL_GPU_TEXTUREFORMAT_R8_UINT,
    r8g8_uint = C.SDL_GPU_TEXTUREFORMAT_R8G8_UINT,
    r8g8b8a8_uint = C.SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UINT,
    r16_uint = C.SDL_GPU_TEXTUREFORMAT_R16_UINT,
    r16g16_uint = C.SDL_GPU_TEXTUREFORMAT_R16G16_UINT,
    r16g16b16a16_uint = C.SDL_GPU_TEXTUREFORMAT_R16G16B16A16_UINT,
    r32_uint = C.SDL_GPU_TEXTUREFORMAT_R32_UINT,
    r32g32_uint = C.SDL_GPU_TEXTUREFORMAT_R32G32_UINT,
    r32g32b32a32_uint = C.SDL_GPU_TEXTUREFORMAT_R32G32B32A32_UINT,
    r8_int = C.SDL_GPU_TEXTUREFORMAT_R8_INT,
    r8g8_int = C.SDL_GPU_TEXTUREFORMAT_R8G8_INT,
    r8g8b8a8_int = C.SDL_GPU_TEXTUREFORMAT_R8G8B8A8_INT,
    r16_int = C.SDL_GPU_TEXTUREFORMAT_R16_INT,
    r16g16_int = C.SDL_GPU_TEXTUREFORMAT_R16G16_INT,
    r16g16b16a16_int = C.SDL_GPU_TEXTUREFORMAT_R16G16B16A16_INT,
    r32_int = C.SDL_GPU_TEXTUREFORMAT_R32_INT,
    r32g32_int = C.SDL_GPU_TEXTUREFORMAT_R32G32_INT,
    r32g32b32a32_int = C.SDL_GPU_TEXTUREFORMAT_R32G32B32A32_INT,
    r8g8b8a8_unorm_srgb = C.SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM_SRGB,
    b8g8r8a8_unorm_srgb = C.SDL_GPU_TEXTUREFORMAT_B8G8R8A8_UNORM_SRGB,
    bc1_rgba_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_BC1_RGBA_UNORM_SRGB,
    bc2_rgba_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_BC2_RGBA_UNORM_SRGB,
    bc3_rgba_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_BC3_RGBA_UNORM_SRGB,
    bc7_rgba_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_BC7_RGBA_UNORM_SRGB,
    depth16_unorm = C.SDL_GPU_TEXTUREFORMAT_D16_UNORM,
    depth24_unorm = C.SDL_GPU_TEXTUREFORMAT_D24_UNORM,
    depth32_float = C.SDL_GPU_TEXTUREFORMAT_D32_FLOAT,
    depth24_unorm_s8_uint = C.SDL_GPU_TEXTUREFORMAT_D24_UNORM_S8_UINT,
    depth32_float_s8_uint = C.SDL_GPU_TEXTUREFORMAT_D32_FLOAT_S8_UINT,
    astc_4x4_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM,
    astc_5x4_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM,
    astc_5x5_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM,
    astc_6x5_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM,
    astc_6x6_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM,
    astc_8x5_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM,
    astc_8x6_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM,
    astc_8x8_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM,
    astc_10x5_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM,
    astc_10x6_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM,
    astc_10x8_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM,
    astc_10x10_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM,
    astc_12x10_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM,
    astc_12x12_unorm_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM,
    astc_4x4_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_4x4_UNORM_SRGB,
    astc_5x4_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_5x4_UNORM_SRGB,
    astc_5x5_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_5x5_UNORM_SRGB,
    astc_6x5_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_6x5_UNORM_SRGB,
    astc_6x6_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_6x6_UNORM_SRGB,
    astc_8x5_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x5_UNORM_SRGB,
    astc_8x6_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x6_UNORM_SRGB,
    astc_8x8_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x8_UNORM_SRGB,
    astc_10x5_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x5_UNORM_SRGB,
    astc_10x6_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x6_UNORM_SRGB,
    astc_10x8_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x8_UNORM_SRGB,
    astc_10x10_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x10_UNORM_SRGB,
    astc_12x10_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_12x10_UNORM_SRGB,
    astc_12x12_unorm_srgb_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_12x12_UNORM_SRGB,
    astc_4x4_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_4x4_FLOAT,
    astc_5x4_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_5x4_FLOAT,
    astc_5x5_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_5x5_FLOAT,
    astc_6x5_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_6x5_FLOAT,
    astc_6x6_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_6x6_FLOAT,
    astc_8x5_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x5_FLOAT,
    astc_8x6_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x6_FLOAT,
    astc_8x8_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_8x8_FLOAT,
    astc_10x5_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x5_FLOAT,
    astc_10x6_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x6_FLOAT,
    astc_10x8_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x8_FLOAT,
    astc_10x10_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_10x10_FLOAT,
    astc_12x10_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_12x10_FLOAT,
    astc_12x12_float_compressed = C.SDL_GPU_TEXTUREFORMAT_ASTC_12x12_FLOAT,

    /// Calculate the size in bytes of a texture format with dimensions.
    ///
    /// ## Function Parameters
    /// * `self`: A texture format.
    /// * `width`: Width in pixels.
    /// * `height`: Height in pixels.
    /// * `depth_or_layer_count`: Depth for 3D textures or layer count otherwise.
    ///
    /// ## Return Value
    /// Returns the size of a texture with this format and dimensions.
    ///
    /// ## Version
    /// This function is available since SDL 3.2.0.
    pub fn calculateSize(
        self: TextureFormat,
        width: u32,
        height: u32,
        depth_or_layer_count: u32,
    ) u32 {
        return C.SDL_CalculateGPUTextureFormatSize(
            @intFromEnum(self),
            width,
            height,
            depth_or_layer_count,
        );
    }
};

/// A structure specifying a location in a texture.
///
/// ## Remarks
/// Used when copying data from one texture to another.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const TextureLocation = struct {
    /// The texture used in the copy operation.
    texture: Texture,
    /// The mip level index of the location.
    mip_level: u32,
    /// The layer index of the location.
    layer: u32,
    /// The left offset of the location.
    x: u32,
    /// The top offset of the location.
    y: u32,
    /// The front offset of the location.
    z: u32,

    /// Convert from an SDL value.
    pub fn fromSdl(
        value: C.SDL_GPUTextureLocation,
    ) TextureLocation {
        return .{
            .texture = .{ .value = value.texture.? },
            .mip_level = value.mip_level,
            .layer = value.layer,
            .x = value.x,
            .y = value.y,
            .z = value.z,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(
        self: TextureLocation,
    ) C.SDL_GPUTextureLocation {
        return .{
            .texture = self.texture.value,
            .mip_level = self.mip_level,
            .layer = self.layer,
            .x = self.x,
            .y = self.y,
            .z = self.z,
        };
    }
};

/// A structure specifying parameters in a sampler binding call.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const TextureSamplerBinding = extern struct {
    /// The texture to bind.
    /// Must have been created with `gpu.TextureUsageFlags.sampler`.
    texture: Texture,
    /// The sampler to bind.
    sampler: Sampler,

    // Size tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_GPUTextureSamplerBinding) == @sizeOf(TextureSamplerBinding));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUTextureSamplerBinding, "texture")) == @sizeOf(@FieldType(TextureSamplerBinding, "texture")));
        std.debug.assert(@offsetOf(C.SDL_GPUTextureSamplerBinding, "texture") == @offsetOf(TextureSamplerBinding, "texture"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUTextureSamplerBinding, "sampler")) == @sizeOf(@FieldType(TextureSamplerBinding, "sampler")));
        std.debug.assert(@offsetOf(C.SDL_GPUTextureSamplerBinding, "sampler") == @offsetOf(TextureSamplerBinding, "sampler"));
    }
};

/// Specifies the type of a texture.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const TextureType = enum(c_uint) {
    /// The texture is a 2-dimensional image.
    two_dimensional = C.SDL_GPU_TEXTURETYPE_2D,
    /// The texture is a 2-dimensional array image.
    two_dimensional_array = C.SDL_GPU_TEXTURETYPE_2D_ARRAY,
    /// The texture is a 3-dimensional image.
    three_dimensional = C.SDL_GPU_TEXTURETYPE_3D,
    /// The texture is a cube image.
    cube = C.SDL_GPU_TEXTURETYPE_CUBE,
    /// The texture is a cube array image.
    cube_array = C.SDL_GPU_TEXTURETYPE_CUBE_ARRAY,
};

/// Specifies how a texture is intended to be used by the client.
///
/// ## Remarks
/// A texture must have at least one usage flag.
/// Note that some usage flag combinations are invalid.
///
/// With regards to compute storage usage, READ | WRITE means that you can have shader A that only writes into the texture
/// and shader B that only reads from the texture and bind the same texture to either shader respectively.
/// SIMULTANEOUS means that you can do reads and writes within the same shader or compute pass.
/// It also implies that atomic ops can be used, since those are read-modify-write operations.
/// If you use SIMULTANEOUS, you are responsible for avoiding data races, as there is no data synchronization within a compute pass.
/// Note that SIMULTANEOUS usage is only supported by a limited number of texture formats.
///
/// ## Version
/// This datatype is available since SDL 3.2.0.
pub const TextureUsageFlags = struct {
    /// Texture supports sampling.
    sampler: bool = false,
    /// Texture is a color render target.
    color_target: bool = false,
    /// Texture is a depth stencil target.
    depth_stencil_target: bool = false,
    /// Texture supports storage reads in graphics stages.
    graphics_storage_read: bool = false,
    /// Texture supports storage reads in the compute stage.
    compute_storage_read: bool = false,
    /// Texture supports storage writes in the compute stage.
    compute_storage_write: bool = false,
    /// Texture supports reads and writes in the same compute shader. This is NOT equivalent to READ | WRITE.
    compute_storage_simultaneous_read_write: bool = false,

    /// Convert from SDL.
    pub fn fromSdl(value: C.SDL_GPUTextureUsageFlags) TextureUsageFlags {
        return .{
            .sampler = value & C.SDL_GPU_TEXTUREUSAGE_SAMPLER > 0,
            .color_target = value & C.SDL_GPU_TEXTUREUSAGE_COLOR_TARGET > 0,
            .depth_stencil_target = value & C.SDL_GPU_TEXTUREUSAGE_DEPTH_STENCIL_TARGET > 0,
            .graphics_storage_read = value & C.SDL_GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ > 0,
            .compute_storage_read = value & C.SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_READ > 0,
            .compute_storage_write = value & C.SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE > 0,
            .compute_storage_simultaneous_read_write = value & C.SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE > 0,
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: TextureUsageFlags) C.SDL_GPUTextureUsageFlags {
        var ret: C.SDL_GPUTextureUsageFlags = 0;
        if (self.sampler)
            ret |= C.SDL_GPU_TEXTUREUSAGE_SAMPLER;
        if (self.color_target)
            ret |= C.SDL_GPU_TEXTUREUSAGE_COLOR_TARGET;
        if (self.depth_stencil_target)
            ret |= C.SDL_GPU_TEXTUREUSAGE_DEPTH_STENCIL_TARGET;
        if (self.graphics_storage_read)
            ret |= C.SDL_GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ;
        if (self.compute_storage_read)
            ret |= C.SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_READ;
        if (self.compute_storage_write)
            ret |= C.SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE;
        if (self.compute_storage_simultaneous_read_write)
            ret |= C.SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE;
        return ret;
    }
};

/// An opaque handle representing a transfer buffer.
///
/// ## Remarks
/// Used for transferring data to and from the device.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const TransferBuffer = struct {
    value: *C.SDL_GPUTransferBuffer,
};

/// Specifies how a transfer buffer is intended to be used by the client.
///
/// ## Remarks
/// Note that mapping and copying **from** an upload transfer buffer or **to** a download transfer buffer is undefined behavior.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const TransferBufferUsage = enum(c_uint) {
    upload = C.SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD,
    download = C.SDL_GPU_TRANSFERBUFFERUSAGE_DOWNLOAD,
};

/// A structure specifying a vertex attribute.
///
/// ## Remarks
/// All vertex attribute locations provided to a `gpu.VertexInputState` must be unique.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const VertexAttribute = extern struct {
    /// The shader input location index.
    location: u32,
    /// The binding slot of the associated vertex buffer.
    buffer_slot: u32,
    /// The size and type of the attribute data.
    format: VertexElementFormat,
    /// The byte offset of this attribute relative to the start of the vertex element.
    offset: u32,

    // Size tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_GPUVertexAttribute) == @sizeOf(VertexAttribute));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUVertexAttribute, "location")) == @sizeOf(@FieldType(VertexAttribute, "location")));
        std.debug.assert(@offsetOf(C.SDL_GPUVertexAttribute, "location") == @offsetOf(VertexAttribute, "location"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUVertexAttribute, "buffer_slot")) == @sizeOf(@FieldType(VertexAttribute, "buffer_slot")));
        std.debug.assert(@offsetOf(C.SDL_GPUVertexAttribute, "buffer_slot") == @offsetOf(VertexAttribute, "buffer_slot"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUVertexAttribute, "format")) == @sizeOf(@FieldType(VertexAttribute, "format")));
        std.debug.assert(@offsetOf(C.SDL_GPUVertexAttribute, "format") == @offsetOf(VertexAttribute, "format"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUVertexAttribute, "offset")) == @sizeOf(@FieldType(VertexAttribute, "offset")));
        std.debug.assert(@offsetOf(C.SDL_GPUVertexAttribute, "offset") == @offsetOf(VertexAttribute, "offset"));
    }
};

/// A structure specifying the parameters of vertex buffers used in a graphics pipeline.
///
/// ## Remarks
/// When you call `gpu.RenderPass.bindVertexBuffers()`, you specify the binding slots of the vertex buffers.
/// For example if you called `gpu.RenderPass.bindVertexBuffers()` with a `first_slot` of `2` and length of `3`,
/// the binding slots `2`, `3`, `4` would be used by the vertex buffers you pass in.
///
/// Vertex attributes are linked to buffers via the `buffer_slot` field of `gpu.VertexAttribute`.
/// For example, if an attribute has a `buffer_slot` of `0`, then that attribute belongs to the vertex buffer bound at slot `0`.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const VertexBufferDescription = extern struct {
    /// The binding slot of the vertex buffer.
    slot: u32,
    /// The byte pitch between consecutive elements of the vertex buffer.
    pitch: u32,
    /// Whether attribute addressing is a function of the vertex index or instance index.
    input_rate: VertexInputRate,
    /// Reserved for future use. Must be set to 0.
    instance_step_rate: u32 = 0,

    // Size tests.
    comptime {
        std.debug.assert(@sizeOf(C.SDL_GPUVertexBufferDescription) == @sizeOf(VertexBufferDescription));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUVertexBufferDescription, "slot")) == @sizeOf(@FieldType(VertexBufferDescription, "slot")));
        std.debug.assert(@offsetOf(C.SDL_GPUVertexBufferDescription, "slot") == @offsetOf(VertexBufferDescription, "slot"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUVertexBufferDescription, "pitch")) == @sizeOf(@FieldType(VertexBufferDescription, "pitch")));
        std.debug.assert(@offsetOf(C.SDL_GPUVertexBufferDescription, "pitch") == @offsetOf(VertexBufferDescription, "pitch"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUVertexBufferDescription, "input_rate")) == @sizeOf(@FieldType(VertexBufferDescription, "input_rate")));
        std.debug.assert(@offsetOf(C.SDL_GPUVertexBufferDescription, "input_rate") == @offsetOf(VertexBufferDescription, "input_rate"));
        std.debug.assert(@sizeOf(@FieldType(C.SDL_GPUVertexBufferDescription, "instance_step_rate")) == @sizeOf(@FieldType(VertexBufferDescription, "instance_step_rate")));
        std.debug.assert(@offsetOf(C.SDL_GPUVertexBufferDescription, "instance_step_rate") == @offsetOf(VertexBufferDescription, "instance_step_rate"));
    }
};

/// Specifies the format of a vertex attribute.
///
/// ## Remarks
/// Format is by type times quantity (`gpu.VertexElementFormat.u32x2` means 2 32-bit unsigned integers).
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const VertexElementFormat = enum(c_uint) {
    i32x1 = C.SDL_GPU_VERTEXELEMENTFORMAT_INT,
    i32x2 = C.SDL_GPU_VERTEXELEMENTFORMAT_INT2,
    i32x3 = C.SDL_GPU_VERTEXELEMENTFORMAT_INT3,
    i32x4 = C.SDL_GPU_VERTEXELEMENTFORMAT_INT4,
    u32x1 = C.SDL_GPU_VERTEXELEMENTFORMAT_UINT,
    u32x2 = C.SDL_GPU_VERTEXELEMENTFORMAT_UINT2,
    u32x3 = C.SDL_GPU_VERTEXELEMENTFORMAT_UINT3,
    u32x4 = C.SDL_GPU_VERTEXELEMENTFORMAT_UINT4,
    f32x1 = C.SDL_GPU_VERTEXELEMENTFORMAT_FLOAT,
    f32x2 = C.SDL_GPU_VERTEXELEMENTFORMAT_FLOAT2,
    f32x3 = C.SDL_GPU_VERTEXELEMENTFORMAT_FLOAT3,
    f32x4 = C.SDL_GPU_VERTEXELEMENTFORMAT_FLOAT4,
    i8x2 = C.SDL_GPU_VERTEXELEMENTFORMAT_BYTE2,
    i8x4 = C.SDL_GPU_VERTEXELEMENTFORMAT_BYTE4,
    u8x2 = C.SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2,
    u8x4 = C.SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4,
    i8x2_normalized = C.SDL_GPU_VERTEXELEMENTFORMAT_BYTE2_NORM,
    i8x4_normalized = C.SDL_GPU_VERTEXELEMENTFORMAT_BYTE4_NORM,
    u8x2_normalized = C.SDL_GPU_VERTEXELEMENTFORMAT_UBYTE2_NORM,
    u8x4_normalized = C.SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4_NORM,
    i16x2 = C.SDL_GPU_VERTEXELEMENTFORMAT_SHORT2,
    i16x4 = C.SDL_GPU_VERTEXELEMENTFORMAT_SHORT4,
    u16x2 = C.SDL_GPU_VERTEXELEMENTFORMAT_USHORT2,
    u16x4 = C.SDL_GPU_VERTEXELEMENTFORMAT_USHORT4,
    i16x2_normalized = C.SDL_GPU_VERTEXELEMENTFORMAT_SHORT2_NORM,
    i16x4_normalized = C.SDL_GPU_VERTEXELEMENTFORMAT_SHORT4_NORM,
    u16x2_normalized = C.SDL_GPU_VERTEXELEMENTFORMAT_USHORT2_NORM,
    u16x4_normalized = C.SDL_GPU_VERTEXELEMENTFORMAT_USHORT4_NORM,
    f16x2 = C.SDL_GPU_VERTEXELEMENTFORMAT_HALF2,
    f16x4 = C.SDL_GPU_VERTEXELEMENTFORMAT_HALF4,

    /// Create from SDL.
    pub fn fromSdl(val: C.SDL_GPUVertexElementFormat) ?VertexElementFormat {
        if (val == C.SDL_GPU_VERTEXELEMENTFORMAT_INVALID) {
            return null;
        }
        return @enumFromInt(val);
    }

    /// Convert to an SDL value.
    pub fn toSdl(val: ?VertexElementFormat) C.SDL_GPUVertexElementFormat {
        if (val) |tmp| {
            return @intFromEnum(tmp);
        }
        return C.SDL_GPU_VERTEXELEMENTFORMAT_INVALID;
    }
};

/// Specifies the rate at which vertex attributes are pulled from buffers.
///
/// ## Version
/// This enum is available since SDL 3.2.0.
pub const VertexInputRate = enum(c_uint) {
    /// Attribute addressing is a function of the vertex index.
    vertex = C.SDL_GPU_VERTEXINPUTRATE_VERTEX,
    /// Attribute addressing is a function of the instance index.
    instance = C.SDL_GPU_VERTEXINPUTRATE_INSTANCE,
};

/// A structure specifying the parameters of a graphics pipeline vertex input state.
///
/// ## Version
/// This struct is available since SDL 3.2.0.
pub const VertexInputState = struct {
    /// Vertex buffer descriptions.
    vertex_buffer_descriptions: []const VertexBufferDescription,
    /// Vertex attribute descriptions.
    vertex_attributes: []const VertexAttribute,

    /// From an SDL value.
    pub fn fromSdl(value: C.SDL_GPUVertexInputState) VertexInputState {
        return .{
            .vertex_buffer_descriptions = @as([*]const VertexBufferDescription, @ptrCast(value.vertex_buffer_descriptions))[0..@intCast(value.num_vertex_buffers)],
            .vertex_attributes = @as([*]const VertexAttribute, @ptrCast(value.vertex_attributes))[0..@intCast(value.num_vertex_attributes)],
        };
    }

    /// Convert to an SDL value.
    pub fn toSdl(self: VertexInputState) C.SDL_GPUVertexInputState {
        return .{
            .vertex_buffer_descriptions = @ptrCast(self.vertex_buffer_descriptions.ptr),
            .num_vertex_buffers = @intCast(self.vertex_buffer_descriptions.len),
            .vertex_attributes = @ptrCast(self.vertex_attributes.ptr),
            .num_vertex_attributes = @intCast(self.vertex_attributes.len),
        };
    }
};

// Test the GPU.
test "Gpu" {
    _ = BufferBinding{
        .buffer = undefined,
        .offset = undefined,
    };
    _ = ColorComponentFlags{};
    _ = ColorTargetBlendState{
        .alpha_blend = undefined,
        .color_blend = undefined,
        .color_write_mask = undefined,
        .destination_alpha = undefined,
        .destination_color = undefined,
        .enable_blend = undefined,
        .enable_color_write_mask = undefined,
        .source_alpha = undefined,
        .source_color = undefined,
    };
    _ = ColorTargetDescription{
        .blend_state = undefined,
        .format = undefined,
    };
    _ = ColorTargetInfo{
        .clear_color = undefined,
        .cycle = undefined,
        .cycle_resolve_texture = undefined,
        .layer_or_depth_plane = undefined,
        .load = undefined,
        .mip_level = undefined,
        .resolve_layer = undefined,
        .resolve_mip_level = undefined,
        .texture = undefined,
        .store = undefined,
        .resolve_texture = undefined,
    };
    _ = IndirectDispatchCommand{
        .group_count_x = undefined,
        .group_count_y = undefined,
        .group_count_z = undefined,
    };
    _ = StorageBufferReadWriteBinding{
        .cycle = undefined,
        .buffer = undefined,
    };
    _ = StorageTextureReadWriteBinding{
        .texture = undefined,
        .mip_level = undefined,
        .layer = undefined,
        .cycle = undefined,
    };
    _ = TextureSamplerBinding{
        .texture = undefined,
        .sampler = undefined,
    };
    _ = VertexAttribute{
        .buffer_slot = undefined,
        .format = undefined,
        .location = undefined,
        .offset = undefined,
    };
    _ = VertexBufferDescription{
        .input_rate = undefined,
        .instance_step_rate = undefined,
        .pitch = undefined,
        .slot = undefined,
    };
}
