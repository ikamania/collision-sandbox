pub const Vec2 = struct {
    x: f32 = 0,
    y: f32 = 0,
};

pub const Body = struct {
    position: Vec2,
    velocity: Vec2,

    pub fn update(self: *Body, dt: f32) void {
        self.position.x += self.velocity.x * dt;
        self.position.y += self.velocity.y * dt;
    }
};
