import XCTest
import Geometria

class Ellipse2Tests: XCTestCase {
    typealias Ellipse = Ellipse2D
    
    func testInitWithRadiusXRadiusY() {
        let sut = Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 4)
        
        XCTAssertEqual(sut.center.x, 1)
        XCTAssertEqual(sut.center.y, 2)
        XCTAssertEqual(sut.radius.x, 3)
        XCTAssertEqual(sut.radius.y, 4)
    }
}

// MARK: Vector: Vector2Type, Scalar: Real Conformance

extension Ellipse2Tests {
    func testContainsXY() {
        let sut = Ellipse(center: .one, radiusX: 1, radiusY: 2)
        
        XCTAssertTrue(sut.contains(x: 1, y: 1))
        XCTAssertTrue(sut.contains(x: 0, y: 1))
        XCTAssertTrue(sut.contains(x: 2, y: 1))
        XCTAssertFalse(sut.contains(x: 0, y: 0))
        XCTAssertFalse(sut.contains(x: 2, y: 2))
    }
}
