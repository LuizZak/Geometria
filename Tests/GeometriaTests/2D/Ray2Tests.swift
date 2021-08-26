import XCTest
import Geometria

class Ray2Tests: XCTestCase {
    typealias Ray = Ray2D
    
    func testInitWithCoordinates() {
        let sut = Ray(x: 1, y: 2, dx: 3, dy: 5)
        
        XCTAssertEqual(sut.start.x, 1)
        XCTAssertEqual(sut.start.y, 2)
        XCTAssertEqual(sut.b.x, 4)
        XCTAssertEqual(sut.b.y, 7)
    }
}
