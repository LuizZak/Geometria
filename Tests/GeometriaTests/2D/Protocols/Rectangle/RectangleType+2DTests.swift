import XCTest
import Geometria

class RectangleType_2DTests: XCTestCase {
    func testX() {
        let sut = TestRectangle2Type(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.x, 1)
    }
    
    func testY() {
        let sut = TestRectangle2Type(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.y, 2)
    }
    
    func testWidth() {
        let sut = TestRectangle2Type(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.width, 3)
    }
    
    func testHeight() {
        let sut = TestRectangle2Type(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.height, 4)
    }
    
    func testTop() {
        let sut = TestRectangle2Type(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.top, 2)
    }
    
    func testLeft() {
        let sut = TestRectangle2Type(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.left, 1)
    }
    
    func testTopLeft() {
        let sut = TestRectangle2Type(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.topLeft, .init(x: 1, y: 2))
    }
}

private struct TestRectangle2Type: RectangleType {
    typealias Vector = Vector2D
    
    var location: Vector2D
    var size: Vector2D
}
