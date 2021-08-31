import XCTest
import Geometria

class ConstructableRectangleTypeTests: XCTestCase {
    typealias Rectangle = Rectangle2D
    
    func testWithLocation() {
        let sut = Rectangle(location: .init(x: 0, y: 0),
                            size: .init(x: 3, y: 4))
        
        let result = sut.withLocation(.init(x: 1, y: 2))
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 3, y: 4))
    }
    
    func testWithSize() {
        let sut = Rectangle(location: .init(x: 1, y: 2),
                            size: .init(x: 0, y: 0))
        
        let result = sut.withSize(.init(x: 3, y: 4))
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 3, y: 4))
    }
}
