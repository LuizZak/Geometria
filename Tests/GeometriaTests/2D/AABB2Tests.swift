import XCTest
import Geometria

class AABB2Tests: XCTestCase {
    typealias Box = Box2D
    
    func testDescription() {
        XCTAssertEqual(Box(minimum: .init(x: 0, y: 1), maximum: .init(x: 2, y: 3)).description,
                       "AABB<Vector2<Double>>(left: 0.0, top: 1.0, right: 2.0, bottom: 3.0)")
    }
    
    func testX() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.x, 1)
    }
    
    func testY() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.y, 2)
    }
    
    func testLeft() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.left, 1)
    }
    
    func testTop() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.top, 2)
    }
    
    func testRight() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.right, 3)
    }
    
    func testBottom() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.bottom, 6)
    }
    
    func testTopLeft() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.topLeft, .init(x: 1, y: 2))
    }
    
    func testTopRight() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.topRight, .init(x: 3, y: 2))
    }
    
    func testBottomRight() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.bottomRight, .init(x: 3, y: 6))
    }
    
    func testBottomLeft() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.bottomLeft, .init(x: 1, y: 6))
    }
    
    func testCorners() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.corners, [
            .init(x: 1, y: 2),
            .init(x: 3, y: 2),
            .init(x: 3, y: 6),
            .init(x: 1, y: 6)
        ])
    }
    
    func testInitWithLeftTopRightBottom() {
        let sut = Box(left: 1, top: 2, right: 3, bottom: 5)
        
        XCTAssertEqual(sut.minimum, .init(x: 1, y: 2))
        XCTAssertEqual(sut.maximum, .init(x: 3, y: 5))
    }
}

// MARK: VectorComparable

extension AABB2Tests {
    func testContainsXY() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertTrue(sut.contains(x: 2, y: 3))
        XCTAssertTrue(sut.contains(x: 1, y: 2))
        XCTAssertTrue(sut.contains(x: 3, y: 2))
        XCTAssertTrue(sut.contains(x: 3, y: 6))
        XCTAssertTrue(sut.contains(x: 1, y: 6))
        XCTAssertFalse(sut.contains(x: 0.9, y: 2))
        XCTAssertFalse(sut.contains(x: 4.1, y: 2))
        XCTAssertFalse(sut.contains(x: 4, y: 6.1))
        XCTAssertFalse(sut.contains(x: 1, y: 6.1))
    }
}

// MARK: VectorAdditive Conformance

extension AABB2Tests {
    func testWidth() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.width, 2)
    }
    
    func testHeight() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.height, 4)
    }
}

