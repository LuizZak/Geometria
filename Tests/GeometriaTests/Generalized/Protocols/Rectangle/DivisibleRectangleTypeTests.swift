import XCTest
import Geometria

class DivisibleRectangleTypeTests: XCTestCase {
    typealias Rectangle = Rectangle2D
    
    func testCenter() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        XCTAssertEqual(sut.center, .init(x: 2.5, y: 4.5))
    }
    
    func testCenter_set() {
        var sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        sut.center = .init(x: 11, y: 13)
        
        XCTAssertEqual(sut.location, .init(x: 9.5, y: 10.5))
        XCTAssertEqual(sut.size, .init(x: 3, y: 5))
    }
    
    func testInflatedByVector() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.inflatedBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(result.location, .init(x: -2.5, y: -3.5))
        XCTAssertEqual(result.size, .init(x: 10, y: 16))
    }
    
    func testInflatedByVector_maintainsCenter() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.inflatedBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(result.center, sut.center)
    }
    
    func testInsetByVector() {
        let sut = Rectangle(x: 1, y: 2, width: 7, height: 11)
        
        let result = sut.insetBy(.init(x: 3, y: 5))
        
        XCTAssertEqual(result.location, .init(x: 2.5, y: 4.5))
        XCTAssertEqual(result.size, .init(x: 4, y: 6))
    }
    
    func testInsetByVector_maintainsCenter() {
        let sut = Rectangle(x: 1, y: 2, width: 7, height: 11)
        
        let result = sut.insetBy(.init(x: 3, y: 5))
        
        XCTAssertEqual(result.center, sut.center)
    }
    
    func testMovingCenterToVector() {
        let sut: DivisibleRectangleTypeTests.Rectangle = Rectangle(x: 1, y: 2, width: 7, height: 11)
        
        let result = sut.movingCenter(to: .init(x: 5, y: 13))
        
        XCTAssertEqual(result.location, .init(x: 1.5, y: 7.5))
        XCTAssertEqual(result.size, .init(x: 7, y: 11))
    }
    
    func testScaledBy() {
        let sut = Rectangle(x: 1, y: 2, width: 7, height: 11)
        
        let result = sut.scaledBy(0.5, around: .zero)

        XCTAssertEqual(result.location, .init(x: 0.5, y: 1.0))
        XCTAssertEqual(result.size, .init(x: 3.5, y: 5.5))
    }
    
    func testScaledAroundCenterBy() {
        let sut = Rectangle(x: 1, y: 2, width: 7, height: 11)
        
        let result = sut.scaledAroundCenterBy(2.0)
        
        XCTAssertEqual(result.location, .init(x: -2.5, y: -3.5))
        XCTAssertEqual(result.size, .init(x: 14.0, y: 22.0))
    }

    func testSubdivided() {
        let sut = Rectangle(
            minimum: .init(x: -5, y: -2),
            maximum: .init(x: 7, y: 12)
        )
        
        let result = sut.subdivided()

        XCTAssertEqual(result, [
            .init(minimum: .init(x: -5.0, y: -2.0), maximum: .init(x: 1.0, y: 5.0)),
            .init(minimum: .init(x: 1.0, y: -2.0), maximum: .init(x: 7.0, y: 5.0)),
            .init(minimum: .init(x: -5.0, y: 5.0), maximum: .init(x: 1.0, y: 12.0)),
            .init(minimum: .init(x: 1.0, y: 5.0), maximum: .init(x: 7.0, y: 12.0)),
        ])
    }
}
