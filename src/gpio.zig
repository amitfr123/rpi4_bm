const Register = @import("register.zig");

const FlagBit = Register.FlagBit;
const HiLoBit = Register.HiLoBit;
const LoHiBit = Register.LoHiBit;
const Reg32 = Register.Reg32;

const GPIO_BASE = Register.EFFECTIVE_PERIPHERAL_BASE + 0x200000;

pub const Regs = struct {
    const base_addr = GPIO_BASE;

    pub const FunctionSelect = enum(u3) {
        input = 0,
        output = 1,
        alt5 = 2,
        alt4 = 3,
        alt0 = 4,
        alt1 = 5,
        alt2 = 6,
        alt3 = 7,
    };

    // arrays in packed structs doesn't work bummer
    pub const FunctionSelectReg = packed struct {
        offset0: FunctionSelect = .input,
        offset1: FunctionSelect = .input,
        offset2: FunctionSelect = .input,
        offset3: FunctionSelect = .input,
        offset4: FunctionSelect = .input,
        offset5: FunctionSelect = .input,
        offset6: FunctionSelect = .input,
        offset7: FunctionSelect = .input,
        offset8: FunctionSelect = .input,
        offset9: FunctionSelect = .input,
        reserved: u2 = 0,
    };

    pub const FunctionSelectRegBank = struct {
        reg0: Reg32.RW(FunctionSelectReg),
        reg1: Reg32.RW(FunctionSelectReg),
        reg2: Reg32.RW(FunctionSelectReg),
        reg3: Reg32.RW(FunctionSelectReg),
        reg4: Reg32.RW(FunctionSelectReg),
        reg5: Reg32.RW(FunctionSelectReg),
    };

    pub const FSELRegBank = FunctionSelectRegBank{
        .reg0 = Reg32.RW(FunctionSelectReg).init(base_addr + 0x0),
        .reg1 = Reg32.RW(FunctionSelectReg).init(base_addr + 0x4),
        .reg2 = Reg32.RW(FunctionSelectReg).init(base_addr + 0x8),
        .reg3 = Reg32.RW(FunctionSelectReg).init(base_addr + 0xc),
        .reg4 = Reg32.RW(FunctionSelectReg).init(base_addr + 0x10),
        .reg5 = Reg32.RW(FunctionSelectReg).init(base_addr + 0x14),
    };

    // Pin ctl helper functions
    fn PinCtlTwinReg(comptime PinType: type, default: anytype) type {
        return struct {
            pub const P1 = packed struct {
                p0: PinType = default,
                p1: PinType = default,
                p2: PinType = default,
                p3: PinType = default,
                p4: PinType = default,
                p5: PinType = default,
                p6: PinType = default,
                p7: PinType = default,
                p8: PinType = default,
                p9: PinType = default,
                p10: PinType = default,
                p11: PinType = default,
                p12: PinType = default,
                p13: PinType = default,
                p14: PinType = default,
                p15: PinType = default,
                p16: PinType = default,
                p17: PinType = default,
                p18: PinType = default,
                p19: PinType = default,
                p20: PinType = default,
                p21: PinType = default,
                p22: PinType = default,
                p23: PinType = default,
                p24: PinType = default,
                p25: PinType = default,
                p26: PinType = default,
                p27: PinType = default,
                p28: PinType = default,
                p29: PinType = default,
                p30: PinType = default,
                p31: PinType = default,
            };
            pub const P2 = packed struct {
                p32: PinType = default,
                p33: PinType = default,
                p34: PinType = default,
                p35: PinType = default,
                p36: PinType = default,
                p37: PinType = default,
                p38: PinType = default,
                p39: PinType = default,
                p40: PinType = default,
                p41: PinType = default,
                p42: PinType = default,
                p43: PinType = default,
                p44: PinType = default,
                p45: PinType = default,
                p46: PinType = default,
                p47: PinType = default,
                p48: PinType = default,
                p49: PinType = default,
                p50: PinType = default,
                p51: PinType = default,
                p52: PinType = default,
                p53: PinType = default,
                p54: PinType = default,
                p55: PinType = default,
                p56: PinType = default,
                p57: PinType = default,
                reserved: u6,
            };
        };
    }

    fn PinCtlTwinBank(comptime Type: type) type {
        return struct {
            pub const P1 = Reg32.RW(Type.P1);
            pub const P2 = Reg32.RW(Type.P2);
            p1: P1,
            p2: P2,
        };
    }

    fn PinCtlTwinBankInit(comptime Type: type, base_offset: usize) PinCtlTwinBank(Type) {
        const t = PinCtlTwinBank(Type);
        return t{
            .p1 = t.P1.init(base_addr + base_offset),
            .p2 = t.P2.init(base_addr + base_offset + 0x4),
        };
    }

    const CommonPCTFlagBit = PinCtlTwinReg(FlagBit, .f);
    pub const SetRegBank = CommonPCTFlagBit;
    pub const set_reg_bank = PinCtlTwinBankInit(SetRegBank, 0x1c);

    pub const CLRRegBank = CommonPCTFlagBit;
    pub const clr_reg_bank = PinCtlTwinBankInit(CLRRegBank, 0x28);

    pub const LEVRegBank = PinCtlTwinReg(LoHiBit, .low);
    pub const lev_reg_bank = PinCtlTwinBankInit(LEVRegBank, 0x34);

    pub const EDSRegBank = CommonPCTFlagBit;
    pub const eds_reg_bank = PinCtlTwinBankInit(EDSRegBank, 0x40);

    pub const RENRegBank = CommonPCTFlagBit;
    pub const ren_reg_bank = PinCtlTwinBankInit(RENRegBank, 0x4c);

    pub const FENRegBank = CommonPCTFlagBit;
    pub const fen_reg_bank = PinCtlTwinBankInit(FENRegBank, 0x58);

    pub const HENRegBank = CommonPCTFlagBit;
    pub const hen_reg_bank = PinCtlTwinBankInit(HENRegBank, 0x64);

    pub const LENRegBank = CommonPCTFlagBit;
    pub const len_reg_bank = PinCtlTwinBankInit(LENRegBank, 0x70);

    pub const ARENRegBank = CommonPCTFlagBit;
    pub const aren_reg_bank = PinCtlTwinBankInit(ARENRegBank, 0x7c);

    pub const AFENRegBank = CommonPCTFlagBit;
    pub const afen_reg_bank = PinCtlTwinBankInit(AFENRegBank, 0x88);

    pub const ResistorSelect = enum(u2) {
        no_resistor = 0,
        pull_up_resistor = 1,
        pull_down_resistor = 2,
        _,
    };

    pub const ResistorSelectReg0 = packed struct {
        ctrl0: ResistorSelect = .pull_up_resistor,
        ctrl1: ResistorSelect = .pull_up_resistor,
        ctrl2: ResistorSelect = .pull_up_resistor,
        ctrl3: ResistorSelect = .pull_up_resistor,
        ctrl4: ResistorSelect = .pull_up_resistor,
        ctrl5: ResistorSelect = .pull_up_resistor,
        ctrl6: ResistorSelect = .pull_up_resistor,
        ctrl7: ResistorSelect = .pull_up_resistor,
        ctrl8: ResistorSelect = .pull_up_resistor,
        ctrl9: ResistorSelect = .pull_down_resistor,
        ctrl10: ResistorSelect = .pull_down_resistor,
        ctrl11: ResistorSelect = .pull_down_resistor,
        ctrl12: ResistorSelect = .pull_down_resistor,
        ctrl13: ResistorSelect = .pull_down_resistor,
        ctrl14: ResistorSelect = .pull_down_resistor,
        ctrl15: ResistorSelect = .pull_down_resistor,
    };
    pub const ResistorSelectReg1 = packed struct {
        ctrl16: ResistorSelect = .pull_down_resistor,
        ctrl17: ResistorSelect = .pull_down_resistor,
        ctrl18: ResistorSelect = .pull_down_resistor,
        ctrl19: ResistorSelect = .pull_down_resistor,
        ctrl20: ResistorSelect = .pull_down_resistor,
        ctrl21: ResistorSelect = .pull_down_resistor,
        ctrl22: ResistorSelect = .pull_down_resistor,
        ctrl23: ResistorSelect = .pull_down_resistor,
        ctrl24: ResistorSelect = .pull_down_resistor,
        ctrl25: ResistorSelect = .pull_down_resistor,
        ctrl26: ResistorSelect = .pull_down_resistor,
        ctrl27: ResistorSelect = .pull_down_resistor,
        ctrl28: ResistorSelect = .no_resistor,
        ctrl29: ResistorSelect = .no_resistor,
        ctrl30: ResistorSelect = .pull_down_resistor,
        ctrl31: ResistorSelect = .pull_down_resistor,
    };
    pub const ResistorSelectReg2 = packed struct {
        ctrl32: ResistorSelect = .pull_down_resistor,
        ctrl33: ResistorSelect = .pull_down_resistor,
        ctrl34: ResistorSelect = .pull_up_resistor,
        ctrl35: ResistorSelect = .pull_up_resistor,
        ctrl36: ResistorSelect = .pull_up_resistor,
        ctrl37: ResistorSelect = .pull_down_resistor,
        ctrl38: ResistorSelect = .pull_down_resistor,
        ctrl39: ResistorSelect = .pull_down_resistor,
        ctrl40: ResistorSelect = .pull_down_resistor,
        ctrl41: ResistorSelect = .pull_down_resistor,
        ctrl42: ResistorSelect = .pull_down_resistor,
        ctrl43: ResistorSelect = .pull_down_resistor,
        ctrl44: ResistorSelect = .no_resistor,
        ctrl45: ResistorSelect = .no_resistor,
        ctrl46: ResistorSelect = .pull_up_resistor,
        ctrl47: ResistorSelect = .pull_up_resistor,
    };
    pub const ResistorSelectReg3 = packed struct {
        ctrl48: ResistorSelect = .pull_up_resistor,
        ctrl49: ResistorSelect = .pull_up_resistor,
        ctrl50: ResistorSelect = .pull_up_resistor,
        ctrl51: ResistorSelect = .pull_up_resistor,
        ctrl52: ResistorSelect = .pull_up_resistor,
        ctrl53: ResistorSelect = .pull_up_resistor,
        ctrl54: ResistorSelect = .pull_up_resistor,
        ctrl55: ResistorSelect = .pull_up_resistor,
        ctrl56: ResistorSelect = .pull_up_resistor,
        ctrl57: ResistorSelect = .pull_up_resistor,
        reserved: u12 = 0,
    };
    pub const RSRegBank = struct {
        reg0: Reg32.RW(ResistorSelectReg0),
        reg1: Reg32.RW(ResistorSelectReg1),
        reg2: Reg32.RW(ResistorSelectReg2),
        reg3: Reg32.RW(ResistorSelectReg3),
    };
    pub const ResistorSelectRegBank = RSRegBank{
        .reg0 = Reg32.RW(ResistorSelectReg0).init(base_addr + 0xe4),
        .reg1 = Reg32.RW(ResistorSelectReg1).init(base_addr + 0xe8),
        .reg2 = Reg32.RW(ResistorSelectReg2).init(base_addr + 0xec),
        .reg3 = Reg32.RW(ResistorSelectReg3).init(base_addr + 0xf0),
    };
};
