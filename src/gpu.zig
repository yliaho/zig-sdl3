// This file was generated using `zig build bindings`. Do not manually edit!

const C = @import("c.zig").C;
const std = @import("std");

/// The GPU context.
pub const Device = struct {
	value: *C.SDL_GPUDevice,
};

/// Used for vertices, indices, indirect draw commands, and general compute data.
pub const Buffer = struct {
	value: *C.SDL_GPUBuffer,
};

/// Used for transferring data to and from the device.
pub const TransferBuffer = struct {
	value: *C.SDL_GPUTransferBuffer,
};
