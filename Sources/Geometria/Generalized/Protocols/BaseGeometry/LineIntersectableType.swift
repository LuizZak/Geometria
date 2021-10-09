/// Protocol for general geometric types that can be intersected with lines.
public protocol LineIntersectableType: GeometricType {
    /// The vector type associated with this `LineIntersectableType`.
    associatedtype Vector: VectorType

    /// Performs an intersection test against the given line, returning a list
    /// of points representing the entrance and exit intersections against this
    /// shape's outer perimeter.
    ///
    /// The resulting intersection list is ordered by the order of occurrence of
    /// each intersection relative to the line's starting position.
    func intersections<Line>(with line: Line) -> LineIntersection<Vector> where Line: LineFloatingPoint, Line.Vector == Vector
}
