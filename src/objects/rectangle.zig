const c = @import("c");

const Body = @import("../physics/body.zig").Body;
const Vec2 = @import("../physics/body.zig").Vec2;
const Color = @import("color.zig").Color;

pub const Rectangle = struct {
    body: Body,
    width: f32,
    height: f32,
    color: Color,

    pub fn init(position: Vec2, velocity: Vec2, width: f32, height: f32, color: Color, restitution: f32) Rectangle {
        return .{ .body = .{
            .position = position,
            .velocity = velocity,
            .width = width,
            .height = height,
            .restitution = restitution,
        }, .width = width, .height = height, .color = color };
    }
};
