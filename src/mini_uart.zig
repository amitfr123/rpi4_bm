const Aux = @import("aux.zig");
const Gpio = @import("gpio.zig");

const ARegs = Aux.Regs;
const MuRegs = ARegs.MiniUart;
const GRegs = Gpio.Regs;

// TODO: uses queues
// TODO: add handling for incomming data
// TODO: control flow
pub const MiniUart = struct {
    // TODO: set uart and core clock using mbox and move this definition
    const core_freq = 500000000;

    fn BaudrateCalc(baud: usize) usize {
        return ((core_freq / (baud * 8)) - 1);
    }

    const baudrate = BaudrateCalc(115200);

    pub fn init() void {
        ARegs.enables_reg.modify(.{ .mini_uart = .f });
        ARegs.enables_reg.modify(.{ .mini_uart = .t });
        MuRegs.ier_reg.writeRaw(0); // disable irq
        MuRegs.cntl_reg.writeRaw(0); // disable all uart activity
        MuRegs.iir_reg.write(MuRegs.IIRRegW{
            .fifo_clr = .{
                .clear_receive_fifo = .t,
                .clear_transmit_fifo = .t,
            },
        }); // clear fifos
        MuRegs.lcr_reg.modify(.{ .data_size = .mode_8bit }); // set to 8bit mode
        MuRegs.baud_reg.modify(.{ .baudrate = baudrate });
        GRegs.ResistorSelectRegBank.reg0.modify(.{ .ctrl14 = .no_resistor });
        GRegs.FSELRegBank.reg1.modify(.{ .offset4 = .alt5 });
        MuRegs.cntl_reg.modify(.{
            .transmitter_enable = .t,
        }); // enable the relevent activity
    }

    pub fn write(c: u8) void {
        // TODO: optimize?
        while (MuRegs.lsr_reg.read().transmitter_empty != .t) {
            asm volatile ("nop");
        }
        MuRegs.io_reg.write(MuRegs.IORegW{ .access = .{ .write = c } });
    }

    pub fn writeString(str: []const u8) void {
        for (str) |c| {
            if (c == '\r') {
                write('\n');
            }
            write(c);
        }
        // zig strings dont have null termination
        write('\x00');
    }
};
