import XCTest
import Geometria
import GeometriaClipping
import TestCommons

@testable import GeometriaClipping

class Parametric2ContourTests: XCTestCase {
    typealias Line = LineSegment2Simplex<Vector2D>
    typealias Arc = CircleArc2Simplex<Vector2D>
    typealias Sut = Parametric2Contour<Vector2D>

    func testWinding_lineAndArc_clockwise() {
        // Ensure that the simplest contour- a line with an arc, has the correct
        // winding computed
        let line = Line(
            start: .init(x: 0.0, y: 0.0),
            end: .init(x: 200.0, y: 0.0),
            startPeriod: 0.0,
            endPeriod: 0.5
        )
        let arc = Arc(
            circleArc: .init(
                startPoint: line.end,
                endPoint: line.start,
                sweepAngle: Angle.pi
            ),
            startPeriod: 0.5,
            endPeriod: 1.0
        )

        let sut = Sut(simplexes: [.lineSegment2(line), .circleArc2(arc)])

        TestFixture.beginFixture { fixture in
            fixture.add(sut, category: "input")

            fixture.assertEquals(sut.winding, .clockwise)
        }
    }

    func testWinding_lineAndArc_counterClockwise() {
        let line = Line(
            start: .init(x: 0.0, y: 0.0),
            end: .init(x: 200.0, y: 0.0),
            startPeriod: 0.0,
            endPeriod: 0.5
        )
        let arc = Arc(
            circleArc: .init(
                startPoint: line.end,
                endPoint: line.start,
                sweepAngle: -Angle.pi
            ),
            startPeriod: 0.5,
            endPeriod: 1.0
        )

        let sut = Sut(simplexes: [.lineSegment2(line), .circleArc2(arc)])

        TestFixture.beginFixture { fixture in
            fixture.add(sut, category: "input")

            fixture.assertEquals(sut.winding, .counterClockwise)
        }
    }

    func testWinding_singleArc_clockwise() {
        let arc = Arc(
            circleArc: .init(
                center: .zero,
                radius: 200.0,
                startAngle: .zero,
                sweepAngle: Angle.pi * 2.0
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        let sut = Sut(simplexes: [.circleArc2(arc)])

        TestFixture.beginFixture { fixture in
            fixture.add(sut, category: "input")

            fixture.assertEquals(sut.winding, .clockwise)
        }
    }

    func testWinding_singleArc_counterClockwise() {
        let arc = Arc(
            circleArc: .init(
                center: .zero,
                radius: 200.0,
                startAngle: .zero,
                sweepAngle: -Angle.pi * 2.0
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        let sut = Sut(simplexes: [.circleArc2(arc)])

        TestFixture.beginFixture { fixture in
            fixture.add(sut, category: "input")

            fixture.assertEquals(sut.winding, .counterClockwise)
        }
    }
}