import XCTest
import Geometria
import TestCommons

class Square2Tests: XCTestCase {
    typealias Square = Square2D
    
    func testInitWithXYSideLength() {
        let sut = Square(x: 1, y: 2, sideLength: 3)
        
        XCTAssertEqual(sut.location.x, 1)
        XCTAssertEqual(sut.location.y, 2)
        XCTAssertEqual(sut.sideLength, 3)
    }
}
