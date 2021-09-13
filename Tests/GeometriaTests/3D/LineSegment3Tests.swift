import XCTest
import Geometria

class LineSegment3Tests: XCTestCase {
    typealias LineSegment = LineSegment3D
    
    func testInitWithCoordinates() {
        let sut = LineSegment(x1: 1, y1: 2, z1: 3, x2: 5, y2: 7, z2: 11)
        
        XCTAssertEqual(sut.start.x, 1)
        XCTAssertEqual(sut.start.y, 2)
        XCTAssertEqual(sut.start.z, 3)
        XCTAssertEqual(sut.end.x, 5)
        XCTAssertEqual(sut.end.y, 7)
        XCTAssertEqual(sut.end.z, 11)
    }
    
    func testMake2DLine() {
        let result =
        LineSegment.make2DLine(
            .init(x: 1, y: 2),
            .init(x: 3, y: 5)
        )
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.end, .init(x: 3, y: 5))
    }
}
