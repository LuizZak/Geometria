import XCTest
import Geometria

class Line2Tests: XCTestCase {
    typealias Line = Line2D
    
    func testInitWithCoordinates() {
        let sut = Line(x1: 1, y1: 2, x2: 3, y2: 5)
        
        XCTAssertEqual(sut.start.x, 1)
        XCTAssertEqual(sut.start.y, 2)
        XCTAssertEqual(sut.end.x, 3)
        XCTAssertEqual(sut.end.y, 5)
    }
}

// MARK: Vector2Real Conformance

extension LineTests {
    func testAngle() {
        let sut = Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.angle, 0.982793723247329, accuracy: 1e-13)
    }
}
