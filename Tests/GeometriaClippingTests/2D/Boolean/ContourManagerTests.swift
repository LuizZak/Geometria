import XCTest
import Geometria
import TestCommons

@testable import GeometriaClipping

class ContourManagerTests: XCTestCase {
    func testAppend_mergeAdjacentCircularArcs() {
        let sut = makeSut()
        let simplex1 = makeCircularArcSimplex(
            center: .zero,
            radius: 50,
            startAngle: 0,
            sweepAngle: 0.5,
            startPeriod: 0.0,
            endPeriod: 0.1
        )
        let simplex2 = makeCircularArcSimplex(
            center: .zero,
            radius: 50,
            startAngle: 0.5,
            sweepAngle: 0.5,
            startPeriod: 0.1,
            endPeriod: 0.2
        )
        let simplex3 = makeLineSimplex(
            start: simplex2.end,
            end: simplex1.start,
            startPeriod: 0.2,
            endPeriod: 1.0
        )
        let builder = sut.beginContour()

        builder.append(simplex1)
        builder.append(simplex2)
        builder.append(simplex3)

        builder.endContour(startPeriod: 0.0, endPeriod: 1.0)
        let result = sut.allContours(applyWindingFiltering: false)
        let expected = [
            makeContour(simplexes: [
                makeCircularArcSimplex(
                    center: .zero,
                    radius: 50,
                    startAngle: 0.0,
                    sweepAngle: 1.0,
                    startPeriod: 0.0,
                    endPeriod: 0.5105033310776835
                ),
                makeLineSimplex(
                    start: simplex2.end,
                    end: simplex1.start,
                    startPeriod: 0.5105033310776835,
                    endPeriod: 1.0
                ),
            ])
        ]
        TestFixture.beginFixture { fixture in
            fixture.add(result, category: "result")
            fixture.add(expected, category: "expected")

            fixture.assertEquals(result, expected)
        }
    }

    func testAppend_mergeAdjacentCircularArcs_splitCircularArc() {
        let sut = makeSut()
        let circularArc = makeCircularArcSimplex(
            center: .zero,
            radius: 50,
            startAngle: 0,
            sweepAngle: 1.0,
            startPeriod: 0.0,
            endPeriod: 0.2
        )
        let (simplex1, simplex2) = circularArc.split(at: 0.1)
        let simplex3 = makeLineSimplex(
            start: simplex2.end,
            end: simplex1.start,
            startPeriod: 0.2,
            endPeriod: 1.0
        )
        let builder = sut.beginContour()

        builder.append(simplex1)
        builder.append(simplex2)
        builder.append(simplex3)

        builder.endContour(startPeriod: 0.0, endPeriod: 1.0)
        let result = sut.allContours(applyWindingFiltering: false)
        let expected = [
            makeContour(simplexes: [
                makeCircularArcSimplex(
                    center: .zero,
                    radius: 50,
                    startAngle: 0.0,
                    sweepAngle: 1.0,
                    startPeriod: 0.0,
                    endPeriod: 0.5105033310776835
                ),
                makeLineSimplex(
                    start: simplex2.end,
                    end: simplex1.start,
                    startPeriod: 0.5105033310776835,
                    endPeriod: 1.0
                ),
            ])
        ]
        TestFixture.beginFixture { fixture in
            fixture.add(result, category: "result")
            fixture.add(expected, category: "expected")

            fixture.assertEquals(result, expected)
        }
    }
}

// MARK: - Test internals

private func makeSut() -> ContourManager<Vector2D> {
    return .init()
}

private func makeContour(
    simplexes: [Parametric2GeometrySimplex<Vector2D>]
) -> Parametric2Contour<Vector2D> {
    .init(simplexes: simplexes)
}

private func makeCircularArcContour(
    center: Vector2D,
    radius: Double,
    startAngle: Double,
    sweepAngle: Double,
    startPeriod: Double,
    endPeriod: Double
) -> Parametric2Contour<Vector2D> {
    .init(simplexes: [
        makeCircularArcSimplex(
            center: center,
            radius: radius,
            startAngle: startAngle,
            sweepAngle: sweepAngle,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    ])
}

private func makeLineContour(
    start: Vector2D,
    end: Vector2D,
    startPeriod: Double,
    endPeriod: Double
) -> Parametric2Contour<Vector2D> {
    .init(simplexes: [
        makeLineSimplex(
            start: start,
            end: end,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    ])
}

private func makeCircularArcSimplex(
    center: Vector2D,
    radius: Double,
    startAngle: Double,
    sweepAngle: Double,
    startPeriod: Double,
    endPeriod: Double
) -> Parametric2GeometrySimplex<Vector2D> {
    .circleArc2(
        .init(
            center: center,
            radius: radius,
            startAngle: .init(radians: startAngle),
            sweepAngle: .init(radians: sweepAngle),
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    )
}

private func makeLineSimplex(
    start: Vector2D,
    end: Vector2D,
    startPeriod: Double,
    endPeriod: Double
) -> Parametric2GeometrySimplex<Vector2D> {
    .lineSegment2(
        .init(
            start: start,
            end: end,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    )
}
