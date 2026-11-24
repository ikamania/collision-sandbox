const Shape = @import("../objects/shape.zig").Shape;
const Vec2 = @import("body.zig").Vec2;
const Body = @import("body.zig").Body;

pub const PhysicsWorld = struct {
    gravity: f32 = 980,

    pub fn update(
        self: *PhysicsWorld,
        shapes: []Shape,
        dt: f32,
        width: f32,
        height: f32,
    ) void {
        self.applyGravity(shapes, dt);

        for (shapes, 0..) |*shape_a, i| {
            for (shapes[i + 1 ..]) |*shape_b| {
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

                if (isColliding(
                    a_position,
                    b_position,
                    .{ .x = body_a.width, .y = body_a.height },
                    .{ .x = body_b.width, .y = body_b.height },
                )) {
                    resolveAxis(body_a.position.x, body_b.position.x, &body_a.velocity.x, &body_b.velocity.x);
                    resolveAxis(body_a.position.y, body_b.position.y, &body_a.velocity.y, &body_b.velocity.y);
                } else {
                    body_a.position = a_position;
                    body_b.position = b_position;
                }

                // border
                resolveBounds(
                    &body_a.position,
                    &body_a.velocity,
                    .{ .x = body_a.width, .y = body_a.height },
                    .{ .x = width, .y = height },
                    body_a.restitution,
                );
                resolveBounds(
                    &body_b.position,
                    &body_b.velocity,
                    .{ .x = body_b.width, .y = body_b.height },
                    .{ .x = width, .y = height },
                    body_a.restitution,
                );
            }
        }
    }

    fn applyGravity(self: *PhysicsWorld, shapes: []Shape, dt: f32) void {
        for (shapes) |*shape| {
            const body: *Body = switch (shape.*) {
                .circle => |*circle| &circle.body,
                .rectangle => |*rectangle| &rectangle.body,
            };

            body.velocity.y += self.gravity * dt; // !!
        }
    }

    fn isColliding(a_position: Vec2, b_position: Vec2, a_size: Vec2, b_size: Vec2) bool {
        return a_position.x < b_position.x + b_size.x and
            a_position.x + a_size.x > b_position.x and
            a_position.y < b_position.y + b_size.y and
            a_position.y + a_size.y > b_position.y;
    }

    fn resolveAxis(
        pos_a: f32,
        pos_b: f32,
        vel_a: *f32,
        vel_b: *f32,
    ) void {
        if (vel_a.* * vel_b.* < 0) {
            vel_a.* = -vel_a.*;
            vel_b.* = -vel_b.*;
        } else if (vel_a.* * vel_b.* > 0) {
            const a_behind = (pos_a - pos_b) * vel_a.* < 0;

            if (a_behind and @abs(vel_a.*) > @abs(vel_b.*)) {
                vel_a.* = -vel_a.*;
            } else if (!a_behind and @abs(vel_b.*) > @abs(vel_a.*)) {
                vel_b.* = -vel_b.*;
            }
        }
    }

    fn resolveBounds(
        position: *Vec2,
        velocity: *Vec2,
        size: Vec2,
        bounds: Vec2,
        restitution: f32,
    ) void {
        if (position.x < 0) {
            position.x = 0;
            resolveBounce(&velocity.x, restitution);
        }
        if (position.x + size.x > bounds.x) {
            position.x = bounds.x - size.x;
            resolveBounce(&velocity.x, restitution);
        }

        if (position.y < 0) {
            position.y = 0;
            resolveBounce(&velocity.y, restitution);
        }
        if (position.y + size.y > bounds.y) {
            position.y = bounds.y - size.y;
            resolveBounce(&velocity.y, restitution);
        }
    }

    fn resolveBounce(velocity: *f32, restitution: f32) void {
        velocity.* = -velocity.* * restitution;
    }
};
