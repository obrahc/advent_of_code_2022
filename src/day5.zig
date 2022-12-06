const std = @import("std");
const aocutils = @import("utils.zig");
const fmt = std.fmt;
const ArrayList = std.ArrayList;
const Stack = std.atomic.Stack;

const allocator = std.heap.page_allocator;
const stdout = std.io.getStdOut().writer();

pub fn Crates() type {
    return struct {
        stacks: [9]Stack(u8),
        last_index: u8,

        pub const Self = @This();

        pub fn init() Self {
            return Self{
                .stacks = undefined,
                .last_index = 0
            };
        }
        
        pub fn addStack(self: *Self, stack: []const u8) void {
            var s: Stack(u8) = Stack(u8).init();
            for (stack) |container| {
                const node = allocator.create(Stack(u8).Node) catch unreachable;
                node.* = .{
                    .next = undefined,
                    .data = container,
                };
                s.push(node);
            }
            self.stacks[self.last_index] = s;
            self.last_index += 1;
        }
        
        pub fn move(self: *Self, num: u8, from: u8, to: u8) !void {
            for (aocutils.range(num)) |_| {
                try self.printRoot(from);
                try self.printRoot(to);
                 self.moveContainer(from, to);
                try self.printRoot(from);
                try self.printRoot(to);
                try stdout.print("\n\n", .{});
            }
        }
        
        pub fn moveContainer(self: *Self, from: u8, to: u8) void {
            var optional_c = self.stacks[from].pop();
            if (optional_c) |c| {
                self.stacks[to].push(c);
            }
        }

        pub fn printRoot(self: *Self, stack_num: u8) !void {
            if (self.stacks[stack_num].root) |node| {
                try stdout.print("{c} ", .{node.data});
            }
        }
    };
}

fn partOne(moves: []const[3]u8) !u16 {
    var stacks: Crates() = Crates().init();
    stacks.addStack("ZN");
    stacks.addStack("MCD");
    stacks.addStack("P");
    
    var total: u16 = 0;
    for (moves) |move| {
        try stdout.print("{d}, {d}, {d}\n", .{move[0], move[1], move[2]});
        try stacks.move(move[0], move[1] - 1 , move[2] - 1);
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

fn day5(lines: []const[]const u8) ![2] u16 {
    var result: [2]u16 = std.mem.zeroes([2]u16);
    var moves = ArrayList([3]u8).init(allocator);
    defer moves.deinit();

    for (lines) |line| {
        var move: [3]u8 = std.mem.zeroes([3]u8);
        var index: u4 = 0;
        var s = std.mem.split(u8, line, " ");
        while (s.next()) |t| {
            const move_int = fmt.parseUnsigned(u8, t, 10) catch continue;
            move[index] = move_int;
            index += 1;
        }
        try moves.append(move);
    }

    var MoveSlice = moves.toOwnedSlice();
    
    result[0] = try partOne(MoveSlice);
//    result[1] = try partTwo(MoveSlice);
    
    return result;
}

pub fn main() !void {
    var lines = try aocutils.ReadAOCInput(allocator, "inputs/day5.txt");
    var result = try day5(lines); 

    try stdout.print("Day Five\n" , .{});
    try stdout.print("Part One: {d}\n" , .{result[0]});
    try stdout.print("Part Two: {d}\n\n" , .{result[1]});
}

test "Provided Test Input" {
    var lines = try aocutils.ReadAOCInput(allocator, "inputs/day5_test.txt");
    
    var result = try day5(lines);
    try std.testing.expect(result[0] == 2);
    try std.testing.expect(result[1] == 4);
}
