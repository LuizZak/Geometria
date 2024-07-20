import XCTest
import Geometria
import TestCommons

class Line3Tests: XCTestCase {
    typealias Line = Line3D
    
    func testInitWithCoordinates() {
        let sut = Line(x1: 1, y1: 2, z1: 3, x2: 5, y2: 7, z2: 11)
        
        XCTAssertEqual(sut.a.x, 1)
        XCTAssertEqual(sut.a.y, 2)
        XCTAssertEqual(sut.a.z, 3)
        XCTAssertEqual(sut.b.x, 5)
        XCTAssertEqual(sut.b.y, 7)
        XCTAssertEqual(sut.b.z, 11)
    }
    
    func testMake2DLine() {
        let result =
        Line.make2DLine(
            .init(x: 1, y: 2),
            .init(x: 3, y: 5)
        )
        
        XCTAssertEqual(result.a, .init(x: 1, y: 2))
        XCTAssertEqual(result.b, .init(x: 3, y: 5))
        XCTAssertEqual(result.category, .line)
    }
}
