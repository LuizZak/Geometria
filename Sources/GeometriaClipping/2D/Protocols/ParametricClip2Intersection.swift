import Numerics

/// Contains information relating to the intersection of two solid parametric
/// geometries.
public enum ParametricClip2Intersection<Period: Hashable & FloatingPoint> {
    /// The compact information present for intersections.
    public typealias Atom = (self: Period, other: Period)

    /// An intersection that occurs at a single point.
    case singlePoint(Atom)

    /// A pair intersection- or an intersection that has an entrance and an exit
    /// on the left-hand side of the intersection.
    case pair(Atom, Atom)

    /// Gets the sequence of periods associated with this intersection result.
    public var periods: [Atom] {
        switch self {
        case .singlePoint(let atom):
            return [atom]

        case .pair(let first, let second):
            return [first, second]
        }
    }

    /// Returns `true` if `self` has a trailing periods on the intersection that
    /// matches `next`'s leading periods.
    func canCombine(withNext next: Self, tolerance: Period) -> Bool {
        guard let last = periods.last else {
            return false
        }
        guard let first = next.periods.first else {
            return false
        }

        return Self.areApproximatelyEqual(last, first, tolerance: tolerance)
    }

    /// Attempts to combine `self` with `next`, returning a single intersection
    /// if the two intersections could be combined.
    func attemptCombine(withNext next: Self, tolerance: Period) -> Self? {
        guard canCombine(withNext: next, tolerance: tolerance) else {
            return nil
        }

        switch (self, next) {
        case (.singlePoint, .singlePoint):
            return self

        case (.singlePoint(let lhs), .pair(_, let rhsTrail)):
            return .pair(lhs, rhsTrail)

        case (.pair(let lhsLead, _), .singlePoint(let rhs)):
            return .pair(lhsLead, rhs)

        case (.pair(let lhsLead, _), .pair(_, let rhsTrail)):
            return .pair(lhsLead, rhsTrail)
        }
    }

    @inlinable
    static func areApproximatelyEqual(_ lhs: Atom, _ rhs: Atom, tolerance: Period) -> Bool {
        let lead = lhs.`self`.isApproximatelyEqualFast(to: rhs.`self`, tolerance: tolerance)
        let trail = lhs.`other`.isApproximatelyEqualFast(to: rhs.`other`, tolerance: tolerance)

        return lead && trail
    }
}

extension ParametricClip2Intersection: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.singlePoint(let lhs), .singlePoint(let rhs)):
            return lhs == rhs

        case (.pair(let lhsLhs, let lhsRhs), .pair(let rhsLhs, let rhsRhs)):
            return lhsLhs == rhsLhs && lhsRhs == rhsRhs

        default:
            return false
        }
    }
}

extension ParametricClip2Intersection: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .singlePoint(let point):
            hasher.combine(0)
            hasher.combine(point.`self`)
            hasher.combine(point.other)

        case .pair(let lhs, let rhs):
            hasher.combine(1)
            hasher.combine(lhs.`self`)
            hasher.combine(lhs.other)
            hasher.combine(rhs.`self`)
            hasher.combine(rhs.other)
        }
    }
}
