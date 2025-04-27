const constants = @import("constants.zig");
const std = @import("std");

extern var in_color: @Vector(4, f32) addrspace(.input);
extern var out_color: @Vector(4, f32) addrspace(.output);

export fn main() callconv(.spirv_fragment) void {
    // Out color still needs to have a location be specified, but should be 0.
    std.gpu.fragmentOrigin(main, .upper_left);
    std.gpu.location(&out_color, constants.frag_out_color_loc);

    // Import the input color as the pre-selected location (must match with vertex shader).
    std.gpu.location(&in_color, constants.vert_out_color_loc);

    // Simple out = in.
    out_color = in_color;
}
