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
    objectManager.addShapes(&.{
        .{
            .rectangle = Rectangle.init(
                .{ .x = 100, .y = height },
                .{ .x = 0, .y = 0 },
                20,
                40,
                .{ .red = 255, .green = 0, .blue = 0 },
                1.0,
                1.0,
            ),
        },
        .{
            .rectangle = Rectangle.init(
                .{ .x = 400, .y = height },
                .{ .x = -100, .y = 0 },
                100,
                80,
                .{ .red = 0, .green = 0, .blue = 255 },
                1.0,
                100.0,
            ),
        },
    });

    while (c.sfRenderWindow_isOpen(window)) {
        while (c.sfRenderWindow_pollEvent(window, &event)) {
            if (event.type == c.sfEvtClosed) {
                c.sfRenderWindow_close(window);
            }
        }
        const dt = c.sfTime_asSeconds(c.sfClock_restart(clock));

        // PhysicsWorld.applyGravity(objectManager.getShapes(), dt);
        PhysicsWorld.integratePositions(objectManager.getShapes(), dt);
        PhysicsWorld.handleCollisions(objectManager.getShapes(), width, height);

        renderer.clear(c.sfWhite);
        renderer.drawShapes(objectManager.getShapes());
        renderer.display();
    }
}
