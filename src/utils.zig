const std = @import("std");
const ArrayList = std.ArrayList;

pub fn ReadAOCInput(allocator: std.mem.Allocator, path: []const u8) ![]const[]const u8 {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    
    var lines = ArrayList([]u8).init(allocator);
    defer lines.deinit();

    while (try in_stream.readUntilDelimiterOrEofAlloc(allocator, '\n', 64)) |line|{
        try lines.append(line);
    }

    const s = lines.toOwnedSlice();
    
    return s;
}