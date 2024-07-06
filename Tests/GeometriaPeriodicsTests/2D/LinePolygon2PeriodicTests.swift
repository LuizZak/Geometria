import XCTest
import Geometria
import TestCommons

@testable import GeometriaPeriodics

class LinePolygon2PeriodicTests: XCTestCase {
    typealias Sut = LinePolygon2Periodic<Vector2D>

    func testEphemeral() {
        let sut = makeStar()

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.printVisualization()
        }
    }
}

// MARK: - Test internals

private func makeSut(
    _ vertices: [Vector2D],
    startPeriod: Double = 0.0,
    endPeriod: Double = 1.0
) -> LinePolygon2PeriodicTests.Sut {

    let polygon = LinePolygon2(vertices: vertices)

    return .init(
        linePolygon2: polygon,
        startPeriod: startPeriod,
        endPeriod: endPeriod
    )
}

private func makeHexagon() -> LinePolygon2PeriodicTests.Sut {
    return makeSut(makeRegularPolygonVertices(sides: 6))
}

private func makeRegularPolygonVertices(sides: Int, radius: Double = 100.0) -> [Vector2D] {
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

private func makeStar() -> LinePolygon2PeriodicTests.Sut {
    var vertices = makeRegularPolygonVertices(sides: 10)
    for i in stride(from: 1, through: 10, by: 2) {
        vertices[i] *= 0.4
    }

    return makeSut(vertices)
}
