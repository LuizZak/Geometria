import Geometria

/// A periodic geometry that is defined by a ``Circle2`` shape.
public struct Circle2Periodic<Vector: Vector2Real>: Periodic2Geometry, Equatable {
    public typealias Scalar = Vector.Scalar
    public typealias Simplex = Periodic2GeometrySimplex<Vector>

    /// The underlying circle shape that comprises this periodic geometry.
    public var circle2: Circle2<Vector>
    var isReversed: Bool = false

    public var startPeriod: Period
    public var endPeriod: Period

    public init(
        center: Vector,
        radius: Scalar,
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.init(
            circle2: .init(
                center: center,
                radius: radius
            ),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

    public init(
        circle2: Circle2<Vector>,
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.circle2 = circle2
        self.startPeriod = startPeriod
        self.endPeriod = endPeriod
    }

    public func contains(_ point: Vector) -> Bool {
        circle2.contains(point)
    }

    public func isOnSurface(_ point: Vector, toleranceSquared: Scalar) -> Bool {
        circle2.distanceSquared(to: point) < toleranceSquared
    }

    public func allSimplexes() -> [Simplex] {
        var arc1: CircleArc2<Vector>
        var arc2: CircleArc2<Vector>

        if isReversed {
            arc1 = circle2.arc(
                startAngle: .pi * 2,
                sweepAngle: -.pi
            )
            arc2 = circle2.arc(
                startAngle: .pi,
                sweepAngle: -.pi
            )
        } else {
            arc1 = circle2.arc(
                startAngle: .zero,
                sweepAngle: .pi
            )
            arc2 = circle2.arc(
                startAngle: .pi,
                sweepAngle: .pi
            )
        }

        let simplexes: [Simplex] = [
            .circleArc2(
                .init(circleArc: arc1, startPeriod: 0, endPeriod: 1 / 2)
            ),
            .circleArc2(
                .init(circleArc: arc2, startPeriod: 1 / 2, endPeriod: 1)
            ),
        ]

        return simplexes
    }

    public func reversed() -> Circle2Periodic<Vector> {
        var copy = self
        copy.isReversed = !isReversed
        return copy
    }
}
