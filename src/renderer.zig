const c = @import("c");
const Shape = @import("objects/shape.zig").Shape;
const Circle = @import("objects/circle.zig").Circle;
const Rectangle = @import("objects/rectangle.zig").Rectangle;

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

    pub fn drawShapes(self: *Renderer, shapes: []Shape) void {
        for (shapes) |*shape| {
            switch (shape.*) { // derefernce pointer (pointer.*)
                .circle => |*circle| {
                    self.drawCircle(circle);
                },
                .rectangle => |*rectangle| {
                    self.drawRectangle(rectangle);
                },
            }
        }
    }

    pub fn drawCircle(self: *Renderer, circle: *Circle) void {
        const shape = c.sfCircleShape_create();

        c.sfCircleShape_setRadius(shape, circle.radius);
        c.sfCircleShape_setPosition(shape, .{
            .x = circle.body.position.x,
            .y = circle.body.position.y,
        });
        c.sfCircleShape_setFillColor(
            shape,
            c.sfColor_fromRGB(circle.color.red, circle.color.green, circle.color.blue),
        );

        c.sfRenderWindow_drawCircleShape(
            self.window,
            shape,
            null,
        );
        c.sfCircleShape_destroy(shape);
    }

    pub fn drawRectangle(self: *Renderer, rectangle: *Rectangle) void {
        const shape = c.sfRectangleShape_create();

        c.sfRectangleShape_setSize(shape, .{
            .x = rectangle.width,
            .y = rectangle.height,
        });
        c.sfRectangleShape_setPosition(shape, .{
            .x = rectangle.body.position.x,
            .y = rectangle.body.position.y,
        });
        c.sfRectangleShape_setFillColor(
            shape,
            c.sfColor_fromRGB(rectangle.color.red, rectangle.color.green, rectangle.color.blue),
        );

        c.sfRenderWindow_drawRectangleShape(
            self.window,
            shape,
            null,
        );
        c.sfRectangleShape_destroy(shape);
    }
};
