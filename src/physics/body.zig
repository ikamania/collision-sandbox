pub const Vec2 = struct {
    x: f32 = 0,
    y: f32 = 0,
};

pub const Body = struct {
    position: Vec2,
    velocity: Vec2,
    width: f32,
    height: f32,

    pub fn update(self: *Body, dt: f32, width: f32, height: f32) void {
        var x = self.position.x + self.velocity.x * dt;
        var y = self.position.y + self.velocity.y * dt;

        // border check from shapes top left
        if (x + self.width > width) {
            x = width - self.width;
            self.velocity.x *= -1;
        }
        if (x < 0) {
            x = 0;
            self.velocity.x *= -1;
        }
        if (y + self.height > height) {
            y = height - self.height;
            self.velocity.y *= -1;
        }
        if (y < 0) {
            y = 0;
            self.velocity.y *= -1;
        }

        self.position.x = x;
        self.position.y = y;
    }
};
