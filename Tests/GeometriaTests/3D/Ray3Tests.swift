import XCTest
import Geometria

class Ray3Tests: XCTestCase {
    typealias Ray = Ray3D

    func testInitWithCoordinates() {
        let sut = Ray(x1: 1, y1: 2, z1: 3, x2: 7, y2: 11, z2: 13)

        XCTAssertEqual(sut.start.x, 1)
        XCTAssertEqual(sut.start.y, 2)
        XCTAssertEqual(sut.start.z, 3)
        XCTAssertEqual(sut.b.x, 7)
        XCTAssertEqual(sut.b.y, 11)
        XCTAssertEqual(sut.b.z, 13)
    }
    
    func testInitWithPositionDirection() {
        let sut = Ray(x: 1, y: 2, z: 3, dx: 7, dy: 11, dz: 13)
        
        XCTAssertEqual(sut.start.x, 1)
        XCTAssertEqual(sut.start.y, 2)
        XCTAssertEqual(sut.start.z, 3)
        XCTAssertEqual(sut.b.x, 8)
        XCTAssertEqual(sut.b.y, 13)
        XCTAssertEqual(sut.b.z, 16)
    }
    
    func testMake2DLine() {
        let result =
        Ray(start: .zero, b: .one).make2DLine(
            .init(x: 1, y: 2),
            .init(x: 3, y: 5)
        )
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.b, .init(x: 3, y: 5))
        XCTAssertEqual(result.category, .ray)
    }
}
