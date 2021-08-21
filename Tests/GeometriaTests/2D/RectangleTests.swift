import XCTest
import Geometria

class RectangleTests: XCTestCase {
    typealias Rectangle = Rectangle2D
    
    func testInitWithLocationSize() {
        let sut = Rectangle(location: .init(x: 1, y: 2),
                            size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
    
    func testWithLocation() {
        let sut = Rectangle(location: .init(x: 0, y: 0),
                            size: .init(x: 3, y: 4))
        
        let result = sut.withLocation(.init(x: 1, y: 2))
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 3, y: 4))
    }
    
    func testWithSize() {
        let sut = Rectangle(location: .init(x: 1, y: 2),
                            size: .init(x: 0, y: 0))
        
        let result = sut.withSize(.init(x: 3, y: 4))
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 3, y: 4))
    }
    
}

// MARK: VectorAdditive Conformance

extension RectangleTests {
    func testIsAreaZero_zeroArea() {
        let sut = Rectangle(location: .init(x: 0, y: 0), size: .init(x: 0, y: 0))
        
        XCTAssertTrue(sut.isAreaZero)
    }
    
    func testIsAreaZero_nonZeroArea() {
        let sut = Rectangle(location: .init(x: 0, y: 0), size: .init(x: 2, y: 2))
        
        XCTAssertFalse(sut.isAreaZero)
    }
    
    func testMinimum() {
        let sut = Rectangle(x: 0, y: 1, width: 2, height: 3)
        
        XCTAssertEqual(sut.minimum, .init(x: 0, y: 1))
    }
    
    func testMinimum_set() {
        var sut = Rectangle(x: 0, y: 1, width: 2, height: 3)
        
        sut.minimum = Vector2(x: -1, y: 0)
        
        XCTAssertEqual(sut.location, .init(x: -1, y: 0))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
    
    func testMaximum() {
        let sut = Rectangle(x: 0, y: 1, width: 2, height: 3)
        
        XCTAssertEqual(sut.maximum, .init(x: 2, y: 4))
    }
    
    func testMaximum_set() {
        var sut = Rectangle(x: 0, y: 1, width: 2, height: 3)
        
        sut.maximum = Vector2(x: 4, y: 6)
        
        XCTAssertEqual(sut.location, .init(x: 0, y: 1))
        XCTAssertEqual(sut.size, .init(x: 4, y: 5))
    }
    
    func testAsBox() {
        let sut = Rectangle(x: 0, y: 1, width: 2, height: 3)
        
        let result = sut.asBox
        
        XCTAssertEqual(result, Box(left: 0, top: 1, right: 2, bottom: 4))
    }
    
    func testInitWithMinimumMaximum() {
        let sut = Rectangle(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
        XCTAssertEqual(sut.size, .init(x: 2, y: 3))
    }
    
    func testOffsetBy() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.offsetBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(result.location, .init(x: 8, y: 13))
        XCTAssertEqual(result.size, .init(x: 3, y: 5))
    }
}

// MARK: VectorAdditive & VectorComparable Conformance

extension RectangleTests {
    func testIsValid() {
        XCTAssertTrue(Rectangle(x: 0, y: 0, width: 0, height: 0).isValid)
        XCTAssertTrue(Rectangle(x: 0, y: 0, width: 0, height: 1).isValid)
        XCTAssertTrue(Rectangle(x: 0, y: 0, width: 1, height: 0).isValid)
        XCTAssertTrue(Rectangle(x: 0, y: 0, width: 1, height: 1).isValid)
        XCTAssertFalse(Rectangle(x: 0, y: 0, width: -1, height: 0).isValid)
        XCTAssertFalse(Rectangle(x: 0, y: 0, width: 0, height: -1).isValid)
        XCTAssertFalse(Rectangle(x: 0, y: 0, width: -1, height: -1).isValid)
    }
    
    func testInitOfPoints() {
        let result = Rectangle(of: .init(x: -1, y: 3), .init(x: 2, y: -5))
        
        XCTAssertEqual(result.location, .init(x: -1, y: -5))
        XCTAssertEqual(result.size, .init(x: 3, y: 8))
    }
    
    func testInitPoints() {
        let result = Rectangle(points: [.init(x: -1, y: 3), .init(x: 2, y: -5)])
        
        XCTAssertEqual(result.location, .init(x: -1, y: -5))
        XCTAssertEqual(result.size, .init(x: 3, y: 8))
    }
    
    func testInitPoints_empty() {
        let result = Rectangle(points: [])
        
        XCTAssertEqual(result.location, .zero)
        XCTAssertEqual(result.size, .zero)
    }
    
    func testExpandToIncludePoint() {
        var sut = Rectangle.zero
        
        sut.expand(toInclude: .init(x: -1, y: 2))
        sut.expand(toInclude: .init(x: 3, y: -5))
        
        XCTAssertEqual(sut.location, .init(x: -1, y: -5))
        XCTAssertEqual(sut.size, .init(x: 4, y: 7))
    }
    
    func testExpandToIncludePoints() {
        var sut = Rectangle.zero
        
        sut.expand(toInclude: [.init(x: -1, y: 2), .init(x: 3, y: -5)])
        
        XCTAssertEqual(sut.location, .init(x: -1, y: -5))
        XCTAssertEqual(sut.size, .init(x: 4, y: 7))
    }
    
    func testContainsPoint() {
        let sut = Rectangle(x: 0, y: 1, width: 5, height: 7)
        
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
    
    func testContainsRectangle() {
        let sut = Rectangle(x: 0, y: 1, width: 5, height: 7)
        
        XCTAssertTrue(sut.contains(rectangle: Rectangle(x: 1, y: 2, width: 3, height: 4)))
        XCTAssertFalse(sut.contains(rectangle: Rectangle(x: -1, y: 2, width: 3, height: 4)))
        XCTAssertFalse(sut.contains(rectangle: Rectangle(x: 1, y: -2, width: 3, height: 4)))
        XCTAssertFalse(sut.contains(rectangle: Rectangle(x: 1, y: 2, width: 5, height: 4)))
        XCTAssertFalse(sut.contains(rectangle: Rectangle(x: 1, y: 2, width: 3, height: 7)))
    }
    
    func testContainsRectangle_returnsTrueForEqualRectangle() {
        let sut = Rectangle(x: 0, y: 1, width: 5, height: 7)
        
        XCTAssertTrue(sut.contains(rectangle: sut))
    }
    
    func testIntersectsRectangle() {
        let sut = Rectangle(x: 0, y: 0, width: 3, height: 3)
        
        XCTAssertTrue(sut.intersects(Rectangle(x: -1, y: -1, width: 2, height: 2)))
        XCTAssertFalse(sut.intersects(Rectangle(x: -3, y: 0, width: 2, height: 2)))
        XCTAssertFalse(sut.intersects(Rectangle(x: 0, y: -3, width: 2, height: 2)))
        XCTAssertFalse(sut.intersects(Rectangle(x: 4, y: 0, width: 2, height: 2)))
        XCTAssertFalse(sut.intersects(Rectangle(x: 0, y: 4, width: 2, height: 2)))
    }
    
    func testIntersectsRectangle_edgeIntersections() {
        let sut = Rectangle(x: 0, y: 0, width: 3, height: 3)
        
        XCTAssertTrue(sut.intersects(Rectangle(x: -2, y: -2, width: 2, height: 2)))
        XCTAssertTrue(sut.intersects(Rectangle(x: -2, y: 3, width: 2, height: 2)))
        XCTAssertTrue(sut.intersects(Rectangle(x: 3, y: -2, width: 2, height: 2)))
        XCTAssertTrue(sut.intersects(Rectangle(x: 3, y: 3, width: 2, height: 2)))
    }
    
    func testUnion() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.union(.init(x: 7, y: 13, width: 17, height: 19))
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 23, y: 30))
    }
    
}

// MARK: VectorMultiplicative Conformance

extension RectangleTests {
    func testZero() {
        let result = Rectangle.zero
        
        XCTAssertEqual(result.location, .init(x: 0, y: 0))
        XCTAssertEqual(result.size, .init(x: 0, y: 0))
    }
    
    func testIsEmpty() {
        XCTAssertTrue(Rectangle(x: 0, y: 0, width: 0, height: 0).isEmpty)
        XCTAssertTrue(Rectangle(x: 2, y: 3, width: 0, height: 0).isEmpty)
        XCTAssertTrue(Rectangle(x: -2, y: -3, width: 0, height: 0).isEmpty)
        XCTAssertFalse(Rectangle(x: 0, y: 0, width: 1, height: 0).isEmpty)
        XCTAssertFalse(Rectangle(x: 0, y: 0, width: 0, height: 1).isEmpty)
        XCTAssertFalse(Rectangle(x: 0, y: 0, width: 1, height: 1).isEmpty)
    }
    
    func testInitEmpty() {
        let sut = Rectangle()
        
        XCTAssertEqual(sut.location, .zero)
        XCTAssertEqual(sut.size, .zero)
    }
    
    func testScaledByVector() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.scaledBy(vector: .init(x: 2, y: 3))
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 6, y: 15))
    }
    
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
        let sut = Rectangle(x: 1, y: 2, width: 7, height: 11)
        
        let result = sut.movingCenter(to: .init(x: 5, y: 13))
        
        XCTAssertEqual(result.location, .init(x: 1.5, y: 7.5))
        XCTAssertEqual(result.size, .init(x: 7, y: 11))
    }
}

// MARK: Vector2Type Conformance

extension RectangleTests {
    func testDescription() {
        XCTAssertEqual(Rectangle(x: 0, y: 1, width: 2, height: 3).description,
                       "Rectangle<Vector2<Double>>(x: 0.0, y: 1.0, width: 2.0, height: 3.0)")
    }
    
    func testX() {
        let sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.x, 1)
    }
    
    func testX_set() {
        var sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        sut.x = 5
        
        XCTAssertEqual(sut.location, .init(x: 5, y: 2))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
    
    func testY() {
        let sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.y, 2)
    }
    
    func testY_set() {
        var sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        sut.y = 5
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 5))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
    
    func testWidth() {
        let sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.width, 3)
    }
    
    func testWidth_set() {
        var sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        sut.width = 5
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
        XCTAssertEqual(sut.size, .init(x: 5, y: 4))
    }
    
    func testHeight() {
        let sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.height, 4)
    }
    
    func testHeight_set() {
        var sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        sut.height = 5
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
        XCTAssertEqual(sut.size, .init(x: 3, y: 5))
    }
    
    func testTop() {
        let sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.top, 2)
    }
    
    func testLeft() {
        let sut = Rectangle(location: .init(x: 1, y: 2), size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.left, 1)
    }
    
    func testTopLeft() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.topLeft, .init(x: 1, y: 2))
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
    
    func testRoundedRadius() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.rounded(radius: .init(x: 5, y: 6))
        
        XCTAssertEqual(result.bounds, sut)
        XCTAssertEqual(result.radius, .init(x: 5, y: 6))
    }
    
    func testRoundedRadiusScalar() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.rounded(radius: 5)
        
        XCTAssertEqual(result.bounds, sut)
        XCTAssertEqual(result.radius, .init(x: 5, y: 5))
    }
}

// MARK: Vector2Type & VectorAdditive Conformance

extension RectangleTests {
    func testRight() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.right, 4)
    }
    
    func testBottom() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.bottom, 6)
    }
    
    func testTopRight() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.topRight, .init(x: 4, y: 2))
    }
    
    func testBottomLeft() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.bottomLeft, .init(x: 1, y: 6))
    }
    
    func testBottomRight() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.bottomRight, .init(x: 4, y: 6))
    }
    
    func testCorners() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.corners, [
            .init(x: 1, y: 2),
            .init(x: 4, y: 2),
            .init(x: 4, y: 6),
            .init(x: 1, y: 6)
        ])
    }
    
    func testInitWithLeftTopRightBottom() {
        let sut = Rectangle(left: 1, top: 2, right: 3, bottom: 5)
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
        XCTAssertEqual(sut.size, .init(x: 2, y: 3))
    }
    
    func testOffsetByXY() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.offsetBy(x: 5, y: 6)
        
        XCTAssertEqual(result.location, .init(x: 6, y: 8))
        XCTAssertEqual(result.size, .init(x: 3, y: 4))
    }
    
    func testMovingRightTo() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.movingRight(to: 11)
        
        XCTAssertEqual(result.location, .init(x: 8, y: 2))
        XCTAssertEqual(result.size, .init(x: 3, y: 4))
    }
    
    func testMovingBottomTo() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.movingBottom(to: 11)
        
        XCTAssertEqual(result.location, .init(x: 1, y: 7))
        XCTAssertEqual(result.size, .init(x: 3, y: 4))
    }
    
    func testStretchingLeftTo() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.stretchingLeft(to: 0)
        
        XCTAssertEqual(result.location, .init(x: 0, y: 2))
        XCTAssertEqual(result.size, .init(x: 4, y: 4))
    }
    
    func testStretchingTopTo() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.stretchingTop(to: 0)
        
        XCTAssertEqual(result.location, .init(x: 1, y: 0))
        XCTAssertEqual(result.size, .init(x: 3, y: 6))
    }
    
    func testStretchingRightTo() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.stretchingRight(to: 7)
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 6, y: 4))
    }
    
    func testStretchingBottomTo() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.stretchingBottom(to: 11)
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 3, y: 9))
    }
    
    func testInset() {
        let sut = Rectangle(x: 1, y: 2, width: 13, height: 17)
        
        let result = sut.inset(.init(left: 1, top: 2, right: 3, bottom: 5))
        
        XCTAssertEqual(result.location, .init(x: 2, y: 4))
        XCTAssertEqual(result.size, .init(x: 9, y: 10))
    }
}

// MARK: Vector2Type & VectorAdditive & VectorComparable, Scalar: Real Conformance

extension RectangleTests {
    func testTransformedBounds_scale() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        let matrix = Matrix2D
            .transformation(xScale: 2,
                            yScale: 3,
                            angle: 0,
                            xOffset: 0,
                            yOffset: 0)
        
        let result = sut.transformedBounds(matrix)
        
        XCTAssertEqual(result.location, .init(x: 2, y: 6))
        XCTAssertEqual(result.size, .init(x: 6, y: 12))
    }
    
    func testTransformedBounds_rotation() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        let matrix = Matrix2D
            .transformation(xScale: 1,
                            yScale: 1,
                            angle: .pi / 2,
                            xOffset: 0,
                            yOffset: 0)
        
        let result = sut.transformedBounds(matrix)
        
        assertEqual(result.location, .init(x: -6, y: 1), accuracy: 1.0e-15)
        assertEqual(result.size, .init(x: 4, y: 3), accuracy: 1.0e-15)
    }
    
    func testTransformedBounds_translate() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        let matrix = Matrix2D
            .transformation(xScale: 1,
                            yScale: 1,
                            angle: 0,
                            xOffset: 5,
                            yOffset: 7)
        
        let result = sut.transformedBounds(matrix)
        
        assertEqual(result.location, .init(x: 6, y: 9), accuracy: 1.0e-15)
        assertEqual(result.size, .init(x: 3, y: 4), accuracy: 1.0e-15)
    }
    
    func testTransformedBounds_scaleRotation() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        let matrix = Matrix2D
            .transformation(xScale: 2,
                            yScale: 3,
                            angle: .pi / 2,
                            xOffset: 0,
                            yOffset: 0)
        
        let result = sut.transformedBounds(matrix)
        
        assertEqual(result.location, .init(x: -18, y: 2), accuracy: 1.0e-15)
        assertEqual(result.size, .init(x: 12, y: 6), accuracy: 1.0e-14)
    }
    
    func testTransformedBounds_rotationTranslation() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        let matrix = Matrix2D
            .transformation(xScale: 1,
                            yScale: 1,
                            angle: .pi / 2,
                            xOffset: 5,
                            yOffset: 7)
        
        let result = sut.transformedBounds(matrix)
        
        assertEqual(result.location, .init(x: -1, y: 8), accuracy: 1.0e-15)
        assertEqual(result.size, .init(x: 4, y: 3), accuracy: 1.0e-15)
    }
    
    func testTransformedBounds_scaleRotationTranslation() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        let matrix = Matrix2D
            .transformation(xScale: 2,
                            yScale: 3,
                            angle: .pi / 2,
                            xOffset: 5,
                            yOffset: 7)
        
        let result = sut.transformedBounds(matrix)
        
        assertEqual(result.location, .init(x: -13, y: 9), accuracy: 1.0e-15)
        assertEqual(result.size, .init(x: 12, y: 6), accuracy: 1.0e-14)
    }
}

// MARK: Vector2Type & VectorAdditive & VectorComparable Conformance

extension RectangleTests {
    func testContainsXY() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertTrue(sut.contains(x: 2, y: 3))
        XCTAssertTrue(sut.contains(x: 1, y: 2))
        XCTAssertTrue(sut.contains(x: 4, y: 2))
        XCTAssertTrue(sut.contains(x: 4, y: 6))
        XCTAssertTrue(sut.contains(x: 1, y: 6))
        XCTAssertFalse(sut.contains(x: 0.9, y: 2))
        XCTAssertFalse(sut.contains(x: 4.1, y: 2))
        XCTAssertFalse(sut.contains(x: 4, y: 6.1))
        XCTAssertFalse(sut.contains(x: 1, y: 6.1))
    }
}

// MARK: Vector2Type & VectorMultiplicative

extension RectangleTests {
    func testScaledByXY() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.scaledBy(x: 5, y: 7)
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 15, y: 28))
    }
}

// MARK: Vector2Type & VectorDivisible

extension RectangleTests {
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

// MARK: Vector2Type, Scalar: FloatingPoint Conformance

extension RectangleTests {
    func testFloatingPointInitWithBinaryInteger() {
        let sut = Rectangle2D(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
}

// MARK: Vector2Type & VectorMultiplicative, Scalar: Comparable Conformance

extension RectangleTests {
    func testIntersection_sameRectangle() {
        let rect = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = rect.intersection(rect)
        
        XCTAssertEqual(result, rect)
    }
    
    func testIntersection_overlappingRectangle() {
        let rect1 = Rectangle(x: 1, y: 2, width: 3, height: 4)
        let rect2 = Rectangle(x: -1, y: 1, width: 3, height: 4)
        
        let result = rect1.intersection(rect2)
        
        XCTAssertEqual(result, Rectangle(x: 1, y: 2, width: 1, height: 3))
    }
    
    func testIntersection_edgeOnly() {
        let rect1 = Rectangle(x: 1, y: 2, width: 3, height: 4)
        let rect2 = Rectangle(x: -2, y: 2, width: 3, height: 4)
        
        let result = rect1.intersection(rect2)
        
        XCTAssertEqual(result, Rectangle(x: 1, y: 2, width: 0, height: 4))
    }
    
    func testIntersection_cornerOnly() {
        let rect1 = Rectangle(x: 1, y: 2, width: 3, height: 4)
        let rect2 = Rectangle(x: -2, y: -2, width: 3, height: 4)
        
        let result = rect1.intersection(rect2)
        
        XCTAssertEqual(result, Rectangle(x: 1, y: 2, width: 0, height: 0))
    }
    
    func testIntersection_noIntersection() {
        let rect1 = Rectangle(x: 1, y: 2, width: 3, height: 4)
        let rect2 = Rectangle(x: -3, y: -3, width: 3, height: 4)
        
        let result = rect1.intersection(rect2)
        
        XCTAssertNil(result)
    }
}
