import XCTest
import Geometria
import TestCommons

@testable import GeometriaClipping

class ParametricClip2GeometryTests: XCTestCase {
    func testIntersectionPeriods_line_arc_arcBase() {
        let box = LinePolygon2Parametric.makeRectangle(width: 100, height: 500, center: .init(x: 0, y: 250))
        let sut = Circle2Parametric.makeTestCircle(center: .zero, radius: 50)

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertIntersections(box, [
                    (self: 0.5, other: 0.0),
                    (self: 0.0, other: 0.08333333333333333),
                ])
        }
    }
}
