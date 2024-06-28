import XCTest
import Geometria
import TestCommons

class AABB2Tests: XCTestCase {
    typealias AABB = AABB2D
    
    func testDescription() {
        XCTAssertEqual(AABB(minimum: .init(x: 0, y: 1), maximum: .init(x: 2, y: 3)).description,
                       "AABB<Vector2<Double>>(left: 0.0, top: 1.0, right: 2.0, bottom: 3.0)")
    }
    
    func testRight() {
        let sut = AABB(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.right, 3)
    }
    
    func testBottom() {
        let sut = AABB(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.bottom, 6)
    }
    
    func testTopRight() {
        let sut = AABB(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.topRight, .init(x: 3, y: 2))
    }
    
    func testBottomRight() {
        let sut = AABB(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.bottomRight, .init(x: 3, y: 6))
    }
    
    func testBottomLeft() {
        let sut = AABB(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.bottomLeft, .init(x: 1, y: 6))
    }
    
    func testCorners() {
        let sut = AABB(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.corners, [
            .init(x: 1, y: 2),
            .init(x: 3, y: 2),
            .init(x: 3, y: 6),
            .init(x: 1, y: 6)
        ])
    }
    
    func testInitWithLeftTopRightBottom() {
        let sut = AABB(left: 1, top: 2, right: 3, bottom: 5)
        
        XCTAssertEqual(sut.minimum, .init(x: 1, y: 2))
        XCTAssertEqual(sut.maximum, .init(x: 3, y: 5))
    }
}

// MARK: VectorComparable

extension AABB2Tests {
    func testContainsXY() {
        let sut = AABB(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
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
