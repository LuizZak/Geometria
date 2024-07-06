import Geometria

/// A 2-dimensional periodic geometry that produces lines and circular arcs as
/// periodic simplexes.
public protocol Periodic2Geometry: PeriodicGeometry {
    /// The type of vectors used to represent geometry within this periodic
    /// geometry.
    associatedtype Vector: Vector2Real

    /// The type of period that this periodic geometry uses to refer to its
    /// ordered simplexes.
    associatedtype Period: PeriodType

    /// The simplex type produced by this periodic geometry.
    typealias Simplex = Periodic2GeometrySimplex<Period, Vector>

    typealias Scalar = Vector.Scalar

    /// The inclusive lower bound period within this geometry.
    var startPeriod: Period { get }

    /// The exclusive upper bound period within this geometry. Must be greater
    /// than `startPeriod`.
    ///
    /// This value is not part of the addressable period range.
    var endPeriod: Period { get }

    /// Performs a point-containment check against this periodic geometry.
    func contains(_ point: Vector) -> Bool

    /// Performs a point-surface check against this periodic geometry, up to a
    /// given tolerance value.
    func isOnSurface(_ point: Vector, tolerance: Scalar) -> Bool

    /// Fetches all simplexes that form this 2-dimensional periodic geometry,
    /// ordered by their relative period within the geometry.
    func allSimplexes() -> [Simplex]

    /// Fetches all simplexes that overlap a given half-open range within this
    /// 2-dimensional periodic geometry, ordered by their relative period within
    /// the geometry.
    func allSimplexes(overlapping range: Range<Period>) -> [Simplex]
}

/// The periodic simplex type produced by a `Periodic2Geometry`.
public enum Periodic2GeometrySimplex<Period: PeriodType, Vector: Vector2Real>: Periodic2Simplex {
    /// A circular arc simplex.
    case circleArc2(CircleArc2Simplex<Period, Vector>)

    /// A line segment simplex.
    case lineSegment2(LineSegment2Simplex<Period, Vector>)

    /// Returns the start period of the underlying simplex contained within this
    /// enumeration.
    public var startPeriod: Period {
        switch self {
        case .circleArc2(let simplex): return simplex.startPeriod
        case .lineSegment2(let simplex): return simplex.startPeriod
        }
    }

    /// Returns the end period of the underlying simplex contained within this
    /// enumeration.
    public var endPeriod: Period {
        switch self {
        case .circleArc2(let simplex): return simplex.endPeriod
        case .lineSegment2(let simplex): return simplex.endPeriod
        }
    }

    /// Returns the start point of the underlying simplex contained within this
    /// enumeration.
    public var start: Vector {
        switch self {
        case .circleArc2(let simplex): return simplex.start
        case .lineSegment2(let simplex): return simplex.start
        }
    }

    /// Returns the end point of the underlying simplex contained within this
    /// enumeration.
    public var end: Vector {
        switch self {
        case .circleArc2(let simplex): return simplex.end
        case .lineSegment2(let simplex): return simplex.end
        }
    }

    // TODO: Implement period-returning intersection method
    // func intersectionPeriods(with other: Self) -> [Period] { ... }
}

extension Periodic2Geometry {
    public func allSimplexes(overlapping range: Range<Period>) -> [Simplex] {
        allSimplexes().filter { simplex in
            range.overlaps(simplex.periodRange)
        }
    }
}
