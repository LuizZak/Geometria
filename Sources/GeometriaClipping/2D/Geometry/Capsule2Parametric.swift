import Geometria

/// A parametric geometry that is defined by line segments connecting two circular
/// arcs at the end-points.
public struct Capsule2Parametric<Vector: Vector2Real>: ParametricClip2Geometry, Equatable {
    public typealias Scalar = Vector.Scalar
    public typealias Simplex = Parametric2GeometrySimplex<Vector>
    public typealias Contour = Parametric2Contour<Vector>

    public var start: Vector
    public var startRadius: Scalar
    public var end: Vector
    public var endRadius: Scalar

    public var startPeriod: Period
    public var endPeriod: Period

    public var isReversed: Bool

    public init(
        start: Vector,
        end: Vector,
        radius: Scalar,
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.init(
            start: start,
            startRadius: radius,
            end: end,
            endRadius: radius,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

    public init(
        start: Vector,
        startRadius: Scalar,
        end: Vector,
        endRadius: Scalar,
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.start = start
        self.startRadius = startRadius
        self.end = end
        self.endRadius = endRadius
        self.startPeriod = startPeriod
        self.endPeriod = endPeriod
        self.isReversed = false
    }

    public func allContours() -> [Contour] {
        let startCircle = Circle2(center: start, radius: startRadius)
        let endCircle = Circle2(center: end, radius: endRadius)

        let tangents = startCircle.outerTangents(to: endCircle)

        let startArc = CircleArc2(clockwiseAngleToCenter: start, startPoint: tangents.1.start, endPoint: tangents.0.start)
        let endArc = CircleArc2(clockwiseAngleToCenter: end, startPoint: tangents.0.end, endPoint: tangents.1.end)

        var simplexes: [Simplex] = []

        simplexes +=
            CircleArc2Simplex.splittingArcSegments(
                startArc,
                startPeriod: 0,
                endPeriod: 0,
                maxAbsoluteSweepAngle: .pi / 2
            ).map(Parametric2GeometrySimplex.circleArc2)

        simplexes += [
            .lineSegment2(.init(lineSegment: tangents.0, startPeriod: 0, endPeriod: 0)),
        ]

        simplexes +=
            CircleArc2Simplex.splittingArcSegments(
                endArc,
                startPeriod: 0,
                endPeriod: 0,
                maxAbsoluteSweepAngle: .pi / 2
            ).map(Parametric2GeometrySimplex.circleArc2)

        simplexes += [
            .lineSegment2(.init(lineSegment: tangents.1.reversed, startPeriod: 0, endPeriod: 0)),
        ]

        let contour = Contour(
            normalizing: simplexes,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )

        if isReversed {
            return [
                contour.reversed()
            ]
        } else {
            return [
                contour
            ]
        }
    }

    public func reversed() -> Capsule2Parametric {
        var copy = self
        copy.isReversed = !isReversed
        return copy
    }
}
