import XCTest
import Geometria

class AABBTests: XCTestCase {
    typealias Box = AABB2D
    
    func testCodable() throws {
        let sut = Box(minimum: .init(x: 1, y: 2),
                      maximum: .init(x: 3, y: 4))
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(Box.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
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

// MARK: BoundableType Conformance

extension AABBTests {
    func testBounds() {
        let sut = Box(minimum: .init(x: 1, y: 2),
                      maximum: .init(x: 3, y: 6))
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: 1, y: 2))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 6))
    }
}

// MARK: Equatable Conformance

extension AABBTests {
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
    
    func testOffsetBy() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 7, y: 11))
        
        let result = sut.offsetBy(.init(x: 13, y: 17))
        
        XCTAssertEqual(result.minimum, .init(x: 14, y: 19))
        XCTAssertEqual(result.maximum, .init(x: 7, y: 11))
    }
}

// MARK: VectorComparable Conformance

extension AABBTests {
    func testIsValid() {
        XCTAssertTrue(Box(minimum: .zero, maximum: .zero).isValid)
        XCTAssertTrue(Box(minimum: .zero, maximum: .one).isValid)
        XCTAssertTrue(Box(minimum: .zero, maximum: .init(x: 0, y: 1)).isValid)
        XCTAssertTrue(Box(minimum: .zero, maximum: .init(x: 1, y: 0)).isValid)
        XCTAssertFalse(Box(minimum: .init(x: 0, y: 1), maximum: .zero).isValid)
        XCTAssertFalse(Box(minimum: .init(x: 1, y: 0), maximum: .zero).isValid)
        XCTAssertFalse(Box(minimum: .one, maximum: .zero).isValid)
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
    
    func testClamp_outOfBounds() {
        let sut = Box(minimum: .init(x: 2, y: 3), maximum: .init(x: 7, y: 11))
        
        XCTAssertEqual(sut.clamp(.init(x: 0, y: 0)), .init(x: 2, y: 3))
        XCTAssertEqual(sut.clamp(.init(x: 12, y: 12)), .init(x: 7, y: 11))
        XCTAssertEqual(sut.clamp(.init(x: 0, y: 5)), .init(x: 2, y: 5))
        XCTAssertEqual(sut.clamp(.init(x: 5, y: 1)), .init(x: 5, y: 3))
    }
    
    func testClamp_withinBounds() {
        let sut = Box(minimum: .init(x: 2, y: 3), maximum: .init(x: 7, y: 11))
        
        XCTAssertEqual(sut.clamp(.init(x: 3, y: 5)), .init(x: 3, y: 5))
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

extension AABBTests {
    func testSize() {
        let sut = Box(minimum: .init(x: 0, y: 1), maximum: .init(x: 2, y: 4))
        
        XCTAssertEqual(sut.size, .init(x: 2, y: 3))
    }
    
    func testIsZero() {
        XCTAssertTrue(Box(minimum: .zero, maximum: .zero).isZero)
        XCTAssertFalse(Box(minimum: .zero, maximum: .one).isZero)
        XCTAssertFalse(Box(minimum: .zero, maximum: .init(x: 0, y: 1)).isZero)
        XCTAssertFalse(Box(minimum: .zero, maximum: .init(x: 1, y: 0)).isZero)
        XCTAssertFalse(Box(minimum: .init(x: 0, y: 1), maximum: .zero).isZero)
        XCTAssertFalse(Box(minimum: .init(x: 1, y: 0), maximum: .zero).isZero)
        XCTAssertFalse(Box(minimum: .one, maximum: .zero).isZero)
    }
    
    func testAsRectangle() {
        let sut = Box(minimum: .init(x: 0, y: 1), maximum: .init(x: 2, y: 4))
        
        let result = sut.asRectangle
        
        XCTAssertEqual(result, NRectangle(x: 0, y: 1, width: 2, height: 3))
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

extension AABBTests {
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

// MARK: VectorMultiplicative Conformance

extension AABBTests {
    func testCenter() {
        let sut = Box(x: 1, y: 2, width: 3, height: 5)
        
        XCTAssertEqual(sut.center, .init(x: 2.5, y: 4.5))
    }
    
    func testCenter_set() {
        var sut = Box(x: 1, y: 2, width: 3, height: 5)
        
        sut.center = .init(x: 11, y: 13)
        
        XCTAssertEqual(sut.location, .init(x: 9.5, y: 10.5))
        XCTAssertEqual(sut.size, .init(x: 3, y: 5))
    }
    
    func testInflatedByVector() {
        let sut = Box(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.inflatedBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(result.location, .init(x: -2.5, y: -3.5))
        XCTAssertEqual(result.size, .init(x: 10, y: 16))
    }
    
    func testInflatedByVector_maintainsCenter() {
        let sut = Box(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.inflatedBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(result.center, sut.center)
    }
    
    func testInsetByVector() {
        let sut = Box(x: 1, y: 2, width: 7, height: 11)
        
        let result = sut.insetBy(.init(x: 3, y: 5))
        
        XCTAssertEqual(result.location, .init(x: 2.5, y: 4.5))
        XCTAssertEqual(result.size, .init(x: 4, y: 6))
    }
    
    func testInsetByVector_maintainsCenter() {
        let sut = Box(x: 1, y: 2, width: 7, height: 11)
        
        let result = sut.insetBy(.init(x: 3, y: 5))
        
        XCTAssertEqual(result.center, sut.center)
    }
    
    func testMovingCenterToVector() {
        let sut = Box(x: 1, y: 2, width: 7, height: 11)
        
        let result = sut.movingCenter(to: .init(x: 5, y: 13))
        
        XCTAssertEqual(result.location, .init(x: 1.5, y: 7.5))
        XCTAssertEqual(result.size, .init(x: 7, y: 11))
    }
}
