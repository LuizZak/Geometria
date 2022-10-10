// TODO: Add LineIntersectableType conformance

/// Protocol for N-dimensional geometric types defined by floating-point vectors
/// that form closed convex shapes which can be intersected by lines.
public protocol ConvexType: GeometricType {
    /// The floating-point vector type associated with this `ConvexType`.
    associatedtype Vector: VectorFloatingPoint
    
    /// Performs an intersection test against the given line, returning up to
    /// two points representing the entrance and exit intersections against this
    /// convex shape's outer perimeter.
    func intersection<Line: LineFloatingPoint>(
        with line: Line
    ) -> ConvexLineIntersection<Vector> where Line.Vector == Vector
}
