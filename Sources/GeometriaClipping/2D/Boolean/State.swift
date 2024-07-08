import Geometria

/// Used to represent a traversal state through intersections of two parametric
/// geometries.
///
/// The state always keeps track of the equivalency of periods during intersections,
/// and each case indicates which geometry to follow in subsequent
/// `IntersectionLookup.next()`/`.previous()` calls.
enum State<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>: Hashable where T1.Period == T2.Period {
    case onLhs(T1.Period, T2.Period)
    case onRhs(T1.Period, T2.Period)

    var isLhs: Bool {
        switch self {
        case .onLhs: return true
        case .onRhs: return false
        }
    }

    var isRhs: Bool {
        switch self {
        case .onLhs: return false
        case .onRhs: return true
        }
    }

    var activePeriod: T1.Period {
        switch self {
        case .onLhs(let period, _),
            .onRhs(_, let period):
            return period
        }
    }

    var lhsPeriod: T1.Period {
        switch self {
        case .onLhs(let lhs, _), .onRhs(let lhs, _):
            return lhs
        }
    }

    var rhsPeriod: T1.Period {
        switch self {
        case .onLhs(_, let rhs), .onRhs(_, let rhs):
            return rhs
        }
    }

    func flipped() -> Self {
        switch self {
        case .onLhs(let lhs, let rhs):
            return .onRhs(lhs, rhs)

        case .onRhs(let lhs, let rhs):
            return .onLhs(lhs, rhs)
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case .onLhs(let value, _):
            hasher.combine(0)
            hasher.combine(value)

        case .onRhs(_, let value):
            hasher.combine(1)
            hasher.combine(value)
        }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs.isLhs, rhs.isLhs) {
        case (true, true):
            return lhs.lhsPeriod == rhs.lhsPeriod

        case (false, false):
            return lhs.rhsPeriod == rhs.rhsPeriod

        default:
            return false
        }
    }
}
