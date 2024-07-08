import Geometria

/// Used to represent a traversal state through intersections of two parametric
/// geometries.
///
/// The state always keeps track of the equivalency of periods during intersections,
/// and each case indicates which geometry to follow in subsequent
/// `IntersectionLookup.next()`/`.previous()` calls.
enum State<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>: Hashable where T1.Period == T2.Period {
    /// The current intersection point is being examined on the left-hand side
    /// geometry.
    case onLhs(T1.Period, T2.Period)

    /// The current intersection point is being examined on the right-hand side
    /// geometry.
    case onRhs(T1.Period, T2.Period)

    /// Returns `true` if `self` is a `onLhs` case.
    var isLhs: Bool {
        switch self {
        case .onLhs: return true
        case .onRhs: return false
        }
    }

    /// Returns `true` if `self` is a `onRhs` case.
    var isRhs: Bool {
        switch self {
        case .onLhs: return false
        case .onRhs: return true
        }
    }

    /// Returns the active period, depending on whether this state is on the
    /// left-hand side or right-hand side of the state period.
    var activePeriod: T1.Period {
        switch self {
        case .onLhs(let period, _),
            .onRhs(_, let period):
            return period
        }
    }

    /// Returns the left-hand side period of this state.
    var lhsPeriod: T1.Period {
        switch self {
        case .onLhs(let lhs, _), .onRhs(let lhs, _):
            return lhs
        }
    }

    /// Returns the right-hand side period of this state.
    var rhsPeriod: T1.Period {
        switch self {
        case .onLhs(_, let rhs), .onRhs(_, let rhs):
            return rhs
        }
    }

    /// Flips the left-hand/right-handed-ness of this state, without changing its
    /// period values.
    func flipped() -> Self {
        switch self {
        case .onLhs(let lhs, let rhs):
            return .onRhs(lhs, rhs)

        case .onRhs(let lhs, let rhs):
            return .onLhs(lhs, rhs)
        }
    }

    /// Hashes the contents of this state.
    ///
    /// - note: Only hashes the contents of the active period, along with a
    /// discriminator for the handedness of the enumeration.
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

    /// Equates the contents of two State values.
    ///
    /// - note: Only compares the contents of the active period of each state.
    /// If the states are pointing to different handednesses, returns `false`.
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
