import XCTest
import Geometria

class BoxTests: XCTestCase {
    typealias Box = Box2D
    
    func testInitWithMinimumMaximum() {
        let sut = Box(minimum: .init(x: 1, y: 2),
                      maximum: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.minimum, .init(x: 1, y: 2))
        XCTAssertEqual(sut.maximum, .init(x: 3, y: 4))
    }
    
    func testLocation() {
        let sut = Box(minimum: .init(x: 1, y: 2),
                      maximum: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
    }
}

// MARK: Equatable Conformance

extension BoxTests {
    func testEquality() {
        XCTAssertEqual(Box(minimum: .init(x: 1, y: 2),
                           maximum: .init(x: 3, y: 4)),
                       Box(minimum: .init(x: 1, y: 2),
                           maximum: .init(x: 3, y: 4)))
    }
    
    func testUnequality() {
        XCTAssertNotEqual(Box(minimum: .init(x: 999, y: 2),
                              maximum: .init(x: 3, y: 4)),
                          Box(minimum: .init(x: 1, y: 2),
                              maximum: .init(x: 3, y: 4)))
        
        XCTAssertNotEqual(Box(minimum: .init(x: 1, y: 999),
                              maximum: .init(x: 3, y: 4)),
                          Box(minimum: .init(x: 1, y: 2),
                              maximum: .init(x: 3, y: 4)))
        
        XCTAssertNotEqual(Box(minimum: .init(x: 1, y: 2),
                              maximum: .init(x: 999, y: 4)),
                          Box(minimum: .init(x: 1, y: 2),
                              maximum: .init(x: 3, y: 4)))
        
        XCTAssertNotEqual(Box(minimum: .init(x: 1, y: 2),
                              maximum: .init(x: 3, y: 999)),
                          Box(minimum: .init(x: 1, y: 2),
                              maximum: .init(x: 3, y: 4)))
    }
    
    func testIsSizeZero_zeroArea() {
        let sut = Box(minimum: .init(x: 0, y: 0), maximum: .init(x: 0, y: 0))
        
        XCTAssertTrue(sut.isSizeZero)
    }
    
    func testIsSizeZero_zeroWidth() {
        let sut = Box(minimum: .init(x: 0, y: 0), maximum: .init(x: 0, y: 1))
        
        XCTAssertFalse(sut.isSizeZero)
    }
    
    func testIsSizeZero_zeroHeight() {
        let sut = Box(minimum: .init(x: 0, y: 0), maximum: .init(x: 1, y: 0))
        
        XCTAssertFalse(sut.isSizeZero)
    }
    
    func testIsSizeZero_nonZeroArea() {
        let sut = Box(minimum: .init(x: 0, y: 0), maximum: .init(x: 1, y: 1))
        
        XCTAssertFalse(sut.isSizeZero)
    }
}

// MARK: VectorComparable Conformance

extension BoxTests {
    func testIsValid() {
        XCTAssertTrue(Box(minimum: .zero, maximum: .zero).isValid)
        XCTAssertTrue(Box(minimum: .zero, maximum: .unit).isValid)
        XCTAssertTrue(Box(minimum: .zero, maximum: .init(x: 0, y: 1)).isValid)
        XCTAssertTrue(Box(minimum: .zero, maximum: .init(x: 1, y: 0)).isValid)
        XCTAssertFalse(Box(minimum: .init(x: 0, y: 1), maximum: .zero).isValid)
        XCTAssertFalse(Box(minimum: .init(x: 1, y: 0), maximum: .zero).isValid)
        XCTAssertFalse(Box(minimum: .unit, maximum: .zero).isValid)
    }
    
    func testExpandToIncludePoint() {
        var sut = Box.zero
        
        sut.expand(toInclude: .init(x: -1, y: 2))
        sut.expand(toInclude: .init(x: 3, y: -5))
        
        XCTAssertEqual(sut.minimum, .init(x: -1, y: -5))
        XCTAssertEqual(sut.maximum, .init(x: 3, y: 2))
    }
    
    func testExpandToIncludePoints() {
        var sut = Box.zero
        
        sut.expand(toInclude: [.init(x: -1, y: 2), .init(x: 3, y: -5)])
        
        XCTAssertEqual(sut.minimum, .init(x: -1, y: -5))
        XCTAssertEqual(sut.maximum, .init(x: 3, y: 2))
    }
    
    func testContainsPoint() {
        let sut = Box(minimum: .init(x: 0, y: 1), maximum: .init(x: 5, y: 8))
        
        XCTAssertTrue(sut.contains(.init(x: 0, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 5, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 5, y: 7)))
        XCTAssertTrue(sut.contains(.init(x: 5, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 3, y: 3)))
        XCTAssertFalse(sut.contains(.init(x: -1, y: 1)))
        XCTAssertFalse(sut.contains(.init(x: 6, y: 1)))
        XCTAssertFalse(sut.contains(.init(x: 6, y: 7)))
        XCTAssertFalse(sut.contains(.init(x: 5, y: 0)))
    }
    
    func testContainsBox() {
        let sut = Box(minimum: .init(x: 0, y: 1), maximum: .init(x: 5, y: 8))
        
        XCTAssertTrue(sut.contains(box: Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))))
        XCTAssertFalse(sut.contains(box: Box(x: -1, y: 2, width: 3, height: 4)))
        XCTAssertFalse(sut.contains(box: Box(x: 1, y: -2, width: 3, height: 4)))
        XCTAssertFalse(sut.contains(box: Box(x: 1, y: 2, width: 5, height: 4)))
        XCTAssertFalse(sut.contains(box: Box(x: 1, y: 2, width: 3, height: 7)))
    }
    
    func testContainsBox_returnsTrueForEqualBox() {
        let sut = Box(minimum: .init(x: 0, y: 1), maximum: .init(x: 5, y: 8))
        
        XCTAssertTrue(sut.contains(box: sut))
    }
    
    func testIntersectsBox() {
        let sut = Box(minimum: .init(x: 0, y: 0), maximum: .init(x: 3, y: 3))
        
        XCTAssertTrue(sut.intersects(Box(x: -1, y: -1, width: 2, height: 2)))
        XCTAssertFalse(sut.intersects(Box(x: -3, y: 0, width: 2, height: 2)))
        XCTAssertFalse(sut.intersects(Box(x: 0, y: -3, width: 2, height: 2)))
        XCTAssertFalse(sut.intersects(Box(x: 4, y: 0, width: 2, height: 2)))
        XCTAssertFalse(sut.intersects(Box(x: 0, y: 4, width: 2, height: 2)))
    }
    
    func testIntersectsBox_edgeIntersections() {
        let sut = Box(minimum: .init(x: 0, y: 0), maximum: .init(x: 3, y: 3))
        
        XCTAssertTrue(sut.intersects(Box(x: -2, y: -2, width: 2, height: 2)))
        XCTAssertTrue(sut.intersects(Box(x: -2, y: 3, width: 2, height: 2)))
        XCTAssertTrue(sut.intersects(Box(x: 3, y: -2, width: 2, height: 2)))
        XCTAssertTrue(sut.intersects(Box(x: 3, y: 3, width: 2, height: 2)))
    }
    
    func testUnion() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 4, y: 7))
        
        let result = sut.union(.init(minimum: .init(x: 7, y: 13),
                                     maximum: .init(x: 23, y: 30)))
        
        XCTAssertEqual(result.minimum, .init(x: 1, y: 2))
        XCTAssertEqual(result.maximum, .init(x: 23, y: 30))
    }
}

// MARK: VectorAdditive Conformance

extension BoxTests {
    func testSize() {
        let sut = Box(minimum: .init(x: 0, y: 1), maximum: .init(x: 2, y: 4))
        
        XCTAssertEqual(sut.size, .init(x: 2, y: 3))
    }
    
    func testIsZero() {
        XCTAssertTrue(Box(minimum: .zero, maximum: .zero).isZero)
        XCTAssertFalse(Box(minimum: .zero, maximum: .unit).isZero)
        XCTAssertFalse(Box(minimum: .zero, maximum: .init(x: 0, y: 1)).isZero)
        XCTAssertFalse(Box(minimum: .zero, maximum: .init(x: 1, y: 0)).isZero)
        XCTAssertFalse(Box(minimum: .init(x: 0, y: 1), maximum: .zero).isZero)
        XCTAssertFalse(Box(minimum: .init(x: 1, y: 0), maximum: .zero).isZero)
        XCTAssertFalse(Box(minimum: .unit, maximum: .zero).isZero)
    }
    
    func testAsRectangle() {
        let sut = Box(minimum: .init(x: 0, y: 1), maximum: .init(x: 2, y: 4))
        
        let result = sut.asRectangle
        
        XCTAssertEqual(result, Rectangle(x: 0, y: 1, width: 2, height: 3))
    }
    
    func testInitEmpty() {
        let sut = Box()
        
        XCTAssertEqual(sut.minimum, .zero)
        XCTAssertEqual(sut.maximum, .zero)
    }
    
    func testInitWithLocationSize() {
        let sut = Box(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.minimum, .init(x: 1, y: 2))
        XCTAssertEqual(sut.maximum, .init(x: 4, y: 6))
    }
}

// MARK: VectorAdditive & VectorComparable Conformance

extension BoxTests {
    func testInitOfPoints() {
        let result = Box(of: .init(x: -1, y: 3), .init(x: 2, y: -5))
        
        XCTAssertEqual(result.minimum, .init(x: -1, y: -5))
        XCTAssertEqual(result.maximum, .init(x: 2, y: 3))
    }
    
    func testInitPoints() {
        let result = Box(points: [.init(x: -1, y: 3), .init(x: 2, y: -5)])
        
        XCTAssertEqual(result.minimum, .init(x: -1, y: -5))
        XCTAssertEqual(result.maximum, .init(x: 2, y: 3))
    }
    
    func testInitPoints_empty() {
        let result = Box(points: [])
        
        XCTAssertEqual(result.minimum, .zero)
        XCTAssertEqual(result.maximum, .zero)
    }
}

// MARK: Vector2Type Conformance

extension BoxTests {
    func testDescription() {
        XCTAssertEqual(Box(minimum: .init(x: 0, y: 1), maximum: .init(x: 2, y: 3)).description,
                       "Box<Vector2<Double>>(left: 0.0, top: 1.0, right: 2.0, bottom: 3.0)")
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

// MARK: Vector2Type & VectorComparable

extension BoxTests {
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

// MARK: Vector2Type & VectorAdditive Conformance

extension BoxTests {
    func testWidth() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.width, 2)
    }
    
    func testHeight() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 6))
        
        XCTAssertEqual(sut.height, 4)
    }
}
