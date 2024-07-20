import XCTest
import Geometria
import TestCommons

@testable import GeometriaClipping

class Parametric2GeometrySimplexTests: XCTestCase {
    typealias Sut = Parametric2GeometrySimplex<Vector2D>

    func testIntersectionPeriods_line_line() {
        let line1 = makeLine(
            start: .init(x: -20, y: 20),
            end: .init(x: 20, y: -20)
        )
        let line2 = makeLine(
            start: .init(x: 20, y: 20),
            end: .init(x: -100, y: -110)
        )

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: line1)
                .assertIntersectionPeriods(line2, accuracy: 1e-14, [
                    (self: 0.52, other: 0.16),
                ])
        }
    }

    func testIntersectionPeriods_line_arc_singleIntersection() {
        let line = makeLine(
            start: .init(x: -20, y: 20),
            end: .init(x: 20, y: -20)
        )
        let arc = makeCircleArc(
            center: .init(x: -10, y: -30),
            radius: 40,
            startAngle: 0,
            sweepAngle: .pi
        )

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: line)
                .assertIntersectionPeriods(arc, accuracy: 1e-14, [
                    (self: 0.25, other: 0.5),
                ])
        }
    }

    func testIntersectionPeriods_line_arc_doubleIntersection() {
        let line = makeLine(
            start: .init(x: 170, y: -140),
            end: .init(x: 170, y: 40)
        )
        let arc = makeCircleArc(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 1.8,
            sweepAngle: .pi * 0.4
        )

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: line)
                .assertIntersectionPeriods(arc, accuracy: 1e-14, [
                    (self: 0.20082417738141645, other: 0.2077851419261496),
                    (self: 0.7991758226185836, other: 0.7922148580738506),
                ])
        }
    }

    func testIntersectionPeriods_line_arc_doubleIntersection_negativeSweep() {
        let line = makeLine(
            start: .init(x: 170, y: -140),
            end: .init(x: 170, y: 40)
        )
        let arc = makeCircleArc(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 0.2,
            sweepAngle: -.pi * 0.4
        )

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: line)
                .assertIntersectionPeriods(arc, accuracy: 1e-14, [
                    (self: 0.20082417738141645, other: 0.7922148580738504),
                    (self: 0.7991758226185836, other: 0.20778514192614939),
                ])
        }
    }

    func testIntersectionPeriods_line_arc_lateSemiCircle() {
        let line = makeLine(
            start: .init(x: -50, y: -90),
            end: .init(x: -110, y: -170)
        )
        let arc = makeCircleArc(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi,
            sweepAngle: .pi,
            startPeriod: 0.5,
            endPeriod: 1.0
        )

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: line)
                .assertIntersectionPeriods(arc, accuracy: 1e-14, [
                    (self: 0.645683229480096, other: 0.6046224788909318),
                ])
        }
    }

    func testIntersectionPeriods_arc_arc() {
        let arc1 = makeCircleArc(
            center: .init(x: -30, y: -50),
            radius: 150,
            startAngle: .pi,
            sweepAngle: .pi,
            startPeriod: 0.5,
            endPeriod: 1.0
        )
        let arc2 = makeCircleArc(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi,
            sweepAngle: .pi,
            startPeriod: 0.5,
            endPeriod: 1.0
        )

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: arc1)
                .assertIntersectionPeriods(arc2, accuracy: 1e-14, [
                    (self: 0.7820471084244875, other: 0.7179528915755125),
                ])
        }
    }

    func testNormalized() {
        let line = makeLine(
            start: .init(x: -20, y: 20),
            end: .init(x: 20, y: -20)
        )
        let arc = makeCircleArc(
            center: .init(x: -10, y: -30),
            radius: 40,
            startAngle: 0,
            sweepAngle: .pi / 2
        )
        let sequence = [line, arc]

        let result = sequence.normalized(startPeriod: 0.0, endPeriod: 1.0)

        XCTAssertEqual(result[0].startPeriod, 0.0, accuracy: 1e-14)
        XCTAssertEqual(result[0].endPeriod, 0.4737718181453922, accuracy: 1e-14)
        XCTAssertEqual(result[1].startPeriod, 0.4737718181453922, accuracy: 1e-14)
        XCTAssertEqual(result[1].endPeriod, 1.0, accuracy: 1e-14)
    }
}

// MARK: - Test internals

private func makeLine(
    start: Vector2D,
    end: Vector2D,
    startPeriod: Double = 0.0,
    endPeriod: Double = 1.0
) -> Parametric2GeometrySimplexTests.Sut {
    let lineSegment2 = LineSegment2(
        start: start,
        end: end
    )

    return .lineSegment2(
        .init(
            lineSegment: lineSegment2,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    )
}

private func makeCircleArc(
    center: Vector2D,
    radius: Double,
    startAngle: Double,
    sweepAngle: Double,
    startPeriod: Double = 0.0,
    endPeriod: Double = 1.0
) -> Parametric2GeometrySimplexTests.Sut {
    let circleArc2 = CircleArc2(
        center: center,
        radius: radius,
        startAngle: startAngle,
        sweepAngle: sweepAngle
    )

    return .circleArc2(
        .init(
            circleArc: circleArc2,
            startPeriod: startPeriod,
            endPeriod: endPeriod
        )
    )
}

private extension TestFixture.AssertionWrapperBase where T == Parametric2GeometrySimplexTests.Sut {
    func assertIntersectionPeriods(
        _ other: T,
        accuracy: T.Period,
        _ expected: [(`self`: Double, other: Double)],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let intersections = value.intersectionPeriods(with: other)
        if intersections.elementsEqual(expected, by: { (lhs, rhs) in
            fixture.assertEquals(lhs, rhs, accuracy: accuracy, file: file, line: line)
        }) {
            return
        }

        fixture.add(value, category: "input 1")
        fixture.add(other, category: "input 2")
        fixture.failure("\(intersections) != \(expected)", file: file, line: line)
    }
}
