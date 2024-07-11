const std = @import("std");
const Target = std.Target;

pub fn build(b: *std.Build) void {
    const query = Target.Query{
        .os_tag = .freestanding,
        .abi = .eabihf,
        .cpu_arch = .aarch64,
        .cpu_model = .{ .explicit = &Target.aarch64.cpu.cortex_a72 },
    };
    const target = b.resolveTargetQuery(query);

    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseSafe,
    });

    const elf = b.addExecutable(.{
        .name = "kernel8.elf",
        .root_source_file = b.path("src/startup.zig"),
        .target = target,
        .optimize = optimize,
    });

    // elf.addAssemblyFile(b.path("src/boot.S"));
    elf.setLinkerScriptPath(b.path("src/link/linker.ld"));

    b.installArtifact(elf);

    const bin = elf.addObjCopy(.{ .format = .bin });
    b.getInstallStep().dependOn(&(b.addInstallBinFile(bin.getOutput(), "kernel8.img").step));

    const qemu = b.addSystemCommand(&[_][]const u8{
        "qemu-system-aarch64",
        "-M",
        "raspi4b",
        "-m",
        "2G",
        "-serial",
        "null",
        "-serial",
        "mon:stdio",
        "-nographic",
        "-kernel",
        "zig-out/bin/kernel8.elf",
        "-s",
        "-S",
    });

    qemu.step.dependOn(b.getInstallStep());
    const qrun_step = b.step("qemu_debug", "Debug the app");
    qrun_step.dependOn(&qemu.step);

    const dumpELFCommand = b.addSystemCommand(&[_][]const u8{
        "arm-none-eabi-objdump",
        "-D",
        "-m",
        "aarch64",
        "zig-out/bin/kernel8.elf",
    });
    dumpELFCommand.step.dependOn(b.getInstallStep());
    const dumpELFStep = b.step("dump-elf", "Disassemble the ELF executable");
    dumpELFStep.dependOn(&dumpELFCommand.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = b.host,
        .optimize = .Debug,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
