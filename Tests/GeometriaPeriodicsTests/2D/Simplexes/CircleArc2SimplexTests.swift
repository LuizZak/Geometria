import XCTest
import Geometria
import TestCommons

@testable import GeometriaPeriodics

class CircleArc2SimplexTests: XCTestCase {
    typealias Sut = CircleArc2Simplex<Vector2D>

    func testLengthSquared() {
        let sut = Sut(
            circleArc: .init(
                center: .init(x: 0, y: 0),
                radius: 10.0,
                startAngle: .zero,
                sweepAngle: .pi
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        XCTAssertEqual(sut.lengthSquared, 986.9604401089358)
    }
}
