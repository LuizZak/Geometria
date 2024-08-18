/// The result of an intersection test between an arbitrary open shape and a
/// line, specialized for storing at most two intersection points at a time.
public enum PairLineIntersection<Vector: VectorFloatingPoint> {
    /// Represents the case where the line crosses the bounds of the shape on a
    /// single point.
    case singlePoint(LineIntersectionPointNormal<Vector>)

    /// Represents cases where the line crosses the shape twice.
    case twoPoint(LineIntersectionPointNormal<Vector>, LineIntersectionPointNormal<Vector>)

    /// Represents the case where no intersection occurs at any point.
    case noIntersection

    /// Returns the list of line intersection point normals referenced by this
    /// intersection instance.
    public var lineIntersectionPointNormals: [LineIntersectionPointNormal<Vector>] {
        switch self {
        case .noIntersection:
            return []

        case .singlePoint(let pn):
            return [pn]

        case .twoPoint(let enter, let exit):
            return [enter, exit]
        }
    }

    /// Returns the list of point normals referenced by this intersection instance.
    public var pointNormals: [PointNormal<Vector>] {
        lineIntersectionPointNormals.map(\.pointNormal)
    }

    /// Returns a new ``PairLineIntersection`` where any ``LineIntersectionPointNormal``
    /// value is mapped by a provided closure before being stored back into the
    /// same enum case and returned.
    public func mappingPointNormals(
        _ mapper: (LineIntersectionPointNormal<Vector>, LineIntersectionPointNormalKind) -> LineIntersectionPointNormal<Vector>
    ) -> PairLineIntersection<Vector> {
        switch self {
        case .noIntersection:
            return .noIntersection

        case .singlePoint(let pointNormal):
            return .singlePoint(mapper(pointNormal, .singlePoint))

        case let .twoPoint(p1, p2):
            return .twoPoint(mapper(p1, .twoPoint), mapper(p2, .twoPoint))
        }
    }

    /// Returns a new ``PairLineIntersection`` where any ``LineIntersectionPointNormal``
    /// value is replaced by a provided closure before being stored back into
    /// the same enum case and returned.
    public func replacingPointNormals<NewVector: VectorType>(
        _ mapper: (LineIntersectionPointNormal<Vector>, LineIntersectionPointNormalKind) -> LineIntersectionPointNormal<NewVector>
    ) -> PairLineIntersection<NewVector> {
        switch self {
        case .noIntersection:
            return .noIntersection

        case .singlePoint(let pointNormal):
            return .singlePoint(mapper(pointNormal, .singlePoint))

        case let .twoPoint(p1, p2):
            return .twoPoint(mapper(p1, .twoPoint), mapper(p2, .twoPoint))
        }
    }

    /// Parameter passed along point normals in ``mappingPointNormals(_:)`` and
    /// ``replacingPointNormals(_:)`` to specify to the closure which kind of point
    /// normal was provided.
    public enum LineIntersectionPointNormalKind {
        case singlePoint
        case twoPoint
    }
}

extension PairLineIntersection: Equatable where Vector: Equatable { }
extension PairLineIntersection: Hashable where Vector: Hashable { }
