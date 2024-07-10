import XCTest
import Geometria
import TestCommons

@testable import GeometriaClipping

class ParametricClip2GeometryTests: XCTestCase {
    func testIntersectionPeriods_line_arc_arcBase() {
        let sut = Circle2Parametric.makeTestCircle(center: .zero, radius: 50)
        let box = LinePolygon2Parametric.makeRectangle(width: 100, height: 500, center: .init(x: 0, y: 250))

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertIntersections(box, [
                    .pair((self: 0.5, other: 1.0), (self: 0.0, other: 0.08333333333333333)),
                    .singlePoint((self: 0.5, other: 0.0))
                ])
        }
    }

    func testIntersectionPeriods_line_line_onIntersection() {
        let sut = LinePolygon2Parametric.makePentagon()
        let box = LinePolygon2Parametric.makeRectangle(width: 500, height: 500, center: .init(x: 0, y: 250))

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertIntersections(box, [
                    .pair((self: 0.5, other: 0.08454915028125264), (self: 0.0, other: 0.17499999999999996))
                ])
        }
    }
}
