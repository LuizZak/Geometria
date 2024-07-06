import XCTest
import TestCommons

@testable import Geometria

class CircleArc2Tests: XCTestCase {
    typealias Sut = CircleArc2D

    func testInitWithStartPointEndPointSweepAngle() {
        let sut = Sut(
            startPoint: .init(x: -90, y: -31),
            endPoint: .init(x: -90, y: -110),
            sweepAngle: .pi
        )

        TestFixture.beginFixture { fixture in
            fixture.assertEquals(
                sut,
                .init(
                    center: .init(x: -90.0, y: -70.5),
                    radius: 39.5,
                    startAngle: .init(radians: 1.5707963267948966),
                    sweepAngle: .pi
                )
            )
        }
    }

    func testInitWithCenterStartPointEndPoint() {
        let sut = Sut(
            center: .init(x: -10, y: -70),
            startPoint: .init(x: -90, y: -30),
            endPoint: .init(x: -90, y: -110)
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertEquals(sut.center, .init(x: -10, y: -70))
            fixture.assertEquals(sut.startPoint, .init(x: -90, y: -30), accuracy: 1e-13)
            fixture.assertEquals(sut.endPoint, .init(x: -90, y: -110), accuracy: 1e-13)
            fixture.assertEquals(sut.sweepAngle, Angle(radians: 0.9272952180016123))
        }
    }

    func testInitWithCenterStartPointEndPoint_negativeSweep() {
        let sut = Sut(
            center: .init(x: -10, y: -70),
            startPoint: .init(x: -90, y: -110),
            endPoint: .init(x: -90, y: -30)
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertEquals(sut.center, .init(x: -10, y: -70))
            fixture.assertEquals(sut.startPoint, .init(x: -90, y: -110), accuracy: 1e-13)
            fixture.assertEquals(sut.endPoint, .init(x: -90, y: -30), accuracy: 1e-13)
            fixture.assertEquals(sut.sweepAngle, Angle(radians: -0.9272952180016123))
        }
    }

    func testArea() {
        let sut = makeSut(
            center: .init(x: 1.0, y: 2.0),
            radius: 1.0,
            startAngle: .pi / 4,
            sweepAngle: .pi / 2
        )

        assertEqual(sut.area, 0.7853981633974483)
    }

    func testArcLength() {
        let sut = makeSut(
            center: .init(x: 1.0, y: 2.0),
            radius: 1.0,
            startAngle: .pi / 4,
            sweepAngle: .pi / 2
        )

        assertEqual(sut.arcLength, .pi / 2)
    }

    func testChordLength() {
        let sut = makeSut(
            center: .init(x: 1.0, y: 2.0),
            radius: 1.5,
            startAngle: .pi / 4,
            sweepAngle: .pi / 2
        )

        assertEqual(sut.chordLength, 2.1213203435596424, accuracy: 1e-14)
    }

    func testChordLength_piOverThree() {
        let sut = makeSut(
            center: .init(x: 1.0, y: 2.0),
            radius: 2.0,
            startAngle: .pi / 4,
            sweepAngle: .pi / 3
        )

        assertEqual(sut.chordLength, 2.0, accuracy: 1e-14)
    }

    func testStartPoint() {
        let sut = makeSut(
            center: .init(x: 10.0, y: 20.0),
            radius: 150.0,
            startAngle: .pi / 4,
            sweepAngle: .pi / 2
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertEquals(
                sut.startPoint,
                .init(x: 116.06601717798213, y: 126.06601717798212)
            )
        }
    }

    func testEndPoint() {
        let sut = makeSut(
            center: .init(x: 10.0, y: 20.0),
            radius: 150.0,
            startAngle: .pi / 4,
            sweepAngle: .pi / 2
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertEquals(
                sut.endPoint,
                .init(x: -96.06601717798212, y: 126.06601717798213)
            )
        }
    }

    func testContainsAngle_subStart_subSweep() {
        let sut = makeSut(
            center: .init(x: 1.0, y: 2.0),
            radius: 1.0,
            startAngle: .pi / 4,
            sweepAngle: .pi / 3
        )

        XCTAssertTrue(sut.contains(Angle.pi / 4.0))
        XCTAssertTrue(sut.contains(Angle.pi / 2.0))
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
        XCTAssertTrue(sut.contains(Angle.pi / 4.0))
        XCTAssertTrue(sut.contains(Angle.pi / 2.0))
        XCTAssertTrue(sut.contains(Angle.pi / 4.0 + Angle.pi * 1.5))
        XCTAssertFalse(sut.contains((Double.pi / 4).nextDown))
        XCTAssertFalse(sut.contains((Double.pi / 4 + Double.pi * 1.5).nextUp))
        XCTAssertFalse(sut.contains(Angle.pi * 1.9))
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
        XCTAssertTrue(sut.contains(Angle.pi * 1.2))
        XCTAssertTrue(sut.contains(Angle.pi * 1.8))
        XCTAssertTrue(sut.contains(Angle.pi * 2.0))
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

        XCTAssertTrue(sut.contains(Angle.pi / 4.0))
        XCTAssertTrue(sut.contains(Angle.pi / 2.0))
        XCTAssertTrue(sut.contains(Angle.pi / 4.0 + Angle.pi / 3.0))
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
                        normalizedMagnitude: 0.615846004801639,
                        point: .init(x: -46.390152057619666, y: -179.0912261488508),
                        normal: .init(x: 0.5092676803841312, y: 0.860608174325672)
                    ))
                ]))
            fixture.assertions(on: sut)
                .assertIntersections(with: line1.reversed, .init(isContained: false, intersections: [
                    .point(.init(
                        normalizedMagnitude: 0.3841539951983606,
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
                        normalizedMagnitude: 0.5054382241875461,
                        point: .init(x: 175.2719112093773, y: -87.36404439531135),
                        normal: .init(x: -0.9684794080625154, y: 0.2490936293020757)
                    ))
                ]))
            fixture.assertions(on: sut)
                .assertIntersections(with: line1.reversed, .init(isContained: false, intersections: [
                    .point(.init(
                        normalizedMagnitude: 0.49456177581245386,
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
                        normalizedMagnitude: 0.5054382241875461,
                        point: .init(x: 175.2719112093773, y: -87.36404439531135),
                        normal: .init(x: -0.9684794080625154, y: 0.2490936293020757)
                    ))
                ]))
            fixture.assertions(on: sut)
                .assertIntersections(with: line1.reversed, .init(isContained: false, intersections: [
                    .point(.init(
                        normalizedMagnitude: 0.49456177581245386,
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
                        normalizedMagnitude: 0.20082417738141645,
                        point: .init(x: 170.0, y: -103.85164807134504),
                        normal: .init(x: 0.9333333333333333, y: -0.3590109871423003)
                    )),
                    .point(.init(
                        normalizedMagnitude: 0.7991758226185836,
                        point: .init(x: 170.0, y: 3.8516480713450396),
                        normal: .init(x: -0.9333333333333333, y: -0.3590109871423003)
                    )),
                ]))
            fixture.assertions(on: sut)
                .assertIntersections(with: line1.reversed, .init(isContained: false, intersections: [
                    .point(.init(
                        normalizedMagnitude: 0.20082417738141645,
                        point: .init(x: 170.0, y: 3.8516480713450396),
                        normal: .init(x: 0.9333333333333333, y: 0.3590109871423003)
                    )),
                    .point(.init(
                        normalizedMagnitude: 0.7991758226185836,
                        point: .init(x: 170.0, y: -103.85164807134504),
                        normal: .init(x: -0.9333333333333333, y: 0.3590109871423003)
                    )),
                ]))
        }
    }
}

extension CircleArc2Tests {
    func testBounds_exactHalfQuadrant() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: 0.0,
            sweepAngle: .pi / 2
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertEquals(
                sut.bounds(),
                .init(
                    left: 30.00000000000001,
                    top: -50.0,
                    right: 180.0,
                    bottom: 100.0
                )
            )
        }
    }

    func testBounds_fourQuadrants() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 0.2,
            sweepAngle: .pi * 1.6
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertEquals(
                sut.bounds(),
                .init(
                    left: -120.0,
                    top: -200.0,
                    right: 151.3525491562421,
                    bottom: 100.0
                )
            )
        }
    }

    func testBounds_overOrigin() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 0.2,
            sweepAngle: -.pi * 0.4
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertEquals(
                sut.bounds(),
                .init(
                    left: 151.3525491562421,
                    top: -138.16778784387097,
                    right: 180.0,
                    bottom: 38.16778784387097
                )
            )
        }
    }

    func testQuadrants_exactHalfQuadrant() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: 0.0,
            sweepAngle: .pi / 2
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertEquals(
                sut.quadrants(),
                [
                    .init(x: 180.0, y: -50.0),
                    .init(x: 30.00000000000001, y: 100.0)
                ]
            )
        }
    }

    func testQuadrants_rotatedHalfQuadrant() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi / 4,
            sweepAngle: .pi / 2
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertEquals(
                sut.quadrants(),
                [
                    .init(x: 30.00000000000001, y: 100.0)
                ]
            )
        }
    }

    func testQuadrants_negativeSweep_exactHalfQuadrant() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi / 2,
            sweepAngle: -.pi / 2
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertEquals(
                sut.quadrants(),
                [
                    .init(x: 180.0, y: -50.0),
                    .init(x: 30.00000000000001, y: 100.0)
                ]
            )
        }
    }

    func testQuadrants_fourQuadrants() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 0.2,
            sweepAngle: .pi * 1.9
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertEquals(
                sut.quadrants(),
                [
                    .init(x: 180.0, y: -50.0),
                    .init(x: 30.00000000000001, y: 100.0),
                    .init(x: -120.0, y: -49.99999999999998),
                    .init(x: 29.99999999999997, y: -200.0)
                ]
            )
        }
    }

    func testProject() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 1.3,
            sweepAngle: .pi * 0.3
        )

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertProject(
                    .init(x: -39, y: -160),
                    expected: .init(x: -49.70740782230952, y: -177.06978058629056),
                    accuracy: 1e-13
                )
                .assertProject(
                    .init(x: -60, y: -140),
                    expected: .init(x: -58.16778784387098, y: -171.3525491562421),
                    accuracy: 1e-14
                )
        }
    }

    func testProject_wrappedAround_positiveSweep() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 1.8,
            sweepAngle: .pi * 0.4
        )

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertProject(
                    .init(x: 150, y: -100),
                    expected: .init(x: 168.46153846153848, y: -107.69230769230768),
                    accuracy: 1e-14
                )
                .assertProject(
                    .init(x: -60, y: -140),
                    expected: .init(x: 151.3525491562421, y: -138.167787843871),
                    accuracy: 1e-14
                )
        }
    }

    func testProject_wrappedAround_negativeSweep() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 0.2,
            sweepAngle: -.pi * 0.4
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertions(on: sut)
                .assertProject(
                    .init(x: 150, y: -100),
                    expected: .init(x: 168.46153846153848, y: -107.69230769230768),
                    accuracy: 1e-14
                )
                .assertProject(
                    .init(x: -60, y: -140),
                    expected: .init(x: 151.3525491562421, y: -138.167787843871),
                    accuracy: 1e-14
                )
        }
    }

    func testProject_outside() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 0.2,
            sweepAngle: -.pi * 0.4
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertions(on: sut)
                .assertProject(
                    .init(x: 170, y: -140),
                    expected: .init(x: 156.17677130648303, y: -131.1136386970248),
                    accuracy: 1e-14
                )
                .assertProject(
                    .init(x: 170, y: 40),
                    expected: .init(x: 156.17677130648303, y: 31.11363869702481),
                    accuracy: 1e-14
                )
        }
    }

    func testDistanceSquaredTo() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 1.3,
            sweepAngle: .pi * 0.3
        )

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertDistanceSquaredTo(
                    .init(x: -39, y: -160),
                    406.0259915373573,
                    accuracy: 1e-12
                )
                .assertDistanceSquaredTo(
                    .init(x: -60, y: -140),
                    986.3393399796445,
                    accuracy: 1e-14
                )
        }
    }

    func testDistanceSquaredTo_wrappedAround_positiveSweep() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 1.8,
            sweepAngle: .pi * 0.4
        )

        TestFixture.beginFixture { fixture in
            fixture.assertions(on: sut)
                .assertDistanceSquaredTo(
                    .init(x: 150, y: -100),
                    400.0000000000005,
                    accuracy: 1e-14
                )
                .assertDistanceSquaredTo(
                    .init(x: -60, y: -140),
                    44673.2570362268,
                    accuracy: 1e-14
                )
        }
    }

    func testDistanceSquaredTo_wrappedAround_negativeSweep() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 0.2,
            sweepAngle: -.pi * 0.4
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertions(on: sut)
                .assertDistanceSquaredTo(
                    .init(x: 150, y: -100),
                    400.0000000000005,
                    accuracy: 1e-14
                )
                .assertDistanceSquaredTo(
                    .init(x: -60, y: -140),
                    44673.2570362268,
                    accuracy: 1e-14
                )
        }
    }

    func testDistanceSquaredTo_outside_positiveSweep() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 1.8,
            sweepAngle: .pi * 0.4
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertions(on: sut)
                .assertDistanceSquaredTo(
                    .init(x: 170, y: -140),
                    270.0490687202857,
                    accuracy: 1e-14
                )
                .assertDistanceSquaredTo(
                    .init(x: 170, y: 40),
                    270.0490687202857,
                    accuracy: 1e-14
                )
        }
    }

    func testDistanceSquaredTo_outside_negativeSweep() {
        let sut = makeSut(
            center: .init(x: 30, y: -50),
            radius: 150,
            startAngle: .pi * 0.2,
            sweepAngle: -.pi * 0.4
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertions(on: sut)
                .assertDistanceSquaredTo(
                    .init(x: 170, y: -140),
                    270.0490687202857,
                    accuracy: 1e-14
                )
                .assertDistanceSquaredTo(
                    .init(x: 170, y: 40),
                    270.0490687202857,
                    accuracy: 1e-14
                )
        }
    }
}

// MARK: - Test internals

private func makeSut(
    startAngle: Double,
    sweepAngle: Double
) -> CircleArc2D {
    return makeSut(
        center: .zero,
        radius: 1.0,
        startAngle: startAngle,
        sweepAngle: sweepAngle
    )
}

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

private extension AssertionWrapperType where Value == CircleArc2Tests.Sut {
    @discardableResult
    func assertProject(
        _ vector: Vector2D,
        expected: Vector2D,
        accuracy: Double,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        let result = value.project(vector)

        if !fixture.assertEquals(result, expected, accuracy: accuracy, file: file, line: line) {
            visualize()
            fixture.add(vector)
        }

        return self
    }

    @discardableResult
    func assertDistanceSquaredTo(
        _ vector: Vector2D,
        _ expected: Double,
        accuracy: Double,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
        let result = value.distanceSquared(to: vector)

        if fixture.assertEquals(result, expected, accuracy: accuracy, file: file, line: line) {
            visualize()
            fixture.add(vector)

            let projected = value.project(vector)
            fixture.add(projected, style: fixture.resultStyle())
        }

        return self
    }
}
