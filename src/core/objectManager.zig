const Shape = @import("../objects/shape.zig").Shape;

pub const ObjectManager = struct {
    shapes: [1000]Shape = undefined, // 1000 - maximum number of shapes
    shape_count: usize = 0,

    pub fn addShape(self: *ObjectManager, shape: Shape) void {
        if (self.shape_count >= self.shapes.len) return;

        self.shapes[self.shape_count] = shape;
        self.shape_count += 1;
    }

    pub fn addShapes(self: *ObjectManager, shapes: []const Shape) void {
        for (shapes) |shape| {
            self.addShape(shape);
        }
    }

    pub fn getShapes(self: *ObjectManager) []Shape {
        return self.shapes[0..self.shape_count]; // get slice of initialized shapes only
    }
};
