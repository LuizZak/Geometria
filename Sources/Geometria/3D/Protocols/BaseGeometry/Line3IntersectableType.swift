/// Protocol for general geometric types that can be intersected with 3D lines.
public protocol Line3IntersectableType: GeometricType {
    /// The floating-point vector type associated with this ``Line3IntersectableType``.
    associatedtype Vector: Vector3FloatingPoint

    /// Performs an intersection test against the given line, returning a list
    /// of points representing the entrance and exit intersections against this
    /// shape's outer perimeter.
    ///
    /// The resulting intersection list is ordered by the order of occurrence of
    /// each intersection relative to the line's starting position.
    func intersections<Line>(with line: Line) -> LineIntersection<Vector> where Line: Line3FloatingPoint, Line.Vector == Vector
}
