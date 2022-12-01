const std = @import("std");
const fmt = std.fmt;
const ArrayList = std.ArrayList;

const allocator = std.heap.page_allocator;
const stdout = std.io.getStdOut().writer();

pub fn isEmptyLine(line: []const u8) bool {
    const empty_line = "";
    return std.mem.eql(u8, line, empty_line);
}

fn partOne(elfs: []u32) u32 {
    return elfs[0];
}

fn partTwo(elfs: []u32) !u32 {
    return elfs[0] + elfs[1] + elfs[2];
}

fn common(lines: ArrayList([]u8)) ![2]u32 {
    var result: [2]u32 = std.mem.zeroes([2]u32);
    var calories: u32 = 0;
    var elfs = ArrayList(u32).init(allocator);
    defer elfs.deinit();

    for (lines.items) |line| {
        if (isEmptyLine(line)){
            try elfs.append(calories);
            calories = 0;
            continue;
        }
        const line_int = fmt.parseUnsigned(u32, line, 10) catch unreachable;
        calories += line_int;
    }
    try elfs.append(calories);

    var sorted_elfs = elfs.toOwnedSlice();
    defer allocator.free(sorted_elfs);

    std.sort.sort(u32, sorted_elfs, {}, std.sort.desc(u32));
    
    result[0] = partOne(sorted_elfs);
    result[1] = try partTwo(sorted_elfs);
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
    try std.testing.expect(result[0] == 24000);
    try std.testing.expect(result[1] == 45000);
}