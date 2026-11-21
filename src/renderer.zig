const c = @import("c");

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
};
