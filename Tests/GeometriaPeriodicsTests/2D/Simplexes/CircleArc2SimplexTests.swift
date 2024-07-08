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
                startAngle: Angle.zero,
                sweepAngle: Angle.pi
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        XCTAssertEqual(sut.lengthSquared, 986.9604401089358)
    }

    func testClampedIn_positiveSweep() throws {
        let sut = Sut(
            circleArc: .init(
                center: .init(x: 0, y: 0),
                radius: 10.0,
                startAngle: Angle.zero,
                sweepAngle: Angle.pi
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        let result = try XCTUnwrap(sut.clamped(in: 0..<0.5))

        assertEqual(result.compute(at: 0.5), .init(x: 0.0, y: 10.0), accuracy: 1e-14)
    }

    func testClampedIn_negativeSweep() throws {
        let sut = Sut(
            circleArc: .init(
                center: .init(x: 0, y: 0),
                radius: 10.0,
                startAngle: Angle.pi,
                sweepAngle: -Angle.pi
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        let result = try XCTUnwrap(sut.clamped(in: 0.3..<0.5))

        assertEqual(result.circleArc.startAngle, Angle(radians: 2.199114857512855), accuracy: 1e-14)
        assertEqual(result.circleArc.sweepAngle, Angle(radians: -0.6283185307179586), accuracy: 1e-14)
        assertEqual(result.compute(at: 0.5), .init(x: 0.0, y: 10.0), accuracy: 1e-14)
    }

    func testComputeAt_positiveSweep() {
        let sut = Sut(
            circleArc: .init(
                center: .init(x: 0, y: 0),
                radius: 10.0,
                startAngle: Angle.zero,
                sweepAngle: Angle.pi
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        assertEqual(sut.compute(at: 0.5), .init(x: 0.0, y: 10.0), accuracy: 1e-14)
    }

    func testComputeAt_negativeSweep() {
        let sut = Sut(
            circleArc: .init(
                center: .init(x: 0, y: 0),
                radius: 10.0,
                startAngle: Angle.pi,
                sweepAngle: -Angle.pi
            ),
            startPeriod: 0.0,
            endPeriod: 1.0
        )

        assertEqual(sut.compute(at: 0.5), .init(x: 0.0, y: 10.0), accuracy: 1e-14)
    }
}
