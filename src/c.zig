pub const C = @cImport({
    @cInclude("SDL3/SDL.h");
    @cInclude("SDL3/SDL_main.h");
    @cInclude("SDL3/SDL_vulkan.h");
    // @cInclude("SDL3_image/SDL_image.h");
});
