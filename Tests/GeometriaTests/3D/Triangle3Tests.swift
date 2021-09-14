import XCTest
import Geometria

class Triangle3Tests: XCTestCase {
    typealias Triangle = Triangle3D
}

// MARK: Vector: Vector3FloatingPoint Conformance

extension Triangle3Tests {
    func testNormal_onPlaneXY() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 0, y: 1, z: 0),
            c: .init(x: 1, y: 0, z: 0)
        )
        
        let result = sut.normal
        
        XCTAssertEqual(result, -.unitZ)
    }
    
    func testNormal_onPlaneXY_counterClockwise() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 1, y: 0, z: 0),
            c: .init(x: 0, y: 1, z: 0)
        )
        
        let result = sut.normal
        
        XCTAssertEqual(result, .unitZ)
    }
    
    func testNormal_slanted() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 0, y: 1, z: 1),
            c: .init(x: 1, y: 0, z: 0)
        )
        
        let result = sut.normal
        
        XCTAssertEqual(result, .init(x: 0.0, y: 0.7071067811865475, z: -0.7071067811865475))
    }
    
    func testNormal_colinear() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 1, y: 1, z: 1),
            c: .init(x: 2, y: 2, z: 2)
        )
        
        let result = sut.normal
        
        XCTAssertEqual(result, .zero)
    }
    
    func testNormal_zero() {
        let sut = Triangle(a: .zero, b: .zero, c: .zero)
        
        let result = sut.normal
        
        XCTAssertEqual(result, .zero)
    }
    
    func testAsPlane_onPlaneXY() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 0, y: 1, z: 0),
            c: .init(x: 1, y: 0, z: 0)
        )
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, sut.a)
        XCTAssertEqual(result.normal, -.unitZ)
    }
    
    func testAsPlane_onPlaneXY_counterClockwise() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 1, y: 0, z: 0),
            c: .init(x: 0, y: 1, z: 0)
        )
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, sut.a)
        XCTAssertEqual(result.normal, .unitZ)
    }
    
    func testAsPlane_slanted() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 0, y: 1, z: 1),
            c: .init(x: 1, y: 0, z: 0)
        )
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, sut.a)
        XCTAssertEqual(result.normal, .init(x: 0.0, y: 0.7071067811865476, z: -0.7071067811865476))
    }
    
    func testAsPlane_colinear() {
        let sut =
        Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 1, y: 1, z: 1),
            c: .init(x: 2, y: 2, z: 2)
        )
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, sut.a)
        XCTAssertEqual(result.normal, .zero)
    }
    
    func testAsPlane_zero() {
        let sut = Triangle(a: .zero, b: .zero, c: .zero)
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, .zero)
        XCTAssertEqual(result.normal, .zero)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_withinTriangleBounds() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z: 0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 50, y1: 0, z1: 25, x2: 50, y2: 1, z2: 25)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, 50.0)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_outsideTriangleBounds1() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z: 0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 25, y1: 0, z1: 50, x2: 25, y2: 1, z2: 50)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_outsideTriangleBounds2() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z: 0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 25, y1: 0, z1: -10, x2: 25, y2: 1, z2: -10)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_outsideTriangleBounds3() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z: 0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 150, y1: 0, z1: 10, x2: 150, y2: 1, z2: 10)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_parallel() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z: 0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 25, y1: 0, z1: 0, x2: 25, y2: 0, z2: 50)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_line_withinTriangleBounds() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z: 0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 50, y1: 0, z1: 25, x2: 50, y2: 1, z2: 25)
        
        let result = sut.intersection(with: line)
        
        XCTAssertEqual(result, .init(x: 50.0, y: 50.0, z: 25.0))
    }
    
    func testIntersectionWith_line_outsideTriangleBounds() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z: 0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 25, y1: 0, z1: 50, x2: 25, y2: 1, z2: 50)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_line_parallel() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z: 0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 25, y1: 0, z1: 0, x2: 25, y2: 0, z2: 50)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_ray_afterEndOfLine() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z: 0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Ray3D(x1: 50, y1: 0, z1: 25, x2: 50, y2: 1, z2: 25)
        
        let result = sut.intersection(with: line)
        
        XCTAssertEqual(result, .init(x: 50.0, y: 50.0, z: 25.0))
    }
    
    func testIntersectionWith_ray_beforeStartOfLine() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z: 0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Ray3D(x1: 50, y1: 150, z1: 25, x2: 50, y2: 151, z2: 25)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_lineSegment_afterEndOfLine() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z: 0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = LineSegment3D(x1: 50, y1: 0, z1: 25, x2: 50, y2: 1, z2: 25)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
}
