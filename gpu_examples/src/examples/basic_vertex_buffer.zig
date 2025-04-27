const common = @import("../common.zig");
const sdl3 = @import("sdl3");

const vert_shader_bin = @embedFile("position_color.vert.spv");
const frag_shader_bin = @embedFile("solid_color.frag.spv");

var pipeline: sdl3.gpu.GraphicsPipeline = undefined;
var vertex_buffer: sdl3.gpu.Buffer = undefined;

const example_name = "Basic Vertex Buffer";

const PositionColorVertex = packed struct {
    position: @Vector(3, f32),
    color: @Vector(4, u8),
};

pub fn init() !common.Context {
    const ctx = try common.init(example_name, .{});

    // Create the shaders.
    const vert_shader = try common.loadShader(
        ctx.device,
        .vertex,
        vert_shader_bin,
        0,
        0,
        0,
        0,
    );
    defer ctx.device.releaseShader(vert_shader);
    const frag_shader = try common.loadShader(
        ctx.device,
        .vertex,
        frag_shader_bin,
        0,
        0,
        0,
        0,
    );
    defer ctx.device.releaseShader(frag_shader);

    // Create the pipelines. TODO: MAKE FUNCTION FOR REFLECTION!
    const pipeline_create_info = sdl3.gpu.GraphicsPipelineCreateInfo{
        .target_info = .{
            .color_target_descriptions = &.{
                .{
                    .format = ctx.device.getSwapchainTextureFormat(ctx.window),
                },
            },
        },
        .vertex_input_state = .{
            .vertex_buffer_descriptions = &.{
                .{
                    .slot = 0,
                    .input_rate = .vertex,
                    .pitch = @intCast(@sizeOf(PositionColorVertex)),
                },
            },
            .vertex_attributes = &.{
                .{
                    .buffer_slot = 0,
                    .format = .f32x3,
                    .location = 0,
                    .offset = @offsetOf(PositionColorVertex, "position"),
                },
                .{
                    .buffer_slot = 0,
                    .format = .u8x4_normalized,
                    .location = 1,
                    .offset = @offsetOf(PositionColorVertex, "color"),
                },
            },
        },
        .vertex_shader = vert_shader,
        .fragment_shader = frag_shader,
    };
    pipeline = try ctx.device.createGraphicsPipeline(pipeline_create_info);
    errdefer ctx.device.releaseGraphicsPipeline(pipeline);

    // Position-color data.
    const vertex_data = [_]PositionColorVertex{
        .{ .position = .{ -1, -1, 0 }, .color = .{ 255, 0, 0, 255 } },
        .{ .position = .{ 1, -1, 0 }, .color = .{ 0, 255, 0, 255 } },
        .{ .position = .{ 0, 1, 0 }, .color = .{ 0, 0, 255, 255 } },
    };
    const vertex_data_size: u32 = @intCast(@sizeOf(@TypeOf(vertex_data)));

    // Create the vertex buffer.
    vertex_buffer = try ctx.device.createBuffer(.{
        .usage = .{ .vertex = true },
        .size = vertex_data_size,
    });
    errdefer ctx.device.releaseBuffer(vertex_buffer);

    // Create a transfer buffer to upload the vertex data.
    const transfer_buffer = try ctx.device.createTransferBuffer(.{
        .usage = .upload,
        .size = vertex_data_size,
    });
    defer ctx.device.releaseTransferBuffer(transfer_buffer);
    const transfer_buffer_mapped = @as(*[3]PositionColorVertex, @alignCast(@ptrCast(try ctx.device.mapTransferBuffer(transfer_buffer, false))));
    transfer_buffer_mapped.* = vertex_data;
    ctx.device.unmapTransferBuffer(transfer_buffer);

    // Upload transfer data to the vertex buffer.
    const upload_cmd_buf = try ctx.device.aquireCommandBuffer();
    const copy_pass = upload_cmd_buf.beginCopyPass();
    copy_pass.uploadToBuffer(.{
        .transfer_buffer = transfer_buffer,
        .offset = 0,
    }, .{
        .buffer = vertex_buffer,
        .offset = 0,
        .size = vertex_data_size,
    }, false);
    copy_pass.end();
    try upload_cmd_buf.submit();

    sdl3.log.log("Loaded \"" ++ example_name ++ "\"");

    return ctx;
}

// Update contexts.
pub fn update(ctx: common.Context) !void {
    _ = ctx;
}

pub fn draw(ctx: common.Context) !void {

    // Get command buffer and swapchain texture.
    const cmd_buf = try ctx.device.aquireCommandBuffer();
    const swapchain_texture = try cmd_buf.waitAndAquireSwapchainTexture(ctx.window);
    if (swapchain_texture.texture) |texture| {

        // Start a render pass if the swapchain texture is available. Make sure to clear it.
        const render_pass = cmd_buf.beginRenderPass(&.{
            sdl3.gpu.ColorTargetInfo{
                .texture = texture,
                .clear_color = .{ .a = 1 },
                .load = .clear,
            },
        }, null);
        defer render_pass.end();

        // Bind the graphics pipeline we chose earlier.
        render_pass.bindGraphicsPipeline(pipeline);

        // Bind the vertex buffers then draw the primitives.
        render_pass.bindVertexBuffers(0, &.{
            .{ .buffer = vertex_buffer, .offset = 0 },
        });
        render_pass.drawPrimitives(3, 1, 0, 0);
    }

    // Finally submit the command buffer.
    try cmd_buf.submit();
}

pub fn quit(ctx: common.Context) void {
    ctx.device.releaseBuffer(vertex_buffer);
    ctx.device.releaseGraphicsPipeline(pipeline);

    common.quit(ctx);
}
