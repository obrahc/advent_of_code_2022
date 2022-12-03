const std = @import("std");
const fmt = std.fmt;
const ArrayList = std.ArrayList;

const allocator = std.heap.page_allocator;
const stdout = std.io.getStdOut().writer();

fn isUpperCase(c: u8) bool {
    return c < '['; 
}

fn computeCharPriority(c: u8) u32 {
    if (isUpperCase(c)) {
        return (c - '&');
    }
    return c - '`';
}

fn partOne(games: [][]u8) !u32 {
    var total: u32 = 0;
    var hash_map = std.AutoHashMap(u8, void).init(allocator);
    for (games) |game| {
        for (game) |item, index| {
            if (index < game.len / 2){
                try hash_map.put(item, {});
            } else {
                if (hash_map.contains(item)) {
                    total += computeCharPriority(item); 
                    hash_map.clearRetainingCapacity();
                    continue;
                }
            }
        }
    }
    return total;
}

fn partTwo(games: [][]u8) !u32 {
    var total: u32 = 0;
    var hash_map = std.AutoHashMap(u8, void).init(allocator);
    var colision_hash_map = std.AutoHashMap(u8, void).init(allocator);
    for (games) |game, index| {
        for (game) |item| {
            if (index % 3 == 0){
                try hash_map.put(item, {});
                continue;
            }
            if (index % 3 == 1){
                if (hash_map.contains(item)) {
                    try colision_hash_map.put(item, {});
                }
                continue;
            }
            if (colision_hash_map.contains(item)) {
                total += computeCharPriority(item); 
                hash_map.clearRetainingCapacity();
                colision_hash_map.clearRetainingCapacity();
                continue;
            }
        }
    }
    return total;
}

fn common(lines: ArrayList([]u8)) ![2]u32 {
    var result: [2]u32 = std.mem.zeroes([2]u32);
    var games = ArrayList([]u8).init(allocator);
    defer games.deinit();

    for (lines.items) |line| {
        try games.append(line);
    }

    const gamesSlice = games.toOwnedSlice();
    
    result[0] = try partOne(gamesSlice);
    result[1] = try partTwo(gamesSlice);
    return result;
}

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    
    var lines = ArrayList([]u8).init(allocator);
    defer lines.deinit();

    while (try in_stream.readUntilDelimiterOrEofAlloc(allocator, '\n', 64)) |line|{
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

    while (try in_stream.readUntilDelimiterOrEofAlloc(allocator, '\n', 64)) |line|{
        try lines.append(line);
    }

    var result = try common(lines);
    try std.testing.expect(result[0] == 157);
    try std.testing.expect(result[1] == 70);
}

test "Calculate Priorities" {
    try std.testing.expect(computeCharPriority('A') == 27);
    try std.testing.expect(computeCharPriority('Z') == 52);
    try std.testing.expect(computeCharPriority('a') == 1);
    try std.testing.expect(computeCharPriority('z') == 26);
}

test "Is Upper Case" {
    try std.testing.expect(isUpperCase('A'));
    try std.testing.expect(isUpperCase('Z'));
    try std.testing.expect(!isUpperCase('a'));
    try std.testing.expect(!isUpperCase('z'));
}