import XCTest
import Geometria

class LineSegment2Tests: XCTestCase {
    typealias LineSegment = LineSegment2D
    
    func testInitWithCoordinates() {
        let sut = LineSegment(x1: 1, y1: 2, x2: 3, y2: 5)
        
        XCTAssertEqual(sut.start.x, 1)
        XCTAssertEqual(sut.start.y, 2)
        XCTAssertEqual(sut.end.x, 3)
        XCTAssertEqual(sut.end.y, 5)
    }
}

// MARK: Vector2Real Conformance

extension LineSegment2Tests {
    func testAngle() {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.angle, 0.982793723247329, accuracy: 1e-13)
    }
}
