const Shape = @import("../objects/shape.zig").Shape;
const Vec2 = @import("body.zig").Vec2;
const Body = @import("body.zig").Body;

pub const ObjectManager = struct {
    shapes: []Shape,

    pub fn update(
        self: *ObjectManager,
        dt: f32,
        width: f32,
        height: f32,
    ) void {
        for (self.shapes, 0..) |*shape_a, i| {
            for (self.shapes[i + 1 ..]) |*shape_b| {
                const body_a: *Body = switch (shape_a.*) {
                    .circle => |*circle| &circle.body,
                    .rectangle => |*rectangle| &rectangle.body,
                };

                const body_b: *Body = switch (shape_b.*) {
                    .circle => |*circle| &circle.body,
                    .rectangle => |*rectangle| &rectangle.body,
                };

                const a_position = Vec2{
                    .x = body_a.position.x + body_a.velocity.x * dt,
                    .y = body_a.position.y + body_a.velocity.y * dt,
                };
                const b_position = Vec2{
                    .x = body_b.position.x + body_b.velocity.x * dt,
                    .y = body_b.position.y + body_b.velocity.y * dt,
                };

                // shape collision
                if (isColliding(
                    a_position,
                    b_position,
                    .{ .x = body_a.width, .y = body_a.height },
                    .{ .x = body_b.width, .y = body_b.height },
                )) { // !! problem - if shape hits from behind they stop moving.
                    if (body_a.velocity.x * body_b.velocity.x < 0) {
                        body_a.velocity.x *= -1;
                        body_b.velocity.x *= -1;
                    }
                    if (body_a.velocity.y * body_b.velocity.y < 0) {
                        body_a.velocity.y *= -1;
                        body_b.velocity.y *= -1;
                    }
                } else {
                    body_a.position = a_position;
                    body_b.position = b_position;
                }

                // borders !! problem - if shape might get stuck outside border if dt is inconsistent.
                if (a_position.x < 0 or a_position.x + body_a.width > width) { // a
                    body_a.velocity.x *= -1;
                }
                if (a_position.y < 0 or a_position.y + body_a.height > height) {
                    body_a.velocity.y *= -1;
                }
                if (b_position.x < 0 or b_position.x + body_b.width > width) { // b
                    body_b.velocity.x *= -1;
                }
                if (b_position.y < 0 or b_position.y + body_b.height > height) {
                    body_b.velocity.y *= -1;
                }
            }
        }
    }

    fn isColliding(a_position: Vec2, b_position: Vec2, a_size: Vec2, b_size: Vec2) bool {
        return a_position.x < b_position.x + b_size.x and
            a_position.x + a_size.x > b_position.x and
            a_position.y < b_position.y + b_size.y and
            a_position.y + a_size.y > b_position.y;
    }
};
