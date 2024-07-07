import Geometria
import GeometriaPeriodics

extension LinePolygon2Periodic where Vector == Vector2D {

    private static func makeSut(
        _ vertices: [Vector2D],
        startPeriod: Double = 0.0,
        endPeriod: Double = 1.0
    ) -> Self {

        let polygon = LinePolygon2(vertices: vertices)

        return .init(
            linePolygon2: polygon,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

    static func makeHexagon(radius: Double = 100.0) -> Self {
        return makeSut(
            makeRegularPolygonVertices(
                sides: 6,
                radius: radius
            )
        )
    }

    static func makeRegularPolygonVertices(sides: Int, radius: Double = 100.0) -> [Vector2D] {
        var points: [Vector2D] = []

        for step in 0..<sides {
            let angle = Double.pi * 2 * (Double(step) / Double(sides))
            let center = Vector2D.zero

            let c = Double.cos(angle) * radius
            let s = Double.sin(angle) * radius

            points.append(center + .init(x: c, y: s))
        }

        return points
    }

    static func makeStar(radius: Double = 100.0) -> Self {
        var vertices = makeRegularPolygonVertices(
            sides: 10,
            radius: radius
        )
        for i in stride(from: 1, through: 10, by: 2) {
            vertices[i] *= 0.4
        }

        return makeSut(vertices)
    }
}
