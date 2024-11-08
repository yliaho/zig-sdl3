# zig-sdl3

A lightweight wrapper to zig-ify SDL3.

Note: This is not production ready and currently in development!
I'm hoping to be done soon, great progress has been made so far!
See the [checklist](checklist.md) for more details on progress.

## About

This library aims to unite the power of SDL3 with general zigisms to feel right at home alongside the zig standard library.
SDL3 is compatible with many different platforms, making it the perfect library to pair with zig.
Some advantages of SDL3 include windowing, audio, gamepad, keyboard, mouse, rendering, and GPU abstractions across all supported platforms.

## Structure

### Binding Generator

A custom wrapper generator program is used to create the wrapper for SDL3.
The source for this program is located in `generate.zig`, and the information used to generate the wrapper is in the `bindings` folder.
Note that certain subsystems are too complex to automatically generate bindings for (such as `rect` or `iostream`), and so the handwritten code to them is located in `bindings/files`.
Bindings can be generated using `zig build bindings`. This will update the `src` directory to be up to date with the latest bindings.

### Examples

The `examples` directory has some example programs utilizing SDL3.
All examples may be built with `zig build examples`, or a single example can be ran with `zig build run -Dexample=<example name>`.

### Template

The `template` directory contains a sample hello world to get started using SDL3.
Simply copy this folder to use as your project, and have fun!

Note that this assumes you already have SDL3 installed and ready to link with for your target platform.
In the future, we may look into bundling SDL3 and building it with this library to have full control.
Doing so can also help potentially decouple parts of SDL3 from libc.

### Tests
Tests are embedded directly into the YAML files to be put in their destination subsystem.
Tests for the library can be ran by running `zig build test`.

## Features

* SDL subsystems are divided into convenient namespaces.
* C namespace exporting raw SDL functions in case it is ever needed.
* Standard `init` and `deinit` functions for creating and destroying resources.
* Skirts around C compat weirdness (C pointers, anyopaque, C types).
* Naming and conventions are more consistent with zig.
* Functions return values rather than write to pointers.
* Types that are intended to be nullable are now clearly annotated as such with optionals.
* Callbacks with generics rather than anyopaque.
* Easy conversion to/from SDL types from the wrapped types.
* The `self.function()` notation is used where applicable.
* Functions that can fail have the return wrapped with an error type.

## Hello World

```zig
const std = @import("std");
const sdl3 = @import("sdl3");

const SCREEN_WIDTH = 640;
const SCREEN_HEIGHT = 480;

pub fn main() !void {
    defer sdl3.init.shutdown();

    const init_flags = sdl3.init.Flags{ .video = true };
    try sdl3.init.init(init_flags);
    defer sdl3.init.quit(init_flags);

    const window = try sdl3.video.Window.init("Hello SDL3", SCREEN_WIDTH, SCREEN_HEIGHT, .{});
    defer window.deinit();

    const surface = try window.getSurface();
    try surface.fillRect(null, surface.mapRgb(128, 30, 255));
    try window.updateSurface();

    sdl3.timer.delayMilliseconds(5000);
}
```
