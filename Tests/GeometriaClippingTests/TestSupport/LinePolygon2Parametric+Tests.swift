import Geometria
import GeometriaClipping

extension LinePolygon2Parametric where Vector == Vector2D {

    func centered(around origin: Vector2D = .zero) -> Self {
        var vertices = linePolygon2.vertices
        let center = vertices.averageVector()
        vertices = vertices.map { vertex in
            vertex - center + origin
        }

        return .init(
            linePolygon2: .init(vertices: vertices),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    }

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

    static func makePentagon(radius: Double = 100.0) -> Self {
        return makeSut(
            makeRegularPolygonVertices(
                sides: 5,
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

    static func makeRectangle(width: Double, height: Double, center: Vector2D = .zero) -> Self {
        let aabb = AABB2D(x: 0, y: 0, width: width, height: height)

        return makeSut(aabb.corners).centered(around: center)
    }

    static func makeCShape(size: Double = 100.0) -> Self {
        let offset1: Double = size * 0.2
        let offset2: Double = size * 0.8
        let vertices: [Vector2D] = [
            .init(x: 0.0, y: 0.0),
            .init(x: size, y: 0.0),
            .init(x: offset2, y: offset1),
            .init(x: offset1, y: offset1),
            .init(x: offset1, y: offset2),
            .init(x: offset2, y: offset2),
            .init(x: size, y: size),
            .init(x: 0, y: size),
        ]

        return makeSut(vertices).centered()
    }
}
