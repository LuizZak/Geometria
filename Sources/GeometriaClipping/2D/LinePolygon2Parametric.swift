import Geometria

/// A parametric geometry that is defined by an underlying set of vertices from a
/// ``LinePolygon2`` shape.
public struct LinePolygon2Parametric<Vector: Vector2Real>: ParametricClip2Geometry, Equatable {
    public typealias Scalar = Vector.Scalar
    public typealias Simplex = Parametric2GeometrySimplex<Vector>
    public typealias Contour = Parametric2Contour<Vector>

    private var _cachedSimplexes: [Simplex]

    /// The underlying line polygon shape that comprises this parametric geometry.
    public var linePolygon2: LinePolygon2<Vector> {
        didSet {
            _cachedSimplexes =
                Self.computeSimplexes(
                    linePolygon2
                ).normalized(
                    startPeriod: startPeriod,
                    endPeriod: endPeriod
                )
        }
    }

    public var startPeriod: Period {
        didSet {
            _cachedSimplexes = _cachedSimplexes.normalized(
                startPeriod: startPeriod,
                endPeriod: endPeriod
            )
        }
    }
    public var endPeriod: Period {
        didSet {
            _cachedSimplexes = _cachedSimplexes.normalized(
                startPeriod: startPeriod,
                endPeriod: endPeriod
            )
        }
    }

    public init(
        linePolygon2: LinePolygon2<Vector>,
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.linePolygon2 = linePolygon2
        self.startPeriod = startPeriod
        self.endPeriod = endPeriod

        self._cachedSimplexes =
            Self.computeSimplexes(
                linePolygon2
            ).normalized(
                startPeriod: startPeriod,
                endPeriod: endPeriod
            )
    }

    public func contains(_ point: Vector) -> Bool {
        linePolygon2.contains(point)
    }

    public func isOnSurface(_ point: Vector, toleranceSquared: Scalar) -> Bool {
        linePolygon2.isPointOnEdge(point, toleranceSquared: toleranceSquared)
    }

    public func allContours() -> [Contour] {
        return [.init(simplexes: _cachedSimplexes)]
    }

    private static func computeSimplexes(_ linePolygon2: LinePolygon2<Vector>) -> [Simplex] {
        let lineSegments = linePolygon2.lineSegments()
        guard lineSegments.count > 1 else {
            return []
        }

        // Construct simplexes
        var result: [Simplex] = []

        for segment in lineSegments {
            let simplex = Simplex.lineSegment2(
                .init(
                    lineSegment: segment,
                    startPeriod: .zero,
                    endPeriod: .zero
                )
            )

            result.append(simplex)
        }

        return result
    }

    public func reversed() -> LinePolygon2Parametric<Vector> {
        let polygon = linePolygon2.reversed()

        return .init(
            linePolygon2: polygon,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }
}
