/// The result of a `ClosestPointQueryGeometry2/3/4.closestPointTo(line:)` query.
public enum ClosestPointQueryResult<Vector: VectorFloatingPoint>: Equatable {
    /// Indicates the line intersects the geometry.
    case intersection

    /// Indicates that a given vector is the closest point on the geometry to the
    /// line. Implies that the vector is not colinear with the line.
    case closest(Vector)

    /// If this query result is `.closest(vector)`, returns the value of `vector`,
    /// otherwise returns `nil`.
    public var vector: Vector? {
        switch self {
        case .intersection:
            return nil
        case .closest(let vector):
            return vector
        }
    }
}
