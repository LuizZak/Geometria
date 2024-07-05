import XCTest

@testable import Geometria

class CircleArc2Tests: XCTestCase {
    func testContainsAngle_subStart_subSweep() {
        let sut = makeSut(
            center: .zero,
            radius: 1.0,
            startAngle: .pi / 4,
            sweepAngle: .pi / 3
        )

        XCTAssertTrue(sut.contains(.pi / 4))
        XCTAssertTrue(sut.contains(.pi / 2))
        XCTAssertTrue(sut.contains(.pi / 4 + .pi / 3))
        XCTAssertFalse(sut.contains((.pi / 4).nextDown))
        XCTAssertFalse(sut.contains((.pi / 4 + .pi / 3).nextUp))
        XCTAssertFalse(sut.contains(Double.pi))
        XCTAssertFalse(sut.contains(0.0))
    }

    func testContainsAngle_overStart_subSweep() {
        let sut = makeSut(
            center: .zero,
            radius: 1.0,
            startAngle: .pi,
            sweepAngle: .pi / 3
        )

        XCTAssertTrue(sut.contains(Double.pi))
        XCTAssertTrue(sut.contains(Double.pi + .pi / 3))
        XCTAssertFalse(sut.contains(.pi.nextDown))
        XCTAssertFalse(sut.contains((.pi + .pi / 3).nextUp))
        XCTAssertFalse(sut.contains(0.0))
    }

    func testContainsAngle_subStart_overSweep() {
        let sut = makeSut(
            center: .zero,
            radius: 1.0,
            startAngle: .pi / 4,
            sweepAngle: .pi * 1.5
        )

        XCTAssertTrue(sut.contains(Double.pi))
        XCTAssertTrue(sut.contains(.pi / 4))
        XCTAssertTrue(sut.contains(.pi / 2))
        XCTAssertTrue(sut.contains(.pi / 4 + .pi * 1.5))
        XCTAssertFalse(sut.contains((.pi / 4).nextDown))
        XCTAssertFalse(sut.contains((.pi / 4 + .pi * 1.5).nextUp))
        XCTAssertFalse(sut.contains(.pi * 1.9))
        XCTAssertFalse(sut.contains(0.0))
    }

    func testContainsAngle_overStart_overSweep() {
        let sut = makeSut(
            center: .zero,
            radius: 1.0,
            startAngle: .pi * 1.2,
            sweepAngle: .pi * 1.5
        )

        XCTAssertTrue(sut.contains(0.0))
        XCTAssertTrue(sut.contains(.pi * 1.2))
        XCTAssertTrue(sut.contains(.pi * 1.8))
        XCTAssertTrue(sut.contains(.pi * 2.0))
        XCTAssertTrue(sut.contains(.pi * 1.2 + .pi * 1.5))
        XCTAssertFalse(sut.contains((.pi * 1.2).nextDown))
        XCTAssertFalse(sut.contains((.pi * 1.2 + .pi * 1.5).nextUp))
        XCTAssertFalse(sut.contains(Double.pi))
    }

    func testContainsAngle_negativeSweep() {
        let sut = makeSut(
            center: .zero,
            radius: 1.0,
            startAngle: (.pi / 4) + .pi / 3,
            sweepAngle: -(.pi / 3)
        )

        XCTAssertTrue(sut.contains(.pi / 4))
        XCTAssertTrue(sut.contains(.pi / 2))
        XCTAssertTrue(sut.contains(.pi / 4 + .pi / 3))
        XCTAssertFalse(sut.contains((.pi / 4).nextDown))
        XCTAssertFalse(sut.contains((.pi / 4 + .pi / 3).nextUp))
        XCTAssertFalse(sut.contains(Double.pi))
        XCTAssertFalse(sut.contains(0.0))
    }

    func testContainsAngle_negativeSweep_overOrigin() {
        let sut = makeSut(
            center: .zero,
            radius: 1.0,
            startAngle: .pi / 4,
            sweepAngle: -.pi / 2
        )

        XCTAssertTrue(sut.contains(0.0))
        XCTAssertTrue(sut.contains(Double.pi / 4))
        XCTAssertTrue(sut.contains(.pi / 4 - .pi / 2))
        XCTAssertFalse(sut.contains((Double.pi / 4).nextUp))
        XCTAssertFalse(sut.contains((.pi / 4 - .pi / 2) - 0.01)) // .nextDown rounds up due to floating-point imprecision
        XCTAssertFalse(sut.contains(Double.pi))
    }

    func testContainsAngle_overSweep_scanning() {
        var failureCount = 0
        func assertTrue(_ value: Bool, line: UInt = #line) {
            guard !value else { return }

            guard failureCount < 10 else { return }
            defer { failureCount += 1 }

            XCTAssertTrue(value, line: line)
        }
        func assertFalse(_ value: Bool, line: UInt = #line) {
            guard value else { return }

            guard failureCount < 10 else { return }
            defer { failureCount += 1 }

            XCTAssertFalse(value, line: line)
        }

        let sweepAngle = Double.pi * 1.8
        for startAngle in stride(from: 0.0, through: .pi, by: 0.01) {
            let sut = makeSut(
                center: .zero,
                radius: 1.0,
                startAngle: startAngle,
                sweepAngle: sweepAngle
            )

            assertFalse(sut.contains(startAngle - 0.01))
            assertTrue(sut.contains(startAngle))
            assertTrue(sut.contains(startAngle + sweepAngle / 2))
            assertTrue(sut.contains(startAngle + sweepAngle))
            assertFalse(sut.contains(startAngle + sweepAngle + 0.01))
        }
    }

    func testContainsAngle_negativeSweep_scanning() {
        var failureCount = 0
        func assertTrue(_ value: Bool, line: UInt = #line) {
            guard !value else { return }

            guard failureCount < 10 else { return }
            defer { failureCount += 1 }

            XCTAssertTrue(value, line: line)
        }
        func assertFalse(_ value: Bool, line: UInt = #line) {
            guard value else { return }

            guard failureCount < 10 else { return }
            defer { failureCount += 1 }

            XCTAssertFalse(value, line: line)
        }

        let sweepAngle = -Double.pi * 1.8
        for startAngle in stride(from: 0.0, through: .pi, by: 0.01) {
            let sut = makeSut(
                center: .zero,
                radius: 1.0,
                startAngle: startAngle,
                sweepAngle: sweepAngle
            )

            assertFalse(sut.contains(startAngle + 0.01))
            assertTrue(sut.contains(startAngle - 0.01))
            assertTrue(sut.contains(startAngle))
            assertTrue(sut.contains(startAngle + sweepAngle / 2))
            assertTrue(sut.contains(startAngle + sweepAngle))
            assertTrue(sut.contains(startAngle + sweepAngle + 0.01))
            assertFalse(sut.contains(startAngle + sweepAngle - 0.01))
        }
    }
}

// MARK: - Test internals

private func makeSut(
    center: Vector2D,
    radius: Double,
    startAngle: Double,
    sweepAngle: Double
) -> CircleArc2D {
    return CircleArc2D(
        center: center,
        radius: radius,
        startAngle: startAngle,
        sweepAngle: sweepAngle
    )
}
