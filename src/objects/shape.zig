const Circle = @import("circle.zig").Circle;
const Rectangle = @import("rectangle.zig").Rectangle;
const Body = @import("../physics/body.zig").Body;

pub const Shape = union(enum) {
    circle: Circle,
    rectangle: Rectangle,

    pub fn getBody(self: *Shape) *Body {
        return switch (self.*) {
            .circle => |*circle| &circle.body,
            .rectangle => |*rectangle| &rectangle.body,
        };
    }
};
