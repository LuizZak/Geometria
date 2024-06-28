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

    /// A set of two or more intersection points between the two convexes.
    ///
    /// The normals are in relation to one of the convexes.
    case points([PointNormal<Vector>])

    /// Represents the case where no intersection occurs at any point.
    case noIntersection

    /// Convenience for `.points([p1, p2])`.
    @inlinable
    public static func twoPoints(_ p1: PointNormal<Vector>, _ p2: PointNormal<Vector>) -> Self {
        .points([p1, p2])
    }

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

        case .points(let points):
            return .points(points.enumerated().map({ mapper($0.element, .points(index: $0.offset)) }))
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

        case .points(let points):
            return .points(points.enumerated().map({ mapper($0.element, .points(index: $0.offset)) }))
        }
    }

    /// Parameter passed along point normals in ``mappingPointNormals(_:)`` and
    /// ``replacingPointNormals(_:)`` to specify to the closure which kind of point
    /// normal was provided.
    public enum PointNormalKind {
        case singlePoint
        case twoPointsFirst
        case twoPointsSecond
        case points(index: Int)
    }
}

extension Convex2Convex2Intersection: Equatable where Vector: Equatable { }
extension Convex2Convex2Intersection: Hashable where Vector: Hashable { }
