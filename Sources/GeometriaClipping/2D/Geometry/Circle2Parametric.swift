import Geometria

/// A parametric geometry that is defined by a ``Circle2`` shape.
public struct Circle2Parametric<Vector: Vector2Real>: ParametricClip2Geometry, Equatable, CustomStringConvertible {
    public typealias Scalar = Vector.Scalar
    public typealias Simplex = Parametric2GeometrySimplex<Vector>
    public typealias Contour = Parametric2Contour<Vector>

    /// The underlying circle shape that comprises this parametric geometry.
    public var circle2: Circle2<Vector>
    var isReversed: Bool = false

    public var startPeriod: Period
    public var endPeriod: Period

    /// Convenience for `circle.center`.
    @inlinable
    public var center: Vector {
        get { circle2.center }
        set { circle2.center = newValue }
    }

    /// Convenience for `circle.radius`.
    @inlinable
    public var radius: Scalar {
        get { circle2.radius }
        set { circle2.radius = newValue }
    }

    public var description: String {
        "\(type(of: self))(center: \(center), radius: \(radius), startPeriod: \(startPeriod), endPeriod: \(endPeriod))"
    }

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

    @inlinable
    public func contains(_ point: Vector) -> Bool {
        circle2.contains(point)
    }

    @inlinable
    public func isOnSurface(_ point: Vector, toleranceSquared: Scalar) -> Bool {
        circle2.distanceSquared(to: point) < toleranceSquared
    }

    public func allContours() -> [Contour] {
        return [
            .init(
                simplexes: allSimplexes(),
                winding: isReversed ? .counterClockwise : .clockwise
            )
        ]
    }

    public func allSimplexes() -> [Simplex] {
        var arc1: CircleArc2<Vector>
        var arc2: CircleArc2<Vector>
        var arc3: CircleArc2<Vector>
        var arc4: CircleArc2<Vector>

        if isReversed {
            arc1 = circle2.arc(
                startAngle: .pi * 2,
                sweepAngle: -.pi / 2
            )
            arc2 = circle2.arc(
                startAngle: .pi * 3 / 2,
                sweepAngle: -.pi / 2
            )
            arc3 = circle2.arc(
                startAngle: .pi,
                sweepAngle: -.pi / 2
            )
            arc4 = circle2.arc(
                startAngle: .pi / 2,
                sweepAngle: -.pi / 2
            )
        } else {
            arc1 = circle2.arc(
                startAngle: .zero,
                sweepAngle: .pi / 2
            )
            arc2 = circle2.arc(
                startAngle: .pi / 2,
                sweepAngle: .pi / 2
            )
            arc3 = circle2.arc(
                startAngle: .pi,
                sweepAngle: .pi / 2
            )
            arc4 = circle2.arc(
                startAngle: .pi * 3 / 2,
                sweepAngle: .pi / 2
            )
        }

        let arcs = [arc1, arc2, arc3, arc4]
        let simplexes: [Simplex] = arcs.enumerated().map { (i, arc) in
            let startPeriod: Scalar = Scalar(i) / Scalar(arcs.count)
            let endPeriod: Scalar = Scalar(i + 1) / Scalar(arcs.count)

            return .circleArc2(
                .init(
                    circleArc: arc,
                    startPeriod: startPeriod,
                    endPeriod: endPeriod
                )
            )
        }

        return simplexes
    }

    public func reversed() -> Circle2Parametric<Vector> {
        var copy = self
        copy.isReversed = !isReversed
        return copy
    }
}
