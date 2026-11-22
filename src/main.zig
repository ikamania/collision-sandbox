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
        .{ .circle = Circle.init(.{ .x = 300, .y = 300 }, .{ .x = 30, .y = -45 }, 25, .{ .red = 255, .green = 0, .blue = 0 }) },
        .{ .rectangle = Rectangle.init(.{ .x = 200, .y = 200 }, .{ .x = 45, .y = 20 }, 50, 25, .{ .red = 255, .green = 255, .blue = 255 }) },
        .{ .circle = Circle.init(.{ .x = 500, .y = 150 }, .{ .x = -25, .y = 35 }, 15, .{ .red = 0, .green = 255, .blue = 0 }) },
        .{ .rectangle = Rectangle.init(.{ .x = 700, .y = 300 }, .{ .x = -40, .y = 30 }, 40, 40, .{ .red = 255, .green = 255, .blue = 0 }) },
        .{ .circle = Circle.init(.{ .x = 900, .y = 500 }, .{ .x = 40, .y = -30 }, 32, .{ .red = 255, .green = 0, .blue = 255 }) },
        .{ .rectangle = Rectangle.init(.{ .x = 400, .y = 600 }, .{ .x = 20, .y = -50 }, 60, 20, .{ .red = 0, .green = 255, .blue = 255 }) },

        .{ .circle = Circle.init(.{ .x = 150, .y = 400 }, .{ .x = 35, .y = 25 }, 12, .{ .red = 255, .green = 128, .blue = 0 }) },
        .{ .rectangle = Rectangle.init(.{ .x = 600, .y = 500 }, .{ .x = -30, .y = -40 }, 35, 20, .{ .red = 128, .green = 0, .blue = 255 }) },
        .{ .circle = Circle.init(.{ .x = 800, .y = 150 }, .{ .x = -45, .y = 35 }, 20, .{ .red = 0, .green = 128, .blue = 255 }) },
        .{ .rectangle = Rectangle.init(.{ .x = 1000, .y = 400 }, .{ .x = 25, .y = -20 }, 45, 30, .{ .red = 255, .green = 100, .blue = 100 }) },

        .{ .circle = Circle.init(.{ .x = 450, .y = 250 }, .{ .x = -35, .y = -45 }, 18, .{ .red = 100, .green = 255, .blue = 100 }) },
        .{ .rectangle = Rectangle.init(.{ .x = 250, .y = 550 }, .{ .x = 40, .y = -15 }, 25, 45, .{ .red = 255, .green = 200, .blue = 0 }) },
        .{ .circle = Circle.init(.{ .x = 1100, .y = 200 }, .{ .x = -20, .y = 40 }, 10, .{ .red = 255, .green = 255, .blue = 255 }) },
        .{ .rectangle = Rectangle.init(.{ .x = 750, .y = 650 }, .{ .x = -35, .y = -25 }, 30, 30, .{ .red = 0, .green = 200, .blue = 200 }) },

        .{ .circle = Circle.init(.{ .x = 550, .y = 350 }, .{ .x = 45, .y = 20 }, 22, .{ .red = 200, .green = 0, .blue = 100 }) },
        .{ .rectangle = Rectangle.init(.{ .x = 950, .y = 600 }, .{ .x = -40, .y = -30 }, 50, 15, .{ .red = 150, .green = 150, .blue = 255 }) },
        .{ .circle = Circle.init(.{ .x = 100, .y = 150 }, .{ .x = 25, .y = 45 }, 14, .{ .red = 255, .green = 150, .blue = 50 }) },
        .{ .rectangle = Rectangle.init(.{ .x = 1150, .y = 500 }, .{ .x = -45, .y = -20 }, 20, 50, .{ .red = 100, .green = 255, .blue = 200 }) },
        .{ .circle = Circle.init(.{ .x = 650, .y = 100 }, .{ .x = 35, .y = 40 }, 28, .{ .red = 180, .green = 50, .blue = 255 }) },
        .{ .rectangle = Rectangle.init(.{ .x = 350, .y = 700 }, .{ .x = 15, .y = -45 }, 40, 20, .{ .red = 255, .green = 80, .blue = 150 }) },
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
