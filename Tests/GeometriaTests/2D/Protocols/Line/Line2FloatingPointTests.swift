import XCTest
import Geometria
import TestCommons

class Line2FloatingPointTests: XCTestCase {
    typealias Line = Line2D
    typealias LineSegment = LineSegment2D
    typealias Ray = Ray2D
    typealias DirectionalRay = DirectionalRay2D
    
    func testIntersection_line_line_parallel() {
        let line1 = Line(x1: 1, y1: 0, x2: 2, y2: 0)
        let line2 = Line(x1: 1, y1: 2, x2: 2, y2: 2)
        
        XCTAssertNil(line1.intersection(with: line2))
    }
    
    func testIntersection_line_line_shallowAngle() {
        let line1 = Line(x1: 1, y1: 0, x2: 2, y2: 0)
        let line2 = Line(x1: 1, y1: 10, x2: 200, y2: 9.9)
        
        let result = line1.intersection(with: line2)
        
        XCTAssertEqual(
            result,
            LineIntersectionResult<Vector2D>(
                point: Vector2D(x: 19901.00000000007, y: 0.0),
                line1NormalizedMagnitude: 19900.00000000007,
                line2NormalizedMagnitude: 100.00000000000036
            )
        )
    }
    
    func testIntersection_line_line_crossing() {
        let line1 = Line(x1: 0, y1: 0, x2: 10, y2: 10)
        let line2 = Line(x1: 10, y1: 0, x2: 0, y2: 10)
        
        let result = line1.intersection(with: line2)
        
        XCTAssertEqual(
            result,
            LineIntersectionResult<Vector2D>(
                point: Vector2D(x: 5, y: 5),
                line1NormalizedMagnitude: 0.5,
                line2NormalizedMagnitude: 0.5
            )
        )
    }
    
    func testIntersection_line_line_extendingPastEnd() {
        let line1 = Line(x1: 0, y1: 0, x2: 3, y2: 3)
        let line2 = Line(x1: 10, y1: 0, x2: 0, y2: 10)
        
        let result = line1.intersection(with: line2)
        
        XCTAssertEqual(
            result,
            LineIntersectionResult<Vector2D>(
                point: Vector2D(x: 5, y: 5),
                line1NormalizedMagnitude: 1.6666666666666667,
                line2NormalizedMagnitude: 0.5
            )
        )
    }
    
    func testIntersection_lineSegment_lineSegment_extendingPastEnd_returnsNil() {
        let line1 = LineSegment(x1: 0, y1: 0, x2: 3, y2: 3)
        let line2 = LineSegment(x1: 10, y1: 0, x2: 0, y2: 10)
        
        XCTAssertNil(line1.intersection(with: line2))
    }
    
    func testIntersection_lineSegment_lineSegment_extendingPastEnd_other_returnsNil() {
        let line1 = LineSegment(x1: 0, y1: 0, x2: 10, y2: 10)
        let line2 = LineSegment(x1: 0, y1: 10, x2: 3, y2: 7)
        
        XCTAssertNil(line1.intersection(with: line2))
    }
    
    func testIntersection_ray_lineSegment_extendingPastStartRayStart_returnsNil() {
        let line1 = Ray(x1: 10, y1: 10, x2: 11, y2: 11)
        let line2 = LineSegment(x1: 10, y1: 0, x2: 0, y2: 10)
        
        XCTAssertNil(line1.intersection(with: line2))
    }
    
    func testIntersection_ray_lineSegment_extendingPastEndRayEnd() {
        let line1 = Ray(x1: 0, y1: 0, x2: 3, y2: 3)
        let line2 = LineSegment(x1: 10, y1: 0, x2: 0, y2: 10)
        
        let result = line1.intersection(with: line2)
        
        XCTAssertEqual(
            result,
            LineIntersectionResult<Vector2D>(
                point: Vector2D(x: 5, y: 5),
                line1NormalizedMagnitude: 1.6666666666666667,
                line2NormalizedMagnitude: 0.5
            )
        )
    }
    
    func testIntersection_directionalRay_lineSegment_extendingPastStartRayStart_returnsNil() {
        let line1 = DirectionalRay(x1: 10, y1: 10, x2: 11, y2: 11)
        let line2 = LineSegment(x1: 10, y1: 0, x2: 0, y2: 10)
        
        XCTAssertNil(line1.intersection(with: line2))
    }
    
    func testIntersection_directionalRa_lineSegment_extendingPastEndRayEnd() {
        let line1 = DirectionalRay(x1: 0, y1: 0, x2: 1, y2: 1)
        let line2 = LineSegment(x1: 10, y1: 0, x2: 0, y2: 10)
        
        let result = line1.intersection(with: line2)
        
        XCTAssertEqual(
            result,
            LineIntersectionResult<Vector2D>(
                point: Vector2D(x: 5, y: 5),
                line1NormalizedMagnitude: 7.0710678118654755,
                line2NormalizedMagnitude: 0.5
            )
        )
    }
}
