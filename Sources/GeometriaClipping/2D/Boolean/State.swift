import Geometria

/// Used to represent a traversal state through intersections of two parametric
/// geometries.
///
/// The state always keeps track of the equivalency of periods during intersections,
/// and each case indicates which geometry to follow in subsequent
/// `IntersectionLookup.next()`/`.previous()` calls.
enum State<Period: Hashable>: Hashable {
    /// The current intersection point is being examined on the left-hand side
    /// geometry.
    case onLhs(Period, lhsIndex: Int, Period, rhsIndex: Int)

    /// The current intersection point is being examined on the right-hand side
    /// geometry.
    case onRhs(Period, lhsIndex: Int, Period, rhsIndex: Int)

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
    var activePeriod: Period {
        switch self {
        case .onLhs(let period, _, _, _),
            .onRhs(_, _, let period, _):
            return period
        }
    }

    /// Returns the left-hand side period of this state.
    var lhsPeriod: Period {
        switch self {
        case .onLhs(let lhs, _, _, _), .onRhs(let lhs, _, _, _):
            return lhs
        }
    }

    /// Returns the left-hand side index of this state.
    var lhsIndex: Int {
        switch self {
        case .onLhs(_, let lhsIndex, _, _), .onRhs(_, let lhsIndex, _, _):
            return lhsIndex
        }
    }

    /// Returns the right-hand side period of this state.
    var rhsPeriod: Period {
        switch self {
        case .onLhs(_, _, let rhs, _), .onRhs(_, _, let rhs, _):
            return rhs
        }
    }

    /// Returns the right-hand side index of this state.
    var rhsIndex: Int {
        switch self {
        case .onLhs(_, _, _, let rhsIndex), .onRhs(_, _, _, let rhsIndex):
            return rhsIndex
        }
    }

    /// Flips the left-hand/right-handed-ness of this state, without changing its
    /// period values.
    ///
    /// Effectively changes the focused geometry from lhs to rhs.
    func flipped() -> Self {
        switch self {
        case .onLhs(let lhs, let lhsIndex, let rhs, let rhsIndex):
            return .onRhs(lhs, lhsIndex: lhsIndex, rhs, rhsIndex: rhsIndex)

        case .onRhs(let lhs, let lhsIndex, let rhs, let rhsIndex):
            return .onLhs(lhs, lhsIndex: lhsIndex, rhs, rhsIndex: rhsIndex)
        }
    }

    /// Hashes the contents of this state.
    ///
    /// - note: Only hashes the contents of the active period, along with a
    /// discriminator for the handedness of the enumeration.
    func hash(into hasher: inout Hasher) {
        switch self {
        case .onLhs(let value, let index, _, _):
            hasher.combine(0)
            hasher.combine(value)
            hasher.combine(index)

        case .onRhs(_, _, let value, let index):
            hasher.combine(1)
            hasher.combine(value)
            hasher.combine(index)
        }
    }

    /// Equates the contents of two State values.
    ///
    /// - note: Only compares the contents of the active period of each state.
    /// If the states are pointing to different handednesses, returns `false`.
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs.isLhs, rhs.isLhs) {
        case (true, true):
            return lhs.lhsPeriod == rhs.lhsPeriod && lhs.lhsIndex == rhs.lhsIndex

        case (false, false):
            return lhs.rhsPeriod == rhs.rhsPeriod && lhs.rhsIndex == rhs.rhsIndex

        default:
            return false
        }
    }
}
