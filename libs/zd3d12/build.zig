const std = @import("std");

pub const BuildOptions = struct {
    enable_debug_layer: bool = false,
    enable_gbv: bool = false,
    enable_d2d: bool = false,
};

pub const BuildOptionsStep = struct {
    options: BuildOptions,
    step: *std.build.OptionsStep,

    pub fn init(b: *std.build.Builder, options: BuildOptions) BuildOptionsStep {
        const bos = .{
            .options = options,
            .step = b.addOptions(),
        };
        bos.step.addOption(bool, "enable_debug_layer", bos.options.enable_debug_layer);
        bos.step.addOption(bool, "enable_gbv", bos.options.enable_gbv);
        bos.step.addOption(bool, "enable_d2d", bos.options.enable_d2d);
        return bos;
    }

    pub fn getPkg(bos: BuildOptionsStep) std.build.Pkg {
        return bos.step.getPackage("zd3d12_options");
    }

    fn addTo(bos: BuildOptionsStep, target_step: *std.build.LibExeObjStep) void {
        target_step.addOptions("zd3d12_options", bos.step);
    }
};

pub fn getPkg(dependencies: []const std.build.Pkg) std.build.Pkg {
    return .{
        .name = "zd3d12",
        .source = .{ .path = thisDir() ++ "/src/zd3d12.zig" },
        .dependencies = dependencies,
    };
}

pub fn build(_: *std.build.Builder) void {}

pub fn link(exe: *std.build.LibExeObjStep, bos: BuildOptionsStep) void {
    bos.addTo(exe);

    exe.step.dependOn(
        &exe.builder.addInstallFile(
            .{ .path = thisDir() ++ "/../zwin32/bin/x64/D3D12Core.dll" },
            "bin/d3d12/D3D12Core.dll",
        ).step,
    );
    exe.step.dependOn(
        &exe.builder.addInstallFile(
            .{ .path = thisDir() ++ "/../zwin32/bin/x64/D3D12Core.pdb" },
            "bin/d3d12/D3D12Core.pdb",
        ).step,
    );
    exe.step.dependOn(
        &exe.builder.addInstallFile(
            .{ .path = thisDir() ++ "/../zwin32/bin/x64/D3D12SDKLayers.dll" },
            "bin/d3d12/D3D12SDKLayers.dll",
        ).step,
    );
    exe.step.dependOn(
        &exe.builder.addInstallFile(
            .{ .path = thisDir() ++ "/../zwin32/bin/x64/D3D12SDKLayers.pdb" },
            "bin/d3d12/D3D12SDKLayers.pdb",
        ).step,
    );
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}
