const std = @import("std");
const c = @import("c");

const Renderer = @import("rendering/renderer.zig").Renderer;
const ObjectManager = @import("core/objectManager.zig").ObjectManager;
const PhysicsWorld = @import("physics/physicsWorld.zig").PhysicsWorld;

const Shape = @import("objects/shape.zig").Shape;
const Circle = @import("objects/circle.zig").Circle;
const Rectangle = @import("objects/rectangle.zig").Rectangle;

const width = 800;
const height = 600;

pub fn main() void {
    const window = c.sfRenderWindow_create(
        .{ .size = .{ .x = width, .y = height }, .bitsPerPixel = 32 },
        "zig-collision",
        c.sfDefaultStyle,
        0,
        null,
    ) orelse return; // handle optional pointer return
    c.sfRenderWindow_setFramerateLimit(window, 60);
    defer c.sfRenderWindow_destroy(window);

    var renderer = Renderer.init(window);

    var event: c.sfEvent = undefined;

    const clock = c.sfClock_create() orelse return;
    defer c.sfClock_destroy(clock);

    //
    var objectManager = ObjectManager{};
    //
    var p = std.Random.DefaultPrng.init(42);
    const rand = p.random();

    for (0..1000) |_| {
        const x = rand.float(f32) * width;
        const y = rand.float(f32) * height;

        const v = 1000.0;
        const v_x = (rand.float(f32) * 2 - 1) * v;
        const v_y = (rand.float(f32) * 2 - 1) * v;

        const s = 3;

        objectManager.addShape(
            .{ .rectangle = Rectangle.init(
                .{ .x = x, .y = y },
                .{ .x = v_x, .y = v_y },
                s,
                s,
                .{ .red = 255, .green = 0, .blue = 0 },
                0.7,
                18.0,
            ) },
        );
    }

    while (c.sfRenderWindow_isOpen(window)) {
        while (c.sfRenderWindow_pollEvent(window, &event)) {
            if (event.type == c.sfEvtClosed) {
                c.sfRenderWindow_close(window);
            }
        }
        const dt = c.sfTime_asSeconds(c.sfClock_restart(clock));

        PhysicsWorld.applyGravity(objectManager.getShapes(), dt);
        PhysicsWorld.integratePositions(objectManager.getShapes(), dt);
        PhysicsWorld.handleCollisions(objectManager.getShapes(), width, height);

        renderer.clear(c.sfWhite);
        renderer.drawShapes(objectManager.getShapes());
        renderer.display();
    }
}
