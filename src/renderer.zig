const c = @import("c");
const Circle = @import("objects/circle.zig").Circle;

pub const Renderer = struct {
    window: *c.sfRenderWindow,

    pub fn init(window: *c.sfRenderWindow) Renderer {
        return .{
            .window = window,
        };
    }

    pub fn clear(self: *Renderer, color: c.sfColor) void {
        c.sfRenderWindow_clear(self.window, color);
    }

    pub fn display(self: *Renderer) void {
        c.sfRenderWindow_display(self.window);
    }

    pub fn drawCircle(self: *Renderer, circle: *Circle) void {
        const shape = c.sfCircleShape_create();

        c.sfCircleShape_setRadius(shape, circle.radius);
        c.sfCircleShape_setPosition(shape, .{
            .x = circle.body.position.x,
            .y = circle.body.position.y,
        });
        c.sfCircleShape_setFillColor(shape, circle.color);

        c.sfRenderWindow_drawCircleShape(
            self.window,
            shape,
            null,
        );
    }
};
