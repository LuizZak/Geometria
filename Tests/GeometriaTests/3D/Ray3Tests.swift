import XCTest
import Geometria

class Ray3Tests: XCTestCase {
    typealias Ray = Ray3D
    
    func testInitWithCoordinates() {
        let sut = Ray(x: 1, y: 2, z: 3, dx: 7, dy: 11, dz: 13)
        
        XCTAssertEqual(sut.start.x, 1)
        XCTAssertEqual(sut.start.y, 2)
        XCTAssertEqual(sut.start.z, 3)
        XCTAssertEqual(sut.b.x, 8)
        XCTAssertEqual(sut.b.y, 13)
        XCTAssertEqual(sut.b.z, 16)
    }
}
