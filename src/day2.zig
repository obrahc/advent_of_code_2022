const std = @import("std");
const aocutils = @import("utils.zig");
const fmt = std.fmt;
const ArrayList = std.ArrayList;

const allocator = std.heap.page_allocator;
const stdout = std.io.getStdOut().writer();

fn partOne(games: [][]u8) u32 {
    var total: u32 = 0;
    for (games) |game| {
        var points: u32 = switch(hash(game)) {
            hash("A X") => 3 + 1,
            hash("A Y") => 6 + 2,
            hash("A Z") => 0 + 3,
            hash("B X") => 0 + 1,
            hash("B Y") => 3 + 2,
            hash("B Z") => 6 + 3,
            hash("C X") => 6 + 1,
            hash("C Y") => 0 + 2,
            hash("C Z") => 3 + 3,
            else => unreachable,
        };
        total += points;
    }
    return total;
}

fn partTwo(games: [][]u8) u32 {
    var total: u32 = 0;
    for (games) |game| {
        var points: u32 = switch(hash(game)) {
            hash("A X") => 0 + 3,
            hash("A Y") => 3 + 1,
            hash("A Z") => 6 + 2,
            hash("B X") => 0 + 1,
            hash("B Y") => 3 + 2,
            hash("B Z") => 6 + 3,
            hash("C X") => 0 + 2,
            hash("C Y") => 3 + 3,
            hash("C Z") => 6 + 1,
            else => unreachable,
        };
        total += points;
    }
    return total;
}

fn hash(s: []const u8) u16 {
    return (@as(u16, s[0]) * 100) + @as(u16, s[2]);
}

fn day2() !void {
    var result: [2]u32 = std.mem.zeroes([2]u32);
    
    var lines = try aocutils.ReadAOCInput(allocator, "inputs/day2.txt");
    defer lines.deinit();

    const gamesSlice = lines.toOwnedSlice();
    
    result[0] = partOne(gamesSlice);
    result[1] = partTwo(gamesSlice);
    try stdout.print("Day Two\n" , .{});
    try stdout.print("Part One: {d}\n" , .{result[0]});
    try stdout.print("Part Two: {d}\n\n" , .{result[1]});
}

pub fn main() !void {
    try day2();
}

test "Provided Test Input" {
    var result: [2]u32 = std.mem.zeroes([2]u32);
    
    var lines = try aocutils.ReadAOCInput(allocator, "inputs/day2_test.txt");
    defer lines.deinit();

    const gamesSlice = lines.toOwnedSlice();
    
    result[0] = partOne(gamesSlice);
    result[1] = partTwo(gamesSlice);
    try std.testing.expect(result[0] == 15);
    try std.testing.expect(result[1] == 12);
}