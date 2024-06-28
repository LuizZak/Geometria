import XCTest
import Geometria
import TestCommons

class NRectangleTests: XCTestCase {
    typealias Rectangle = Rectangle2D
    
    func testCodable() throws {
        let sut = Rectangle(location: .init(x: 1, y: 2),
                            size: .init(x: 3, y: 4))
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(Rectangle.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testInitWithLocationSize() {
        let sut = Rectangle(location: .init(x: 1, y: 2),
                            size: .init(x: 3, y: 4))
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
        XCTAssertEqual(sut.size, .init(x: 3, y: 4))
    }
    
    func testRoundedRadius() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.rounded(radius: .init(x: 5, y: 6))
        
        XCTAssertEqual(result.rectangle, sut)
        XCTAssertEqual(result.radius, .init(x: 5, y: 6))
    }
    
    func testRoundedRadiusScalar() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 4)
        
        let result = sut.rounded(radius: 5)
        
        XCTAssertEqual(result.rectangle, sut)
        XCTAssertEqual(result.radius, .init(x: 5, y: 5))
    }
}

// MARK: BoundableType Conformance

extension NRectangleTests {
    func testBounds() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: 1, y: 2))
        XCTAssertEqual(result.maximum, .init(x: 4, y: 7))
    }
}

// MARK: VectorAdditive Conformance

extension NRectangleTests {
    func testZero() {
        let result = Rectangle.zero
        
        XCTAssertEqual(result.location, .init(x: 0, y: 0))
        XCTAssertEqual(result.size, .init(x: 0, y: 0))
    }
    
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
    
    func testInitEmpty() {
        let sut = Rectangle()
        
        XCTAssertEqual(sut.location, .zero)
        XCTAssertEqual(sut.size, .zero)
    }
}

// MARK: VectorAdditive & VectorComparable Conformance

extension NRectangleTests {
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
    
    func testAsAABB() {
        let sut = Rectangle(x: 0, y: 1, width: 2, height: 3)
        
        let result = sut.asAABB
        
        XCTAssertEqual(result, AABB(left: 0, top: 1, right: 2, bottom: 4))
    }
    
    func testInitWithMinimumMaximum() {
        let sut = Rectangle(minimum: .init(x: 1, y: 2), maximum: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
        XCTAssertEqual(sut.size, .init(x: 2, y: 3))
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
}

// MARK: SelfIntersectableRectangleType Conformance

extension NRectangleTests {
    func testContainsRectangle() {
        let sut = Rectangle(x: 0, y: 1, width: 5, height: 7)
        
        XCTAssertTrue(sut.contains(Rectangle(x: 1, y: 2, width: 3, height: 4)))
        XCTAssertFalse(sut.contains(Rectangle(x: -1, y: 2, width: 3, height: 4)))
        XCTAssertFalse(sut.contains(Rectangle(x: 1, y: -2, width: 3, height: 4)))
        XCTAssertFalse(sut.contains(Rectangle(x: 1, y: 2, width: 5, height: 4)))
        XCTAssertFalse(sut.contains(Rectangle(x: 1, y: 2, width: 3, height: 7)))
    }
    
    func testContainsRectangle_returnsTrueForEqualRectangle() {
        let sut = Rectangle(x: 0, y: 1, width: 5, height: 7)
        
        XCTAssertTrue(sut.contains(sut))
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
    
    func testIntersection_sameRectangle_matchesInitialRectangle() {
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

// MARK: Vector: VectorMultiplicative Conformance

extension NRectangleTests {
    func testUnit() {
        let sut = Rectangle.unit
        
        XCTAssertEqual(sut.location, .zero)
        XCTAssertEqual(sut.size, .one)
    }
    
    func testScaledByVector() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.scaledBy(vector: .init(x: 2, y: 3))
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 6, y: 15))
    }
}

// MARK: - ConvexType Conformance

// MARK: 2D

extension NRectangleTests {
    // MARK: intersects(line:)
    
    func testIntersectsLine_2d_line() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 2, y1: 9, x2: 15, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_line_alongEdge_returnsTrue() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_line_outsideLineLimits_returnsTrue() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 0, y1: 9, x2: 1, y2: 8)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_line_noIntersection_bottom_returnsFalse() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 12, y1: 9, x2: 13, y2: 9)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_line_noIntersection_returnsFalse() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 9, y1: 9, x2: 15, y2: 7)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_lineSegment_outsideLineLimits_returnsFalse() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 0, y1: 9, x2: 1, y2: 8)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_lineSegment_alongEdge_returnsTrue() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_lineSegment_alongEdge_startsAfterEdge_returnsFalse() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 12, y1: 3, x2: 13, y2: 3)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 2, y1: 9, x2: 15, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray_intersectsBeforeRayStart_returnsFalse() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 2, y1: 10, x2: 15, y2: 11)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray_intersectsAfterRayStart_returnsTrue() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray_startsWithinRectangle_returnsTrue() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray_alongEdge_returnsTrue() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_directionalRay_intersectsBeforeRayStart_returnsFalse() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 2, y1: 10, x2: 15, y2: 11)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_directionalRay_intersectsAfterRayStart_returnsTrue() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_directionalRay_startsWithinRectangle_returnsTrue() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_directionalRay_alongEdge_returnsTrue() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    // MARK: intersection(with:)
    
    func testIntersectionWith_2d_line_across_horizontal() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 0, y1: 5, x2: 12, y2: 5)
        
        assertEqual(
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
    
    func testIntersectionWith_2d_line_contained_horizontal() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 3, y1: 5, x2: 7, y2: 5)
        
        assertEqual(
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
    
    func testIntersectionWith_2d_line_fromTop_pointingDown() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 5, y1: 0, x2: 5, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_line_fromTop_pointingUp() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 5, y1: 1, x2: 5, y2: 0)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_line_fromLeft_pointingRight() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 0, y1: 5, x2: 1, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_line_fromLeft_pointingLeft() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 1, y1: 5, x2: 0, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_line_fromRight_pointingLeft() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 13, y1: 5, x2: 12, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_line_fromRight_pointingRight() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 12, y1: 5, x2: 13, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_line_fromBottom_pointingUp() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 5, y1: 9, x2: 5, y2: 8)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_line_fromBottom_pointingDown() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 5, y1: 8, x2: 5, y2: 9)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_line_outsideLineLimits() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 0, y1: 8, x2: 1, y2: 7)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_line_noIntersection() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 9, y1: 9, x2: 15, y2: 7)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_top_horizontal() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 3, y1: 2, x2: 5, y2: 2)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_left_vertical() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 1, y1: 2, x2: 1, y2: 3)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_right_vertical() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 12, y1: 2, x2: 12, y2: 3)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_bottom_horizontal() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 3, y1: 9, x2: 5, y2: 9)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_bottomRight_horizontal() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 12, y1: 9, x2: 13, y2: 9)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_alongEdge() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_lineSegment_outsideLineLimits() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 0, y1: 9, x2: 1, y2: 8)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_lineSegment_exitOnly() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 5, y1: 4, x2: 12, y2: 4)
        
        assertEqual(
            sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 11.0, y: 4.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_lineSegment_endsWithinRectangle() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 2, y1: 4, x2: 5, y2: 4)
        
        assertEqual(
            sut.intersection(with: line),
            .enter(
                PointNormal(
                    point: .init(x: 2.0, y: 4.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_lineSegment_alongEdge() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_line_contained() {
        let sut = Rectangle(left: 0, top: 0, right: 20, bottom: 20)
        let line = LineSegment2D(start: .one, end: .init(x: 10, y: 10))
        
        assertEqual(sut.intersection(with: line), .contained)
    }
    
    func testIntersectionWith_2d_ray() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 2, y1: 9, x2: 15, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_ray_intersectsBeforeRayStart() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 10, y1: 10, x2: 15, y2: 11)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_ray_intersectsAfterRayStart() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_ray_startsWithinRectangle() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 6.0, y: 7.0),
                    normal: .init(x: 0.0, y: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_ray_alongEdge() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_directionalRay_intersectsBeforeRayStart() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 2, y1: 10, x2: 15, y2: 11)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_directionalRay_intersectsAfterRayStart() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    func testIntersectionWith_2d_directionalRay_startsWithinRectangle() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 6.0, y: 7.0),
                    normal: .init(x: 0.0, y: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_directionalRay_alongEdge() {
        let sut = Rectangle(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        assertEqual(
            sut.intersection(with: line),
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
    
    // MARK: -
    
    func testIntersectionWith_2d_lineSegment_bug1() {
        // Verify that the intersection point containment check doesn't fail due
        // to rounding errors in the produced intersection points
        
        let sut = Rectangle(left: 162.5, top: 135.0, right: 237.5, bottom: 165.0)
        let line = LineSegment2D(x1: 101.01359554152113, y1: 164.20182144594258,
                                 x2: 298.9864044584789, y2: 145.79817855405742)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 162.5, y: 158.4860171567055),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 237.50000000000003, y: 151.5139828432945),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
}

// MARK: 3D

extension NRectangleTests {
    typealias Rectangle3 = NRectangle<Vector3D>
    
    // MARK: intersects(line:)
    
    func testIntersectsLine_3d_line_acrossTopQuadrant() {
        let sut = Rectangle3(minimum: .init(x: 0, y: 0, z: 0), maximum: .init(x: 10, y: 10, z: 10))
        let line = Line3D(x1: -5, y1: 5, z1: 7, x2: 15, y2: 5, z2: 7)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    // MARK: intersection(with:)
    
    // MARK: X - Positive
    
    func testIntersectionWith_3d_line_acrossTopQuadrant_xPositive() {
        // Run a line on a rectangular-shaped Rectangle of dimensions (x30 y20 z10),
        // along the X coordinate through the top (Y: 10, Z: 7) quadrant.
        
        let sut = Rectangle3(minimum: .init(x: 0, y: 0, z: 0), maximum: .init(x: 30, y: 20, z: 10))
        let line = Line3D(x1: -5, y1: 10, z1: 7, x2: 40, y2: 10, z2: 7)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -2.7755575615628914e-16, y: 10.0, z: 7.0),
                    normal: .init(x: -1.0, y: 0.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 30.0, y: 10.0, z: 7.0),
                    normal: .init(x: -1.0, y: 0.0, z: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_3d_line_acrossFarQuadrant_xPositive() {
        // Run a line on a rectangular-shaped Rectangle of dimensions (x30 y20 z10),
        // along the X coordinate through the far (Y: 12, Z: 10) quadrant.
        
        let sut = Rectangle3(minimum: .init(x: 0, y: 0, z: 0), maximum: .init(x: 30, y: 20, z: 10))
        let line = Line3D(x1: -5, y1: 12, z1: 5, x2: 40, y2: 12, z2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -2.7755575615628914e-16, y: 12, z: 5.0),
                    normal: .init(x: -1.0, y: 0.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 30.0, y: 12, z: 5.0),
                    normal: .init(x: -1.0, y: 0.0, z: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_3d_line_acrossBottomQuadrant_xPositive() {
        // Run a line on a rectangular-shaped Rectangle of dimensions (x30 y20 z10),
        // along the X coordinate through the bottom (Y: 10, Z: 3) quadrant.
        
        let sut = Rectangle3(minimum: .init(x: 0, y: 0, z: 0), maximum: .init(x: 30, y: 20, z: 10))
        let line = Line3D(x1: -5, y1: 10, z1: 3, x2: 40, y2: 10, z2: 3)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -2.7755575615628914e-16, y: 10.0, z: 3.0),
                    normal: .init(x: -1.0, y: 0.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 30.0, y: 10.0, z: 3.0),
                    normal: .init(x: -1.0, y: 0.0, z: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_3d_line_acrossNearQuadrant_xPositive() {
        // Run a line on a rectangular-shaped Rectangle of dimensions (x30 y20 z10),
        // along the X coordinate through the near (Y: 7, Z: 10) quadrant.
        
        let sut = Rectangle3(minimum: .init(x: 0, y: 0, z: 0), maximum: .init(x: 30, y: 20, z: 10))
        let line = Line3D(x1: -5, y1: 7, z1: 5, x2: 40, y2: 7, z2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -2.7755575615628914e-16, y: 7, z: 5.0),
                    normal: .init(x: -1.0, y: 0.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 30.0, y: 7, z: 5.0),
                    normal: .init(x: -1.0, y: 0.0, z: 0.0)
                )
            )
        )
    }
    
    // MARK: X - Negative
    
    func testIntersectionWith_3d_line_acrossTopQuadrant_xNegative() {
        // Run a line on a rectangular-shaped Rectangle of dimensions (x30 y20 z10),
        // along the X coordinate through the top (Y: 10, Z: 7) quadrant.
        
        let sut = Rectangle3(minimum: .init(x: 0, y: 0, z: 0), maximum: .init(x: 30, y: 20, z: 10))
        let line = Line3D(x1: 40, y1: 10, z1: 7, x2: -5, y2: 10, z2: 7)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 30.0, y: 10.0, z: 7.0),
                    normal: .init(x: 1.0, y: 0.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 2.220446049250313e-15, y: 10.0, z: 7.0),
                    normal: .init(x: 1.0, y: 0.0, z: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_3d_line_acrossFarQuadrant_xNegative() {
        // Run a line on a rectangular-shaped Rectangle of dimensions (x30 y20 z10),
        // along the X coordinate through the far (Y: 12, Z: 10) quadrant.
        
        let sut = Rectangle3(minimum: .init(x: 0, y: 0, z: 0), maximum: .init(x: 30, y: 20, z: 10))
        let line = Line3D(x1: 40, y1: 12, z1: 5, x2: -5, y2: 12, z2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 30.0, y: 12, z: 5.0),
                    normal: .init(x: 1.0, y: 0.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 2.220446049250313e-15, y: 12.0, z: 5.0),
                    normal: .init(x: 1.0, y: 0.0, z: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_3d_line_acrossBottomQuadrant_xNegative() {
        // Run a line on a rectangular-shaped Rectangle of dimensions (x30 y20 z10),
        // along the X coordinate through the bottom (Y: 10, Z: 3) quadrant.
        
        let sut = Rectangle3(minimum: .init(x: 0, y: 0, z: 0), maximum: .init(x: 30, y: 20, z: 10))
        let line = Line3D(x1: 40, y1: 10, z1: 3, x2: -5, y2: 10, z2: 3)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 30.0, y: 10.0, z: 3.0),
                    normal: .init(x: 1.0, y: 0.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 2.220446049250313e-15, y: 10.0, z: 3.0),
                    normal: .init(x: 1.0, y: 0.0, z: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_3d_line_acrossNearQuadrant_xNegative() {
        // Run a line on a rectangular-shaped Rectangle of dimensions (x30 y20 z10),
        // along the X coordinate through the near (Y: 7, Z: 10) quadrant.
        
        let sut = Rectangle3(minimum: .init(x: 0, y: 0, z: 0), maximum: .init(x: 30, y: 20, z: 10))
        let line = Line3D(x1: 40, y1: 7, z1: 5, x2: -5, y2: 7, z2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 30.0, y: 7.0, z: 5.0),
                    normal: .init(x: 1.0, y: 0.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 2.220446049250313e-15, y: 7.0, z: 5.0),
                    normal: .init(x: 1.0, y: 0.0, z: 0.0)
                )
            )
        )
    }
    
    // MARK: Y - Positive - Angled
    
    func testIntersectionWith_3d_ray_acrossTopQuadrant_yPositiveAngled() {
        // Run a line on a rectangular-shaped Rectangle of dimensions (x30 y20 z10),
        // along the Y coordinate through the near (X: 20, Z: 7) quadrant, with
        // a downard slope that cuts to the far bottom (X: 20, Z: 3) quadrant.
        
        let sut = Rectangle3(minimum: .init(x: 0, y: 0, z: 0), maximum: .init(x: 30, y: 20, z: 10))
        let line = DirectionalRay3D(x1: 20, y1: -5, z1: 7, x2: 20, y2: 25, z2: 3)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 20.0, y: 1.67257683684584e-16, z: 6.333333333333333),
                    normal: .init(x: 0.0, y: -1.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 20.0, y: 20.0, z: 3.666666666666667),
                    normal: .init(x: 0.0, y: -1.0, z: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_3d_ray_offset_acrossTopQuadrant_yPositiveAngled() {
        // Run a line on a rectangular-shaped Rectangle of dimensions (x30 y20 z10)
        // with an offset from origin of (x2, y3, z4), along the Y coordinate
        // through the near (X: 20, Z: 7) quadrant, with a downard slope that
        // cuts to the bottom far (Y: 17, Z: 4) quadrant.
        
        let sut = Rectangle3(minimum: .init(x: 2, y: 3, z: 4), maximum: .init(x: 30, y: 20, z: 10))
        let line = DirectionalRay3D(x1: 20, y1: -5, z1: 7, x2: 20, y2: 25, z2: 3)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 20.0, y: 2.999999999999999, z: 5.933333333333334),
                    normal: .init(x: 0.0, y: -1.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 20.0, y: 17.5, z: 4.0),
                    normal: .init(x: 0.0, y: 0.0, z: 1.0)
                )
            )
        )
    }
}

// MARK: SignedDistanceMeasurableType Conformance

extension NRectangleTests {
    func testSignedDistanceTo_center() {
        let sut = Rectangle(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: sut.center), -2.0)
    }
    
    func testSignedDistanceTo_onEdge_left() {
        let sut = Rectangle(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 1, y: 5)), 0.0)
    }
    
    func testSignedDistanceTo_onEdge_top() {
        let sut = Rectangle(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 3, y: 7)), 0.0)
    }
    
    func testSignedDistanceTo_onEdge_right() {
        let sut = Rectangle(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 5, y: 5)), 0.0)
    }
    
    func testSignedDistanceTo_onEdge_bottom() {
        let sut = Rectangle(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 3, y: 2)), 0.0)
    }
    
    func testSignedDistanceTo_outside_bottomEdge() {
        let sut = Rectangle(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 3, y: 0)), 2.0)
    }
    
    func testSignedDistanceTo_outside_rightEdge() {
        let sut = Rectangle(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 7, y: 5)), 2.0)
    }
    
    func testSignedDistanceTo_outside_bottomLeftEdge() {
        let sut = Rectangle(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 0, y: 0)), 2.23606797749979)
    }
}
