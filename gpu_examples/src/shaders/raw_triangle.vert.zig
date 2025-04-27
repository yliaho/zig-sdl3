const constants = @import("constants.zig");
const std = @import("std");

extern var vertex_index: u32 addrspace(.input);
extern var position: @Vector(4, f32) addrspace(.output);
extern var color: @Vector(4, f32) addrspace(.output);

export fn main() callconv(.spirv_vertex) void {
    // Vertex index and position are built-ins.
    std.gpu.vertexIndex(&vertex_index);
    std.gpu.position(&position);

    // Export the color to a pre-selected slot.
    std.gpu.location(&color, constants.vert_out_color_loc);

    // Since we are drawing 1 primitive triangle, the indices 0, 1, and 2 are the only vetices expected.
    switch (vertex_index) {
        0 => {
            position = .{ -1, -1, 0, 1 };
            color = .{ 1, 0, 0, 1 };
        },
        1 => {
            position = .{ 1, -1, 0, 1 };
            color = .{ 0, 1, 0, 1 };
        },
        else => {
            position = .{ 0, 1, 0, 1 };
            color = .{ 0, 0, 1, 1 };
        },
    }
}
