import XCTest
import Geometria

class Cube3Tests: XCTestCase {
    typealias Cube = Cube3D
    
    func testInitWithXYSideLength() {
        let sut = Cube(x: 1, y: 2, z: 3, sideLength: 4)
        
        XCTAssertEqual(sut.location.x, 1)
        XCTAssertEqual(sut.location.y, 2)
        XCTAssertEqual(sut.location.z, 3)
        XCTAssertEqual(sut.sideLength, 4)
    }
}
