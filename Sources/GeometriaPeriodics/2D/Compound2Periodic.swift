import Geometria

/// A 2-dimensional periodic shape that is composed of generic simplexes that
/// are joined end-to-end in a loop.
public struct Compound2Periodic<Vector: Vector2Real>: Periodic2Geometry {
    public typealias Scalar = Vector.Scalar
    public typealias Simplex = Periodic2GeometrySimplex<Vector>

    /// The list of simplexes that compose this compound periodic.
    public var simplexes: [Simplex]

    public var startPeriod: Period
    public var endPeriod: Period

    /// Initializes a new compound periodic with a given list of simplexes, using
    /// the start period of the first simplex and the end period of the last
    /// simplex as the start and end periods for the geometry.
    public init(simplexes: [Simplex]) {
        self.init(
            simplexes: simplexes,
            startPeriod: simplexes.first?.startPeriod ?? .zero,
            endPeriod: simplexes.last?.endPeriod ?? 1
        )
    }

    /// Initializes a new compound periodic with a given list of simplexes, first
    /// normalizing their period intervals so they lie in the range
    /// `(0, 1]`.
    public init(
        normalizing simplexes: [Simplex]
    ) {
        self.init(
            normalizing: simplexes,
            startPeriod: .zero,
            endPeriod: 1
        )
    }

    /// Initializes a new compound periodic with a given list of simplexes, first
    /// normalizing their period intervals so they lie in the range
    /// `(startPeriod, endPeriod]`.
    public init(
        normalizing simplexes: [Simplex],
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.init(
            simplexes: simplexes.normalized(
                startPeriod: startPeriod,
                endPeriod: endPeriod
            ),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

    /// Initializes a new compound periodic with a given list of simplexes and
    /// a pre-defined start/end period range.
    ///
    /// - note: The period of the contained simplexes is not modified and is
    /// assumed to match the range `(startPeriod, endPeriod]`.
    public init(simplexes: [Simplex], startPeriod: Period, endPeriod: Period) {
        self.simplexes = simplexes
        self.startPeriod = startPeriod
        self.endPeriod = endPeriod
    }

    public func contains(_ point: Vector) -> Bool {
        // Construct a line segment that starts at the queried point and ends at
        // a point known to be outside the geometry, then count the number of
        // unique point-intersections along the way; if the intersection count
        // is divisible by two, then the point is not contained within the
        // geometry.

        var points: [Vector] = []

        let bounds = simplexes.bounds()

        let lineSegment = LineSegment2<Vector>(
            start: point,
            end: .init(x: bounds.right + 10, y: point.y)
        )
        let lineSimplex = Periodic2GeometrySimplex.lineSegment2(
            .init(lineSegment: lineSegment, startPeriod: .zero, endPeriod: 1)
        )

        for simplex in simplexes {
            let intersections = simplex.intersectionPeriods(with: lineSimplex)

            for intersection in intersections {
                let point = simplex.compute(at: intersection.`self`)

                if !points.contains(point) {
                    points.append(point)
                }
            }
        }

        return points.count % 2 == 1
    }

    public func isOnSurface(_ point: Vector, toleranceSquared: Scalar) -> Bool {
        for simplex in simplexes {
            if simplex.isOnSurface(point, toleranceSquared: toleranceSquared) {
                return true
            }
        }

        return false
    }

    public func allSimplexes() -> [Simplex] {
        simplexes
    }
}
