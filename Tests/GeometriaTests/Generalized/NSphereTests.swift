import XCTest
import Geometria

class NSphereTests: XCTestCase {
    typealias NSphere = Circle2D
    
    func testDescription() {
        let sut = NSphere(center: .init(x: 0, y: 1), radius: 2)
        
        XCTAssertEqual(sut.description, "NSphere<Vector2<Double>>(center: Vector2<Double>(x: 0.0, y: 1.0), radius: 2.0)")
    }
    
    func testCodable() throws {
        let sut = NSphere(center: .init(x: 0, y: 1), radius: 2)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(NSphere.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testInitWithCenterRadius() {
        let sut = NSphere(center: .init(x: 0, y: 1), radius: 2)
        
        XCTAssertEqual(sut.center, .init(x: 0, y: 1))
        XCTAssertEqual(sut.radius, 2)
    }
    
    func testInitWithXYRadius() {
        let sut = NSphere(x: 0, y: 1, radius: 2)
        
        XCTAssertEqual(sut.center, .init(x: 0, y: 1))
        XCTAssertEqual(sut.radius, 2)
    }
}

// MARK: BoundableType Conformance

extension NSphereTests {
    func testBounds() {
        let sut = NSphere(center: .init(x: 0, y: 1), radius: 2)
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -2, y: -1))
        XCTAssertEqual(result.maximum, .init(x: 2, y: 3))
    }
}

// MARK: Scalar: AdditiveArithmetic Conformance

extension NSphereTests {
    func testExpandedBy() {
        let sut = NSphere(center: .init(x: 0, y: 1), radius: 2)
        
        let result = sut.expanded(by: 3)
        
        XCTAssertEqual(result.center, .init(x: 0, y: 1))
        XCTAssertEqual(result.radius, 5)
    }
    
}

// MARK: VectorMultiplicative, Scalar: Comparable Conformance

extension NSphereTests {
    func testContainsVector() {
        let sut = NSphere(center: .init(x: 0, y: 1), radius: 2)
        
        XCTAssertTrue(sut.contains(.init(x: 1, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 0, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: -1, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: -2, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 2, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 0, y: -1)))
        XCTAssertTrue(sut.contains(.init(x: 0, y: 0)))
        XCTAssertTrue(sut.contains(.init(x: 0, y: 3)))
        //
        XCTAssertFalse(sut.contains(.init(x: -3, y: 1)))
        XCTAssertFalse(sut.contains(.init(x: 3, y: 1)))
        XCTAssertFalse(sut.contains(.init(x: 0, y: 4)))
        XCTAssertFalse(sut.contains(.init(x: 0, y: -3)))
    }
}

// MARK: ConvexType & PointProjectableType Conformance

extension NSphereTests {
    func testProjectUnclampedVector_atCenter() {
        let sut = NSphere(center: .init(x: 1, y: 2), radius: 1)
        let point = Vector2D(x: 1, y: 2)
        
        let result = sut.project(point)
        
        XCTAssertEqual(
            result,
            .init(x: 0.7071067811865475, y: 0.7071067811865475)
        )
    }
    
    func testProjectUnclampedVector_fromTop() {
        let sut = NSphere(center: .init(x: 0, y: 0), radius: 1)
        let point = Vector2D(x: 0, y: -2)
        
        let result = sut.project(point)
        
        XCTAssertEqual(
            result,
            .init(x: 0, y: -1)
        )
    }
    
    func testProjectUnclampedVector_fromRight() {
        let sut = NSphere(center: .init(x: 0, y: 0), radius: 1)
        let point = Vector2D(x: 2, y: 0)
        
        let result = sut.project(point)
        
        XCTAssertEqual(
            result,
            .init(x: 1, y: 0)
        )
    }
    
    func testProjectUnclampedVector_withinSphere() {
        let sut = NSphere(center: .init(x: 3, y: 5), radius: 2)
        let point = Vector2D(x: 2, y: 4)
        
        let result = sut.project(point)
        
        XCTAssertEqual(
            result,
            .init(x: -1.414213562373095, y: -1.414213562373095)
        )
    }
    
    func testProjectUnclampedVector_outsideSphere() {
        let sut = NSphere(center: .init(x: 3, y: 5), radius: 2)
        let point = Vector2D(x: 0, y: 0)
        
        let result = sut.project(point)
        
        XCTAssertEqual(
            result,
            .init(x: -1.028991510855053, y: -1.7149858514250882)
        )
    }
}

// 2D intersection tests
extension NSphereTests {
    typealias PointNormal = Geometria.PointNormal<Vector2D>
    typealias Circle = Circle2<Vector2D>
    typealias Line2 = Geometria.Line2<Vector2D>
    typealias Ray2 = Geometria.Ray2<Vector2D>
    typealias DRay2 = Geometria.DirectionalRay2<Vector2D>
    typealias LineSegment2 = Geometria.LineSegment2<Vector2D>
    
    func testIntersectsLine_2d_originCircle() {
        let sut = Circle(center: .zero, radius: 1)
        
        // Horizontal line with Y = -2
        XCTAssertFalse(
            sut.intersects(line: Line2(x1: -1, y1: -2, x2: 1, y2: -2))
        )
        // Horizontal line with Y = -1
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: -1, y1: -1, x2: 1, y2: -1))
        )
        // Horizontal line with Y = 0
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: -1, y1: 0, x2: 1, y2: 0))
        )
        // Horizontal line with Y = 1
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: -1, y1: 1, x2: 1, y2: 1))
        )
        // Horizontal line with Y = 2
        XCTAssertFalse(
            sut.intersects(line: Line2(x1: -1, y1: 2, x2: 1, y2: 2))
        )
        // Vertical line with X = -2
        XCTAssertFalse(
            sut.intersects(line: Line2(x1: -2, y1: -1, x2: -2, y2: 1))
        )
        // Vertical line with X = -1
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: -1, y1: -1, x2: -1, y2: 1))
        )
        // Vertical line with X = 0
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: 0, y1: -1, x2: 0, y2: 1))
        )
        // Vertical line with X = 1
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: 1, y1: -1, x2: 1, y2: 1))
        )
        // Vertical line with X = 2
        XCTAssertFalse(
            sut.intersects(line: Line2(x1: 2, y1: -1, x2: 2, y2: 1))
        )
        // Tangential line
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: 0, y1: 1, x2: 1, y2: 0))
        )
        // Tangential line, off radii
        XCTAssertFalse(
            sut.intersects(line: Line2(x1: 0, y1: 2, x2: 2, y2: 0))
        )
    }
    
    func testIntersectsLine_2d_offsetCircle() {
        let sut = Circle(center: .init(x: 2, y: 3), radius: 1)
        
        // Horizontal line with Y = 1
        XCTAssertFalse(
            sut.intersects(line: Line2(x1: 0, y1: 1, x2: 4, y2: 1))
        )
        // Horizontal line with Y = 2
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: 0, y1: 2, x2: 4, y2: 2))
        )
        // Horizontal line with Y = 3
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: 0, y1: 3, x2: 4, y2: 3))
        )
        // Horizontal line with Y = 4
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: 0, y1: 4, x2: 4, y2: 4))
        )
        // Horizontal line with Y = 5
        XCTAssertFalse(
            sut.intersects(line: Line2(x1: 0, y1: 5, x2: 4, y2: 5))
        )
        // Vertical line with X = 0
        XCTAssertFalse(
            sut.intersects(line: Line2(x1: 0, y1: 0, x2: 0, y2: 4))
        )
        // Vertical line with X = 1
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: 1, y1: 0, x2: 1, y2: 4))
        )
        // Vertical line with X = 2
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: 2, y1: 0, x2: 2, y2: 4))
        )
        // Vertical line with X = 3
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: 3, y1: 0, x2: 3, y2: 4))
        )
        // Vertical line with X = 4
        XCTAssertFalse(
            sut.intersects(line: Line2(x1: 4, y1: 0, x2: 4, y2: 4))
        )
        // Tangential line
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: 2, y1: 4, x2: 3, y2: 2))
        )
        // Tangential line, off radii
        XCTAssertTrue(
            sut.intersects(line: Line2(x1: 2, y1: 5, x2: 4, y2: 1))
        )
    }
    
    // MARK: Line Intersection
    
    func testIntersectionWithLine_line_noIntersection() {
        let sut = Circle(center: .zero, radius: 1)
        let line = Line2(x1: -2, y1: 2, x2: 2, y2: 2)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWithLine_line_tangent() {
        let sut = Circle(center: .zero, radius: 1)
        let line = Line2(x1: -2, y1: 1, x2: 2, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
            .singlePoint(
                PointNormal(
                    point: .init(x: 0, y: 1),
                    normal: .init(x: 0, y: 1)
                )
            )
        )
    }
    
    func testIntersectionWithLine_line_tangent_startsAfterCircle() {
        let sut = Circle(center: .zero, radius: 1)
        let line = Line2(x1: 1.1, y1: 1, x2: 5, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
            .singlePoint(
                PointNormal(
                    point: .init(x: 1.2497125841293429e-16, y: 1),
                    normal: .init(x: 1.2497125841293429e-16, y: 1)
                )
            )
        )
    }
    
    func testIntersectionWithLine_line_tangent_endsBeforeCircle() {
        let sut = Circle(center: .zero, radius: 1)
        let line = Line2(x1: -4.5, y1: 1, x2: -1, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
            .singlePoint(
                PointNormal(
                    point: .init(x: 3.3306690738754696e-16, y: 1.0),
                    normal: .init(x: 3.3306690738754696e-16, y: 1.0)
                )
            )
        )
    }
    
    func testIntersectionWithLine_line_across() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = Line2(x1: -3, y1: 4.5, x2: 5, y2: 4.5)
        
        XCTAssertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                ),
                PointNormal(
                    point: .init(x: 2.322875655532295, y: 4.5),
                    normal: .init(x: -0.6614378277661476, y: -0.7500000000000001)
                )
            )
        )
    }
    
    func testIntersectionWithLine_line_across_startsWithinCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = Line2(x1: 1, y1: 4.5, x2: 3, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                ),
                PointNormal(
                    point: .init(x: 2.3228756555322954, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: -0.75)
                )
            )
        )
    }
    
    func testIntersectionWithLine_line_across_endsWithinCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = Line2(x1: -3, y1: 4.5, x2: 1, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                ),
                PointNormal(
                    point: .init(x: 2.322875655532295, y: 4.5),
                    normal: .init(x: -0.6614378277661476, y: -0.7500000000000001)
                )
            )
        )
    }
    
    func testIntersectionWithLine_line_across_startsAndEndsBeforeCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = Line2(x1: -4, y1: 4.5, x2: -3, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                ),
                PointNormal(
                    point: .init(x: 2.322875655532295, y: 4.5),
                    normal: .init(x: -0.6614378277661476, y: -0.7500000000000001)
                )
            )
        )
    }
    
    func testIntersectionWithLine_line_across_startsAndEndsAfterCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = Line2(x1: 4, y1: 4.5, x2: 5, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.3228756555322949, y: 4.5),
                    normal: .init(x: -0.6614378277661476, y: 0.7500000000000001)
                ),
                PointNormal(
                    point: .init(x: 2.3228756555322954, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: -0.75)
                )
            )
        )
    }
    
    func testIntersectionWithLine_line_across_startsAndEndsWithinCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = Line2(x1: 0.5, y1: 4.5, x2: 1.5, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                ),
                PointNormal(
                    point: .init(x: 2.3228756555322954, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: -0.75)
                )
            )
        )
    }
    
    func testIntersectionWithLine_line_across_centerLine() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 1)
        let line = Line2(x1: -2, y1: 3, x2: 2, y2: 3)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 0.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 2.0, y: 3.0),
                    normal: .init(x: -1.0, y: -0.0)
                )
            )
        )
    }
    
    // MARK: Ray Intersection
    
    func testIntersectionWithLine_ray_noIntersection() {
        let sut = Circle(center: .zero, radius: 1)
        let line = Ray2(x1: -2, y1: 2, x2: 2, y2: 2)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWithLine_ray_tangent() {
        let sut = Circle(center: .zero, radius: 1)
        let line = Ray2(x1: -2, y1: 1, x2: 2, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
            .singlePoint(
                PointNormal(
                    point: .init(x: 0.0, y: 1.0),
                    normal: .init(x: 0.0, y: 1.0)
                )
            )
        )
    }
    
    func testIntersectionWithLine_ray_tangent_startsAfterCircle() {
        let sut = Circle(center: .zero, radius: 1)
        let line = Ray2(x1: 1.1, y1: 1, x2: 2, y2: 1)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWithLine_ray_tangent_endsBeforeCircle() {
        let sut = Circle(center: .zero, radius: 1)
        let line = Ray2(x1: -1.5, y1: 1, x2: -1, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
            .singlePoint(
                PointNormal(
                    point: .init(x: 0.0, y: 1.0),
                    normal: .init(x: 0.0, y: 1.0)
                )
            )
        )
    }
    
    func testIntersectionWithLine_ray_across() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = Ray2(x1: -3, y1: 4.5, x2: 3, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                ),
                PointNormal(
                    point: .init(x: 2.322875655532295, y: 4.5),
                    normal: .init(x: -0.6614378277661476, y: -0.7500000000000001)
                )
            )
        )
    }
    
    func testIntersectionWithLine_ray_across_startsWithinCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = Ray2(x1: 1, y1: 4.5, x2: 3, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 2.3228756555322954, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: -0.75)
                )
            )
        )
    }
    
    func testIntersectionWithLine_ray_across_endsWithinCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = Ray2(x1: -3, y1: 4.5, x2: 1, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                ),
                PointNormal(
                    point: .init(x: 2.322875655532295, y: 4.5),
                    normal: .init(x: -0.6614378277661476, y: -0.7500000000000001)
                )
            )
        )
    }
    
    func testIntersectionWithLine_ray_across_startsAndEndsBeforeCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = Ray2(x1: -4, y1: 4.5, x2: -3, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                ),
                PointNormal(
                    point: .init(x: 2.322875655532295, y: 4.5),
                    normal: .init(x: -0.6614378277661476, y: -0.7500000000000001)
                )
            )
        )
    }
    
    func testIntersectionWithLine_ray_across_startsAndEndsAfterCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = Ray2(x1: 4, y1: 4.5, x2: 5, y2: 4.5)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWithLine_ray_across_startsAndEndsWithinCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = Ray2(x1: 0.5, y1: 4.5, x2: 1.5, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 2.3228756555322954, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: -0.75)
                )
            )
        )
    }
    
    func testIntersectionWithLine_ray_across_centerLine() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 1)
        let line = Ray2(x1: -2, y1: 3, x2: 2, y2: 3)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 0.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 2.0, y: 3.0),
                    normal: .init(x: -1.0, y: -0.0)
                )
            )
        )
    }
    
    // MARK: Directional Ray Intersection
    
    func testIntersectionWithLine_dray_noIntersection() {
        let sut = Circle(center: .zero, radius: 1)
        let line = DRay2(x1: -2, y1: 2, x2: 2, y2: 2)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWithLine_dray_tangent() {
        let sut = Circle(center: .zero, radius: 1)
        let line = DRay2(x1: -2, y1: 1, x2: 2, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
            .singlePoint(
                PointNormal(
                    point: .init(x: 0.0, y: 1.0),
                    normal: .init(x: 0.0, y: 1.0)
                )
            )
        )
    }
    
    func testIntersectionWithLine_dray_tangent_startsAfterCircle() {
        let sut = Circle(center: .zero, radius: 1)
        let line = DRay2(x1: 1.1, y1: 1, x2: 2, y2: 1)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWithLine_dray_tangent_endsBeforeCircle() {
        let sut = Circle(center: .zero, radius: 1)
        let line = DRay2(x1: -1.5, y1: 1, x2: -1, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
            .singlePoint(
                PointNormal(
                    point: .init(x: 0.0, y: 1.0),
                    normal: .init(x: 0.0, y: 1.0)
                )
            )
        )
    }
    
    func testIntersectionWithLine_dray_across() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = DRay2(x1: -3, y1: 4.5, x2: 3, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                ),
                PointNormal(
                    point: .init(x: 2.322875655532295, y: 4.5),
                    normal: .init(x: -0.6614378277661476, y: -0.7500000000000001)
                )
            )
        )
    }
    
    func testIntersectionWithLine_dray_across_startsWithinCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = DRay2(x1: 1, y1: 4.5, x2: 3, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 2.3228756555322954, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: -0.75)
                )
            )
        )
    }
    
    func testIntersectionWithLine_dray_across_endsWithinCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = DRay2(x1: -3, y1: 4.5, x2: 1, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                ),
                PointNormal(
                    point: .init(x: 2.322875655532295, y: 4.5),
                    normal: .init(x: -0.6614378277661476, y: -0.7500000000000001)
                )
            )
        )
    }
    
    func testIntersectionWithLine_dray_across_startsAndEndsBeforeCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = DRay2(x1: -4, y1: 4.5, x2: -3, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                ),
                PointNormal(
                    point: .init(x: 2.322875655532295, y: 4.5),
                    normal: .init(x: -0.6614378277661476, y: -0.7500000000000001)
                )
            )
        )
    }
    
    func testIntersectionWithLine_dray_across_startsAndEndsAfterCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = DRay2(x1: 4, y1: 4.5, x2: 5, y2: 4.5)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWithLine_dray_across_startsAndEndsWithinCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = DRay2(x1: 0.5, y1: 4.5, x2: 1.5, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 2.3228756555322954, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: -0.75)
                )
            )
        )
    }
    
    func testIntersectionWithLine_dray_across_centerLine() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 1)
        let line = DRay2(x1: -2, y1: 3, x2: 2, y2: 3)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 0.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 2.0, y: 3.0),
                    normal: .init(x: -1.0, y: -0.0)
                )
            )
        )
    }
    
    // MARK: Line Segment Intersection
    
    func testIntersectionWithLine_lineSegment_noIntersection() {
        let sut = Circle(center: .zero, radius: 1)
        let line = LineSegment2(x1: -2, y1: 2, x2: 2, y2: 2)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWithLine_lineSegment_tangent() {
        let sut = Circle(center: .zero, radius: 1)
        let line = LineSegment2(x1: -2, y1: 1, x2: 2, y2: 1)
        
        assertEqual(
            sut.intersection(with: line),
            .singlePoint(
                PointNormal(
                    point: .init(x: 0.0, y: 1.0),
                    normal: .init(x: 0.0, y: 1.0)
                )
            )
        )
    }
    
    func testIntersectionWithLine_lineSegment_tangent_startsAfterCircle() {
        let sut = Circle(center: .zero, radius: 1)
        let line = LineSegment2(x1: 1, y1: 1, x2: 1.5, y2: 1)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWithLine_lineSegment_tangent_endsBeforeCircle() {
        let sut = Circle(center: .zero, radius: 1)
        let line = LineSegment2(x1: -1.5, y1: 1, x2: -1, y2: 1)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWithLine_lineSegment_across() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = LineSegment2(x1: -3, y1: 4.5, x2: 3, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                ),
                PointNormal(
                    point: .init(x: 2.322875655532295, y: 4.5),
                    normal: .init(x: -0.6614378277661476, y: -0.7500000000000001)
                )
            )
        )
    }
    
    func testIntersectionWithLine_lineSegment_across_startsWithinCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = LineSegment2(x1: 1, y1: 4.5, x2: 3, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 2.3228756555322954, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: -0.75)
                )
            )
        )
    }
    
    func testIntersectionWithLine_lineSegment_across_endsWithinCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = LineSegment2(x1: -3, y1: 4.5, x2: 1, y2: 4.5)
        
        assertEqual(
            sut.intersection(with: line),
            .enter(
                PointNormal(
                    point: .init(x: -0.32287565553229536, y: 4.5),
                    normal: .init(x: -0.6614378277661477, y: 0.75)
                )
            )
        )
    }
    
    func testIntersectionWithLine_lineSegment_across_startsAndEndsBeforeCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = LineSegment2(x1: -4, y1: 4.5, x2: -3, y2: 4.5)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWithLine_lineSegment_across_startsAndEndsAfterCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = LineSegment2(x1: 4, y1: 4.5, x2: 5, y2: 4.5)
        
        assertEqual(sut.intersection(with: line), .noIntersection)
    }
    
    func testIntersectionWithLine_lineSegment_across_startsAndEndsWithinCircle() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 2)
        let line = LineSegment2(x1: 0.5, y1: 4.5, x2: 1.5, y2: 4.5)
        
        assertEqual(sut.intersection(with: line), .contained)
    }
    
    func testIntersectionWithLine_lineSegment_across_centerLine() {
        let sut = Circle(center: .init(x: 1, y: 3), radius: 1)
        let line = LineSegment2(x1: -2, y1: 3, x2: 2, y2: 3)
        
        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 0.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 2.0, y: 3.0),
                    normal: .init(x: -1.0, y: -0.0)
                )
            )
        )
    }
}

// 3D intersection tests
extension NSphereTests {
    typealias Sphere = Geometria.NSphere<Vector3D>
    typealias Line3 = Geometria.Line3<Vector3D>
    
    func testIntersectsLine_3d_originSphere() {
        let sut = Sphere(center: .zero,
                         radius: 1)
        
        // X plane line with Y = -2, Z = 0
        XCTAssertFalse(
            sut.intersects(line: Line3(x1: -1, y1: -2, z1: 0, x2: 1, y2: -2, z2: 0))
        )
        // X plane line with Y = -1, Z = 0
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: -1, y1: -1, z1: 0, x2: 1, y2: -1, z2: 0))
        )
        // X plane line with Y = 0, Z = 0
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: -1, y1: 0, z1: 0, x2: 1, y2: 0, z2: 0))
        )
        // X plane line with Y = 1, Z = 0
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: -1, y1: 1, z1: 0, x2: 1, y2: 1, z2: 0))
        )
        // X plane line with Y = 2, Z = 0
        XCTAssertFalse(
            sut.intersects(line: Line3(x1: -1, y1: 2, z1: 0, x2: 1, y2: 2, z2: 0))
        )
        // X plane line with Y = 0, Z = -1
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: -1, y1: 0, z1: -1, x2: 1, y2: 0, z2: -1))
        )
        // X plane line with Y = 0, Z = 1
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: -1, y1: 0, z1: 1, x2: 1, y2: 0, z2: 1))
        )
        
        // Y plane line with X = -2, Z = 0
        XCTAssertFalse(
            sut.intersects(line: Line3(x1: -2, y1: -1, z1: 0, x2: -2, y2: 1, z2: 0))
        )
        // Y plane line with X = -1, Z = 0
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: -1, y1: -1, z1: 0, x2: -1, y2: 1, z2: 0))
        )
        // Y plane line with X = 0, Z = 0
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: 0, y1: -1, z1: 0, x2: 0, y2: 1, z2: 0))
        )
        // Y plane line with X = 1, Z = 0
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: 1, y1: -1, z1: 0, x2: 1, y2: 1, z2: 0))
        )
        // Y plane line with X = 2, Z = 0
        XCTAssertFalse(
            sut.intersects(line: Line3(x1: 2, y1: -1, z1: 0, x2: 2, y2: 1, z2: 0))
        )
        
        // Tangential line
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: 1, y1: 1, z1: 1, x2: -1, y2: -1, z2: -1))
        )
        // Tangential line, off-radii
        XCTAssertFalse(
            sut.intersects(line: Line3(x1: 0, y1: 2, z1: 2, x2: 2, y2: 0, z2: -2))
        )
    }
    
    func testIntersectsLine_3d_offsetSphere() {
        let sut = Sphere(center: .init(x: 2, y: 3, z: 5),
                         radius: 1)
        
        // X plane line with Y = 2, Z = 5
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: -1, y1: 2, z1: 5, x2: 1, y2: 2, z2: 5))
        )
        // X plane line with Y = 3, Z = 5
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: -1, y1: 3, z1: 5, x2: 1, y2: 3, z2: 5))
        )
        // X plane line with Y = 4, Z = 5
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: -1, y1: 4, z1: 5, x2: 1, y2: 4, z2: 5))
        )
        // X plane line with Y = 3, Z = 4
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: -1, y1: 3, z1: 4, x2: 1, y2: 3, z2: 4))
        )
        // X plane line with Y = 3, Z = 6
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: -1, y1: 3, z1: 6, x2: 1, y2: 3, z2: 6))
        )
        
        // Y plane line with X = 1, Z = 5
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: 1, y1: -1, z1: 5, x2: 1, y2: 1, z2: 5))
        )
        // Y plane line with X = 2, Z = 5
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: 2, y1: -1, z1: 5, x2: 2, y2: 1, z2: 5))
        )
        // Y plane line with X = 3, Z = 5
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: 3, y1: -1, z1: 5, x2: 3, y2: 1, z2: 5))
        )
        
        // Tangential line
        XCTAssertTrue(
            sut.intersects(line: Line3(x1: 3, y1: 4, z1: 6, x2: 1, y2: 2, z2: 4))
        )
    }
}
