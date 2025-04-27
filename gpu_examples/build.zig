const std = @import("std");

fn compileShader(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    module: *std.Build.Module,
    path: []const u8,
    out_name: []const u8,
) void {
    const shader = b.addObject(.{
        .name = out_name,
        .root_source_file = b.path(path),
        .target = target,
        .optimize = .ReleaseFast,
        .use_llvm = false,
        .use_lld = false,
    });
    module.addAnonymousImport(out_name, .{
        .root_source_file = shader.getEmittedBin(),
    });
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const vulkan12_target = b.resolveTargetQuery(.{
        .cpu_arch = .spirv64,
        .cpu_model = .{ .explicit = &std.Target.spirv.cpu.vulkan_v1_2 },
        .cpu_features_add = std.Target.spirv.featureSet(&.{.int64}),
        .os_tag = .vulkan,
        .ofmt = .spirv,
    });

    const exe = b.addExecutable(.{
        .name = "gpu-examples",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    // const shader_path = b.path("src/shaders");
    // TODO: HAVE THIS BE DONE AUTOMATICALLY!!!
    compileShader(b, vulkan12_target, exe.root_module, "src/shaders/raw_triangle.vert.zig", "raw_triangle.vert.spv");
    compileShader(b, vulkan12_target, exe.root_module, "src/shaders/solid_color.frag.zig", "solid_color.frag.spv");

    const sdl3 = b.dependency("sdl3", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("sdl3", sdl3.module("sdl3"));
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
