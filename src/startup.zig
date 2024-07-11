const main = @import("main.zig");

// // These symbols come from the linker script
extern var __bss_start: u32;
extern var __bss_end: u32;
extern var __bss_size: u32;

export fn _start() linksection(".text.boot") callconv(.Naked) noreturn {
    // check if core id is 0 (main core)
    // block all but the main core
    // set stack to before code
    asm volatile (
        \\mrs x1, mpidr_el1
        \\and x1, x1, #3
        \\cbz x1, 2f
        \\1:
        \\wfe
        \\b 1b
        \\2:
        \\ldr     x1, =_start
        \\mov     sp, x1
        \\bl startPart2
    );
}

export fn startPart2() void {
    // clear the bss section
    for (@as([*]u8, @ptrCast(&__bss_start))[0..__bss_size]) |*b| b.* = 0;
    main.main();
    unreachable;
}
