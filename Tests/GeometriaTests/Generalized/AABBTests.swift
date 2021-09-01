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
        
        let result = sut.union(.init(minimum: .init(x: -7, y: 13),
                                     maximum: .init(x: 23, y: 30)))
        
        XCTAssertEqual(result.minimum, .init(x: -7, y: 2))
        XCTAssertEqual(result.maximum, .init(x: 23, y: 30))
    }
    
    func testUnion_returnsSelfForEqualBox() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 5))
        
        let result = sut.union(sut)
        
        XCTAssertEqual(result.minimum, .init(x: 1, y: 2))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 5))
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

// MARK: Vector2FloatingPoint & VectorComparable Conformance

extension AABBTests {
    // MARK: intersects(line:)
    
    func testIntersectsLine_line() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 2, y1: 9, x2: 15, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_line_alongEdge_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_line_outsideLineLimits_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 0, y1: 9, x2: 1, y2: 8)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_line_noIntersection_bottom_returnsFalse() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 12, y1: 9, x2: 13, y2: 9)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_line_noIntersection_returnsFalse() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 9, y1: 9, x2: 15, y2: 7)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_lineSegment_outsideLineLimits_returnsFalse() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 0, y1: 9, x2: 1, y2: 8)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_lineSegment_alongEdge_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_lineSegment_alongEdge_startsAfterEdge_returnsFalse() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 12, y1: 3, x2: 13, y2: 3)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_ray() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 2, y1: 9, x2: 15, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_ray_intersectsBeforeRayStart_returnsFalse() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 2, y1: 10, x2: 15, y2: 11)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_ray_intersectsAfterRayStart_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_ray_startsWithinAABB_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_ray_alongEdge_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_directionalRay_intersectsBeforeRayStart_returnsFalse() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 2, y1: 10, x2: 15, y2: 11)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_directionalRay_intersectsAfterRayStart_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_directionalRay_startsWithinAABB_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_directionalRay_alongEdge_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    // MARK: intersection(with:)
    
    func testIntersectionWith_line_across_horizontal() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 0, y1: 5, x2: 12, y2: 5)
        
        XCTAssertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 5.0),
                    normal: .init(x: -1.0, y: 0)
                ),
                PointNormal(
                    point: .init(x: 11.0, y: 5.0),
                    normal: .init(x: -1.0, y: 0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_contained_horizontal() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 3, y1: 5, x2: 7, y2: 5)
        
        XCTAssertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 5.0),
                    normal: .init(x: -1.0, y: 0)
                ),
                PointNormal(
                    point: .init(x: 11.0, y: 5.0),
                    normal: .init(x: -1.0, y: 0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_fromTop_pointingDown() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 5, y1: 0, x2: 5, y2: 1)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 5.0, y: 3.0),
                    normal: .init(x: 0.0, y: -1.0)
                ),
                PointNormal(
                    point: .init(x: 5.0, y: 7.0),
                    normal: .init(x: 0.0, y: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_fromTop_pointingUp() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 5, y1: 1, x2: 5, y2: 0)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 5.0, y: 7.0),
                    normal: .init(x: 0.0, y: 1.0)
                ),
                PointNormal(
                    point: .init(x: 5.0, y: 3.0),
                    normal: .init(x: 0.0, y: 1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_fromLeft_pointingRight() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 0, y1: 5, x2: 1, y2: 5)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 5.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 11.0, y: 5.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_fromLeft_pointingLeft() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 1, y1: 5, x2: 0, y2: 5)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 11.0, y: 5.0),
                    normal: .init(x: 1.0, y: 0)
                ),
                PointNormal(
                    point: .init(x: 2.0, y: 5.0),
                    normal: .init(x: 1.0, y: 0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_fromRight_pointingLeft() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 13, y1: 5, x2: 12, y2: 5)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 11.0, y: 5.0),
                    normal: .init(x: 1.0, y: 0)
                ),
                PointNormal(
                    point: .init(x: 2.0, y: 5.0),
                    normal: .init(x: 1.0, y: 0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_fromRight_pointingRight() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 12, y1: 5, x2: 13, y2: 5)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 5.0),
                    normal: .init(x: -1, y: 0)
                ),
                PointNormal(
                    point: .init(x: 11.0, y: 5.0),
                    normal: .init(x: -1, y: 0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_fromBottom_pointingUp() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 5, y1: 9, x2: 5, y2: 8)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 5.0, y: 7.0),
                    normal: .init(x: 0.0, y: 1.0)
                ),
                PointNormal(
                    point: .init(x: 5.0, y: 3.0),
                    normal: .init(x: 0.0, y: 1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_fromBottom_pointingDown() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 5, y1: 8, x2: 5, y2: 9)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 5.0, y: 3.0),
                    normal: .init(x: 0.0, y: -1.0)
                ),
                PointNormal(
                    point: .init(x: 5.0, y: 7.0),
                    normal: .init(x: 0.0, y: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_outsideLineLimits() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 0, y1: 8, x2: 1, y2: 7)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 6.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 5.0, y: 3.0),
                    normal: .init(x: 0.0, y: 1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_noIntersection() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 9, y1: 9, x2: 15, y2: 7)
        
        XCTAssertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_line_noIntersection_top_horizontal() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 3, y1: 2, x2: 5, y2: 2)
        
        XCTAssertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_line_noIntersection_left_vertical() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 1, y1: 2, x2: 1, y2: 3)
        
        XCTAssertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_line_noIntersection_right_vertical() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 12, y1: 2, x2: 12, y2: 3)
        
        XCTAssertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_line_noIntersection_bottom_horizontal() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 3, y1: 9, x2: 5, y2: 9)
        
        XCTAssertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_line_noIntersection_bottomRight_horizontal() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 12, y1: 9, x2: 13, y2: 9)
        
        XCTAssertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_line_alongEdge() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 11.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_lineSegment_outsideLineLimits() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 0, y1: 9, x2: 1, y2: 8)
        
        XCTAssertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_lineSegment_exitOnly() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 5, y1: 4, x2: 12, y2: 4)
        
        XCTAssertEqual(sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 11.0, y: 4.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_lineSegment_endsWithinAABB() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 2, y1: 4, x2: 5, y2: 4)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enter(
                PointNormal(
                    point: .init(x: 2.0, y: 4.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_lineSegment_alongEdge() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 11.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_ray() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 2, y1: 9, x2: 15, y2: 5)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 8.5, y: 7.0),
                    normal: .init(x: 0.0, y: 1.0)
                ),
                PointNormal(
                    point: .init(x: 11.0, y: 6.230769230769231),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_ray_intersectsBeforeRayStart() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 10, y1: 10, x2: 15, y2: 11)
        
        XCTAssertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_ray_intersectsAfterRayStart() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 3.0, y: 3.0),
                    normal: .init(x: 0.0, y: -1.0)
                ),
                PointNormal(
                    point: .init(x: 7.0, y: 7.0),
                    normal: .init(x: 0.0, y: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_ray_startsWithinAABB() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        XCTAssertEqual(sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 6.0, y: 7.0),
                    normal: .init(x: 0.0, y: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_ray_alongEdge() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 11.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_directionalRay_intersectsBeforeRayStart() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 2, y1: 10, x2: 15, y2: 11)
        
        XCTAssertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_directionalRay_intersectsAfterRayStart() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 3.0, y: 3.0),
                    normal: .init(x: 0.0, y: -1.0)
                ),
                PointNormal(
                    point: .init(x: 6.999999999999999, y: 6.999999999999999),
                    normal: .init(x: 0.0, y: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_directionalRay_startsWithinAABB() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        XCTAssertEqual(sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 5.999999999999998, y: 7.0),
                    normal: .init(x: 0.0, y: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_directionalRay_alongEdge() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        XCTAssertEqual(sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 11.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
}
