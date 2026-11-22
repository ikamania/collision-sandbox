const std = @import("std");
const c = @import("c");

const Renderer = @import("renderer.zig").Renderer;
const ObjectManager = @import("physics/objectManager.zig").ObjectManager;
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
    defer c.sfRenderWindow_destroy(window);

    var renderer = Renderer.init(window);

    var event: c.sfEvent = undefined;

    const clock = c.sfClock_create() orelse return;
    defer c.sfClock_destroy(clock);

    //
    var objectManager = ObjectManager{};
    //
    objectManager.addShapes(&.{
        .{ .circle = Circle.init(.{ .x = 300, .y = 300 }, .{ .x = 30, .y = -45 }, 25, .{ .red = 255, .green = 0, .blue = 0 }) },
        .{ .rectangle = Rectangle.init(.{ .x = 200, .y = 200 }, .{ .x = 45, .y = 20 }, 50, 25, .{ .red = 0, .green = 0, .blue = 255 }) },
        .{ .circle = Circle.init(.{ .x = 500, .y = 150 }, .{ .x = -25, .y = 35 }, 15, .{ .red = 0, .green = 255, .blue = 0 }) },
    });

    while (c.sfRenderWindow_isOpen(window)) {
        while (c.sfRenderWindow_pollEvent(window, &event)) {
            if (event.type == c.sfEvtClosed) {
                c.sfRenderWindow_close(window);
            }
        }
        const dt = c.sfTime_asSeconds(c.sfClock_restart(clock));

        PhysicsWorld.update(objectManager.getShapes(), dt, width, height);

        renderer.clear(c.sfWhite);
        renderer.drawShapes(objectManager.getShapes());
        renderer.display();
    }
}
