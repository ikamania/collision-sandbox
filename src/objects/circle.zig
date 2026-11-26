const c = @import("c");

const Body = @import("../physics/body.zig").Body;
const Vec2 = @import("../physics/body.zig").Vec2;
const Color = @import("color.zig").Color;

pub const Circle = struct {
    body: Body,
    radius: f32,
    color: Color,

    pub fn init(position: Vec2, velocity: Vec2, radius: f32, color: Color, restitution: f32, mass: f32) Circle {
        return .{ .body = .{
            .position = position,
            .velocity = velocity,
            .width = radius * 2,
            .height = radius * 2,
            .restitution = restitution,
            .mass = mass,
        }, .radius = radius, .color = color };
    }
};
