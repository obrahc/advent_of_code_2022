const std = @import("std");
const fmt = std.fmt;
const ArrayList = std.ArrayList;

const allocator = std.heap.page_allocator;
const stdout = std.io.getStdOut().writer();

fn partOne(games: []u16) u32 {
    var total: u32 = 0;
    for (games) |game| {
        var points: u32 = switch(game) {
            6588 => 3 + 1,
            6589 => 6 + 2,
            6590 => 0 + 3,
            6688 => 0 + 1,
            6689 => 3 + 2,
            6690 => 6 + 3,
            6788 => 6 + 1,
            6789 => 0 + 2,
            6790 => 3 + 3,
            else => unreachable,
        };
        total += points;
    }
    return total;
}

fn partTwo(games: []u16) u32 {
    var total: u32 = 0;
    for (games) |game| {
        var points: u32 = switch(game) {
            6588 => 0 + 3,
            6589 => 3 + 1,
            6590 => 6 + 2,
            6688 => 0 + 1,
            6689 => 3 + 2,
            6690 => 6 + 3,
            6788 => 0 + 2,
            6789 => 3 + 3,
            6790 => 6 + 1,
            else => unreachable,
        };
        total += points;
    }
    return total;
}

fn simpleHash(line: []u8) u16 {
    return (@as(u16, line[0]) * 100) + @as(u16, line[2]);
}

fn common(lines: ArrayList([]u8)) ![2]u32 {
    var result: [2]u32 = std.mem.zeroes([2]u32);
    var games = ArrayList(u16).init(allocator);
    defer games.deinit();

    for (lines.items) |line| {
        try games.append(simpleHash(line));
    }

    const gamesSlice = games.toOwnedSlice();
    
    result[0] = partOne(gamesSlice);
    result[1] = partTwo(gamesSlice);
    return result;
}

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    
    var lines = ArrayList([]u8).init(allocator);
    defer lines.deinit();

    while (try in_stream.readUntilDelimiterOrEofAlloc(allocator, '\n', 20)) |line|{
        try lines.append(line);
    }

    var result: [2]u32 = try common(lines);
    try stdout.print("Part One: {d}\n" , .{result[0]});
    try stdout.print("Part Two: {d}\n" , .{result[1]});
}

test "Provided Test Input" {
    var file = try std.fs.cwd().openFile("test_input/test1.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    
    var lines = ArrayList([]u8).init(allocator);
    defer lines.deinit();

    while (try in_stream.readUntilDelimiterOrEofAlloc(allocator, '\n', 20)) |line|{
        try lines.append(line);
    }

    var result = try common(lines);
    try std.testing.expect(result[0] == 15);
    try std.testing.expect(result[1] == 12);
}