const C = @import("c.zig").C;
const std = @import("std");

pub const FloatingType = f32;
pub const IntegerType = i32;

/// A positional point.
pub fn Point(comptime Type: type) type {
    return struct {
        const Self = @This();
        x: Type,
        y: Type,

        /// From an SDL point.
        fn fromSdlFPoint(self: C.SDL_FPoint) Self {
            return .{
                .x = @floatCast(self.x),
                .y = @floatCast(self.y),
            };
        }

        /// From an SDL point.
        fn fromSdlIPoint(self: C.SDL_Point) Self {
            return .{
                .x = @intCast(self.x),
                .y = @intCast(self.y),
            };
        }

        /// Get the SDL point.
        fn toSdlFPoint(self: Self) C.SDL_FPoint {
            return .{
                .x = @floatCast(self.x),
                .y = @floatCast(self.y),
            };
        }

        /// Get the SDL point.
        fn toSdlIPoint(self: Self) C.SDL_Point {
            return .{
                .x = @intCast(self.x),
                .y = @intCast(self.y),
            };
        }

        // Put other SDL declarations here.
        const isFPoint = Type == FloatingType;
        const isIPoint = Type == IntegerType;

        /// Get a point from an SDL point.
        pub const fromSdl = if (isIPoint) fromSdlIPoint else if (isFPoint) fromSdlFPoint else null;
        /// Get the SDL point.
        pub const toSdl = if (isIPoint) toSdlIPoint else if (isFPoint) toSdlFPoint else null;
    };
}
pub const FPoint = Point(FloatingType);
pub const IPoint = Point(IntegerType);

/// Rectangle with position and size.
pub fn Rect(comptime Type: type) type {
    return struct {
        const Self = @This();
        x: Type,
        y: Type,
        w: Type,
        h: Type,

        /// Get this as a different type of rectangle.
        pub fn asOtherRect(self: Self, comptime NewType: type) Rect(NewType) {
            return .{
                .x = @as(NewType, self.x),
                .y = @as(NewType, self.y),
                .w = @as(NewType, self.w),
                .h = @as(NewType, self.h),
            };
        }

        /// If the rectangle is empty (has no area).
        pub fn empty(self: Self) bool {
            return self.x <= 0 and self.y <= 0;
        }

        // Equal does not need to exist, use std.meta.eql.

        /// Create from an SDL rect.c
        fn fromSdlFRect(rect: C.SDL_FRect) FRect {
            return .{
                .x = @floatCast(rect.x),
                .y = @floatCast(rect.y),
                .w = @floatCast(rect.w),
                .h = @floatCast(rect.h),
            };
        }

        /// Create from an SDL rect.
        fn fromSdlIRect(rect: C.SDL_Rect) IRect {
            return .{
                .x = @intCast(rect.x),
                .y = @intCast(rect.y),
                .w = @intCast(rect.w),
                .h = @intCast(rect.h),
            };
        }

        /// If two rectangles are intersecting.
        fn hasIntersectionFRect(self: FRect, other: FRect) bool {
            const a = self.toSdl();
            const b = other.toSdl();
            return C.SDL_HasRectIntersectionFloat(&a, &b);
        }

        /// If two rectangles are intersecting.
        fn hasIntersectionIRect(self: IRect, other: IRect) bool {
            const a = self.toSdl();
            const b = other.toSdl();
            return C.SDL_HasRectIntersection(&a, &b);
        }

        /// Get intersection with another rect.
        fn intersectionFRect(self: FRect, other: FRect) ?FRect {
            const a = self.toSdl();
            const b = other.toSdl();
            var ret: C.SDL_FRect = undefined;
            if (!C.SDL_GetRectIntersectionFloat(&a, &b, &ret))
                return null;
            return fromSdl(ret);
        }

        /// Get intersection with another rect.
        fn intersectionIRect(self: IRect, other: IRect) ?IRect {
            const a = self.toSdl();
            const b = other.toSdl();
            var ret: C.SDL_Rect = undefined;
            if (!C.SDL_GetRectIntersection(&a, &b, &ret))
                return null;
            return fromSdl(ret);
        }

        /// Check to see if a point is inside this rectangle.
        pub fn pointIn(self: Self, point: Point(Type)) bool {
            return point.x >= self.x and (point.x < (self.x + self.w)) and
                (point.y >= self.y) and (point.y < (self.y + self.h));
        }

        /// Calculate the intersection between a rect and lines. Returns null if there is no intersection.
        fn rectAndLineIntersectionFRect(self: FRect, line: [2]FPoint) ?[2]FPoint {
            const rect = self.toSdl();
            var p1 = line[0].toSdl();
            var p2 = line[1].toSdl();
            if (!C.SDL_GetRectAndLineIntersectionFloat(&rect, &p1.x, &p1.y, &p2.x, &p2.y))
                return null;
            return [_]FPoint{ p1.fromSdl(), p2.fromSdl() };
        }

        /// Calculate the intersection between a rect and lines. Returns null if there is no intersection.
        fn rectAndLineIntersectionIRect(self: IRect, line: [2]IPoint) ?[2]IPoint {
            const rect = self.toSdl();
            var p1 = line[0].toSdl();
            var p2 = line[1].toSdl();
            if (!C.SDL_GetRectAndLineIntersection(&rect, &p1.x, &p1.y, &p2.x, &p2.y))
                return null;
            return [_]IPoint{ p1.fromSdl(), p2.fromSdl() };
        }

        /// Get a rectangle enclosing all the points in the clipping rectangle (or creates one if null). If none of the points are in the rectangle, returns null.
        fn rectEnclosingPoints(points: []Point(Type), clip: ?Self) ?Self {
            if (points.len < 1)
                return null;

            // If clipping rectangle exists.
            var min_x: Type = undefined;
            var min_y: Type = undefined;
            var max_x: Type = undefined;
            var max_y: Type = undefined;
            if (clip) |rect| {
                if (rect.empty())
                    return null;
                var added = false;
                const clip_min_x = rect.x;
                const clip_min_y = rect.y;
                const clip_max_x = rect.x + rect.w;
                const clip_max_y = rect.y + rect.h;
                for (points) |point| {
                    const x = point.x;
                    const y = point.y;
                    if (x < clip_min_x or x > clip_max_x or y < clip_min_y or y > clip_max_y)
                        continue;
                    if (!added) {
                        min_x = x;
                        max_x = x;
                        min_y = y;
                        max_y = y;
                        added = true;
                        continue;
                    }
                    min_x = @min(x, min_x);
                    min_y = @min(y, min_y);
                    max_x = @max(x, max_x);
                    max_y = @max(y, max_y);
                }
                if (!added)
                    return null;
            } else {
                min_x = points[0].x;
                max_x = points[0].x;
                min_y = points[0].y;
                max_y = points[0].y;
                for (points[1..]) |point| {
                    min_x = @min(min_x, point.x);
                    min_y = @min(min_y, point.y);
                    max_x = @max(max_x, point.x);
                    max_y = @max(max_y, point.y);
                }
            }
            return .{
                .x = min_x,
                .y = min_y,
                .w = (max_x - min_x),
                .h = (max_y - min_y),
            };
        }

        /// Get the SDL rect.
        fn toSdlFRect(self: FRect) C.SDL_FRect {
            return C.SDL_FRect{
                .x = @floatCast(self.x),
                .y = @floatCast(self.y),
                .w = @floatCast(self.w),
                .h = @floatCast(self.h),
            };
        }

        /// Get the SDL rect.
        fn toSdlIRect(self: IRect) C.SDL_Rect {
            return C.SDL_Rect{
                .x = @intCast(self.x),
                .y = @intCast(self.y),
                .w = @intCast(self.w),
                .h = @intCast(self.h),
            };
        }

        /// Get the union between two rectangles.
        fn unionFRect(self: FRect, other: FRect) !FRect {
            const a = self.toSdl();
            const b = other.toSdl();
            var ret: C.SDL_FRect = undefined;
            if (!C.SDL_GetRectUnionFloat(&a, &b, &ret))
                return error.SDLError;
            return fromSdl(ret);
        }

        /// Get the union between two rectangles.
        fn unionIRect(self: IRect, other: IRect) !IRect {
            const a = self.toSdl();
            const b = other.toSdl();
            var ret: C.SDL_Rect = undefined;
            if (!C.SDL_GetRectUnion(&a, &b, &ret))
                return error.SDLError;
            return fromSdl(ret);
        }

        // Put other SDL declarations here.
        const isFRect = Type == FloatingType;
        const isIRect = Type == IntegerType;

        /// Create a rectangle from an SDL rectangle.
        pub const fromSdl = if (isIRect) fromSdlIRect else if (isFRect) fromSdlFRect else null;
        /// Get the intersection region with another rectangle.
        pub const intersection = if (isIRect) intersectionIRect else if (isFRect) intersectionFRect else null;
        /// If intersecting with another rectangle.
        pub const hasIntersection = if (isIRect) hasIntersectionIRect else if (isFRect) hasIntersectionFRect else null;
        /// Calculate the intersection between a rect and lines. Returns null if there is no intersection.
        pub const rectAndLineIntersection = if (isIRect) rectAndLineIntersectionIRect else if (isFRect) rectAndLineIntersectionFRect else null;
        /// Get the SDL rectangle.
        pub const toSdl = if (isIRect) toSdlIRect else if (isFRect) toSdlFRect else null;
        /// Get the union region between two rectangles.
        pub const unionRegion = if (isIRect) unionIRect else if (isFRect) unionFRect else null;
    };
}
pub const FRect = Rect(FloatingType);
pub const IRect = Rect(IntegerType);

test "Rect" {
    const a = IRect{ .x = 10, .y = 20, .w = 50, .h = 50 };
    const b = IRect{ .x = 30, .y = 30, .w = 10, .h = 10 };
    try std.testing.expect(a.hasIntersection(b));
    try std.testing.expect(std.meta.eql(a.intersection(b), .{ .x = 30, .y = 30, .w = 10, .h = 10 }));
    // TODO: MORE TESTS!!!
}
