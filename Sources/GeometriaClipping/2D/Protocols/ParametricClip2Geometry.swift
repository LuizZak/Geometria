import Geometria

/// A 2-dimensional parametric geometry that produces lines and circular arcs as
/// parametric simplexes.
public protocol ParametricClip2Geometry<Vector>: ParametricClipGeometry {
    /// The type of vectors used to represent geometry within this parametric
    /// geometry.
    associatedtype Vector: Vector2Real

    typealias Scalar = Vector.Scalar
    typealias Period = Vector.Scalar

    /// The simplex type produced by this parametric geometry.
    typealias Simplex = Parametric2GeometrySimplex<Vector>
    /// The contour type produced by this parametric geometry.
    typealias Contour = Parametric2Contour<Vector>

    /// The inclusive lower bound period within this geometry.
    var startPeriod: Period { get }

    /// The exclusive upper bound period within this geometry. Must be greater
    /// than `startPeriod`.
    ///
    /// This value is not part of the addressable period range.
    var endPeriod: Period { get }

    /// Gets the bounds for this parametric geometry.
    var bounds: AABB<Vector> { get }

    /// Gets all contours that make up this parametric geometry.
    ///
    /// Contours are ordered according to their containment incidence: A contour
    /// that is contained in another appears later in the array than the containing
    /// contour.
    func allContours() -> [Contour]

    /// Performs a point-containment check against this parametric geometry.
    func contains(_ point: Vector) -> Bool

    /// Returns `true` if the given periods have a precedence of `lhs < rhs`.
    ///
    /// Periods are first normalized to be within `startPeriod` and `endPeriod`
    /// before the comparison.
    func periodPrecedes(_ lhs: Period, _ rhs: Period) -> Bool

    /// Returns `true` if the given periods have a precedence of `start < lhs < rhs`.
    ///
    /// Periods are first normalized to be within `startPeriod` and `endPeriod`
    /// before the comparison.
    func periodPrecedes(from start: Period, _ lhs: Period, _ rhs: Period) -> Bool

    /// Returns the reverse of this parametric geometry by inverting the order
    /// and direction of each of its simplexes, while maintaining `self.startPeriod`
    /// and `self.endPeriod`.
    func reversed() -> Self

    /// Performs a point-surface check against this parametric geometry, up to a
    /// given squared tolerance value.
    func isOnSurface(_ point: Vector, toleranceSquared: Scalar) -> Bool
}

extension ParametricClip2Geometry {
    @inlinable
    var periodRange: Period {
        endPeriod - startPeriod
    }

    @inlinable
    public var bounds: AABB<Vector> {
        AABB(aabbs: self.allContours().map(\.bounds))
    }

    @inlinable
    func normalizedPeriod(_ period: Period) -> Period {
        if period >= startPeriod && period < endPeriod {
            return period
        }

        return startPeriod + period.truncatingRemainder(dividingBy: periodRange)
    }

    @inlinable
    public func periodPrecedes(
        _ lhs: Period,
        _ rhs: Period
    ) -> Bool {
        let lhsNormalized = normalizedPeriod(lhs)
        let rhsNormalized = normalizedPeriod(rhs)

        return lhsNormalized < rhsNormalized
    }

    @inlinable
    public func periodPrecedes(
        from start: Period,
        _ lhs: Period,
        _ rhs: Period
    ) -> Bool {
        let startNormalized = normalizedPeriod(start)
        let lhsNormalized = normalizedPeriod(lhs)
        let rhsNormalized = normalizedPeriod(rhs)

        return startNormalized < lhsNormalized && lhsNormalized < rhsNormalized
    }

    @inlinable
    public func contains(_ point: Vector) -> Bool {
        for contour in allContours().reversed() {
            if contour.contains(point) {
                switch contour.winding {
                case .clockwise:
                    return true

                case .counterClockwise:
                    return false
                }
            }
        }

        return false
    }

    @inlinable
    public func isOnSurface(_ point: Vector, toleranceSquared: Scalar) -> Bool {
        for contour in allContours() {
            if contour.isOnSurface(point, toleranceSquared: toleranceSquared) {
                return true
            }
        }

        return false
    }
}
