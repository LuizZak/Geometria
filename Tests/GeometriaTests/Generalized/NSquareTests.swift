import XCTest
import Geometria

class NSquareTests: XCTestCase {
    typealias Square = NSquare<Vector2D>
    
    func testEquatable() {
        XCTAssertEqual(Square(location: .unitY, sideLength: 1),
                       Square(location: .unitY, sideLength: 1))
        XCTAssertNotEqual(Square(location: .unitY, sideLength: 1),
                          Square(location: .unitX, sideLength: 1))
        XCTAssertNotEqual(Square(location: .unitY, sideLength: 1),
                          Square(location: .unitY, sideLength: 2))
    }
    
    func testHashable() {
        XCTAssertEqual(Square(location: .unitY, sideLength: 1).hashValue,
                       Square(location: .unitY, sideLength: 1).hashValue)
        XCTAssertNotEqual(Square(location: .unitY, sideLength: 1).hashValue,
                          Square(location: .unitX, sideLength: 1).hashValue)
        XCTAssertNotEqual(Square(location: .unitY, sideLength: 1).hashValue,
                          Square(location: .unitY, sideLength: 2).hashValue)
    }
    
    func testAsRectangle() {
        let sut = Square(location: .init(x: 2, y: 3), sideLength: 4)
        
        let result = sut.asRectangle
        
        XCTAssertEqual(result.location, .init(x: 2, y: 3))
        XCTAssertEqual(result.size, .init(x: 4, y: 4))
    }
}

// MARK: RectangleType & BoundableType Conformance

extension NSquareTests {
    func testSize() {
        let sut = Square(location: .init(x: 1, y: 2), sideLength: 3)
        
        XCTAssertEqual(sut.size, .init(x: 3, y: 3))
    }
    
    func testBounds() {
        let sut = Square(location: .init(x: 2, y: 3), sideLength: 4)
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: 2, y: 3))
        XCTAssertEqual(result.maximum, .init(x: 6, y: 7))
    }
}

// MARK: VectorAdditive & VectorComparable Conformance

extension NSquareTests {
    func testContainsVector_center() {
        let sut = Square(location: .init(x: 3, y: 2), sideLength: 1)
        
        XCTAssertTrue(sut.contains(.init(x: 3.5, y: 2.5)))
    }
    
    func testContainsVector() {
        let sut = Square(location: .init(x: 2.5, y: 4.5), sideLength: 1)
        
        XCTAssert(sut.contains(.init(x: 2.5, y: 4.5)))
        XCTAssert(sut.contains(.init(x: 2.5, y: 5.5)))
        XCTAssert(sut.contains(.init(x: 3.5, y: 5.5)))
        XCTAssert(sut.contains(.init(x: 3.5, y: 4.5)))
        XCTAssertFalse(sut.contains(.init(x: 0, y: 0)))
        XCTAssertFalse(sut.contains(.init(x: 1, y: 2)))
        XCTAssertFalse(sut.contains(.init(x: 5, y: 6)))
    }
}
