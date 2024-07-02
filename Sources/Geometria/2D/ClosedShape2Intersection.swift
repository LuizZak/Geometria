/// The result of a intersection test against two 2-dimensional closed shapes.
public enum ClosedShape2Intersection<Vector: Vector2FloatingPoint> {
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

    /// A sequence of one or more intersection pairs of points that represent
    /// the entrance and exit points of the intersection in relation to one of
    /// the convexes.
    case pairs([Pair])

    /// Represents the case where no intersection occurs at any point.
    case noIntersection

    /// Convenience for `.pairs([.init(enter: p1, exit: p2)])`.
    @inlinable
    public static func twoPoints(
        _ p1: PointNormal<Vector>,
        _ p2: PointNormal<Vector>
    ) -> Self {
        .pairs([
            .init(enter: p1, exit: p2)
        ])
    }

    /// Returns a new ``ClosedShape2Intersection`` where any ``PointNormal`` value
    /// is mapped by a provided closure before being stored back into the same
    /// enum case and returned.
    public func mappingPointNormals(
        _ mapper: (PointNormal<Vector>, PointNormalKind) -> PointNormal<Vector>
    ) -> Self {

        switch self {
        case .contained:
            return .contained

        case .contains:
            return .contains

        case .noIntersection:
            return .noIntersection

        case .singlePoint(let pointNormal):
            return .singlePoint(mapper(pointNormal, .singlePoint))

        case .pairs(let pairs):
            return .pairs(pairs.enumerated().map({ pair in
                .init(
                    enter: mapper(pair.element.enter, .pairEnter(index: pair.offset)),
                    exit: mapper(pair.element.exit, .pairExit(index: pair.offset))
                )
            }))
        }
    }

    /// Returns a new ``ClosedShape2Intersection`` where any ``PointNormal`` value
    /// is replaced by a provided closure before being stored back into the same
    /// enum case and returned.
    public func replacingPointNormals<NewVector: VectorType>(
        _ mapper: (PointNormal<Vector>, PointNormalKind) -> PointNormal<NewVector>
    ) -> ClosedShape2Intersection<NewVector> {

        switch self {
        case .contained:
            return .contained

        case .contains:
            return .contains

        case .noIntersection:
            return .noIntersection

        case .singlePoint(let pointNormal):
            return .singlePoint(mapper(pointNormal, .singlePoint))

        case .pairs(let pairs):
            return .pairs(pairs.enumerated().map { pair in
                .init(
                    enter: mapper(pair.element.enter, .pairEnter(index: pair.offset)),
                    exit: mapper(pair.element.exit, .pairExit(index: pair.offset))
                )
            })
        }
    }

    /// A pair of entrance/exit intersection points.
    ///
    /// The definition of entrance/exit is dependant on the shapes intersected,
    /// and the only requirement is that within the same `ClosedShape2Intersection`,
    /// each pair is expected to be connectable entrance-to-exit with its
    /// succeeding pair.
    public struct Pair {
        /// The entrance point of the intersection.
        public var enter: PointNormal<Vector>

        /// The exit point of the intersection.
        public var exit: PointNormal<Vector>

        public init(enter: PointNormal<Vector>, exit: PointNormal<Vector>) {
            self.enter = enter
            self.exit = exit
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
        case pairEnter(index: Int)
        case pairExit(index: Int)
    }
}

extension ClosedShape2Intersection.Pair: Equatable where Vector: Equatable { }
extension ClosedShape2Intersection.Pair: Hashable where Vector: Hashable { }

extension ClosedShape2Intersection: Equatable where Vector: Equatable { }
extension ClosedShape2Intersection: Hashable where Vector: Hashable { }
