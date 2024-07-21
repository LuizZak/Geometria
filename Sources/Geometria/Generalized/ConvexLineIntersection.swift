/// The result of a convex-line intersection test.
public enum ConvexLineIntersection<Vector: VectorFloatingPoint> {
    /// Represents the case where the line's boundaries are completely contained
    /// within the bounds of the convex shape.
    case contained

    /// Represents the case where the line crosses the bounds of the convex
    /// shape on a single vertex, or tangentially, in case of spheroids.
    case singlePoint(LineIntersectionPointNormal<Vector>)

    /// Represents cases where the line starts outside the shape and crosses in
    /// before ending within the shape's bounds.
    case enter(LineIntersectionPointNormal<Vector>)

    /// Represents cases where the line starts within the convex shape and
    /// intersects the boundaries on the way out.
    case exit(LineIntersectionPointNormal<Vector>)

    /// Represents cases where the line crosses the convex shape twice: Once on
    /// the way in, and once again on the way out.
    case enterExit(LineIntersectionPointNormal<Vector>, LineIntersectionPointNormal<Vector>)

    /// Represents the case where no intersection occurs at any point.
    case noIntersection

    /// Returns the list of line intersection point normals referenced by this
    /// intersection instance.
    public var lineIntersectionPointNormals: [LineIntersectionPointNormal<Vector>] {
        switch self {
        case .contained, .noIntersection:
            return []

        case .singlePoint(let pn), .enter(let pn), .exit(let pn):
            return [pn]

        case .enterExit(let enter, let exit):
            return [enter, exit]
        }
    }

    /// Returns the list of point normals referenced by this intersection instance.
    public var pointNormals: [PointNormal<Vector>] {
        lineIntersectionPointNormals.map(\.pointNormal)
    }

    /// Returns a new ``ConvexLineIntersection`` where any ``LineIntersectionPointNormal``
    /// value is mapped by a provided closure before being stored back into the
    /// same enum case and returned.
    public func mappingPointNormals(
        _ mapper: (LineIntersectionPointNormal<Vector>, LineIntersectionPointNormalKind) -> LineIntersectionPointNormal<Vector>
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

    /// Returns a new ``ConvexLineIntersection`` where any ``LineIntersectionPointNormal``
    /// value is replaced by a provided closure before being stored back into
    /// the same enum case and returned.
    public func replacingPointNormals<NewVector: VectorType>(
        _ mapper: (LineIntersectionPointNormal<Vector>, LineIntersectionPointNormalKind) -> LineIntersectionPointNormal<NewVector>
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
    public enum LineIntersectionPointNormalKind {
        case singlePoint
        case enter
        case exit
    }
}

extension ConvexLineIntersection: Equatable where Vector: Equatable { }
extension ConvexLineIntersection: Hashable where Vector: Hashable { }
