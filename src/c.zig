pub const C = @cImport({
    @cInclude("SDL3/SDL.h");
    @cInclude("SDL3/SDL_main.h");
    @cInclude("SDL3/SDL_vulkan.h");
    const ext_image = @import("extension_options").image; // Optional include.
    if (ext_image) {
        @cInclude("SDL3_image/SDL_image.h");
    }
});
