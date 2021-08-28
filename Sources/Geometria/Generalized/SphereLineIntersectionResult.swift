// TODO: Generalize into convex-polygon-line intersection result value?

/// The result of a sphere-line intersection test.
public enum SphereLineIntersectionResult<Vector: VectorType> {
    /// Represents the case where the line's boundaries are completely contained
    /// within the bounds of the sphere
    case contained
    
    /// Represents the case where the line crosses the bounds of the sphere
    /// tangentially, on a given point.
    case tangent(Vector)
    
    /// Represents cases where the line starts within the sphere and crosses
    /// out, or starts outside the sphere and crosses in before ending within
    /// the sphere's bounds.
    case singlePoint(Vector)
    
    /// Represents cases where the line crosses the sphere twice: Once on the
    /// way in, and once again on the way out of the sphere.
    case dualPoint(Vector, Vector)
    
    /// Represents the case where no intersection occurs at any point.
    case noIntersection
}

extension SphereLineIntersectionResult: Equatable where Vector: Equatable { }
extension SphereLineIntersectionResult: Hashable where Vector: Hashable { }
extension SphereLineIntersectionResult: Encodable where Vector: Encodable { }
extension SphereLineIntersectionResult: Decodable where Vector: Decodable { }
