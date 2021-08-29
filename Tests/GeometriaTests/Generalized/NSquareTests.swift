import XCTest
import Geometria

class NSquareTests: XCTestCase {
    typealias Square = NSquare<Vector2D>
    
    func testAsRectangle() {
        let sut = Square(origin: .init(x: 2, y: 3), sideLength: 4)
        
        let result = sut.asRectangle
        
        XCTAssertEqual(result.location, .init(x: 2, y: 3))
        XCTAssertEqual(result.size, .init(x: 4, y: 4))
    }
}

// MARK: BoundableType Conformance

extension NSquareTests {
    func testBounds() {
        let sut = Square(origin: .init(x: 2, y: 3), sideLength: 4)
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: 2, y: 3))
        XCTAssertEqual(result.maximum, .init(x: 6, y: 7))
    }
}

// MARK: VectorAdditive & VectorComparable Conformance

extension NSquareTests {
    func testContainsVector_center() {
        let sut = Square(origin: .init(x: 3, y: 2), sideLength: 1)
        
        XCTAssertTrue(sut.contains(.init(x: 3.5, y: 2.5)))
    }
    
    func testContainsVector() {
        let sut = Square(origin: .init(x: 2.5, y: 4.5), sideLength: 1)
        
        XCTAssert(sut.contains(.init(x: 2.5, y: 4.5)))
        XCTAssert(sut.contains(.init(x: 2.5, y: 5.5)))
        XCTAssert(sut.contains(.init(x: 3.5, y: 5.5)))
        XCTAssert(sut.contains(.init(x: 3.5, y: 4.5)))
        XCTAssertFalse(sut.contains(.init(x: 0, y: 0)))
        XCTAssertFalse(sut.contains(.init(x: 1, y: 2)))
        XCTAssertFalse(sut.contains(.init(x: 5, y: 6)))
    }
}
