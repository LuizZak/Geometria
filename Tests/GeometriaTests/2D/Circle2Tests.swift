import XCTest
import Geometria

class Circle2Tests: XCTestCase {
    typealias Circle = Circle2D
    
    func testInitWithCenterRadius() {
        let sut = Circle(center: .init(x: 0, y: 1), radius: 2)
        
        XCTAssertEqual(sut.center, .init(x: 0, y: 1))
        XCTAssertEqual(sut.radius, 2)
    }
    
    func testExpandedBy() {
        let sut = Circle(center: .init(x: 0, y: 1), radius: 2)
        
        let result = sut.expanded(by: 3)
        
        XCTAssertEqual(result.center, .init(x: 0, y: 1))
        XCTAssertEqual(result.radius, 5)
    }
    
    func testContainsVector() {
        let sut = Circle(center: .init(x: 0, y: 1), radius: 2)
        
        XCTAssertTrue(sut.contains(.init(x: 1, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 0, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: -1, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: -2, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 2, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 0, y: -1)))
        XCTAssertTrue(sut.contains(.init(x: 0, y: 0)))
        XCTAssertTrue(sut.contains(.init(x: 0, y: 3)))
        //
        XCTAssertFalse(sut.contains(.init(x: -3, y: 1)))
        XCTAssertFalse(sut.contains(.init(x: 3, y: 1)))
        XCTAssertFalse(sut.contains(.init(x: 0, y: 4)))
        XCTAssertFalse(sut.contains(.init(x: 0, y: -3)))
    }
}
