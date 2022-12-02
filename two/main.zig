const std = @import("std");
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

fn common(lines: ArrayList([]u8)) ![2]u32 {
    var result: [2]u32 = std.mem.zeroes([2]u32);
    var games = ArrayList([]u8).init(allocator);
    defer games.deinit();

    for (lines.items) |line| {
        try games.append(line);
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