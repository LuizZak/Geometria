import XCTest
import TestCommons

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

// MARK: LineIntersectableType Conformance Tests

extension CircleArc2Tests {
    func testIntersections() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 1.3,
            sweepAngle: .pi * 0.3
        )
        let line1 = makeLine(start: .init(x: -39, y: -160), end: .init(x: -51, y: -191))
        let line2 = makeLine(start: .init(x: -60, y: -140), end: .init(x: -100, y: -180))

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertions(on: sut)
                .assertIntersections(with: line1, .init(isContained: false, intersections: [
                    .point(.init(
                        point: .init(x: -46.390152057619666, y: -179.0912261488508),
                        normal: .init(x: 0.5092676803841312, y: 0.860608174325672)
                    ))
                ]))
            fixture.assertions(on: sut)
                .assertIntersections(with: line1.reversed, .init(isContained: false, intersections: [
                    .point(.init(
                        point: .init(x: -46.39015205761967, y: -179.0912261488508),
                        normal: .init(x: -0.5092676803841312, y: -0.860608174325672)
                    ))
                ]))
            fixture.assertions(on: sut)
                .assertIntersections(with: line2, .init(isContained: false, intersections: []))
        }
    }

    func testIntersections_wrappedAround_positiveSweep() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 1.8,
            sweepAngle: .pi * 0.4
        )
        let line1 = makeLine(start: .init(x: 150, y: -100), end: .init(x: 200, y: -75))
        let line2 = makeLine(start: .init(x: -60, y: -140), end: .init(x: -100, y: -180))

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertions(on: sut)
                .assertIntersections(with: line1, .init(isContained: false, intersections: [
                    .point(.init(
                        point: .init(x: 175.2719112093773, y: -87.36404439531135),
                        normal: .init(x: -0.9684794080625154, y: 0.2490936293020757)
                    ))
                ]))
            fixture.assertions(on: sut)
                .assertIntersections(with: line1.reversed, .init(isContained: false, intersections: [
                    .point(.init(
                        point: .init(x: 175.2719112093773, y: -87.36404439531135),
                        normal: .init(x: 0.9684794080625154, y: -0.2490936293020757)
                    ))
                ]))
            fixture.assertions(on: sut)
                .assertIntersections(with: line2, .init(isContained: false, intersections: []))
        }
    }

    func testIntersections_wrappedAround_negativeSweep() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 0.2,
            sweepAngle: -.pi * 0.4
        )
        let line1 = makeLine(start: .init(x: 150, y: -100), end: .init(x: 200, y: -75))
        let line2 = makeLine(start: .init(x: -60, y: -140), end: .init(x: -100, y: -180))

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertions(on: sut)
                .assertIntersections(with: line1, .init(isContained: false, intersections: [
                    .point(.init(
                        point: .init(x: 175.2719112093773, y: -87.36404439531135),
                        normal: .init(x: -0.9684794080625154, y: 0.2490936293020757)
                    ))
                ]))
            fixture.assertions(on: sut)
                .assertIntersections(with: line1.reversed, .init(isContained: false, intersections: [
                    .point(.init(
                        point: .init(x: 175.2719112093773, y: -87.36404439531135),
                        normal: .init(x: 0.9684794080625154, y: -0.2490936293020757)
                    ))
                ]))
            fixture.assertions(on: sut)
                .assertIntersections(with: line2, .init(isContained: false, intersections: []))
        }
    }

    func testIntersections_doubleIntersection() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 0.2,
            sweepAngle: -.pi * 0.4
        )
        let line1 = makeLine(start: .init(x: 170, y: -140), end: .init(x: 170, y: 40))

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertions(on: sut)
                .assertIntersections(with: line1, .init(isContained: false, intersections: [
                    .point(.init(
                        point: .init(x: 170.0, y: -103.85164807134504),
                        normal: .init(x: 0.9333333333333333, y: -0.3590109871423003)
                    )),
                    .point(.init(
                        point: .init(x: 170.0, y: 3.8516480713450396),
                        normal: .init(x: -0.9333333333333333, y: -0.3590109871423003)
                    )),
                ]))
            fixture.assertions(on: sut)
                .assertIntersections(with: line1.reversed, .init(isContained: false, intersections: [
                    .point(.init(
                        point: .init(x: 170.0, y: 3.8516480713450396),
                        normal: .init(x: 0.9333333333333333, y: 0.3590109871423003)
                    )),
                    .point(.init(
                        point: .init(x: 170.0, y: -103.85164807134504),
                        normal: .init(x: -0.9333333333333333, y: 0.3590109871423003)
                    )),
                ]))
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

private func makeLine(start: Vector2D, end: Vector2D) -> LineSegment2D {
    .init(start: start, end: end)
}
