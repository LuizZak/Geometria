import XCTest
import Geometria

class Circle2Tests: XCTestCase {
    typealias Circle = Circle2D
    
    func testContainsXY() {
        let sut = Circle(center: .init(x: 0, y: 1), radius: 2)
        
        XCTAssertTrue(sut.contains(x: 1, y: 1))
        XCTAssertTrue(sut.contains(x: 0, y: 1))
        XCTAssertTrue(sut.contains(x: -1, y: 1))
        XCTAssertTrue(sut.contains(x: -2, y: 1))
        XCTAssertTrue(sut.contains(x: 2, y: 1))
        XCTAssertTrue(sut.contains(x: 0, y: -1))
        XCTAssertTrue(sut.contains(x: 0, y: 0))
        XCTAssertTrue(sut.contains(x: 0, y: 3))
        //
        XCTAssertFalse(sut.contains(x: -3, y: 1))
        XCTAssertFalse(sut.contains(x: 3, y: 1))
        XCTAssertFalse(sut.contains(x: 0, y: 4))
        XCTAssertFalse(sut.contains(x: 0, y: -3))
    }
}
