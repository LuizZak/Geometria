import XCTest
import Geometria

class Cube3Tests: XCTestCase {
    typealias Cube = Cube3D
    
    func testInitWithXYSideLength() {
        let sut = Cube(x: 1, y: 2, z: 3, sideLength: 4)
        
        XCTAssertEqual(sut.origin.x, 1)
        XCTAssertEqual(sut.origin.y, 2)
        XCTAssertEqual(sut.origin.z, 3)
        XCTAssertEqual(sut.sideLength, 4)
    }
}
