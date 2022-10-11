import XCTest
import Geometria

class AABBTests: XCTestCase {
    typealias Box = AABB2D
    typealias AABB3 = AABB3D
    
    func testCodable() throws {
        let sut = Box(
            minimum: .init(x: 1, y: 2),
            maximum: .init(x: 3, y: 4)
        )
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(Box.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testInitWithMinimumMaximum() {
        let sut = Box(
            minimum: .init(x: 1, y: 2),
            maximum: .init(x: 3, y: 4)
        )
        
        XCTAssertEqual(sut.minimum, .init(x: 1, y: 2))
        XCTAssertEqual(sut.maximum, .init(x: 3, y: 4))
    }
    
    func testLocation() {
        let sut = Box(
            minimum: .init(x: 1, y: 2),
            maximum: .init(x: 3, y: 4)
        )
        
        XCTAssertEqual(sut.location, .init(x: 1, y: 2))
    }
}

// MARK: BoundableType Conformance

extension AABBTests {
    func testBounds() {
        let sut = Box(
            minimum: .init(x: 1, y: 2),
            maximum: .init(x: 3, y: 6)
        )
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: 1, y: 2))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 6))
    }
}

// MARK: Equatable Conformance

extension AABBTests {
    func testEquality() {
        XCTAssertEqual(
            Box(
                minimum: .init(x: 1, y: 2),
                maximum: .init(x: 3, y: 4)
            ),
            Box(
                minimum: .init(x: 1, y: 2),
                maximum: .init(x: 3, y: 4)
            )
        )
    }
    
    func testUnequality() {
        XCTAssertNotEqual(
            Box(
                minimum: .init(x: 999, y: 2),
                maximum: .init(x: 3, y: 4)
            ),
            Box(minimum: .init(x: 1, y: 2),
                maximum: .init(x: 3, y: 4)
            )
        )
        
        XCTAssertNotEqual(
            Box(
                minimum: .init(x: 1, y: 999),
                maximum: .init(x: 3, y: 4)
            ),
            Box(
                minimum: .init(x: 1, y: 2),
                maximum: .init(x: 3, y: 4)
            )
        )
        
        XCTAssertNotEqual(
            Box(
                minimum: .init(x: 1, y: 2),
                maximum: .init(x: 999, y: 4)
            ),
            Box(
                minimum: .init(x: 1, y: 2),
                maximum: .init(x: 3, y: 4)
            )
        )
        
        XCTAssertNotEqual(
            Box(
                minimum: .init(x: 1, y: 2),
                maximum: .init(x: 3, y: 999)
            ),
            Box(
                minimum: .init(x: 1, y: 2),
                maximum: .init(x: 3, y: 4)
            )
        )
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
    
    func testInitOfPoints_2Points() {
        let result = Box(of: .init(x: -5, y: 6), .init(x: 3, y: -2))
        
        XCTAssertEqual(result.minimum, .init(x: -5, y: -2))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 6))
    }
    
    func testInitOfPoints_3Points() {
        let result =
        Box(of: .init(x: -5, y: 4),
            .init(x: 3, y: -2),
            .init(x: 2, y: 6)
        )
        
        XCTAssertEqual(result.minimum, .init(x: -5, y: -2))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 6))
    }
    
    func testInitOfPoints_4Points() {
        let result =
        Box(of: .init(x: -5, y: 4),
            .init(x: 3, y: -2),
            .init(x: 1, y: 3),
            .init(x: 2, y: 6)
        )
        
        XCTAssertEqual(result.minimum, .init(x: -5, y: -2))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 6))
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
}

// MARK: SelfIntersectableRectangleType Conformance

extension AABBTests {
    func testContainsAABB() {
        let sut = Box(x: 0, y: 1, width: 5, height: 7)
        
        XCTAssertTrue(sut.contains(Box(x: 1, y: 2, width: 3, height: 4)))
        XCTAssertFalse(sut.contains(Box(x: -1, y: 2, width: 3, height: 4)))
        XCTAssertFalse(sut.contains(Box(x: 1, y: -2, width: 3, height: 4)))
        XCTAssertFalse(sut.contains(Box(x: 1, y: 2, width: 5, height: 4)))
        XCTAssertFalse(sut.contains(Box(x: 1, y: 2, width: 3, height: 7)))
    }
    
    func testContainsAABB_returnsTrueForEqualBox() {
        let sut = Box(x: 0, y: 1, width: 5, height: 7)
        
        XCTAssertTrue(sut.contains(sut))
    }
    
    func testIntersectsAABB() {
        let sut = Box(x: 0, y: 0, width: 3, height: 3)
        
        XCTAssertTrue(sut.intersects(Box(x: -1, y: -1, width: 2, height: 2)))
        XCTAssertFalse(sut.intersects(Box(x: -3, y: 0, width: 2, height: 2)))
        XCTAssertFalse(sut.intersects(Box(x: 0, y: -3, width: 2, height: 2)))
        XCTAssertFalse(sut.intersects(Box(x: 4, y: 0, width: 2, height: 2)))
        XCTAssertFalse(sut.intersects(Box(x: 0, y: 4, width: 2, height: 2)))
    }
    
    func testIntersectsAABB_edgeIntersections() {
        let sut = Box(x: 0, y: 0, width: 3, height: 3)
        
        XCTAssertTrue(sut.intersects(Box(x: -2, y: -2, width: 2, height: 2)))
        XCTAssertTrue(sut.intersects(Box(x: -2, y: 3, width: 2, height: 2)))
        XCTAssertTrue(sut.intersects(Box(x: 3, y: -2, width: 2, height: 2)))
        XCTAssertTrue(sut.intersects(Box(x: 3, y: 3, width: 2, height: 2)))
    }
    
    func testUnion() {
        let sut = Box(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.union(.init(x: 7, y: 13, width: 17, height: 19))
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 23, y: 30))
    }
    
    func testIntersection_sameAABB() {
        let rect = Box(x: 1, y: 2, width: 3, height: 4)
        
        let result = rect.intersection(rect)
        
        XCTAssertEqual(result, rect)
    }
    
    func testIntersection_overlappingAABB() {
        let rect1 = Box(x: 1, y: 2, width: 3, height: 4)
        let rect2 = Box(x: -1, y: 1, width: 3, height: 4)
        
        let result = rect1.intersection(rect2)
        
        XCTAssertEqual(result, Box(x: 1, y: 2, width: 1, height: 3))
    }
    
    func testIntersection_edgeOnly() {
        let rect1 = Box(x: 1, y: 2, width: 3, height: 4)
        let rect2 = Box(x: -2, y: 2, width: 3, height: 4)
        
        let result = rect1.intersection(rect2)
        
        XCTAssertEqual(result, Box(x: 1, y: 2, width: 0, height: 4))
    }
    
    func testIntersection_cornerOnly() {
        let rect1 = Box(x: 1, y: 2, width: 3, height: 4)
        let rect2 = Box(x: -2, y: -2, width: 3, height: 4)
        
        let result = rect1.intersection(rect2)
        
        XCTAssertEqual(result, Box(x: 1, y: 2, width: 0, height: 0))
    }
    
    func testIntersection_noIntersection() {
        let rect1 = Box(x: 1, y: 2, width: 3, height: 4)
        let rect2 = Box(x: -3, y: -3, width: 3, height: 4)
        
        let result = rect1.intersection(rect2)
        
        XCTAssertNil(result)
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
    func testInitOfPoints_variadic() {
        let result =
            Box(of:
                .init(x: -5, y: 4),
                .init(x: 3, y: -2),
                .init(x: 1, y: 3),
                .init(x: 2, y: 1),
                .init(x: 2, y: 6)
            )
        
        XCTAssertEqual(result.minimum, .init(x: -5, y: -2))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 6))
    }
    
    func testInitPoints() {
        let result = Box(points: [
            .init(x: -5, y: 4),
            .init(x: 3, y: -2),
            .init(x: 1, y: 3),
            .init(x: 2, y: 1),
            .init(x: 2, y: 6),
        ])
        
        XCTAssertEqual(result.minimum, .init(x: -5, y: -2))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 6))
    }
    
    func testInitPoints_empty() {
        let result = Box(points: [])
        
        XCTAssertEqual(result.minimum, .zero)
        XCTAssertEqual(result.maximum, .zero)
    }

    func testInitAABBs() {
        let aabb1 = Box(
            minimum: .init(x: -5, y: -2),
            maximum: .init(x: 3, y: 4)
        )
        let aabb2 = Box(
            minimum: .init(x: 1, y: 1),
            maximum: .init(x: 2, y: 12)
        )
        let aabb3 = Box(
            minimum: .init(x: 2, y: 6),
            maximum: .init(x: 7, y: 3)
        )

        let result = Box(aabbs: [aabb1, aabb2, aabb3])

        XCTAssertEqual(result.minimum, .init(x: -5, y: -2))
        XCTAssertEqual(result.maximum, .init(x: 7, y: 12))
    }
    
    func testInitAABBs_empty() {
        let result = Box(aabbs: [])
        
        XCTAssertEqual(result.minimum, .zero)
        XCTAssertEqual(result.maximum, .zero)
    }
}

// MARK: Vector: VectorMultiplicative Tests

extension AABBTests {
    func testUnit() {
        let sut = Box.unit
        
        XCTAssertEqual(sut.minimum, .zero)
        XCTAssertEqual(sut.maximum, .one)
    }
}

// MARK: DivisibleRectangleType where Vector: VectorDivisible & VectorComparable Tests

extension AABBTests {
    func testSubdivided_2D() {
        TestFixture.beginFixture(sceneScale: 5, renderScale: 20) { fixture in
            let sut = Box(
                minimum: .init(x: -5, y: -2),
                maximum: .init(x: 7, y: 12)
            )
            
            fixture.add(sut)

            let result = sut.subdivided()

            fixture.assertEquals(result, [
                .init(minimum: .init(x: -5.0, y: -2.0), maximum: .init(x: 1.0, y: 5.0)),
                .init(minimum: .init(x: 1.0, y: -2.0), maximum: .init(x: 7.0, y: 5.0)),
                .init(minimum: .init(x: -5.0, y: 5.0), maximum: .init(x: 1.0, y: 12.0)),
                .init(minimum: .init(x: 1.0, y: 5.0), maximum: .init(x: 7.0, y: 12.0)),
            ])
        }
    }

    func testSubdivided_3D() {
        TestFixture.beginFixture(sceneScale: 1.0, renderScale: 20.0) { fixture in
            let sut = AABB3(
                minimum: .init(x: -5, y: -2, z: -1),
                maximum: .init(x: 7, y: 12, z: 10)
            )
            
            fixture.add(sut)

            let result = sut.subdivided()

            fixture.assertEquals(result, [
                AABB3(minimum: .init(x: -5.0, y: -2.0, z: -1.0), maximum: .init(x: 1.0, y: 5.0, z: 4.5)),
                AABB3(minimum: .init(x: 1.0, y: -2.0, z: -1.0), maximum: .init(x: 7.0, y: 5.0, z: 4.5)),
                AABB3(minimum: .init(x: -5.0, y: 5.0, z: -1.0), maximum: .init(x: 1.0, y: 12.0, z: 4.5)),
                AABB3(minimum: .init(x: 1.0, y: 5.0, z: -1.0), maximum: .init(x: 7.0, y: 12.0, z: 4.5)),
                AABB3(minimum: .init(x: -5.0, y: -2.0, z: 4.5), maximum: .init(x: 1.0, y: 5.0, z: 10.0)),
                AABB3(minimum: .init(x: 1.0, y: -2.0, z: 4.5), maximum: .init(x: 7.0, y: 5.0, z: 10.0)),
                AABB3(minimum: .init(x: -5.0, y: 5.0, z: 4.5), maximum: .init(x: 1.0, y: 12.0, z: 10.0)),
                AABB3(minimum: .init(x: 1.0, y: 5.0, z: 4.5), maximum: .init(x: 7.0, y: 12.0, z: 10.0)),
            ])
        }
    }
}

// MARK: - ConvexType Conformance

// MARK: 2D

extension AABBTests {
    // MARK: intersects(line:)
    
    func testIntersectsLine_2d_line() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 2, y1: 9, x2: 15, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_line_alongEdge_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_line_outsideLineLimits_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 0, y1: 9, x2: 1, y2: 8)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_line_noIntersection_bottom_returnsFalse() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 12, y1: 9, x2: 13, y2: 9)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_line_noIntersection_returnsFalse() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 9, y1: 9, x2: 15, y2: 7)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_lineSegment_outsideLineLimits_returnsFalse() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 0, y1: 9, x2: 1, y2: 8)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_lineSegment_alongEdge_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_lineSegment_alongEdge_startsAfterEdge_returnsFalse() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 12, y1: 3, x2: 13, y2: 3)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 2, y1: 9, x2: 15, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray_intersectsBeforeRayStart_returnsFalse() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 2, y1: 10, x2: 15, y2: 11)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray_intersectsAfterRayStart_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray_startsWithinAABB_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_ray_alongEdge_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 0, y1: 3, x2: 1, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_directionalRay_intersectsBeforeRayStart_returnsFalse() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 2, y1: 10, x2: 15, y2: 11)
        
        XCTAssertFalse(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_directionalRay_intersectsAfterRayStart_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 0, y1: 0, x2: 1, y2: 1)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_directionalRay_startsWithinAABB_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 3, y1: 4, x2: 4, y2: 5)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_2d_directionalRay_alongEdge_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 1, y1: 3, x2: 13, y2: 3)
        
        XCTAssertTrue(sut.intersects(line: line))
    }

    func testIntersectsLine_2d_fullyContained_returnsTrue() {
        let sut = Box(left: 2, top: 3, right: 13, bottom: 17)
        let line = LineSegment2D(x1: 3, y1: 4, x2: 5, y2: 6)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    // MARK: intersection(with:)
    
    func testIntersectionWith_2d_line_across_horizontal() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 9, y1: 9, x2: 15, y2: 7)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_top_horizontal() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 3, y1: 2, x2: 5, y2: 2)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_top_horizontal_long_line() {
        let sut = Box(left: 2, top: 3, right: 4, bottom: 7)
        let line = Line2D(x1: -50, y1: 2.5, x2: 50, y2: 2.5)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_left_vertical() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 1, y1: 2, x2: 1, y2: 3)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_right_vertical() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 12, y1: 2, x2: 12, y2: 3)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_bottom_horizontal() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 3, y1: 9, x2: 5, y2: 9)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_noIntersection_bottomRight_horizontal() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Line2D(x1: 12, y1: 9, x2: 13, y2: 9)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_line_alongEdge() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = LineSegment2D(x1: 0, y1: 9, x2: 1, y2: 8)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_lineSegment_exitOnly() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
    
    func testIntersectionWith_2d_lineSegment_endsWithinAABB() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 0, top: 0, right: 20, bottom: 20)
        let line = LineSegment2D(start: .one, end: .init(x: 10, y: 10))
        
        assertEqual(sut.intersection(with: line), .contained)
    }
    
    func testIntersectionWith_2d_ray() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = Ray2D(x1: 10, y1: 10, x2: 15, y2: 11)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_ray_intersectsAfterRayStart() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
    
    func testIntersectionWith_2d_ray_startsWithinAABB() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
        let line = DirectionalRay2D(x1: 2, y1: 10, x2: 15, y2: 11)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWith_2d_directionalRay_intersectsAfterRayStart() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
    
    func testIntersectionWith_2d_directionalRay_startsWithinAABB() {
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        let sut = Box(left: 2, top: 3, right: 11, bottom: 7)
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
        
        let sut = Box(left: 162.5, top: 135.0, right: 237.5, bottom: 165.0)
        let line = LineSegment2D(
            x1: 101.01359554152113, y1: 164.20182144594258,
            x2: 298.9864044584789, y2: 145.79817855405742
        )
        
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

extension AABBTests {
    // MARK: intersects(line:)
    
    func testIntersectsLine_3d_line_acrossTopQuadrant() {
        let sut = AABB3(
            minimum: .init(x: 0, y: 0, z: 0),
            maximum: .init(x: 10, y: 10, z: 10)
        )
        let line = Line3D(x1: -5, y1: 5, z1: 7, x2: 15, y2: 5, z2: 7)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    func testIntersectsLine_3d_line_zeroDepth_headOn() {
        let sut = AABB3(
            minimum: .init(x: 0, y: 5, z: 0),
            maximum: .init(x: 10, y: 5, z: 10)
        )
        let line = Line3D(x1: 5, y1: -5, z1: 7, x2: 5, y2: 5, z2: 7)
        
        XCTAssertTrue(sut.intersects(line: line))
    }
    
    // MARK: intersection(with:)
    
    // MARK: X - Positive
    
    func testIntersectionWith_3d_line_acrossTopQuadrant_xPositive() {
        // Run a line on a rectangular-shaped AABB of dimensions (x30 y20 z10),
        // along the X coordinate through the top (Y: 10, Z: 7) quadrant.
        
        let sut = AABB3(
            minimum: .init(x: 0, y: 0, z: 0),
            maximum: .init(x: 30, y: 20, z: 10)
        )
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
        // Run a line on a rectangular-shaped AABB of dimensions (x30 y20 z10),
        // along the X coordinate through the far (Y: 12, Z: 10) quadrant.
        
        let sut = AABB3(
            minimum: .init(x: 0, y: 0, z: 0),
            maximum: .init(x: 30, y: 20, z: 10)
        )
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
        // Run a line on a rectangular-shaped AABB of dimensions (x30 y20 z10),
        // along the X coordinate through the bottom (Y: 10, Z: 3) quadrant.
        
        let sut = AABB3(
            minimum: .init(x: 0, y: 0, z: 0),
            maximum: .init(x: 30, y: 20, z: 10)
        )
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
        // Run a line on a rectangular-shaped AABB of dimensions (x30 y20 z10),
        // along the X coordinate through the near (Y: 7, Z: 10) quadrant.
        
        let sut = AABB3(
            minimum: .init(x: 0, y: 0, z: 0),
            maximum: .init(x: 30, y: 20, z: 10)
        )
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
        // Run a line on a rectangular-shaped AABB of dimensions (x30 y20 z10),
        // along the X coordinate through the top (Y: 10, Z: 7) quadrant.
        
        let sut = AABB3(
            minimum: .init(x: 0, y: 0, z: 0),
            maximum: .init(x: 30, y: 20, z: 10)
        )
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
        // Run a line on a rectangular-shaped AABB of dimensions (x30 y20 z10),
        // along the X coordinate through the far (Y: 12, Z: 10) quadrant.
        
        let sut = AABB3(
            minimum: .init(x: 0, y: 0, z: 0),
            maximum: .init(x: 30, y: 20, z: 10)
        )
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
        // Run a line on a rectangular-shaped AABB of dimensions (x30 y20 z10),
        // along the X coordinate through the bottom (Y: 10, Z: 3) quadrant.
        
        let sut = AABB3(
            minimum: .init(x: 0, y: 0, z: 0),
            maximum: .init(x: 30, y: 20, z: 10)
        )
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
        // Run a line on a rectangular-shaped AABB of dimensions (x30 y20 z10),
        // along the X coordinate through the near (Y: 7, Z: 10) quadrant.
        
        let sut = AABB3(
            minimum: .init(x: 0, y: 0, z: 0),
            maximum: .init(x: 30, y: 20, z: 10)
        )
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
    
    // MARK: Y - Positive - Zero-depth AABB
    
    func testIntersectionWith_3d_line_zeroDepth_headOn() {
        let sut = AABB3(
            minimum: .init(x: 0, y: 5, z: 0),
            maximum: .init(x: 10, y: 5, z: 10)
        )
        let line = Line3D(x1: 5, y1: -5, z1: 7, x2: 5, y2: 5, z2: 7)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 5.0, y: 5.0, z: 7.0),
                    normal: .init(x: 0.0, y: -1.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 5.0, y: 5.0, z: 7.0),
                    normal: .init(x: 0.0, y: -1.0, z: 0.0)
                )
            )
        )
    }
    
    // MARK: Y - Positive - Angled
    
    func testIntersectionWith_3d_ray_acrossTopQuadrant_yPositiveAngled() {
        // Run a line on a rectangular-shaped AABB of dimensions (x30 y20 z10),
        // along the Y coordinate through the near (X: 20, Z: 7) quadrant, with
        // a downward slope that cuts to the far bottom (X: 20, Z: 3) quadrant.
        
        let sut = AABB3(
            minimum: .init(x: 0, y: 0, z: 0),
            maximum: .init(x: 30, y: 20, z: 10)
        )
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
        // Run a line on a rectangular-shaped AABB of dimensions (x30 y20 z10)
        // with an offset from origin of (x2, y3, z4), along the Y coordinate
        // through the near (X: 20, Z: 7) quadrant, with a downward slope that
        // cuts to the bottom far (Y: 17, Z: 4) quadrant.
        
        let sut = AABB3(
            minimum: .init(x: 2, y: 3, z: 4),
            maximum: .init(x: 30, y: 20, z: 10)
        )
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

    #if ENABLE_SIMD
    #if canImport(simd)
    
    func testIntersectionWith_3d_ray_normalBug1() {
        // From GeometriaApp commit 8bf1b3021ef3fd133c46ca6c3e959c90a84df2f5
        // at pixel coord: (x: 174, y: 160)
        // Original AABB:
        // AABB(minimum: .init(x: -20.0, y: 110.0, z: 80.0),
        //      maximum: .init(x: 60.0, y: 90.0, z: 95.0))
        //
        // Issue turned out to be the inverted Y min-max axis above, but we leave
        // the test here to reference it in the future just in case.
        //
        typealias Vector = SIMD3<Double>
        
        let sut = AABB<Vector>(
            minimum: .init(x: -20.0, y: 90.0, z: 80.0),
            maximum: .init(x: 60.0, y: 110.0, z: 95.0)
        )
        let ray = DirectionalRay<Vector>(
            start: .init(x: -7.8, y: 0.0, z: 87.0),
            direction: .init(
                x: -0.08629543594487392,
                y: 0.995716568594699,
                z: -0.03319055228648997
            )
        )
        
        assertEqual(
            sut.intersection(with: ray),
            .enterExit(
                PointNormal(
                    point: .init(x: -15.6, y: 90.0, z: 84.0),
                    normal: .init(x: 0.0, y: -1.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: -17.333333333333332, y: 110.0, z: 83.33333333333333),
                    normal: .init(x: 0.0, y: -1.0, z: 0.0)
                )
            )
        )
    }

    #endif // #if canImport(simd)
    #endif // #if ENABLE_SIMD
}

// MARK: SignedDistanceMeasurableType Conformance

extension AABBTests {
    func testSignedDistanceTo_center() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: sut.center), -2.0)
    }
    
    func testSignedDistanceTo_onEdge_left() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 1, y: 5)), 0.0)
    }
    
    func testSignedDistanceTo_onEdge_top() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 3, y: 7)), 0.0)
    }
    
    func testSignedDistanceTo_onEdge_right() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 5, y: 5)), 0.0)
    }
    
    func testSignedDistanceTo_onEdge_bottom() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 3, y: 2)), 0.0)
    }
    
    func testSignedDistanceTo_outside_bottomEdge() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 3, y: 0)), 2.0)
    }
    
    func testSignedDistanceTo_outside_rightEdge() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 7, y: 5)), 2.0)
    }
    
    func testSignedDistanceTo_outside_bottomLeftEdge() {
        let sut = Box(minimum: .init(x: 1, y: 2), maximum: .init(x: 5, y: 7))
        
        XCTAssertEqual(sut.signedDistance(to: .init(x: 0, y: 0)), 2.23606797749979)
    }
}
