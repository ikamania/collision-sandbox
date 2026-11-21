const std = @import("std");
const c = @import("c");

const Renderer = @import("renderer.zig").Renderer;
const Circle = @import("objects/circle.zig").Circle;

pub fn main() void {
    const window = c.sfRenderWindow_create(
        .{ .size = .{ .x = 800, .y = 600 }, .bitsPerPixel = 32 },
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
    var ball = Circle.init(
        .{ .x = 200, .y = 200 },
        .{ .x = 10, .y = 15 },
        25,
        c.sfRed,
    );

    while (c.sfRenderWindow_isOpen(window)) {
        while (c.sfRenderWindow_pollEvent(window, &event)) {
            if (event.type == c.sfEvtClosed) {
                c.sfRenderWindow_close(window);
            }
        }
        const dt = c.sfTime_asSeconds(c.sfClock_restart(clock));

        ball.update(dt);

        renderer.clear(c.sfWhite);
        renderer.drawCircle(&ball);
        renderer.display();
    }
}
