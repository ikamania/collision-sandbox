const c = @import("c");

const Body = @import("../physics/body.zig").Body;
const Vec2 = @import("../physics/body.zig").Vec2;

pub const Circle = struct {
    body: Body,
    radius: f32,
    color: c.sfColor,

    pub fn init(position: Vec2, velocity: Vec2, radius: f32, color: c.sfColor) Circle {
        return .{ .body = .{
            .position = position,
            .velocity = velocity,
            .width = radius * 2,
            .height = radius * 2,
        }, .radius = radius, .color = color };
    }

    pub fn update(self: *Circle, dt: f32, width: f32, height: f32) void {
        self.body.update(dt, width, height);
    }
};
