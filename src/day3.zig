const std = @import("std");
const aocutils = @import("utils.zig");
const fmt = std.fmt;
const ArrayList = std.ArrayList;

const allocator = std.heap.page_allocator;
const stdout = std.io.getStdOut().writer();

fn isUpperCase(c: u8) bool {
    return c < '['; 
}

fn priority(c: u8) u8 {
    if (isUpperCase(c)) {
        return (c - '&');
    }
    return c - '`';
}

fn partOne(sacks: []const[]const u8) !u16 {
    var total: u16 = 0;
    var hash_map = std.AutoHashMap(u8, void).init(allocator);
    defer hash_map.deinit();
    for (sacks) |sack| {
        for (sack) |item, index| {
            if (index < sack.len / 2){
                try hash_map.put(item, {});
            } else {
                if (hash_map.contains(item)) {
                    total += priority(item); 
                    hash_map.clearRetainingCapacity();
                    continue;
                }
            }
        }
    }
    return total;
}

fn partTwo(sacks: []const[]const u8) !u16 {
    var total: u16 = 0;
    var hash_map = std.AutoHashMap(u8, void).init(allocator);
    defer hash_map.deinit();
    var colision_hash_map = std.AutoHashMap(u8, void).init(allocator);
    defer colision_hash_map.deinit();
    for (sacks) |sack, index| {
        for (sack) |item| {
            switch(index % 3) {
                0 => try hash_map.put(item, {}),
                1 => {
                    if (hash_map.contains(item)) {
                        try colision_hash_map.put(item, {});
                    }},
                2 => {
                    if (colision_hash_map.contains(item)) {
                        total += priority(item); 
                        hash_map.clearRetainingCapacity();
                        colision_hash_map.clearRetainingCapacity();
                    }},
                else => unreachable,
            }
        }
    }
    return total;
}

fn day3(lines: []const[]const u8) ![2] u16 {
    var result: [2]u16 = std.mem.zeroes([2]u16);

    result[0] = try partOne(lines);
    result[1] = try partTwo(lines);
    
    return result;
}

pub fn main() !void {
    var lines = try aocutils.ReadAOCInput(allocator, "inputs/day3.txt");
    var result = try day3(lines); 

    try stdout.print("Day Three\n" , .{});
    try stdout.print("Part One: {d}\n" , .{result[0]});
    try stdout.print("Part Two: {d}\n\n" , .{result[1]});
}

test "Provided Test Input" {
    var result: [2]u32 = std.mem.zeroes([2]u32);
    var lines = try aocutils.ReadAOCInput(allocator, "inputs/day3_test.txt");
    
    result[0] = try partOne(lines);
    result[1] = try partTwo(lines);
    try std.testing.expect(result[0] == 157);
    try std.testing.expect(result[1] == 70);
}

test "Calculate Priorities" {
    try std.testing.expect(priority('A') == 27);
    try std.testing.expect(priority('Z') == 52);
    try std.testing.expect(priority('a') == 1);
    try std.testing.expect(priority('z') == 26);
}

test "Is Upper Case" {
    try std.testing.expect(isUpperCase('A'));
    try std.testing.expect(isUpperCase('Z'));
    try std.testing.expect(!isUpperCase('a'));
    try std.testing.expect(!isUpperCase('z'));
}