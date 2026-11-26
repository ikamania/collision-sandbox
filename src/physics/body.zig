pub const Vec2 = struct {
    x: f32 = 0,
    y: f32 = 0,
};

pub const Body = struct {
    position: Vec2,
    velocity: Vec2,
    width: f32,
    height: f32,
    restitution: f32, // bounciness
    mass: f32,
};
