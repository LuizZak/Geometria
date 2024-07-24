import Geometria

/// The parametric simplex type produced by a `ParametricClip2Geometry`.
public enum Parametric2GeometrySimplex<Vector: Vector2Real>: Parametric2Simplex, Equatable {
    public typealias Scalar = Vector.Scalar

    /// A circular arc simplex.
    case circleArc2(CircleArc2Simplex<Vector>)

    /// A line segment simplex.
    case lineSegment2(LineSegment2Simplex<Vector>)

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

    @usableFromInline
    var lengthSquared: Vector.Scalar {
        switch self {
        case .circleArc2(let simplex): return simplex.lengthSquared
        case .lineSegment2(let simplex): return simplex.lengthSquared
        }
    }

    public var bounds: AABB2<Vector> {
        switch self {
        case .circleArc2(let simplex): return simplex.bounds
        case .lineSegment2(let simplex): return simplex.bounds
        }
    }

    public func compute(at period: Period) -> Vector {
        switch self {
        case .lineSegment2(let lineSegment):
            return lineSegment.compute(at: period)

        case .circleArc2(let circleArc):
            return circleArc.compute(at: period)
        }
    }

    public func isOnSurface(_ vector: Vector, toleranceSquared: Scalar) -> Bool {
        switch self {
        case .lineSegment2(let lineSegment):
            return lineSegment.isOnSurface(vector, toleranceSquared: toleranceSquared)

        case .circleArc2(let circleArc):
            return circleArc.isOnSurface(vector, toleranceSquared: toleranceSquared)
        }
    }

    public func closestPeriod(to vector: Vector) -> Period {
        switch self {
        case .lineSegment2(let lineSegment):
            return lineSegment.closestPeriod(to: vector)

        case .circleArc2(let circleArc):
            return circleArc.closestPeriod(to: vector)
        }
    }

    /// Returns `startPeriod + (endPeriod - startPeriod) * ratio`.
    ///
    /// - note: The result is unclamped.
    @inlinable
    func period(onRatio ratio: Scalar) -> Period {
        startPeriod + (endPeriod - startPeriod) * ratio
    }

    /// Clamps this simplex so its contained geometry is only present within a
    /// given period range.
    ///
    /// If the geometry is not available on the given range, `nil` is returned,
    /// instead.
    public func clamped(in range: Range<Period>) -> Self? {
        if startPeriod >= range.upperBound || endPeriod <= range.lowerBound {
            return nil
        }

        switch self {
        case .lineSegment2(let lineSegment):
            guard let lineSegment = lineSegment.clamped(in: range) else {
                return nil
            }

            return .lineSegment2(lineSegment)

        case .circleArc2(let circleArc):
            guard let circleArc = circleArc.clamped(in: range) else {
                return nil
            }

            return .circleArc2(circleArc)
        }
    }

    // MARK: - Intersection

    /// Returns a list of pairs for periods where `self` and `other` intersect
    /// in space.
    ///
    /// If `self` and `other` do not intersect, an empty array is returned,
    /// instead.
    @inlinable
    public func intersectionPeriods(with other: Self) -> [(`self`: Period, other: Period)] {
        switch (self, other) {
        case (.lineSegment2(let lhs), .lineSegment2(let rhs)):
            // MARK: Line / Line
            guard let intersection = lhs.lineSegment.intersection(with: rhs.lineSegment) else {
                return []
            }
            guard
                Self.isWithinAbsoluteBounds(intersection.line1NormalizedMagnitude),
                Self.isWithinAbsoluteBounds(intersection.line2NormalizedMagnitude)
            else {
                return []
            }

            let period1 = self.period(onRatio: intersection.line1NormalizedMagnitude)
            let period2 = other.period(onRatio: intersection.line2NormalizedMagnitude)

            return [(period1, period2)]

        case (.lineSegment2(let lhs), .circleArc2(let rhs)):
            // MARK: Line / Arc
            let intersections = rhs.circleArc.intersections(with: lhs.lineSegment).intersections
            return intersections.compactMap { intersection in
                let period1 = self.period(onRatio: intersection.lineIntersectionPointNormal.normalizedMagnitude)

                guard
                    let circleArcPeriod = Self.circleArcIntersectionRatio(
                        rhs,
                        intersection: intersection
                    ),
                    Self.isWithinAbsoluteBounds(circleArcPeriod)
                else {
                    return nil
                }
                let period2 = other.period(onRatio: circleArcPeriod)

                return (period1, period2)
            }

        case (.circleArc2(let lhs), .lineSegment2(let rhs)):
            // MARK: Arc / Line
            let intersections = lhs.circleArc.intersections(with: rhs.lineSegment).intersections
            return intersections.compactMap { intersection in
                guard
                    let circleArcPeriod = Self.circleArcIntersectionRatio(
                        lhs,
                        intersection: intersection
                    ),
                    Self.isWithinAbsoluteBounds(circleArcPeriod)
                else {
                    return nil
                }
                let period1 = self.period(onRatio: circleArcPeriod)

                let period2 = other.period(onRatio: intersection.lineIntersectionPointNormal.normalizedMagnitude)

                return (period1, period2)
            }

        case (.circleArc2(let lhs), .circleArc2(let rhs)):
            // MARK: Arc / Arc
            let intersections =
                lhs.asCircle2
                .intersection(with: rhs.asCircle2)
                .pointNormals

            return intersections.compactMap { intersection in
                guard
                    let selfPeriod = Self.circleArcIntersectionRatio(
                        lhs,
                        intersection: intersection
                    ),
                    Self.isWithinAbsoluteBounds(selfPeriod)
                else {
                    return nil
                }
                let period1 = self.period(onRatio: selfPeriod)

                guard
                    let otherPeriod = Self.circleArcIntersectionRatio(
                        rhs,
                        intersection: intersection
                    ),
                    Self.isWithinAbsoluteBounds(otherPeriod)
                else {
                    return nil
                }
                let period2 = other.period(onRatio: otherPeriod)

                return (period1, period2)
            }
        }
    }

    // MARK: -

    public func reversed() -> Self {
        switch self {
        case .lineSegment2(let simplex):
            return .lineSegment2(simplex.reversed())

        case .circleArc2(let simplex):
            return .circleArc2(simplex.reversed())
        }
    }

    /// Reverses this simplex, also reversing its start/end period according to
    /// the given global start/end periods.
    public func reversed(globalStartPeriod: Period, globalEndPeriod: Period) -> Self {
        switch self {
        case .lineSegment2(let simplex):
            var simplex = simplex.reversed()

            let toEnd = globalEndPeriod - simplex.endPeriod
            let toStart = simplex.startPeriod - globalStartPeriod

            simplex.startPeriod = toEnd
            simplex.endPeriod = globalEndPeriod - toStart

            return .lineSegment2(simplex)

        case .circleArc2(let simplex):
            var simplex = simplex.reversed()

            let toEnd = globalEndPeriod - simplex.endPeriod
            let toStart = simplex.startPeriod - globalStartPeriod

            simplex.startPeriod = toEnd
            simplex.endPeriod = globalEndPeriod - toStart

            return .circleArc2(simplex)
        }
    }

    @inlinable
    static func isWithinAbsoluteBounds(_ period: Period) -> Bool {
        period >= .zero && period < 1
    }

    @inlinable
    static func circleArcIntersectionRatio(
        _ circleArc: CircleArc2Simplex<Vector>,
        intersection: LineIntersection<Vector>.Intersection
    ) -> Period? {
        return circleArcIntersectionRatio(
            circleArc.circleArc,
            intersection: intersection.lineIntersectionPointNormal
        )
    }

    @inlinable
    static func circleArcIntersectionRatio(
        _ circleArc: CircleArc2Simplex<Vector>,
        intersection: LineIntersectionPointNormal<Vector>
    ) -> Period? {
        return circleArcIntersectionRatio(
            circleArc.circleArc,
            intersection: intersection
        )
    }

    @inlinable
    static func circleArcIntersectionRatio(
        _ circleArc: CircleArc2Simplex<Vector>,
        intersection: PointNormal<Vector>
    ) -> Period? {
        return circleArcIntersectionRatio(
            circleArc.circleArc,
            intersection: intersection
        )
    }

    @inlinable
    static func circleArcIntersectionRatio(
        _ circleArc: CircleArc2<Vector>,
        intersection: LineIntersectionPointNormal<Vector>
    ) -> Period? {
        return circleArcIntersectionRatio(
            circleArc,
            intersection: intersection.pointNormal
        )
    }

    @inlinable
    static func circleArcIntersectionRatio(
        _ circleArc: CircleArc2<Vector>,
        intersection: PointNormal<Vector>
    ) -> Period? {
        return circleArcIntersectionRatio(
            circleArc,
            intersection: intersection.point
        )
    }

    @inlinable
    static func circleArcIntersectionRatio(
        _ circleArc: CircleArc2<Vector>,
        intersection: Vector
    ) -> Period? {
        let point = intersection
        let intersectionAngle = circleArc.center.angle(to: point)

        let angleSweep = circleArc.asAngleSweep

        guard angleSweep.contains(intersectionAngle) else {
            return nil
        }

        return angleSweep.ratioOfAngle(intersectionAngle)
    }
}

extension Sequence {
    /// Returns the result of clamping all simplexes within this sequence to be
    /// within a given range.
    ///
    /// If no simplex overlaps the given region, an empty array is returned, instead.
    public func clampedSimplexes<Vector>(
        in range: Range<Vector.Scalar>
    ) -> [Parametric2GeometrySimplex<Vector>] where Element == Parametric2GeometrySimplex<Vector> {
        compactMap { simplex in
            simplex.clamped(in: range)
        }
    }

    /// Returns the result of clamping all simplexes within this sequence to be
    /// within a given range.
    ///
    /// If no simplex overlaps the given region, an array of empty arrays is
    /// returned, one for each element in this array, instead.
    public func clampedSimplexes<Vector>(
        in range: Range<Vector.Scalar>
    ) -> [[Parametric2GeometrySimplex<Vector>]] where Element == [Parametric2GeometrySimplex<Vector>] {
        map { $0.clampedSimplexes(in: range) }
    }
}

extension Collection {
    /// Computes the minimal bounding box capable of containing this collection
    /// of simplexes.
    @inlinable
    func bounds<Vector>() -> AABB2<Vector> where Element == Parametric2GeometrySimplex<Vector> {
        return AABB2(aabbs: self.map(\.bounds))
    }

    /// Renormalizes the simplexes within this collection such that the periods
    /// of the simplexes have a sequential value within the given start and end
    /// periods, relative to each simplex's length.
    @inlinable
    func normalized<Vector>(startPeriod: Vector.Scalar, endPeriod: Vector.Scalar) -> [Element] where Element == Parametric2GeometrySimplex<Vector> {
        typealias Scalar = Vector.Scalar

        let perimeterSequence = self.map { simplex in
            (simplex.lengthSquared.squareRoot(), simplex)
        }
        let perimeter: Scalar = perimeterSequence.reduce(.zero) { $0 + $1.0 }
        guard perimeter > .zero else {
            // TODO: Handle zero-perimeter simplex sequences better
            return []
        }

        let periodLength = endPeriod - startPeriod

        var currentLength: Scalar = .zero
        let relativeSegments: [(periodRange: Range<Scalar>, simplex: Element)] = perimeterSequence.map { (length, simplex) in
            defer { currentLength += length }

            let relativeStart = currentLength / perimeter
            let relativeEnd = (currentLength + length) / perimeter

            let periodStart = startPeriod + periodLength * relativeStart
            let periodEnd = startPeriod + periodLength * relativeEnd

            return (periodStart..<periodEnd, simplex)
        }

        return relativeSegments.map { (range, simplex) in
            switch simplex {
            case .circleArc2(var arc):
                arc.startPeriod = range.lowerBound
                arc.endPeriod = range.upperBound
                return .circleArc2(arc)

            case .lineSegment2(var line):
                line.startPeriod = range.lowerBound
                line.endPeriod = range.upperBound
                return .lineSegment2(line)
            }
        }
    }
}
