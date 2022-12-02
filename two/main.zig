const std = @import("std");
const fmt = std.fmt;
const ArrayList = std.ArrayList;

const allocator = std.heap.page_allocator;
const stdout = std.io.getStdOut().writer();

const Choice = enum (u2) { rock, paper, scissor };

fn calculateResultFromMoves(advmove: u8, move: u8) u32 {
        var result: i8 = @intCast(i8, advmove) - @intCast(i8, move);
        var p: u32 = switch(result) {
            -22, -25 => 0,
            -21, -24 => 6,
            -23 => 3,
            else => unreachable,
        };

        return p;
}

fn calculatePointsForMove(move: u8) u32 {
    var movePoints: u32 = switch(move) {
        65, 88 => 1,
        66, 89 => 2,
        67, 90 => 3,
        else => unreachable,
    };
    return movePoints;
}

fn calculateMoveFromResult(result: u32, advmove: u8) u8 {
    var move: u8 = switch(result) {
        0 => calculateMove(advmove, false),
        3 => advmove,
        6 => calculateMove(advmove, true),
        else => unreachable,
    };
    return move;
}

fn calculateMove(advmove: u8, winning: bool) u8 {
    const move: u8 = switch(advmove) {
        65 => if (winning) 89  else 90,
        66 => if (winning) 90  else 88,
        67 => if (winning) 88  else 89,
        else => unreachable,
    };
    return move;
}

fn calculateResultFromLetter(l: u8) u32 {
    const result: u32 = switch(l) {
        88 => 0,
        89 => 3,
        90 => 6,
        else => unreachable,
    };
    return result;
}

fn partOne(games: [][2]u8) u32 {
    var total: u32 = 0;
    for (games) |game| {
        total += calculateResultFromMoves(game[0], game[1]);
        total += calculatePointsForMove(game[1]);
    }
    return total;
}

fn partTwo(games: [][2]u8) u32 {
    var total: u32 = 0;
    for (games) |game| {
        var result: u32 = calculateResultFromLetter(game[1]);

        total += result;
        total += calculatePointsForMove(calculateMoveFromResult(result, game[0]));
    }
    return total;
}

fn common(lines: ArrayList([]u8)) ![2]u32 {
    var result: [2]u32 = std.mem.zeroes([2]u32);
    var games = ArrayList([2]u8).init(allocator);
    defer games.deinit();

    for (lines.items) |line| {
        try games.append([2]u8{line[0], line[2]});
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