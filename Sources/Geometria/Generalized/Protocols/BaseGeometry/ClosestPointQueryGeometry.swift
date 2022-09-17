/// A protocol for geometric types that can be queried against the closest point
/// on the geometry to a line.
public protocol ClosestPointQueryGeometry: GeometricType {
    associatedtype Vector: VectorFloatingPoint

    /// Returns the closest point on this geometry to a given line.
    func closestPointTo<Line: LineFloatingPoint>(line: Line) -> ClosestPointQueryResult<Vector> where Line.Vector == Vector
}

/// The result of a `ClosestPointQueryGeometry.closestPointTo(line:)` query.
public enum ClosestPointQueryResult<Vector: VectorFloatingPoint>: Equatable {
    /// Indicates the line intersects the geometry.
    case intersection

    /// Indicates that a given vector is the closest point on the geometry to the
    /// line. Implies that the vector is not colinear with the line.
    case closest(Vector)

    var vector: Vector? {
        switch self {
        case .intersection:
            return nil
        case .closest(let vector):
            return vector
        }
    }
}
