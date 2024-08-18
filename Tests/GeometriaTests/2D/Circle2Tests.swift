import XCTest
import Geometria
import TestCommons

class Circle2Tests: XCTestCase {
    func testContainsXY() {
        let sut = makeSut(center: .init(x: 0, y: 1), radius: 2)

        XCTAssertTrue(sut.contains(x: 1, y: 1))
        XCTAssertTrue(sut.contains(x: 0, y: 1))
        XCTAssertTrue(sut.contains(x: -1, y: 1))
        XCTAssertTrue(sut.contains(x: -2, y: 1))
        XCTAssertTrue(sut.contains(x: 2, y: 1))
        XCTAssertTrue(sut.contains(x: 0, y: -1))
        XCTAssertTrue(sut.contains(x: 0, y: 0))
        XCTAssertTrue(sut.contains(x: 0, y: 3))
        //
        XCTAssertFalse(sut.contains(x: -3, y: 1))
        XCTAssertFalse(sut.contains(x: 3, y: 1))
        XCTAssertFalse(sut.contains(x: 0, y: 4))
        XCTAssertFalse(sut.contains(x: 0, y: -3))
    }
}

// MARK: Vector: Vector2FloatingPoint Conformance

extension Circle2Tests {
    func testIntersectionWithCircle_noIntersection() {
        let c1 = makeSut(x: 0, y: 0, radius: 1)
        let c2 = makeSut(x: 3, y: 0, radius: 1)

        XCTAssertEqual(c1.intersection(with: c2), .noIntersection)
    }

    func testIntersectionWithCircle_singlePoint() {
        let c1 = makeSut(x: 0, y: 0, radius: 1)
        let c2 = makeSut(x: 2, y: 0, radius: 1)

        XCTAssertEqual(
            c1.intersection(with: c2),
            .singlePoint(
                .init(point: .init(x: 1, y: 0), normal: .init(x: 1, y: 0))
            )
        )
    }

    func testIntersectionWithCircle_twoPoints() {
        let c1 = makeSut(x: 0, y: 0, radius: 1)
        let c2 = makeSut(x: 2, y: 1, radius: 2)

        TestFixture.beginFixture(lineScale: 160, renderScale: 80) { fixture in
            fixture.add(c1)
            fixture.add(c2)

            let result = c1.intersection(with: c2)

            fixture.assertEquals(
                result,
                .twoPoints(
                    .init(
                        point: .init(x: 0.8, y: -0.5999999999999998),
                        normal: .init(x: 0.8000000000000002, y: -0.5999999999999999)
                    ),
                    .init(
                        point: .init(x: 2.220446049250313e-16, y: 0.9999999999999999),
                        normal: .init(x: 2.2204460492503136e-16, y: 1.0)
                    )
                )
            )
        }
    }

    func testIntersectionWithCircle_contained() {
        let c1 = makeSut(x: 0, y: 0, radius: 1)
        let c2 = makeSut(x: 0, y: 0, radius: 2)

        XCTAssertEqual(c1.intersection(with: c2), .contained)
    }

    func testIntersectionWithCircle_contains() {
        let c1 = makeSut(x: 0, y: 0, radius: 2)
        let c2 = makeSut(x: 0, y: 0, radius: 1)

        XCTAssertEqual(c1.intersection(with: c2), .contains)
    }
}

// MARK: Vector: Vector2Real Conformance

extension Circle2Tests {
    func testTangentsTo() {
        let circle = makeSut(x: 0, y: 0, radius: 200)
        let point = Vector2D(x: 300, y: 100)

        TestFixture.beginFixture { fixture in
            fixture.add(circle)
            let (t1, t2) = circle.tangents(to: point)

            fixture.add(point)

            fixture.add(t1)
            fixture.add(t2)

            fixture.add(LineSegment2D(start: point, end: t1))
            fixture.add(LineSegment2D(start: point, end: t2))

            fixture.assertEquals(t1, .init(x: 71.01020514433644, y: 186.96938456699067), accuracy: 1e-14)
            fixture.assertEquals(t2, .init(x: 168.98979485566355, y: -106.96938456699068), accuracy: 1e-14)
        }
    }

    func testOuterTangentsTo() {
        let c1 = makeSut(x: -100, y: 0, radius: 100)
        let c2 = makeSut(x: 100, y: 25, radius: 75)

        TestFixture.beginFixture { fixture in
            fixture.add(c1)
            fixture.add(c2)

            let (t1, t2) = c1.outerTangents(to: c2)

            fixture.add(t1)
            fixture.add(t2)

            fixture.assertEquals(
                t1.start,
                .init(x: -75.38461538461537, y: -96.92307692307692),
                accuracy: 1e-14
            )
            fixture.assertEquals(
                t1.end,
                .init(x: 118.46153846153847, y: -47.69230769230769),
                accuracy: 1e-14
            )

            fixture.assertEquals(
                t2.start,
                .init(x: -100.0, y: 100.0),
                accuracy: 1e-14
            )
            fixture.assertEquals(
                t2.end,
                .init(x: 100.0, y: 100.0),
                accuracy: 1e-14
            )
        }
    }
}

// MARK: - Test internals

private func makeSut(center: Vector2D, radius: Double) -> Circle2D {
    .init(center: center, radius: radius)
}

private func makeSut(x: Double, y: Double, radius: Double) -> Circle2D {
    .init(x: x, y: y, radius: radius)
}
