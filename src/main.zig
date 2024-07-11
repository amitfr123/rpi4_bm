const std = @import("std");
const testing = std.testing;

const MiniUart = @import("mini_uart.zig").MiniUart;

const assert = std.debug.assert;

pub fn main() void {
    MiniUart.init();
    MiniUart.writeString("hello world");
    while (true) {
        asm volatile ("nop");
    }
}

test {
    _ = @import("register.zig");
    _ = @import("gpio.zig");
    _ = @import("aux.zig");

    testing.refAllDecls(@This());
}
