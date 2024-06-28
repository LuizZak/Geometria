/// The result of a convex-line intersection test.
public enum ConvexLineIntersection<Vector: VectorFloatingPoint> {
    /// Represents the case where the line's boundaries are completely contained
    /// within the bounds of the convex shape.
    case contained

    /// Represents the case where the line crosses the bounds of the convex
    /// shape on a single vertex, or tangentially, in case of spheroids.
    case singlePoint(PointNormal<Vector>)

    /// Represents cases where the line starts outside the shape and crosses in
    /// before ending within the shape's bounds.
    case enter(PointNormal<Vector>)

    /// Represents cases where the line starts within the convex shape and
    /// intersects the boundaries on the way out.
    case exit(PointNormal<Vector>)

    /// Represents cases where the line crosses the convex shape twice: Once on
    /// the way in, and once again on the way out.
    case enterExit(PointNormal<Vector>, PointNormal<Vector>)

    /// Represents the case where no intersection occurs at any point.
    case noIntersection

    /// Returns a new ``ConvexLineIntersection`` where any ``PointNormal`` value
    /// is mapped by a provided closure before being stored back into the same
    /// enum case and returned.
    public func mappingPointNormals(
        _ mapper: (PointNormal<Vector>, PointNormalKind) -> PointNormal<Vector>
    ) -> ConvexLineIntersection<Vector> {

        switch self {
        case .contained:
            return .contained

        case .noIntersection:
            return .noIntersection

        case .singlePoint(let pointNormal):
            return .singlePoint(mapper(pointNormal, .singlePoint))

        case .enter(let pointNormal):
            return .enter(mapper(pointNormal, .enter))

        case .exit(let pointNormal):
            return .exit(mapper(pointNormal, .exit))

        case let .enterExit(p1, p2):
            return .enterExit(mapper(p1, .enter), mapper(p2, .exit))
        }
    }

    /// Returns a new ``ConvexLineIntersection`` where any ``PointNormal`` value
    /// is replaced by a provided closure before being stored back into the same
    /// enum case and returned.
    public func replacingPointNormals<NewVector: VectorType>(
        _ mapper: (PointNormal<Vector>, PointNormalKind) -> PointNormal<NewVector>
    ) -> ConvexLineIntersection<NewVector> {

        switch self {
        case .contained:
            return .contained

        case .noIntersection:
            return .noIntersection

        case .singlePoint(let pointNormal):
            return .singlePoint(mapper(pointNormal, .singlePoint))

        case .enter(let pointNormal):
            return .enter(mapper(pointNormal, .enter))

        case .exit(let pointNormal):
            return .exit(mapper(pointNormal, .exit))

        case let .enterExit(p1, p2):
            return .enterExit(mapper(p1, .enter), mapper(p2, .exit))
        }
    }

    /// Parameter passed along point normals in ``mappingPointNormals(_:)`` and
    /// ``replacingPointNormals(_:)`` to specify to the closure which kind of point
    /// normal was provided.
    public enum PointNormalKind {
        case singlePoint
        case enter
        case exit
    }
}

extension ConvexLineIntersection: Equatable where Vector: Equatable { }
extension ConvexLineIntersection: Hashable where Vector: Hashable { }
