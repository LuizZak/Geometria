import Geometria

/// The periodic simplex type produced by a `Periodic2Geometry`.
public enum Periodic2GeometrySimplex<Vector: Vector2Real>: Periodic2Simplex {
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

    public func compute(at period: Period) -> Vector {
        switch self {
        case .lineSegment2(let lineSegment):
            return lineSegment.compute(at: period)

        case .circleArc2(let circleArc):
            return circleArc.compute(at: period)
        }
    }

    /// Returns `startPeriod + (endPeriod - startPeriod) * ratio`.
    ///
    /// - note: The result is unclamped.
    func period(onRatio ratio: Scalar) -> Period {
        startPeriod + (endPeriod - startPeriod) * ratio
    }

    /// Returns a list of pairs for periods where `self` and `other` intersect
    /// in space.
    ///
    /// If `self` and `other` do not intersect, an empty array is returned,
    /// instead.
    public func intersectionPeriods(with other: Self) -> [(`self`: Period, other: Period)] {
        switch (self, other) {
        case (.lineSegment2(let lhs), .lineSegment2(let rhs)):
            guard let intersection = lhs.lineSegment.intersection(with: rhs.lineSegment) else {
                return []
            }

            let period1 = self.period(onRatio: intersection.line1NormalizedMagnitude)
            let period2 = other.period(onRatio: intersection.line2NormalizedMagnitude)

            return [(period1, period2)]

        case (.lineSegment2(let lhs), .circleArc2(let rhs)):
            let intersections = rhs.circleArc.intersections(with: lhs.lineSegment).intersections
            return intersections.map { intersection in
                let period1 = self.period(onRatio: intersection.lineIntersectionPointNormal.normalizedMagnitude)

                let circleArcPeriod = Self.circleArcIntersectionRatio(rhs, intersection: intersection)
                let period2 = other.period(onRatio: circleArcPeriod)

                return (period1, period2)
            }

        case (.circleArc2(let lhs), .lineSegment2(let rhs)):
            let intersections = lhs.circleArc.intersections(with: rhs.lineSegment).intersections
            return intersections.map { intersection in
                let circleArcPeriod = Self.circleArcIntersectionRatio(
                    lhs,
                    intersection: intersection
                )
                let period1 = self.period(onRatio: circleArcPeriod)

                let period2 = other.period(onRatio: intersection.lineIntersectionPointNormal.normalizedMagnitude)

                return (period1, period2)
            }

        case (.circleArc2(let lhs), .circleArc2(let rhs)):
            let intersections =
                lhs.asCircle2
                .intersection(with: rhs.asCircle2)
                .pointNormals

            return intersections.map { intersection in
                let selfPeriod = Self.circleArcIntersectionRatio(
                    lhs,
                    intersection: intersection
                )
                let period1 = self.period(onRatio: selfPeriod)

                let otherPeriod = Self.circleArcIntersectionRatio(
                    rhs,
                    intersection: intersection
                )
                let period2 = other.period(onRatio: otherPeriod)

                return (period1, period2)
            }
        }
    }

    static func circleArcIntersectionRatio(
        _ circleArc: CircleArc2Simplex<Vector>,
        intersection: LineIntersection<Vector>.Intersection
    ) -> Period {
        return circleArcIntersectionRatio(
            circleArc.circleArc,
            intersection: intersection.lineIntersectionPointNormal
        )
    }

    static func circleArcIntersectionRatio(
        _ circleArc: CircleArc2Simplex<Vector>,
        intersection: LineIntersectionPointNormal<Vector>
    ) -> Period {
        return circleArcIntersectionRatio(
            circleArc.circleArc,
            intersection: intersection
        )
    }

    static func circleArcIntersectionRatio(
        _ circleArc: CircleArc2Simplex<Vector>,
        intersection: PointNormal<Vector>
    ) -> Period {
        return circleArcIntersectionRatio(
            circleArc.circleArc,
            intersection: intersection
        )
    }

    static func circleArcIntersectionRatio(
        _ circleArc: CircleArc2<Vector>,
        intersection: LineIntersectionPointNormal<Vector>
    ) -> Period {
        return circleArcIntersectionRatio(
            circleArc,
            intersection: intersection.pointNormal
        )
    }

    static func circleArcIntersectionRatio(
        _ circleArc: CircleArc2<Vector>,
        intersection: PointNormal<Vector>
    ) -> Period {
        let point = intersection.point
        let intersectionAngle = circleArc.center.angle(to: point)

        let angleSweep = circleArc.asAngleSweep

        return angleSweep.ratioOfAngle(intersectionAngle)
    }
}
