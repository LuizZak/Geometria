/// A protocol for 2D geometric types that can be queried against the closest
/// point on the geometry to a line.
public protocol ClosestPointQueryGeometry2: GeometricType {
    associatedtype Vector: Vector2FloatingPoint

    /// Returns the closest point on this geometry to a given line.
    func closestPointTo<Line: Line2FloatingPoint>(line: Line) -> ClosestPointQueryResult<Vector> where Line.Vector == Vector
}
