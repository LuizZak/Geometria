import Geometria

/// A periodic geometry that is defined by an underlying set of vertices from a
/// ``LinePolygon2`` object.
public struct LinePolygon2Periodic<Vector: Vector2Real>: Periodic2Geometry {
    public typealias Scalar = Vector.Scalar
    public typealias Simplex = Periodic2GeometrySimplex<Vector>

    /// The underlying line polygon object that comprises this periodic geometry.
    public var linePolygon2: LinePolygon2<Vector>

    public var startPeriod: Period
    public var endPeriod: Period

    public init(
        linePolygon2: LinePolygon2<Vector>,
        startPeriod: Period,
        endPeriod: Period
    ) {
        self.linePolygon2 = linePolygon2
        self.startPeriod = startPeriod
        self.endPeriod = endPeriod
    }

    public func contains(_ point: Vector) -> Bool {
        linePolygon2.contains(point)
    }

    public func isOnSurface(_ point: Vector, tolerance: Scalar) -> Bool {
        linePolygon2.isPointOnEdge(point, tolerance: tolerance)
    }

    public func allSimplexes() -> [Simplex] {
        let lineSegments = linePolygon2.lineSegments()
        guard lineSegments.count > 1 else {
            return []
        }

        let perimeterSequence = lineSegments.map({ ($0, $0.lengthSquared) })
        let perimeterSquared: Scalar = perimeterSequence.reduce(.zero) { $0 + $1.1 }
        guard perimeterSquared > .zero else {
            // TODO: Handle zero perimeter polygons better
            return []
        }

        let periodLength = endPeriod - startPeriod

        var currentLengthSquared: Scalar = .zero
        let relativeSegments: [(periodRange: Range<Period>, segment: LineSegment2<Vector>)] = perimeterSequence.map { (lineSegment, lengthSquared) in
            defer { currentLengthSquared += lengthSquared }

            let relativeStart = currentLengthSquared / perimeterSquared
            let relativeEnd = (currentLengthSquared + lengthSquared) / perimeterSquared

            let periodStart = self.startPeriod + periodLength * relativeStart
            let periodEnd = self.startPeriod + periodLength * relativeEnd

            return (periodStart..<periodEnd, lineSegment)
        }

        // Construct simplexes
        var result: [Simplex] = []

        for relativeSegment in relativeSegments {
            let simplex = Simplex.lineSegment2(
                .init(
                    lineSegment: relativeSegment.segment,
                    startPeriod: relativeSegment.periodRange.lowerBound,
                    endPeriod: relativeSegment.periodRange.upperBound
                )
            )

            result.append(simplex)
        }

        return result
    }
}
