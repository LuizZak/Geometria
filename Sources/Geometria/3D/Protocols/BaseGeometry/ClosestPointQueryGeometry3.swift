/// A protocol for 3D geometric types that can be queried against the closest
/// point on the geometry to a line.
public protocol ClosestPointQueryGeometry3: GeometricType {
    associatedtype Vector: Vector3FloatingPoint

    /// Returns the closest point on this geometry to a given line.
    func closestPointTo<Line: Line3FloatingPoint>(line: Line) -> ClosestPointQueryResult<Vector> where Line.Vector == Vector
}
