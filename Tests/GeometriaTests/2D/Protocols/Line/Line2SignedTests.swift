import XCTest
import TestCommons

@testable import Geometria

class Line2SignedTests: XCTestCase {
    func testIsCollinear_vector_endPoints() {
        let sut = makeSut(start: .init(x: 10, y: 20), end: .init(x: 200, y: 250))

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertTrue(sut.isCollinear(with: sut.start, tolerance: 1e-14))
            fixture.assertTrue(sut.isCollinear(with: sut.end, tolerance: 1e-14))
        }
    }

    func testIsCollinear_vector_collinear() {
        let sut = makeSut(start: .init(x: 10, y: 20), end: .init(x: 200, y: 250))
        let point1 = sut.projectedNormalizedMagnitude(-0.5)
        let point2 = sut.projectedNormalizedMagnitude(1.5)

        TestFixture.beginFixture { fixture in
            fixture.add(sut)
            fixture.add(point1)
            fixture.add(point2)

            fixture.assertTrue(sut.isCollinear(with: point1, tolerance: 1e-14))
            fixture.assertTrue(sut.isCollinear(with: point2, tolerance: 1e-14))
        }
    }

    func testIsCollinear_vector_notCollinear() {
        let sut = makeSut(start: .init(x: 10, y: 20), end: .init(x: 200, y: 250))
        let point1 = sut.projectedNormalizedMagnitude(-0.5) + sut.lineSlope.rightRotated()
        let point2 = sut.projectedNormalizedMagnitude(1.5) + sut.lineSlope.rightRotated()

        TestFixture.beginFixture { fixture in
            fixture.add(sut)
            fixture.add(point1)
            fixture.add(point2)

            fixture.assertFalse(sut.isCollinear(with: point1, tolerance: 1e-14))
            fixture.assertFalse(sut.isCollinear(with: point2, tolerance: 1e-14))
        }
    }

    func testIsCollinear_line_sameLine() {
        let sut = makeSut(start: .init(x: 10, y: 20), end: .init(x: 200, y: 250))

        TestFixture.beginFixture { fixture in
            fixture.add(sut)

            fixture.assertTrue(sut.isCollinear(with: sut, tolerance: 1e-14))
        }
    }

    func testIsCollinear_line_collinear_beforeStart() {
        let sut = makeSut(start: .init(x: 10, y: 20), end: .init(x: 200, y: 250))
        let line = makeSut(
            start: sut.projectedNormalizedMagnitude(-1.0),
            end: sut.projectedNormalizedMagnitude(-0.5)
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)
            fixture.add(line)

            fixture.assertTrue(sut.isCollinear(with: line, tolerance: 1e-14))
        }
    }

    func testIsCollinear_line_collinear_afterEnd() {
        let sut = makeSut(start: .init(x: 10, y: 20), end: .init(x: 200, y: 250))
        let line = makeSut(
            start: sut.projectedNormalizedMagnitude(1.0),
            end: sut.projectedNormalizedMagnitude(1.5)
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)
            fixture.add(line)

            fixture.assertTrue(sut.isCollinear(with: line, tolerance: 1e-14))
        }
    }

    func testIsCollinear_line_collinear_reversed() {
        let sut = makeSut(start: .init(x: 10, y: 20), end: .init(x: 200, y: 250))
        let line = makeSut(
            start: sut.end,
            end: sut.start
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)
            fixture.add(line)

            fixture.assertTrue(sut.isCollinear(with: line, tolerance: 1e-14))
        }
    }

    func testIsCollinear_line_coincidentStart_nonCollinear() {
        let sut = makeSut(start: .init(x: 10, y: 20), end: .init(x: 200, y: 250))
        let line = makeSut(
            start: sut.start,
            end: sut.projectedNormalizedMagnitude(1.5) + sut.lineSlope.rightRotated()
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)
            fixture.add(line)

            fixture.assertFalse(sut.isCollinear(with: line, tolerance: 1e-14))
        }
    }

    func testIsCollinear_line_coincidentEnd_nonCollinear() {
        let sut = makeSut(start: .init(x: 10, y: 20), end: .init(x: 200, y: 250))
        let line = makeSut(
            start: sut.start + sut.lineSlope.rightRotated(),
            end: sut.end
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)
            fixture.add(line)

            fixture.assertFalse(sut.isCollinear(with: line, tolerance: 1e-14))
        }
    }

    func testIsCollinear_line_intersecting_nonCollinear() {
        let sut = makeSut(start: .init(x: 10, y: 20), end: .init(x: 200, y: 250))
        let line = makeSut(
            start: sut.start - sut.lineSlope.rightRotated(),
            end: sut.end + sut.lineSlope.rightRotated()
        )

        TestFixture.beginFixture { fixture in
            fixture.add(sut)
            fixture.add(line)

            fixture.assertFalse(sut.isCollinear(with: line, tolerance: 1e-14))
        }
    }
}

// MARK: - Test internals

private func makeSut(
    start: Vector2D,
    end: Vector2D
) -> LineSegment2D {
    return .init(start: start, end: end)
}
