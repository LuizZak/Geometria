import XCTest
import Geometria

class DirectionalRay3Tests: XCTestCase {
    typealias DirectionalRay = DirectionalRay3D
    
    func testInitWithCoordinates() {
        let sut = DirectionalRay(x1: 1, y1: 2, z1: 3, x2: 7, y2: 11, z2: 13)
        
        XCTAssertEqual(sut.start.x, 1)
        XCTAssertEqual(sut.start.y, 2)
        XCTAssertEqual(sut.start.z, 3)
        XCTAssertEqual(sut.b.x, 1.4073065399812785)
        XCTAssertEqual(sut.b.y, 2.610959809971918)
        XCTAssertEqual(sut.b.z, 3.6788442333021307)
    }

    func testInitWithPositionDirection() {
        let sut = DirectionalRay(x: 1, y: 2, z: 3, dx: 7, dy: 11, dz: 13)

        XCTAssertEqual(sut.start.x, 1)
        XCTAssertEqual(sut.start.y, 2)
        XCTAssertEqual(sut.start.z, 3)
        XCTAssertEqual(sut.b.x, 1.3801878126154978)
        XCTAssertEqual(sut.b.y, 2.5974379912529253)
        XCTAssertEqual(sut.b.z, 3.706063080571639)
    }
}
