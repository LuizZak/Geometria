import XCTest
import Geometria

class AdditiveRectangleTypeTests: XCTestCase {
    typealias Rectangle = Rectangle2D
    
    func testOffsetBy() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.offsetBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(result.location, .init(x: 8, y: 13))
        XCTAssertEqual(result.size, .init(x: 3, y: 5))
    }
    
    func testResizedBy() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.resizedBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 10, y: 16))
    }
}
