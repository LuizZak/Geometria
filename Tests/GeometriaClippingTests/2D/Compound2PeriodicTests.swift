import XCTest
import Geometria
import TestCommons

@testable import GeometriaClipping

class Compound2PeriodicTests: XCTestCase {
    typealias Sut = Compound2Periodic<Vector2D>

    func testContains_onSimplexVertex() {
        let sut = makeSut(lines: [
            .init(x1: -150, y1: -150, x2: 150, y2: 0),
            .init(x1: 150, y1: 0, x2: -150, y2: 150),
            .init(x1: -150, y1: 150, x2: -150, y2: -150),
        ])

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertContains(.init(x: 0, y: -10))
                .assertContains(.init(x: 0, y: 0))
                .assertDoesNotContain(.init(x: -200, y: -10))
                .assertDoesNotContain(.init(x: -200, y: 0))
        }
    }
}

// MARK: - Test internals

private func makeSut(
    lines: [LineSegment2D]
) -> Compound2PeriodicTests.Sut {
    let simplexes = lines.map { line in
        Periodic2GeometrySimplex.lineSegment2(
            .init(lineSegment: line, startPeriod: 0, endPeriod: 0)
        )
    }

    return makeSut(normalizing: simplexes)
}

private func makeSut(
    normalizing simplexes: [Periodic2GeometrySimplex<Vector2D>]
) -> Compound2PeriodicTests.Sut {
    .init(normalizing: simplexes)
}
