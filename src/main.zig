const std = @import("std");
const c = @import("c");

pub fn main() void {
    const window = c.sfRenderWindow_create(
        .{ .size = .{ .x = 800, .y = 600 }, .bitsPerPixel = 32 },
        "zig-collision",
        c.sfDefaultStyle,
        0,
        null,
    );
    defer c.sfRenderWindow_destroy(window);

    var event: c.sfEvent = undefined;

    while (c.sfRenderWindow_isOpen(window)) {
        while (c.sfRenderWindow_pollEvent(window, &event)) {
            if (event.type == c.sfEvtClosed) {
                c.sfRenderWindow_close(window);
            }
        }

        c.sfRenderWindow_clear(window, c.sfBlack);
        c.sfRenderWindow_display(window);
    }
}
