/// Location to use for vertex color outputs.
pub const vert_out_color_loc: u32 = 0;

// Note that vertex output locations and fragment output locations are allowed to overlap because they are different address spaces.
// Any vertex output location works as a fragment input location.

/// The fragment output color location should just be 0.
/// I don't know why, it's just expected to be at 0.
pub const frag_out_color_loc: u32 = 0;
