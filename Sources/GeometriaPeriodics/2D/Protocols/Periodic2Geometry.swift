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

extension Periodic2Geometry {
    public func allSimplexes(overlapping range: Range<Period>) -> [Simplex] {
        allSimplexes().filter { simplex in
            range.overlaps(simplex.periodRange)
        }
    }
}
