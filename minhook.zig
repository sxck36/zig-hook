const builtin = @import("builtin");
const std = @import("std");

const WINAPI: std.builtin.CallingConvention = switch (builtin.cpu.arch) {
    .x86 => .stdcall,
    else => .c,
};

pub const MH_STATUS = enum(c_int) {
    MH_UNKNOWN = -1,
    MH_OK = 0,
    MH_ERROR_ALREADY_INITIALIZED,
    MH_ERROR_NOT_INITIALIZED,
    MH_ERROR_ALREADY_CREATED,
    MH_ERROR_NOT_CREATED,
    MH_ERROR_ENABLED,
    MH_ERROR_DISABLED,
    MH_ERROR_NOT_EXECUTABLE,
    MH_ERROR_UNSUPPORTED_FUNCTION,
    MH_ERROR_MEMORY_ALLOC,
    MH_ERROR_MEMORY_PROTECT,
    MH_ERROR_MODULE_NOT_FOUND,
    MH_ERROR_FUNCTION_NOT_FOUND,
};

pub const MH_ALL_HOOKS: ?*anyopaque = null;

extern fn MH_Initialize() callconv(WINAPI) MH_STATUS;
extern fn MH_Uninitialize() callconv(WINAPI) MH_STATUS;
extern fn MH_CreateHook(pTarget: ?*anyopaque, pDetour: ?*anyopaque, ppOriginal: ?*?*anyopaque) callconv(WINAPI) MH_STATUS;
extern fn MH_CreateHookApi(pszModule: [*:0]const u16, pszProcName: [*:0]const u8, pDetour: ?*anyopaque, ppOriginal: ?*?*anyopaque) callconv(WINAPI) MH_STATUS;
extern fn MH_CreateHookApiEx(pszModule: [*:0]const u16, pszProcName: [*:0]const u8, pDetour: ?*anyopaque, ppOriginal: ?*?*anyopaque, ppTarget: ?*?*anyopaque) callconv(WINAPI) MH_STATUS;
extern fn MH_RemoveHook(pTarget: ?*anyopaque) callconv(WINAPI) MH_STATUS;
extern fn MH_EnableHook(pTarget: ?*anyopaque) callconv(WINAPI) MH_STATUS;
extern fn MH_DisableHook(pTarget: ?*anyopaque) callconv(WINAPI) MH_STATUS;
extern fn MH_QueueEnableHook(pTarget: ?*anyopaque) callconv(WINAPI) MH_STATUS;
extern fn MH_QueueDisableHook(pTarget: ?*anyopaque) callconv(WINAPI) MH_STATUS;
extern fn MH_ApplyQueued() callconv(WINAPI) MH_STATUS;

pub const initialize = MH_Initialize;
pub const uninitialize = MH_Uninitialize;
pub const createHook = MH_CreateHook;
pub const createHookApi = MH_CreateHookApi;
pub const createHookApiEx = MH_CreateHookApiEx;
pub const removeHook = MH_RemoveHook;
pub const enableHook = MH_EnableHook;
pub const disableHook = MH_DisableHook;
pub const queueEnableHook = MH_QueueEnableHook;
pub const queueDisableHook = MH_QueueDisableHook;
pub const applyQueued = MH_ApplyQueued;
