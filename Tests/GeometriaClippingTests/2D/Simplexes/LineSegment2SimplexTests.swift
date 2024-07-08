import XCTest
import Geometria
import TestCommons

@testable import GeometriaClipping

class LineSegment2SimplexTests: XCTestCase {
    typealias Sut = LineSegment2Simplex<Vector2D>

    func testLengthSquared() {
        let sut = Sut(
            lineSegment: .init(
                start: .init(x: 0.0, y: 0.0),
                end: .init(x: 10.0, y: 10.0)
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        XCTAssertEqual(sut.lengthSquared, 200.0)
    }
}
