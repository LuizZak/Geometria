import XCTest
import Geometria
import simd

class NRectangleTests: XCTestCase {
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

extension NRectangleTests {
    func testIsSizeZero_zeroArea() {
        let sut = Rectangle(location: .init(x: 0, y: 0), size: .init(x: 0, y: 0))
        
        XCTAssertTrue(sut.isSizeZero)
    }
    
    func testIsSizeZero_zeroWidth() {
        let sut = Rectangle(location: .init(x: 0, y: 0), size: .init(x: 0, y: 1))
        
        XCTAssertFalse(sut.isSizeZero)
    }
    
    func testIsSizeZero_zeroHeight() {
        let sut = Rectangle(location: .init(x: 0, y: 0), size: .init(x: 1, y: 0))
        
        XCTAssertFalse(sut.isSizeZero)
    }
    
    func testIsSizeZero_nonZeroArea() {
        let sut = Rectangle(location: .init(x: 0, y: 0), size: .init(x: 1, y: 1))
        
        XCTAssertFalse(sut.isSizeZero)
    }
    
    func testMinimum() {
        let sut = Rectangle(x: 0, y: 1, width: 2, height: 3)
        
        XCTAssertEqual(sut.minimum, .init(x: 0, y: 1))
    }
    
    func testMinimum_set() {
        var sut = Rectangle(x: 0, y: 1, width: 2, height: 3)
        
        sut.minimum = .init(x: -1, y: 0)
        
        XCTAssertEqual(sut.location, .init(x: -1, y: 0))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
    
    func testMaximum() {
        let sut = Rectangle(x: 0, y: 1, width: 2, height: 3)
        
        XCTAssertEqual(sut.maximum, .init(x: 2, y: 4))
    }
    
    func testMaximum_set() {
        var sut = Rectangle(x: 0, y: 1, width: 2, height: 3)
        
        sut.maximum = .init(x: 4, y: 6)
        
        XCTAssertEqual(sut.location, .init(x: 0, y: 1))
        XCTAssertEqual(sut.size, .init(x: 4, y: 5))
    }
    
    func testAsBox() {
        let sut = Rectangle(x: 0, y: 1, width: 2, height: 3)
        
        let result = sut.asBox
        
        XCTAssertEqual(result, NBox(left: 0, top: 1, right: 2, bottom: 4))
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

extension NRectangleTests {
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

extension NRectangleTests {
    func testZero() {
        let result = Rectangle.zero
        
        XCTAssertEqual(result.location, .init(x: 0, y: 0))
        XCTAssertEqual(result.size, .init(x: 0, y: 0))
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
