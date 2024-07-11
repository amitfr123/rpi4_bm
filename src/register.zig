const std = @import("std");
const assert = std.debug.assert;

pub fn Reg(comptime RawReg: type) type {
    return struct {
        pub fn Ex(comptime Read: type, comptime Write: type) type {
            return ExReg(RawReg, Read, Write);
        }

        pub fn RW(comptime T: type) type {
            return ExReg(RawReg, T, T);
        }

        pub fn RO(comptime Read: type) type {
            return ROReg(RawReg, Read);
        }

        pub fn WO(comptime Write: type) type {
            return WOReg(RawReg, Write);
        }
    };
}

pub const Reg32 = Reg(u32);
pub const Reg64 = Reg(u64);

fn WOReg(comptime RawReg: type, comptime Write: type) type {
    return struct {
        const Self = @This();

        raw_ptr: *allowzero volatile RawReg,

        pub fn init(address: usize) Self {
            return Self{ .raw_ptr = @as(*allowzero volatile RawReg, @ptrFromInt(address)) };
        }

        pub fn write(self: Self, value: Write) void {
            self.raw_ptr.* = @as(RawReg, @bitCast(value));
        }

        pub fn writeRaw(self: Self, value: RawReg) void {
            self.raw_ptr.* = value;
        }
    };
}

fn ROReg(comptime RawReg: type, comptime Read: type) type {
    return struct {
        const Self = @This();

        raw_ptr: *allowzero volatile RawReg,

        pub fn init(address: usize) Self {
            return Self{ .raw_ptr = @as(*allowzero volatile RawReg, @ptrFromInt(address)) };
        }

        pub fn read(self: Self) Read {
            return @as(Read, @bitCast(self.raw_ptr.*));
        }

        pub fn readRaw(self: Self) RawReg {
            return self.raw_ptr.*;
        }
    };
}

fn ExReg(comptime RawReg: type, comptime Read: type, comptime Write: type) type {
    comptime assert(@bitSizeOf(Read) == @bitSizeOf(Write));
    return struct {
        const Self = @This();

        raw_ptr: *allowzero volatile RawReg,

        pub fn init(address: usize) Self {
            return Self{ .raw_ptr = @as(*allowzero volatile RawReg, @ptrFromInt(address)) };
        }

        pub fn read(self: Self) Read {
            return @as(Read, @bitCast(self.raw_ptr.*));
        }

        pub fn readRaw(self: Self) RawReg {
            return self.raw_ptr.*;
        }

        pub fn write(self: Self, value: Write) void {
            self.raw_ptr.* = @as(RawReg, @bitCast(value));
        }

        pub fn writeRaw(self: Self, value: RawReg) void {
            self.raw_ptr.* = value;
        }

        /// Reads the current state and only changes the given fields.
        /// The read and write data types must be identical.
        pub fn modify(self: Self, new_value: anytype) void {
            comptime if (Read != Write) {
                @compileError("modify requires that Read an Write are the same type");
            };
            var old_value = self.read();
            const info = @typeInfo(@TypeOf(new_value));
            inline for (info.Struct.fields) |field| {
                @field(old_value, field.name) = @field(new_value, field.name);
            }
            self.write(old_value);
        }
    };
}

pub const FlagBit = enum(u1) {
    f = 0,
    t = 1,
};

pub const HiLoBit = enum(u1) {
    high = 0,
    low = 1,
};

pub const LoHiBit = enum(u1) {
    low = 0,
    high = 1,
};

pub const PERIPHERAL_BASE = 0xfc000000;
pub const EFFECTIVE_PERIPHERAL_BASE = PERIPHERAL_BASE + 0x2000000;
