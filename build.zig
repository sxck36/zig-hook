const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("minhook", .{
        .root_source_file = b.path("minhook.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    const lib_path: []const u8 = switch (target.result.cpu.arch) {
        .x86 => "libs/libMinHook.x86.lib",
        .x86_64 => "libs/libMinHook.x64.lib",
        else => @panic("MinHook only supports x86 and x86_64"),
    };

    mod.addObjectFile(b.path(lib_path));
}
