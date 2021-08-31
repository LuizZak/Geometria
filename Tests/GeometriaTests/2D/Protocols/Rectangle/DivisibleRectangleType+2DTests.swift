import XCTest
import Geometria

class DivisibleRectangleType_2DTests: XCTestCase {
    typealias Rectangle = Rectangle2D
    
    func testCenterX() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.centerX, 2.5)
    }
    
    func testCenterX_set() {
        var sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        sut.centerX = 3
        
        XCTAssertEqual(sut.location, .init(x: 1.5, y: 2))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
    
    func testCenterY() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.centerY, 4)
    }
    
    func testCenterY_set() {
        var sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        sut.centerY = 5
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 3))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
    
    func testInflatedByXY() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.inflatedBy(x: 7, y: 11)
        
        XCTAssertEqual(result.location, .init(x: -2.5, y: -3.5))
        XCTAssertEqual(result.size, .init(x: 10, y: 16))
    }
    
    func testInflatedByXY_maintainsCenter() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.inflatedBy(x: 7, y: 11)
        
        XCTAssertEqual(result.center, sut.center)
    }
    
    func testInsetByXY() {
        let sut = Rectangle(x: 1, y: 2, width: 7, height: 11)
        
        let result = sut.insetBy(x: 3, y: 5)
        
        XCTAssertEqual(result.location, .init(x: 2.5, y: 4.5))
        XCTAssertEqual(result.size, .init(x: 4, y: 6))
    }
    
    func testInsetByXY_maintainsCenter() {
        let sut = Rectangle(x: 1, y: 2, width: 7, height: 11)
        
        let result = sut.insetBy(x: 3, y: 5)
        
        XCTAssertEqual(result.center, sut.center)
    }
    
    func testMovingCenterToXY() {
        let sut = Rectangle(x: 1, y: 2, width: 7, height: 11)
        
        let result = sut.movingCenter(toX: 5, y: 13)
        
        XCTAssertEqual(result.location, .init(x: 1.5, y: 7.5))
        XCTAssertEqual(result.size, .init(x: 7, y: 11))
    }
}
