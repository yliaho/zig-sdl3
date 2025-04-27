const sdl3 = @import("sdl3");

pub const Context = struct {
    device: sdl3.gpu.Device,
    window: sdl3.video.Window,
    delta_time: f32 = 0,
    left_pressed: bool = false,
    right_pressed: bool = false,
    down_pressed: bool = false,
};

pub fn init(example_name: [:0]const u8, window_flags: sdl3.video.WindowFlags) !Context {

    // Get our GPU device that supports SPIR-V.
    const device = try sdl3.gpu.Device.init(.{ .spirv = true }, false, null);
    errdefer device.deinit();

    // Make our demo window.
    const window = try sdl3.video.Window.init(example_name, 640, 480, window_flags);
    errdefer window.deinit();

    // Generate swapchain for window.
    try device.claimWindow(window);
    return .{
        .device = device,
        .window = window,
    };
}

pub fn quit(ctx: Context) void {
    ctx.device.releaseWindow(ctx.window);
    ctx.window.deinit();
    ctx.device.deinit();
}

pub fn loadShader(
    device: sdl3.gpu.Device,
    stage: sdl3.gpu.ShaderStage,
    code: []const u8,
    sampler_count: u32,
    uniform_buffer_count: u32,
    storage_buffer_count: u32,
    storage_texture_count: u32,
) !sdl3.gpu.Shader {
    return device.createShader(.{
        .code = code,
        .entry_point = "main",
        .format = .{ .spirv = true },
        .stage = stage,
        .num_samplers = sampler_count,
        .num_uniform_buffers = uniform_buffer_count,
        .num_storage_buffers = storage_buffer_count,
        .num_storage_textures = storage_texture_count,
        .props = null,
    });
}
