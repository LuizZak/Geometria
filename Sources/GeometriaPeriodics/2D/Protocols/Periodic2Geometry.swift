import Geometria

/// A 2-dimensional periodic geometry that produces lines and circular arcs as
/// periodic simplexes.
public protocol Periodic2Geometry: PeriodicGeometry {
    /// The type of vectors used to represent geometry within this periodic
    /// geometry.
    associatedtype Vector: Vector2Real

    typealias Scalar = Vector.Scalar
    typealias Period = Vector.Scalar

    /// The simplex type produced by this periodic geometry.
    typealias Simplex = Periodic2GeometrySimplex<Vector>

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

    /// Fetches all simplexes, clamped to be within a given given half-open range
    /// within this 2-dimensional periodic geometry, ordered by their relative
    /// period within the geometry.
    ///
    /// The clamping process preserves relative positioning of points within the
    /// simplexes so that computing a point based on a period results in the
    /// same point being produced as if the simplexes where not clamped, if the
    /// point is contained within `range`.
    ///
    /// If no simplex is contained within the given range, an empty array is
    /// returned, instead.
    func clampedSimplexes(in range: Range<Period>) -> [Simplex]
}

extension Periodic2Geometry {
    public func allSimplexes(overlapping range: Range<Period>) -> [Simplex] {
        allSimplexes().filter { simplex in
            range.overlaps(simplex.periodRange)
        }
    }

    public func clampedSimplexes(in range: Range<Period>) -> [Simplex] {
        allSimplexes().compactMap { simplex in
            simplex.clamped(in: range)
        }
    }
}
