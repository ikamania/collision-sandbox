const std = @import("std");
const c = @import("c");

const Renderer = @import("renderer.zig").Renderer;
const ObjectManager = @import("physics/objectManager.zig").ObjectManager;

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
    var shapes = [_]Shape{
        .{ .circle = Circle.init(.{ .x = 300, .y = 300 }, .{ .x = 100, .y = -200 }, 50, c.sfRed) },
        .{ .rectangle = Rectangle.init(.{ .x = 200, .y = 200 }, .{ .x = 400, .y = 100 }, 100, 50, c.sfBlue) },

        .{ .circle = Circle.init(.{ .x = 500, .y = 150 }, .{ .x = -180, .y = 120 }, 30, c.sfGreen) },
        .{ .rectangle = Rectangle.init(.{ .x = 700, .y = 300 }, .{ .x = -250, .y = 180 }, 80, 80, c.sfYellow) },

        .{ .circle = Circle.init(.{ .x = 900, .y = 500 }, .{ .x = 220, .y = -160 }, 65, c.sfMagenta) },
        .{ .rectangle = Rectangle.init(.{ .x = 400, .y = 600 }, .{ .x = 150, .y = -300 }, 120, 40, c.sfCyan) },
    };
    var objectManager = ObjectManager{
        .shapes = &shapes,
    };

    while (c.sfRenderWindow_isOpen(window)) {
        while (c.sfRenderWindow_pollEvent(window, &event)) {
            if (event.type == c.sfEvtClosed) {
                c.sfRenderWindow_close(window);
            }
        }
        const dt = c.sfTime_asSeconds(c.sfClock_restart(clock));

        renderer.clear(c.sfWhite);
        for (&shapes) |*shape| {
            switch (shape.*) { // derefernce pointer (pointer.*)
                .circle => |*circle| {
                    renderer.drawCircle(circle);
                },
                .rectangle => |*rectangle| {
                    renderer.drawRectangle(rectangle);
                },
            }
        }
        objectManager.update(dt, width, height);
        renderer.display();
    }
}
