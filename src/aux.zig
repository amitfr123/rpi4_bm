const Register = @import("register.zig");
const Reg32 = Register.Reg32;
const FlagBit = Register.FlagBit;
const HiLoBit = Register.HiLoBit;

const AUX_BASE = Register.EFFECTIVE_PERIPHERAL_BASE + 0x215000;

pub const Regs = struct {
    const base_addr = AUX_BASE;

    pub const IrqReg = packed struct {
        mini_uart: FlagBit = .f,
        spi1: FlagBit = .f,
        spi2: FlagBit = .f,
        reserved: u29 = 0,
    };
    pub const irq_reg = Reg32.RO(IrqReg).init(base_addr + 0x0);

    const EnablesReg = packed struct {
        mini_uart: FlagBit = .f,
        spi1: FlagBit = .f,
        spi2: FlagBit = .f,
        reserved: u29 = 0,
    };
    pub const enables_reg = Reg32.RW(EnablesReg).init(base_addr + 0x4);

    pub const MiniUart = struct {
        pub const IORegR = packed struct {
            access: packed union {
                read: u8,
                baudrate_ls8: u8,
            },
            reserved: u24 = 0,
        };

        pub const IORegW = packed struct {
            access: packed union {
                write: u8,
                baudrate_ls8: u8,
            },
            reserved: u24 = 0,
        };
        pub const io_reg = Reg32.Ex(IORegR, IORegW).init(base_addr + 0x40);

        pub const IERReg = packed struct {
            access: packed union {
                ir_ctrl: packed struct {
                    transmit: FlagBit,
                    receive: FlagBit,
                },
                baudrate_ms8: u8,
            },
            reserved: u24 = 0,
        };
        pub const ier_reg = Reg32.RW(IERReg).init(base_addr + 0x44);

        pub const IIRRegR = packed struct {
            ir_pending: enum(u1) {
                pending = 0,
                clear = 1,
            } = .clear,
            ir_read: enum(u2) {
                no_ir = 0,
                transmit_ir = 1,
                receive_ir = 2,
                _,
            } = .no_ir,
            reserved1: u3 = 0,
            fifo_enables: u2 = 3,
            reserved2: u24 = 0,
        };

        pub const IIRRegW = packed struct {
            reserved1: u1 = 0,
            fifo_clr: packed struct {
                clear_receive_fifo: FlagBit = .f,
                clear_transmit_fifo: FlagBit = .f,
            },
            reserved2: u29 = 0,
        };
        pub const iir_reg = Reg32.Ex(IIRRegR, IIRRegW).init(base_addr + 0x48);

        pub const LCRReg = packed struct {
            data_size: enum(u1) {
                mode_7bit = 0,
                mode_8bit = 1,
            } = .mode_7bit,
            reserved1: u5 = 0,
            break_mode: FlagBit = .f,
            dlab_access_mode: FlagBit = .f,
            reserved2: u24 = 0,
        };
        pub const lcr_reg = Reg32.RW(LCRReg).init(base_addr + 0x4c);

        pub const MCRReg = packed struct {
            reserved1: u1 = 0,
            rts: HiLoBit = .high,
            reserved2: u30 = 0,
        };
        pub const mcr_reg = Reg32.RW(MCRReg).init(base_addr + 0x50);

        pub const LSRReg = packed struct {
            data_ready: FlagBit = .f,
            receiver_overrun: FlagBit = .f,
            reserved1: u3 = 0,
            transmitter_empty: FlagBit = .f,
            transmitter_idle: FlagBit = .t,
            reserved2: u25 = 0,
        };
        pub const lsr_reg = Reg32.RO(LSRReg).init(base_addr + 0x54);

        pub const MSRReg = packed struct {
            reserved1: u4 = 0,
            cts_status: HiLoBit = .low,
            reserved2: u30 = 0,
        };
        pub const msr_reg = Reg32.RO(MSRReg).init(base_addr + 0x58);

        pub const ScratchReg = packed struct {
            scratch: u8 = 0,
            reserved: u24 = 0,
        };
        pub const scratch_reg = Reg32.RW(ScratchReg).init(base_addr + 0x5c);

        pub const CNTLReg = packed struct {
            receiver_enable: FlagBit = .t,
            transmitter_enable: FlagBit = .t,
            enable_receive_auto_flow_ctrl_rts: FlagBit = .f,
            enable_transmit_auto_flow_ctrl_cts: FlagBit = .f,
            rts_auto_flow_level: enum(u2) {
                spaces_left_3 = 0,
                spaces_left_2 = 1,
                spaces_left_1 = 2,
                spaces_left_4 = 3,
            },
            rts_assert_level: HiLoBit = .high,
            cts_assert_level: HiLoBit = .high,
            reserved: u24 = 0,
        };
        pub const cntl_reg = Reg32.RW(CNTLReg).init(base_addr + 0x60);

        pub const StatReg = packed struct {
            symbol_avalible: FlagBit = .f,
            space_avalible: FlagBit = .f,
            receiver_idle: FlagBit = .t,
            transmiter_idle: FlagBit = .t,
            receiver_overrun: FlagBit = .f,
            transmiter_fifo_full: FlagBit = .f,
            rts_status: HiLoBit = .high,
            cts_line: HiLoBit = .high,
            transmit_fifo_empty: FlagBit = .t,
            transmit_fifo_done: FlagBit = .t,
            reserved1: u6 = 0,
            receive_fifo_fill_level: u4 = 0,
            reserved2: u4 = 0,
            transmit_fifo_fill_level: u4 = 0,
            reserved3: u4 = 0,
        };
        pub const stat_reg = Reg32.RO(StatReg).init(base_addr + 0x64);

        pub const BaudReg = packed struct {
            baudrate: u16 = 0,
            reserved: u16 = 0,
        };
        pub const baud_reg = Reg32.RW(BaudReg).init(base_addr + 0x68);
    };
};
