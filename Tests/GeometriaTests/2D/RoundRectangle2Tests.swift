import XCTest
import Geometria
import TestCommons

class RoundRectangle2Tests: XCTestCase {
    typealias RoundRectangle = RoundRectangle2D
    
    func testInitWithRadiusXY() {
        let sut = RoundRectangle(rectangle: .init(x: 1, y: 2, width: 3, height: 5), radiusX: 7, radiusY: 11)
        
        XCTAssertEqual(sut.bounds.x, 1)
        XCTAssertEqual(sut.bounds.y, 2)
        XCTAssertEqual(sut.bounds.width, 3)
        XCTAssertEqual(sut.bounds.height, 5)
        XCTAssertEqual(sut.radius.x, 7)
        XCTAssertEqual(sut.radius.y, 11)
    }
}
