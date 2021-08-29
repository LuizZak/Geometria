/// Protocol for geometric types defined by floating-point vectors that form
/// closed convex shapes.
public protocol ConvexType {
    associatedtype Vector: VectorFloatingPoint
    
    /// Performs an intersection test against the given line, returning up to
    /// two points representing the entrance and exit intersections against this
    /// convex shape's outer perimeter.
    func intersection<Line: LineFloatingPoint>(with line: Line) -> ConvexLineIntersection<Vector> where Line.Vector == Vector
}
