import XCTest
import Geometria

class Line3Tests: XCTestCase {
    typealias Line = Line3D
    
    func testInitWithCoordinates() {
        let sut = Line(x1: 1, y1: 2, z1: 3, x2: 5, y2: 7, z2: 11)
        
        XCTAssertEqual(sut.start.x, 1)
        XCTAssertEqual(sut.start.y, 2)
        XCTAssertEqual(sut.start.z, 3)
        XCTAssertEqual(sut.end.x, 5)
        XCTAssertEqual(sut.end.y, 7)
        XCTAssertEqual(sut.end.z, 11)
    }
}
