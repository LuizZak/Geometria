import XCTest
import Geometria

class RectangleType_2DTests: XCTestCase {
    typealias Rectangle = Rectangle2D
    
    func testX() {
        let sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.x, 1)
    }
    
    func testY() {
        let sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.y, 2)
    }
    
    func testWidth() {
        let sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.width, 3)
    }
    
    func testHeight() {
        let sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.height, 4)
    }
    
    func testTop() {
        let sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.top, 2)
    }
    
    func testLeft() {
        let sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.left, 1)
    }
    
    func testTopLeft() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.topLeft, .init(x: 1, y: 2))
    }
}
