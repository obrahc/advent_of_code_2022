const std = @import("std");
const aocutils = @import("utils.zig");
const fmt = std.fmt;
const ArrayList = std.ArrayList;
const Stack = std.atomic.Stack;

const allocator = std.heap.page_allocator;
const stdout = std.io.getStdOut().writer();

pub fn Buffer(comptime size: u4) type {
    return struct {
        buf: [size]u8,

        pub const Self = @This();

        pub fn init() Self {
            return Self{
                .buf = std.mem.zeroes([size]u8),
            };
        }
        
        pub fn add(self: *Self, c: u8) void {
            var i = self.buf.len - 1;
            while (i > 0) {
                self.buf[i] = self.buf[i - 1];
                i -= 1;
            }
            self.buf[0] = c;
        }

        pub fn distinct(self: *Self) bool {
            var hash_map = std.AutoHashMap(u8, void).init(allocator);
            defer hash_map.deinit();
            for (self.buf) |char| {
                if (hash_map.contains(char)) {
                    return false;
                }
                hash_map.put(char, {}) catch unreachable;
            }
            return true;
        }
    };
}
        

fn partOne(lines: []const[]const u8) usize {
    var b: Buffer(4) = Buffer(4).init();

    for (lines[0]) |c, index| {
        if (index > 3 and b.distinct()) return index;
        b.add(c);
    }
    return 0;
}

fn partTwo(lines: []const[]const u8) usize {
    var b: Buffer(14) = Buffer(14).init();

    for (lines[0]) |c, index| {
        if (index > 3 and b.distinct()) return index;
        b.add(c);
    }
    return 0;
}

fn day6(lines: []const[]const u8) [2] usize {
    var result: [2]usize = std.mem.zeroes([2]usize);

    result[0] = partOne(lines);
    result[1] = partTwo(lines);
    
    return result;
}

pub fn main() !void {
    var lines = try aocutils.ReadAOCInput(allocator, "inputs/day6.txt");
    var result = day6(lines); 

    try stdout.print("Day Six\n" , .{});
    try stdout.print("Part One: {d}\n" , .{result[0]});
    try stdout.print("Part Two: {d}\n\n" , .{result[1]});
}

test "Provided Test Input" {
    var lines = try aocutils.ReadAOCInput(allocator, "inputs/day6_test.txt");
    
    var result = day6(lines);
    try std.testing.expect(result[0] == 5);
    try std.testing.expect(result[1] == 23);
}
