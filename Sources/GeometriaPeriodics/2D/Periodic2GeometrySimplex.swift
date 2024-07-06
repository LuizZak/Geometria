import Geometria

/// The periodic simplex type produced by a `Periodic2Geometry`.
public enum Periodic2GeometrySimplex<Period: PeriodType, Vector: Vector2Real>: Periodic2Simplex {
    public typealias Scalar = Vector.Scalar

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
}

extension Periodic2GeometrySimplex where Period == Vector.Scalar {
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
            rhs.circleArc.intersections(with: lhs.lineSegment)

        case (.circleArc2, .lineSegment2):
            break

        case (.circleArc2, .circleArc2):
            break
        }

        return []
    }
}
