import XCTest
import Geometria

class ConstructableRectangleType_2DTests: XCTestCase {
    typealias Rectangle = Rectangle2D
    
    func testX_set() {
        var sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        sut.x = 5
        
        XCTAssertEqual(sut.location, .init(x: 5, y: 2))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
    
    func testY_set() {
        var sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        sut.y = 5
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 5))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
    
    func testWidth_set() {
        var sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        sut.width = 5
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
        XCTAssertEqual(sut.size, .init(x: 5, y: 4))
    }
    
    func testHeight_set() {
        var sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        sut.height = 5
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
        XCTAssertEqual(sut.size, .init(x: 3, y: 5))
    }
    
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
    
    func testMovingTopTo() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.movingTop(to: 5)
        
        XCTAssertEqual(result.location, .init(x: 1, y: 5))
        XCTAssertEqual(result.size, .init(x: 3, y: 4))
    }
    
    func testMovingLeftTo() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.movingLeft(to: 5)
        
        XCTAssertEqual(result.location, .init(x: 5, y: 2))
        XCTAssertEqual(result.size, .init(x: 3, y: 4))
    }
}

// MARK: Self: AdditiveRectangleType, Vector: Vector2Type Conformance

extension ConstructableRectangleType_2DTests {
    func testOffsetByXY() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.offsetBy(x: 5, y: 6)
        
        XCTAssertEqual(result.location, .init(x: 6, y: 8))
        XCTAssertEqual(result.size, .init(x: 3, y: 4))
    }
}
