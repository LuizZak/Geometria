import XCTest
import Geometria
import simd

class Rectangle2Tests: XCTestCase {
    typealias Rectangle = Rectangle2D
    
    func testDescription() {
        XCTAssertEqual(Rectangle(x: 0, y: 1, width: 2, height: 3).description,
                       "NRectangle<Vector2<Double>>(x: 0.0, y: 1.0, width: 2.0, height: 3.0)")
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
}

// MARK: VectorAdditive Conformance

extension Rectangle2Tests {
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

// MARK: VectorReal

extension Rectangle2Tests {
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

// MARK: VectorAdditive & VectorComparable Conformance

extension Rectangle2Tests {
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

// MARK: VectorMultiplicative

extension Rectangle2Tests {
    func testScaledByXY() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.scaledBy(x: 5, y: 7)
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 15, y: 28))
    }
}

// MARK: VectorDivisible

extension Rectangle2Tests {
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

// MARK: Scalar: FloatingPoint Conformance

extension Rectangle2Tests {
    func testFloatingPointInitWithBinaryInteger() {
        let sut = Rectangle2D(x: 1, y: 2, width: 3, height: 4)
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
}

// MARK: VectorMultiplicative, Scalar: Comparable Conformance

extension Rectangle2Tests {
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
