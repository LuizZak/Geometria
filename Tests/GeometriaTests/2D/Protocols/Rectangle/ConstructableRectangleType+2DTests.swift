import XCTest
import Geometria

class ConstructableRectangleType_2DTests: XCTestCase {
    typealias Rectangle = Rectangle2D
    
    func testInitWithXYWidthHeight() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
    
    func testWithSizeWidthHeight() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.withSize(width: 5, height: 6)
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 5, y: 6))
    }
    
    func testWithLocationXY() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.withLocation(x: 5, y: 6)
        
        XCTAssertEqual(result.location, .init(x: 5, y: 6))
        XCTAssertEqual(result.size, .init(x: 3, y: 4))
    }
}
