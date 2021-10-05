/// Protocol for 2D geometric types defined by floating-point vectors that form
/// closed convex shapes.
public protocol Convex2Type: GeometricType {
    /// The floating-point vector type associated with this ``Convex2Type``.
    associatedtype Vector: Vector2FloatingPoint
    
    /// Performs an intersection test against the given line, returning up to
    /// two points representing the entrance and exit intersections against this
    /// convex shape's outer perimeter.
    func intersection<Line: Line2FloatingPoint>(with line: Line) -> ConvexLineIntersection<Vector> where Line.Vector == Vector
}
