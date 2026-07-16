# zig-hook

A thin Zig wrapper around [MinHook](https://github.com/TsudaKageyu/minhook) for runtime function hooking on Windows.

## Requirements

- **Zig** `0.16.0` or newer
- **MSVC ABI** (Windows only)
- Prebuilt MinHook libraries are bundled with this repo

## Installation

Fetch the package and save it to your `build.zig.zon`:

```sh
zig fetch --save git+https://github.com/sxck36/zig-hook
```

Then wire it up in your `build.zig`:

```zig
const zighook = b.dependency("zighook", .{
    .target = target,
    .optimize = optimize,
});
mod.addImport("zighook", zighook.module("zighook"));
```

## Usage

Below is a complete example that hooks `kernel32!Sleep`, logs the requested delay, calls the original, then uninstalls the hook cleanly.

```zig
const std = @import("std");
const win = @import("win32").everything;
const zh = @import("zighook");

var sleep_o: *const fn (u32) callconv(.c) void = undefined;

fn detourSleep(ms: u32) callconv(.c) void {
    std.log.info("sleep hooked: {}ms", .{ms});
    sleep_o(ms);
}

pub fn main() !void {
    var status = zh.initialize();
    if (status != .MH_OK) {
        std.log.err("zh.initialize failed: {}", .{status});
        return;
    }

    const target: ?*anyopaque = @ptrCast(@constCast(&win.Sleep));
    var original: ?*anyopaque = null;

    status = zh.createHook(target, @ptrCast(@constCast(&detourSleep)), &original);
    if (status != .MH_OK) {
        std.log.err("zh.createHook failed: {}", .{status});
        return;
    }
    sleep_o = @ptrCast(original.?);

    status = zh.enableHook(target);
    if (status != .MH_OK) {
        std.log.err("zh.enableHook failed: {}", .{status});
        return;
    }

    std.log.info("hook installed", .{});
    win.Sleep(1000);

    status = zh.disableHook(target);
    if (status != .MH_OK) {
        std.log.err("zh.disableHook failed: {}", .{status});
        return;
    }

    status = zh.removeHook(target);
    if (status != .MH_OK) {
        std.log.err("zh.removeHook failed: {}", .{status});
        return;
    }
    std.log.info("hook removed", .{});

    status = zh.uninitialize();
    if (status != .MH_OK) {
        std.log.err("zh.uninitialize failed: {}", .{status});
        return;
    }
}
```

## Credits

The MinHook library is © Tsuda Kageyu and is distributed under the BSD 2-Clause License. See [MinHook's LICENSE.txt](https://github.com/TsudaKageyu/minhook/blob/master/LICENSE.txt) for the full text. This repository bundles prebuilt MinHook binaries for convenience and does not modify the upstream source.

## License

See the `LICENSE` file in this repository for the license covering the zighook wrapper code. MinHook retains its own BSD-2-Clause license as linked above.
