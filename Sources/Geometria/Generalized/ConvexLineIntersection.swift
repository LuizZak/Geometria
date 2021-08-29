/// The result of a convex-line intersection test.
public enum ConvexLineIntersection<Vector: VectorType> {
    /// Represents the case where the line's boundaries are completely contained
    /// within the bounds of the convex shape.
    case contained
    
    /// Represents the case where the line crosses the bounds of the convex
    /// shape on a single vertex, or tangentially, in case of spheroids.
    case singlePoint(Vector)
    
    /// Represents cases where the line starts outside the shape and crosses in
    /// before ending within the shape's bounds.
    case enter(Vector)
    
    /// Represents cases where the line starts within the convex shape and
    /// intersects the boundaries on the way out.
    case exit(Vector)
    
    /// Represents cases where the line crosses the convex shape twice: Once on
    /// the way in, and once again on the way out.
    case enterExit(Vector, Vector)
    
    /// Represents the case where no intersection occurs at any point.
    case noIntersection
}

extension ConvexLineIntersection: Equatable where Vector: Equatable { }
extension ConvexLineIntersection: Hashable where Vector: Hashable { }

#if swift(>=5.5)
extension ConvexLineIntersection: Encodable where Vector: Encodable { }
extension ConvexLineIntersection: Decodable where Vector: Decodable { }
#endif
