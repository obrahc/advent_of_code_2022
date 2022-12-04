const std = @import("std");
const aocutils = @import("utils.zig");
const fmt = std.fmt;
const ArrayList = std.ArrayList;

const allocator = std.heap.page_allocator;

fn partOne(pairs: []const[4]u8) !u16 {
    var total: u16 = 0;
    for (pairs) |pair| {
        if ((pair[0] <= pair[2] and pair[1] >= pair[3]) 
            or (pair[2] <= pair[0] and pair[3] >= pair[1])) {
            total += 1;
        }
    }
    return total;
}

fn partTwo(pairs: []const[4]u8) !u16 {
    var total: u16 = 0;
    for (pairs) |pair| {
        if ((pair[1] >= pair[2] and pair[1] <= pair[3]) 
            or (pair[3] >= pair[0] and pair[3] <= pair[1])) {
            total += 1;
        }
    }
    return total;
}

fn day4(lines: []const[]const u8) ![2] u16 {
    var result: [2]u16 = std.mem.zeroes([2]u16);
    var assignments = ArrayList([4]u8).init(allocator);
    defer assignments.deinit();
    
    for (lines) |line| {
        var pairs: [4]u8 = std.mem.zeroes([4]u8);
        var index: u4 = 0;
        var pair_tokens = std.mem.split(u8, line, ",");
        while (pair_tokens.next()) |elf| {
            var elf_assignment = std.mem.split(u8, elf, "-");
            while (elf_assignment.next()) |boundary| {
                const boundary_int = fmt.parseUnsigned(u8, boundary, 10) catch unreachable;
                pairs[index] = boundary_int;
                index += 1;
            } 
        }
        try assignments.append(pairs);
    }

    var pairSlice = assignments.toOwnedSlice();
    
    result[0] = try partOne(pairSlice);
    result[1] = try partTwo(pairSlice);
    
    return result;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var lines = try aocutils.ReadAOCInput(allocator, "inputs/day4.txt");
    var result = try day4(lines); 

    try stdout.print("Day Three\n" , .{});
    try stdout.print("Part One: {d}\n" , .{result[0]});
    try stdout.print("Part Two: {d}\n\n" , .{result[1]});
}

test "Provided Test Input" {
    var lines = try aocutils.ReadAOCInput(allocator, "inputs/day4_test.txt");
    
    var result = try day4(lines);
    try std.testing.expect(result[0] == 2);
    try std.testing.expect(result[1] == 4);
}
