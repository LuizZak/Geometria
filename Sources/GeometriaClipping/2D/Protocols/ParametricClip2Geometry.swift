import Geometria

/// A 2-dimensional parametric geometry that produces lines and circular arcs as
/// parametric simplexes.
public protocol ParametricClip2Geometry: ParametricClipGeometry {
    /// The type of vectors used to represent geometry within this parametric
    /// geometry.
    associatedtype Vector: Vector2Real

    typealias Scalar = Vector.Scalar
    typealias Period = Vector.Scalar

    /// The simplex type produced by this parametric geometry.
    typealias Simplex = Parametric2GeometrySimplex<Vector>

    /// The inclusive lower bound period within this geometry.
    var startPeriod: Period { get }

    /// The exclusive upper bound period within this geometry. Must be greater
    /// than `startPeriod`.
    ///
    /// This value is not part of the addressable period range.
    var endPeriod: Period { get }

    /// Performs a point-containment check against this parametric geometry.
    func contains(_ point: Vector) -> Bool

    /// Computes the point on this parametric geometry matching a given period.
    func compute(at period: Period) -> Vector

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

    /// Performs a point-surface check against this parametric geometry, up to a
    /// given squared tolerance value.
    func isOnSurface(_ point: Vector, toleranceSquared: Scalar) -> Bool

    /// Fetches all simplexes that form this 2-dimensional parametric geometry,
    /// ordered by their relative period within the geometry.
    func allSimplexes() -> [Simplex]

    /// Fetches all simplexes that overlap a given half-open range within this
    /// 2-dimensional parametric geometry, ordered by their relative period within
    /// the geometry.
    func allSimplexes(overlapping range: Range<Period>) -> [Simplex]

    /// Fetches all simplexes, clamped to be within a given given half-open range
    /// within this 2-dimensional parametric geometry, ordered by their relative
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

    /// Returns the reverse of this parametric geometry by inverting the order
    /// and direction of each of its simplexes, while maintaining `self.startPeriod`
    /// and `self.endPeriod`.
    func reversed() -> Self
}

extension ParametricClip2Geometry {
    var periodRange: Period {
        endPeriod - startPeriod
    }

    func normalizedPeriod(_ period: Period) -> Period {
        if period >= startPeriod && period < endPeriod {
            return period
        }

        return startPeriod + period.truncatingRemainder(dividingBy: periodRange)
    }

    public func periodPrecedes(
        _ lhs: Period,
        _ rhs: Period
    ) -> Bool {
        let lhsNormalized = normalizedPeriod(lhs)
        let rhsNormalized = normalizedPeriod(rhs)

        return lhsNormalized < rhsNormalized
    }

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

    public func compute(at period: Period) -> Vector {
        let normalized = normalizedPeriod(period)

        for simplex in allSimplexes() {
            guard simplex.periodRange.contains(normalized) else {
                continue
            }

            return simplex.compute(at: normalized)
        }

        return Vector.zero
    }

    /// Gets the simplex that occupies a given period.
    public func simplex(on period: Period) -> Simplex {
        allSimplexes().filter { $0.periodRange.contains(normalizedPeriod(period)) }[0]
    }

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

public extension ParametricClip2Geometry {
    /// Returns all unique intersection periods between `self` and `other`.
    /// The resulting array of periods is guaranteed to not contain the same
    /// period value twice for all `tuple.self` and for all `tuple.other`,
    /// separately.
    ///
    /// If two intersections have a difference smaller than `tolerance`, the
    /// two intersections are elided from the result. Passing `.infinity` to
    /// `tolerance` disables this behavior.
    func allIntersectionPeriods<T: ParametricClip2Geometry>(
        _ other: T,
        tolerance: Scalar = Scalar.leastNonzeroMagnitude
    ) -> [(`self`: Period, other: Period)] where T.Vector == Vector {
        typealias Intersection = (`self`: Period, other: Period)

        func absoluteDifference<Period: FloatingPoint>(
            _ lhs: Period,
            _ rhs: Period
        ) -> Period {
            (lhs - rhs).magnitude
        }

        func smallestAbsoluteDifference(
            _ lhs: Intersection,
            _ rhs: Intersection
        ) -> Scalar {
            let selfDiff = absoluteDifference(lhs.`self`, rhs.`self`)
            let otherDiff = absoluteDifference(lhs.`other`, rhs.`other`)

            if selfDiff < otherDiff {
                return selfDiff
            } else {
                return otherDiff
            }
        }

        let selfSimplexes = self.allSimplexes()
        let otherSimplexes = other.allSimplexes()

        var allIntersections: [Intersection?] = []

        for selfSimplex in selfSimplexes {
            for otherSimplex in otherSimplexes {
                var currentIntersections: [Intersection] = []
                let intersections = selfSimplex.intersectionPeriods(with: otherSimplex)

                currentIntersections.append(contentsOf: intersections.map { intersection in
                    (
                        self: self.normalizedPeriod(intersection.`self`),
                        other: other.normalizedPeriod(intersection.other)
                    )
                })

                // Avoid adding intersections with repeated periods which may occur
                // when a geometry intersects two simplexes exactly
                allIntersections.append(contentsOf: currentIntersections.filter { intersection in
                    for case let last? in allIntersections {
                        if last.`self` == intersection.`self` {
                            return false
                        }
                        if last.other == intersection.other {
                            return false
                        }
                    }

                    return true
                })
            }
        }

        guard tolerance < .infinity else {
            var selfPeriods: Set<Period> = []
            var otherPeriods: Set<T.Period> = []

            allIntersections = allIntersections.filter { intersection in
                guard selfPeriods.insert(intersection!.`self`).inserted else {
                    return false
                }
                guard otherPeriods.insert(intersection!.other).inserted else {
                    return false
                }

                return true
            }

            return allIntersections.compactMap { $0 }
        }

        // Collapse intersections that are too close together
        let occupiedSelf = allIntersections.map(\.!.`self`).enumerated()
        let occupiedOther = allIntersections.map(\.!.`other`).enumerated()

        var hasChanged: Bool
        repeat {
            hasChanged = false

            outer:
            for (i, inter) in allIntersections.enumerated() {
                guard let inter else {
                    continue
                }

                for (n, occupiedSelf) in occupiedSelf where i != n {
                    guard absoluteDifference(inter.`self`, occupiedSelf) < tolerance else {
                        continue
                    }

                    allIntersections[i] = nil
                    hasChanged = true
                    break outer
                }

                for (n, occupiedOther) in occupiedOther where i != n {
                    guard absoluteDifference(inter.`other`, occupiedOther) < tolerance else {
                        continue
                    }

                    allIntersections[i] = nil
                    hasChanged = true
                    break outer
                }
            }
        } while hasChanged

        return allIntersections.compactMap { $0 }
    }
}