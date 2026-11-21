const Circle = @import("circle.zig").Circle;
const Rectangle = @import("rectangle.zig").Rectangle;

pub const Shape = union(enum) { circle: Circle, rectangle: Rectangle };
