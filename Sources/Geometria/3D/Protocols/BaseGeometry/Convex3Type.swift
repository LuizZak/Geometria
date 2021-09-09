/// Protocol for exclusively 3D geometric types defined by floating-point vectors
/// that form closed convex shapes.
public protocol Convex3Type: GeometricType {
    /// The floating-point vector type associated with this ``Convex3Type``.
    associatedtype Vector: Vector3FloatingPoint
    
    /// Performs an intersection test against the given line, returning up to
    /// two points representing the entrance and exit intersections against this
    /// convex shape's outer perimeter.
    func intersection<Line: Line3FloatingPoint>(with line: Line) -> ConvexLineIntersection<Vector> where Line.Vector == Vector
}
