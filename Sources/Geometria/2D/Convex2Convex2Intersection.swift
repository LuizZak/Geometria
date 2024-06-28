/// The result of a convex-2-convex-2 intersection test.
public enum Convex2Convex2Intersection<Vector: Vector2FloatingPoint> {
    /// Represents the case where the convex's boundaries are completely contained
    /// within the bounds of the other convex shape.
    case contained

    /// Represents the case where the other convex's boundaries are completely
    /// contained within the bounds of the first convex shape.
    ///
    /// Is the diametrical opposite of `.contained`.
    case contains

    /// Represents the case where the convex crosses the bounds of the convex
    /// shape on a single vertex, or tangentially, in case of spheroids.
    case singlePoint(PointNormal<Vector>)

    /// Represents cases where the convex crosses the other convex shape twice.
    case twoPoints(PointNormal<Vector>, PointNormal<Vector>)

    /// Represents the case where no intersection occurs at any point.
    case noIntersection

    /// Returns a new ``Convex2Convex2Intersection`` where any ``PointNormal`` value
    /// is mapped by a provided closure before being stored back into the same
    /// enum case and returned.
    public func mappingPointNormals(
        _ mapper: (PointNormal<Vector>, PointNormalKind) -> PointNormal<Vector>
    ) -> Convex2Convex2Intersection<Vector> {

        switch self {
        case .contained:
            return .contained

        case .contains:
            return .contains

        case .noIntersection:
            return .noIntersection

        case .singlePoint(let pointNormal):
            return .singlePoint(mapper(pointNormal, .singlePoint))

        case let .twoPoints(p1, p2):
            return .twoPoints(mapper(p1, .twoPointsFirst), mapper(p2, .twoPointsSecond))
        }
    }

    /// Returns a new ``Convex2Convex2Intersection`` where any ``PointNormal`` value
    /// is replaced by a provided closure before being stored back into the same
    /// enum case and returned.
    public func replacingPointNormals<NewVector: VectorType>(
        _ mapper: (PointNormal<Vector>, PointNormalKind) -> PointNormal<NewVector>
    ) -> Convex2Convex2Intersection<NewVector> {

        switch self {
        case .contained:
            return .contained

        case .contains:
            return .contains

        case .noIntersection:
            return .noIntersection

        case .singlePoint(let pointNormal):
            return .singlePoint(mapper(pointNormal, .singlePoint))

        case let .twoPoints(p1, p2):
            return .twoPoints(mapper(p1, .twoPointsFirst), mapper(p2, .twoPointsSecond))
        }
    }

    /// Parameter passed along point normals in ``mappingPointNormals(_:)`` and
    /// ``replacingPointNormals(_:)`` to specify to the closure which kind of point
    /// normal was provided.
    public enum PointNormalKind {
        case singlePoint
        case twoPointsFirst
        case twoPointsSecond
    }
}

extension Convex2Convex2Intersection: Equatable where Vector: Equatable { }
extension Convex2Convex2Intersection: Hashable where Vector: Hashable { }
