const Shape = @import("../objects/shape.zig").Shape;
const Vec2 = @import("body.zig").Vec2;
const Body = @import("body.zig").Body;

const GRAVITY: f32 = 9.8;

const Collision = struct {
    normal: Vec2,
    penetration: f32,
};

pub const PhysicsWorld = struct {
    pub fn applyGravity(shapes: []Shape, dt: f32) void {
        for (shapes) |*shape| {
            const body = shape.getBody();

            body.velocity.y += GRAVITY * body.mass * dt; // !!
        }
    }

    pub fn integratePositions(shapes: []Shape, dt: f32) void {
        for (shapes) |*shape| {
            const body = shape.getBody();

            body.position.x += body.velocity.x * dt;
            body.position.y += body.velocity.y * dt;
        }
    }

    pub fn handleCollisions(shapes: []Shape) void {
        // resolving the collision between A and B can affect the collision between B and C!!
        for (shapes, 0..) |*shape_a, i| {
            for (shapes[i + 1 ..]) |*shape_b| {
                const body_a: *Body = shape_a.getBody();
                const body_b: *Body = shape_b.getBody();

                if (detectCollision(body_a, body_b)) |collision| {
                    separateBodies(body_a, body_b, collision);
                    resolveCollision(body_a, body_b, collision);
                }
            }
        }
    }

    fn detectCollision(body_a: *Body, body_b: *Body) ?Collision {
        const a_right = body_a.position.x + body_a.width;
        const b_right = body_b.position.x + body_b.width;

        const a_bottom = body_a.position.y + body_a.height;
        const b_bottom = body_b.position.y + body_b.height;

        const overlap_x = @min(a_right, b_right) - @max(body_a.position.x, body_b.position.x);
        const overlap_y = @min(a_bottom, b_bottom) - @max(body_a.position.y, body_b.position.y);

        if (overlap_x <= 0 or overlap_y <= 0) return null;

        if (overlap_x < overlap_y) {
            return .{
                .normal = .{
                    .x = if (body_a.position.x < body_b.position.x) -1 else 1,
                    .y = 0,
                },
                .penetration = overlap_x,
            };
        }
        return .{
            .normal = .{
                .x = 0,
                .y = if (body_a.position.y < body_b.position.y) -1 else 1,
            },
            .penetration = overlap_y,
        };
    }

    fn separateBodies(
        body_a: *Body,
        body_b: *Body,
        collision: Collision,
    ) void {
        const inv_mass_a = 1.0 / body_a.mass;
        const inv_mass_b = 1.0 / body_b.mass;

        const total_inv_mass = inv_mass_a + inv_mass_b;

        const correction = collision.penetration / total_inv_mass;

        body_a.position.x += collision.normal.x * correction * inv_mass_a;
        body_a.position.y += collision.normal.y * correction * inv_mass_a;

        body_b.position.x -= collision.normal.x * correction * inv_mass_b;
        body_b.position.y -= collision.normal.y * correction * inv_mass_b;
    }

    fn resolveCollision(
        body_a: *Body,
        body_b: *Body,
        collision: Collision,
    ) void {
        const relative_velocity = Vec2{ .x = body_a.velocity.x - body_b.velocity.x, .y = body_a.velocity.y - body_b.velocity.y };
        const velocity_along_normal = relative_velocity.x * collision.normal.x + relative_velocity.y * collision.normal.y;

        if (velocity_along_normal >= 0) return;

        const inv_mass_a = 1.0 / body_a.mass;
        const inv_mass_b = 1.0 / body_b.mass;

        const restitution = @min(body_a.restitution, body_b.restitution); // !

        const j = -(1.0 + restitution) * velocity_along_normal / (inv_mass_a + inv_mass_b);

        body_a.velocity.x += j * collision.normal.x * inv_mass_a;
        body_a.velocity.y += j * collision.normal.y * inv_mass_a;

        body_b.velocity.x -= j * collision.normal.x * inv_mass_b;
        body_b.velocity.y -= j * collision.normal.y * inv_mass_b;
    }
};
