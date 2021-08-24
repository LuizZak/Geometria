import XCTest
import Geometria

class Square2Tests: XCTestCase {
    typealias Square = Square2D
    
    func testInitWithXYSideLength() {
        let sut = Square(x: 1, y: 2, sideLength: 3)
        
        XCTAssertEqual(sut.origin.x, 1)
        XCTAssertEqual(sut.origin.y, 2)
        XCTAssertEqual(sut.sideLength, 3)
    }
}
