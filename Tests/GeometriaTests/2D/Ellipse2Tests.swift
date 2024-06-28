import XCTest
import Geometria
import TestCommons

class Ellipse2Tests: XCTestCase {
    typealias Ellipse = Ellipse2D

    func testInitWithRadiusXRadiusY() {
        let sut = Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 4)

        XCTAssertEqual(sut.center.x, 1)
        XCTAssertEqual(sut.center.y, 2)
        XCTAssertEqual(sut.radius.x, 3)
        XCTAssertEqual(sut.radius.y, 4)
    }

    func testRadiusX() {
        let sut = Ellipse(center: .init(x: 1, y: 2), radius: .init(x: 3, y: 4))

        XCTAssertEqual(sut.radiusX, 3)
    }

    func testRadiusX_set() {
        var sut = Ellipse(center: .init(x: 1, y: 2), radius: .init(x: 3, y: 4))

        sut.radiusX = 5

        XCTAssertEqual(sut.center.x, 1)
        XCTAssertEqual(sut.center.y, 2)
        XCTAssertEqual(sut.radius.x, 5)
        XCTAssertEqual(sut.radius.y, 4)
    }

    func testRadiusY() {
        let sut = Ellipse(center: .init(x: 1, y: 2), radius: .init(x: 3, y: 4))

        XCTAssertEqual(sut.radiusY, 4)
    }

    func testRadiusY_set() {
        var sut = Ellipse(center: .init(x: 1, y: 2), radius: .init(x: 3, y: 4))

        sut.radiusY = 5

        XCTAssertEqual(sut.center.x, 1)
        XCTAssertEqual(sut.center.y, 2)
        XCTAssertEqual(sut.radius.x, 3)
        XCTAssertEqual(sut.radius.y, 5)
    }
}

// MARK: Vector: VectorReal Conformance

extension Ellipse2Tests {
    func testContainsXY() {
        let sut = Ellipse(center: .one, radius: .init(x: 1, y: 2))

        XCTAssertTrue(sut.contains(x: 1, y: 1))
        XCTAssertTrue(sut.contains(x: 0, y: 1))
        XCTAssertTrue(sut.contains(x: 2, y: 1))
        XCTAssertFalse(sut.contains(x: 0, y: 0))
        XCTAssertFalse(sut.contains(x: 2, y: 2))
    }
}

// MARK: Vector: Vector2FloatingPoint Conformance

extension Ellipse2Tests {
    func testFoci_sphericalEllipse() {
        let sut = Ellipse(center: .one, radius: .init(x: 2, y: 2))

        let result = sut.foci()

        XCTAssertEqual(result.a, sut.center)
        XCTAssertEqual(result.b, sut.center)
    }

    func testFoci_horizontalEllipse() {
        let sut = Ellipse(center: .one, radius: .init(x: 2, y: 1))

        let result = sut.foci()

        assertEqual(result.a, .init(x: -0.7320508075688772, y: 1), accuracy: 0.0001)
        assertEqual(result.b, .init(x: 2.732050807568877, y: 1), accuracy: 0.0001)
    }

    func testFoci_verticalEllipse() {
        let sut = Ellipse(center: .one, radius: .init(x: 1, y: 2))

        let result = sut.foci()

        assertEqual(result.a, .init(x: 1, y: -0.7320508075688772), accuracy: 0.0001)
        assertEqual(result.b, .init(x: 1, y: 2.732050807568877), accuracy: 0.0001)
    }
}
