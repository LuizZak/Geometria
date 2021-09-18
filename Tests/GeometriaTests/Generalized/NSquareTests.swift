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

// MARK: Vector: VectorAdditive & VectorComparable Conformance

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

// MARK: Vector: VectorDivisible Conformance

extension NSquareTests {
    func testCenter() {
        let sut = Square(x: 2, y: 3, sideLength: 5)
        
        XCTAssertEqual(sut.center, .init(x: 4.5, y: 5.5))
    }
}

// MARK: - ConvexType Conformance

extension NSquareTests {
    // MARK: intersects(line:)
    
    func testIntersectsLine_2d_line() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 2, y1: 9, x2: 15, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_line_alongEdge_returnsTrue() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_line_outsideLineLimits_returnsTrue() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 0, y1: 9, x2: 1, y2: 8)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_line_noIntersection_bottom_returnsFalse() {
        let sut = Square(x: 2, y: 3, sideLength: 4)
        let line = Line2D(x1: 12, y1: 9, x2: 13, y2: 9)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_line_noIntersection_returnsFalse() {
        let sut = Square(x: 2, y: 3, sideLength: 4)
        let line = Line2D(x1: 9, y1: 9, x2: 15, y2: 7)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_lineSegment_outsideLineLimits_returnsFalse() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = LineSegment2D(x1: 0, y1: 9, x2: 1, y2: 8)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_lineSegment_alongEdge_returnsTrue() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = LineSegment2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_lineSegment_alongEdge_startsAfterEdge_returnsFalse() {
        let sut = Square(x: 2, y: 3, sideLength: 4)
        let line = LineSegment2D(x1: 12, y1: 3, x2: 13, y2: 3)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Ray2D(x1: 2, y1: 9, x2: 15, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray_intersectsBeforeRayStart_returnsFalse() {
        let sut = Square(x: 2, y: 3, sideLength: 4)
        let line = Ray2D(x1: 2, y1: 10, x2: 15, y2: 11)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray_intersectsAfterRayStart_returnsTrue() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Ray2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray_startsWithinSquare_returnsTrue() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Ray2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray_alongEdge_returnsTrue() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Ray2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_directionalRay_intersectsBeforeRayStart_returnsFalse() {
        let sut = Square(x: 2, y: 3, sideLength: 4)
        let line = DirectionalRay2D(x1: 2, y1: 10, x2: 15, y2: 11)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_directionalRay_intersectsAfterRayStart_returnsTrue() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = DirectionalRay2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_directionalRay_startsWithinSquare_returnsTrue() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = DirectionalRay2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_directionalRay_alongEdge_returnsTrue() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    // MARK: intersection(with:)
    
    func testIntersectionWith_2d_line_across_horizontal() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 0, y1: 5, x2: 12, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                .init(
                    point: .init(x: 2.0, y: 5.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                .init(
                    point: .init(x: 13.0, y: 5.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_line_contained_horizontal() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 3, y1: 5, x2: 7, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                .init(
                    point: .init(x: 2.0, y: 5.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                .init(
                    point: .init(x: 13.0, y: 5.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_line_fromTop_pointingDown() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 5, y1: 0, x2: 5, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 5.0, y: 3.0),
                    normal: .init(x: 0.0, y: -1.0)
                ),
                PointNormal(
                    point: .init(x: 5.0, y: 14.0),
                    normal: .init(x: 0.0, y: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_line_fromTop_pointingUp() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 5, y1: 1, x2: 5, y2: 0)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 5.0, y: 14.0),
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
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 0, y1: 5, x2: 1, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 5.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 13.0, y: 5.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_line_fromLeft_pointingLeft() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 1, y1: 5, x2: 0, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 13.0, y: 5.0),
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
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 13, y1: 5, x2: 12, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 13.0, y: 5.0),
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
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 12, y1: 5, x2: 13, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 5.0),
                    normal: .init(x: -1, y: 0)
                ),
                PointNormal(
                    point: .init(x: 13.0, y: 5.0),
                    normal: .init(x: -1, y: 0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_line_fromBottom_pointingUp() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 5, y1: 9, x2: 5, y2: 8)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 5.0, y: 14.0),
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
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 5, y1: 8, x2: 5, y2: 9)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 5.0, y: 3.0),
                    normal: .init(x: 0.0, y: -1.0)
                ),
                PointNormal(
                    point: .init(x: 5.0, y: 14.0),
                    normal: .init(x: 0.0, y: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_line_outsideLineLimits() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
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
        let sut = Square(x: 2, y: 3, sideLength: 4)
        let line = Line2D(x1: 9, y1: 9, x2: 15, y2: 7)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_top_horizontal() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 3, y1: 2, x2: 5, y2: 2)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_left_vertical() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 1, y1: 2, x2: 1, y2: 3)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_right_vertical() {
        let sut = Square(x: 2, y: 3, sideLength: 4)
        let line = Line2D(x1: 12, y1: 2, x2: 12, y2: 3)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_bottom_horizontal() {
        let sut = Square(x: 2, y: 3, sideLength: 4)
        let line = Line2D(x1: 3, y1: 9, x2: 5, y2: 9)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_bottomRight_horizontal() {
        let sut = Square(x: 2, y: 3, sideLength: 4)
        let line = Line2D(x1: 12, y1: 9, x2: 13, y2: 9)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_alongEdge() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 13.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_lineSegment_outsideLineLimits() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = LineSegment2D(x1: 0, y1: 9, x2: 1, y2: 8)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_lineSegment_exitOnly() {
        let sut = Square(x: 2, y: 3, sideLength: 8)
        let line = LineSegment2D(x1: 5, y1: 4, x2: 12, y2: 4)
        
        assertEqual(
            sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 10.0, y: 4.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_lineSegment_endsWithinSquare() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
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
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Line2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 13.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_line_contained() {
        let sut = Square(x: 0, y: 0, sideLength: 20)
        let line = LineSegment2D(start: .one, end: .init(x: 10, y: 10))
        
        assertEqual(sut.intersection(with: line), .contained)
    }
    
    func testIntersectionWith_2d_ray() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Ray2D(x1: 2, y1: 9, x2: 15, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                .init(
                    point: .init(x: 2.0, y: 9.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                .init(
                    point: .init(x: 13.0, y: 5.615384615384615),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_ray_intersectsBeforeRayStart() {
        let sut = Square(x: 2, y: 3, sideLength: 4)
        let line = Ray2D(x1: 10, y1: 10, x2: 15, y2: 11)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_ray_intersectsAfterRayStart() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Ray2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 3.0, y: 3.0),
                    normal: .init(x: 0.0, y: -1.0)
                ),
                PointNormal(
                    point: .init(x: 13.0, y: 13.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_ray_startsWithinSquare() {
        let sut = Square(x: 2, y: 3, sideLength: 4)
        let line = Ray2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 6.0, y: 7.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_ray_alongEdge() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = Ray2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 13.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_directionalRay_intersectsBeforeRayStart() {
        let sut = Square(x: 2, y: 3, sideLength: 4)
        let line = DirectionalRay2D(x1: 2, y1: 10, x2: 15, y2: 11)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_directionalRay_intersectsAfterRayStart() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = DirectionalRay2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                .init(
                    point: .init(x: 3.0, y: 3.0),
                    normal: .init(x: -0.0, y: -1.0)
                ),
                .init(
                    point: .init(x: 13.0, y: 13.0),
                    normal: .init(x: -1.0, y: -0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_directionalRay_startsWithinSquare() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = DirectionalRay2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        assertEqual(
            sut.intersection(with: line),
            .exit(
                .init(
                    point: .init(x: 13.0, y: 14.0),
                    normal: .init(x: -1.0, y: -0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_2d_directionalRay_alongEdge() {
        let sut = Square(x: 2, y: 3, sideLength: 11)
        let line = DirectionalRay2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                .init(
                    point: .init(x: 2.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                .init(
                    point: .init(x: 13.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }
}

// MARK: SignedDistanceMeasurableType Conformance

extension NSquareTests {
    func testSignedDistanceTo_center() {
        let sut = Square(location: .init(x: 1, y: 2), sideLength: 5)
        
        XCTAssertEqual(sut.signedDistance(to: sut.center), -2.5)
    }
    
    func testSignedDistanceTo_onEdge_left() {
        let sut = Square(location: .init(x: 1, y: 2), sideLength: 5)
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 1, y: 5)), 0.0)
    }
    
    func testSignedDistanceTo_onEdge_top() {
        let sut = Square(location: .init(x: 1, y: 2), sideLength: 5)
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 3, y: 7)), 0.0)
    }
    
    func testSignedDistanceTo_onEdge_right() {
        let sut = Square(location: .init(x: 1, y: 2), sideLength: 5)
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 6, y: 5)), 0.0)
    }
    
    func testSignedDistanceTo_onEdge_bottom() {
        let sut = Square(location: .init(x: 1, y: 2), sideLength: 5)
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 3, y: 2)), 0.0)
    }
    
    func testSignedDistanceTo_outside_bottomEdge() {
        let sut = Square(location: .init(x: 1, y: 2), sideLength: 5)
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 3, y: 0)), 2.0)
    }
    
    func testSignedDistanceTo_outside_rightEdge() {
        let sut = Square(location: .init(x: 1, y: 2), sideLength: 5)
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 8, y: 5)), 2.0)
    }
    
    func testSignedDistanceTo_outside_bottomLeftEdge() {
        let sut = Square(location: .init(x: 1, y: 2), sideLength: 5)
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 0, y: 0)), 2.23606797749979)
    }
}
