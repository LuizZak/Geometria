import XCTest
import Geometria

class Line2Tests: XCTestCase {
    typealias Line = Line2D
    
    func testInitWithCoordinates() {
        let sut = Line(x1: 1, y1: 2, x2: 3, y2: 5)
        
        XCTAssertEqual(sut.a.x, 1)
        XCTAssertEqual(sut.a.y, 2)
        XCTAssertEqual(sut.b.x, 3)
        XCTAssertEqual(sut.b.y, 5)
    }
}
