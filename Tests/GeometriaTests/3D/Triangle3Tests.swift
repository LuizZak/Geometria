import XCTest
import Geometria

class Triangle3Tests: XCTestCase {
    typealias Vector = Vector3D
    typealias Triangle = Triangle3<Vector>
}

// MARK: PlaneType Conformance

extension Triangle3Tests {
    func testNormal_onPlaneXY() {
        let sut = Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 0, y: 1, z: 0),
            c: .init(x: 1, y: 0, z: 0)
        )
        
        let result = sut.normal
        
        XCTAssertEqual(result, -.unitZ)
    }
    
    func testNormal_onPlaneXY_counterClockwise() {
        let sut = Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 1, y: 0, z: 0),
            c: .init(x: 0, y: 1, z: 0)
        )
        
        let result = sut.normal
        
        XCTAssertEqual(result, .unitZ)
    }
    
    func testNormal_slanted() {
        let sut = Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 0, y: 1, z: 1),
            c: .init(x: 1, y: 0, z: 0)
        )
        
        let result = sut.normal
        
        XCTAssertEqual(result, .init(x: 0.0, y: 0.7071067811865475, z: -0.7071067811865475))
    }
    
    func testNormal_colinear() {
        let sut = Triangle(
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
        let sut = Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 0, y: 1, z: 0),
            c: .init(x: 1, y: 0, z: 0)
        )
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, sut.a)
        XCTAssertEqual(result.normal, -.unitZ)
    }
    
    func testAsPlane_onPlaneXY_counterClockwise() {
        let sut = Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 1, y: 0, z: 0),
            c: .init(x: 0, y: 1, z: 0)
        )
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, sut.a)
        XCTAssertEqual(result.normal, .unitZ)
    }
    
    func testAsPlane_slanted() {
        let sut = Triangle(
            a: .init(x: 0, y: 0, z: 0),
            b: .init(x: 0, y: 1, z: 1),
            c: .init(x: 1, y: 0, z: 0)
        )
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, sut.a)
        XCTAssertEqual(result.normal, .init(x: 0.0, y: 0.7071067811865476, z: -0.7071067811865476))
    }
    
    func testAsPlane_colinear() {
        let sut = Triangle(
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
}

// MARK: - LineIntersectablePlaneType Conformance

extension Triangle3Tests {
    func testUnclampedNormalMagnitudeForIntersection_line_withinTriangleBounds() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 50, y1: 0, z1: 25, x2: 50, y2: 1, z2: 25)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, 50.0)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_outsideTriangleBounds1() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 25, y1: 0, z1: 50, x2: 25, y2: 1, z2: 50)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_outsideTriangleBounds2() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 25, y1: 0, z1: -10, x2: 25, y2: 1, z2: -10)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_outsideTriangleBounds3() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 150, y1: 0, z1: 10, x2: 150, y2: 1, z2: 10)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_parallel() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 25, y1: 0, z1: 0, x2: 25, y2: 0, z2: 50)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_line_withinTriangleBounds() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 50, y1: 0, z1: 25, x2: 50, y2: 1, z2: 25)
        
        let result = sut.intersection(with: line)
        
        XCTAssertEqual(result, .init(x: 50.0, y: 50.0, z: 25.0))
    }
    
    func testIntersectionWith_line_outsideTriangleBounds() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 25, y1: 0, z1: 50, x2: 25, y2: 1, z2: 50)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_line_outsideTriangleBounds_pastAPoint() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let line = Line3D(x1: -1, y1: -1, z1: 1, x2: -1, y2: -1, z2: -1)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_line_outsideTriangleBounds_pastBPoint() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let line = Line3D(x1: 120, y1: -10, z1: 1, x2: 120, y2: -10, z2: -1)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_line_outsideTriangleBounds_pastCPoint() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let line = Line3D(x1: -10, y1: 120, z1: 1, x2: -10, y2: 120, z2: -1)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_line_outsideTriangleBounds_pastAEdge() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let line = Line3D(x1: 60, y1: 60, z1: 1, x2: 60, y2: 60, z2: -1)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_line_outsideTriangleBounds_pastBEdge() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let line = Line3D(x1: -10, y1: 50, z1: 1, x2: -10, y2: 50, z2: -1)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_line_outsideTriangleBounds_pastCEdge() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let line = Line3D(x1: 50, y1: -10, z1: 1, x2: 50, y2: -10, z2: -1)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_line_parallel() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 25, y1: 0, z1: 0, x2: 25, y2: 0, z2: 50)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_ray_afterEndOfLine() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Ray3D(x1: 50, y1: 0, z1: 25, x2: 50, y2: 1, z2: 25)
        
        let result = sut.intersection(with: line)
        
        XCTAssertEqual(result, .init(x: 50.0, y: 50.0, z: 25.0))
    }
    
    func testIntersectionWith_ray_beforeStartOfLine() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Ray3D(x1: 50, y1: 150, z1: 25, x2: 50, y2: 151, z2: 25)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testIntersectionWith_lineSegment_afterEndOfLine() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = LineSegment3D(x1: 50, y1: 0, z1: 25, x2: 50, y2: 1, z2: 25)
        
        let result = sut.intersection(with: line)
        
        XCTAssertNil(result)
    }
    
    func testMollerTrumboreIntersectWith_line_withinTriangleBounds() throws {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 50, y1: 0, z1: 25, x2: 50, y2: 5, z2: 25)
        
        let result = try XCTUnwrap(sut.mollerTrumboreIntersect(with: line))
        
        XCTAssertEqual(result.lineMagnitude, 10.0)
        XCTAssertEqual(result.1.wa, 0.50)
        XCTAssertEqual(result.1.wb, 0.25)
        XCTAssertEqual(result.1.wc, 0.25)
        XCTAssertEqual(sut.projectToWorld(result.1), .init(x: 50.0, y: 50.0, z: 25.0))
    }
    
    func testMollerTrumboreIntersectWith_line_outsideTriangleBounds() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 25, y1: 0, z1: 50, x2: 25, y2: 1, z2: 50)
        
        let result = sut.mollerTrumboreIntersect(with: line)
        
        XCTAssertNil(result)
    }
    
    func testMollerTrumboreIntersectWith_line_outsideTriangleBounds_pastAPoint() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let line = Line3D(x1: -1, y1: -1, z1: 1, x2: -1, y2: -1, z2: -1)
        
        let result = sut.mollerTrumboreIntersect(with: line)
        
        XCTAssertNil(result)
    }
    
    func testMollerTrumboreIntersectWith_line_outsideTriangleBounds_pastBPoint() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let line = Line3D(x1: 120, y1: -10, z1: 1, x2: 120, y2: -10, z2: -1)
        
        let result = sut.mollerTrumboreIntersect(with: line)
        
        XCTAssertNil(result)
    }
    
    func testMollerTrumboreIntersectWith_line_outsideTriangleBounds_pastCPoint() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let line = Line3D(x1: -10, y1: 120, z1: 1, x2: -10, y2: 120, z2: -1)
        
        let result = sut.mollerTrumboreIntersect(with: line)
        
        XCTAssertNil(result)
    }
    
    func testMollerTrumboreIntersectWith_line_outsideTriangleBounds_pastAEdge() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let line = Line3D(x1: 60, y1: 60, z1: 1, x2: 60, y2: 60, z2: -1)
        
        let result = sut.mollerTrumboreIntersect(with: line)
        
        XCTAssertNil(result)
    }
    
    func testMollerTrumboreIntersectWith_line_outsideTriangleBounds_pastBEdge() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let line = Line3D(x1: -10, y1: 50, z1: 1, x2: -10, y2: 50, z2: -1)
        
        let result = sut.mollerTrumboreIntersect(with: line)
        
        XCTAssertNil(result)
    }
    
    func testMollerTrumboreIntersectWith_line_outsideTriangleBounds_pastCEdge() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let line = Line3D(x1: 50, y1: -10, z1: 1, x2: 50, y2: -10, z2: -1)
        
        let result = sut.mollerTrumboreIntersect(with: line)
        
        XCTAssertNil(result)
    }
    
    func testMollerTrumboreIntersectWith_line_parallel() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Line3D(x1: 25, y1: 0, z1: 0, x2: 25, y2: 0, z2: 50)
        
        let result = sut.mollerTrumboreIntersect(with: line)
        
        XCTAssertNil(result)
    }
    
    func testMollerTrumboreIntersectWith_ray_afterEndOfLine() throws {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Ray3D(x1: 50, y1: 0, z1: 25, x2: 50, y2: 1, z2: 25)
        
        let result = try XCTUnwrap(sut.mollerTrumboreIntersect(with: line))
        
        XCTAssertEqual(result.lineMagnitude, 50.0)
        XCTAssertEqual(result.1.wa, 0.50)
        XCTAssertEqual(result.1.wb, 0.25)
        XCTAssertEqual(result.1.wc, 0.25)
        XCTAssertEqual(sut.projectToWorld(result.1), .init(x: 50.0, y: 50.0, z: 25.0))
    }
    
    func testMollerTrumboreIntersectWith_ray_beforeStartOfLine() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = Ray3D(x1: 50, y1: 150, z1: 25, x2: 50, y2: 151, z2: 25)
        
        let result = sut.mollerTrumboreIntersect(with: line)
        
        XCTAssertNil(result)
    }
    
    func testMollerTrumboreIntersectWith_lineSegment_afterEndOfLine() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let line = LineSegment3D(x1: 50, y1: 0, z1: 25, x2: 50, y2: 1, z2: 25)
        
        let result = sut.mollerTrumboreIntersect(with: line)
        
        XCTAssertNil(result)
    }
    
    func testToBarycentricXYZ() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        
        let result = sut.toBarycentric(x: 20, y: 20, z: 20)
        
        XCTAssertEqual(result.wa, 0.8)
        XCTAssertEqual(result.wb, 0.0)
        XCTAssertEqual(result.wc, 0.19999999999999996)
    }
    
    func testToBarycentric_aPoint() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let point = sut.a
        
        let result = sut.toBarycentric(point)
        
        XCTAssertEqual(result.wa, 1.0)
        XCTAssertEqual(result.wb, 0.0)
        XCTAssertEqual(result.wc, 0.0)
    }
    
    func testToBarycentric_bPoint() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let point = sut.b
        
        let result = sut.toBarycentric(point)
        
        XCTAssertEqual(result.wa, 0.0)
        XCTAssertEqual(result.wb, 1.0)
        XCTAssertEqual(result.wc, 0.0)
    }
    
    func testToBarycentric_cPoint() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let point = sut.c
        
        let result = sut.toBarycentric(point)
        
        XCTAssertEqual(result.wa, 0.0)
        XCTAssertEqual(result.wb, 0.0)
        XCTAssertEqual(result.wc, 1.0)
    }
    
    func testToBarycentric_center() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let point = sut.center
        
        let result = sut.toBarycentric(point)
        
        XCTAssertEqual(result.wa, 0.3333333333333333)
        XCTAssertEqual(result.wb, 0.3333333333333333)
        XCTAssertEqual(result.wc, 0.3333333333333334)
    }
    
    func testToBarycentric_extrapolated() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z:   0),
            c: .init(x: 100, y: 100, z: 100)
        )
        let point = Vector(x: 200, y: 200, z: 200)
        
        let result = sut.toBarycentric(point)
        
        XCTAssertEqual(result.wa, -1.0)
        XCTAssertEqual(result.wb, 0.0)
        XCTAssertEqual(result.wc, 2.0)
    }
    
    func testToBarycentric_extrapolated_reversedTriangle() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 100, y: 100, z: 100),
            c: .init(x: 100, y: 100, z:   0)
        )
        let point = Vector(x: 200, y: 200, z: 200)
        
        let result = sut.toBarycentric(point)
        
        XCTAssertEqual(result.wa, -1.0)
        XCTAssertEqual(result.wb, 2.0)
        XCTAssertEqual(result.wc, 0.0)
    }
}

// MARK: SignedDistanceMeasurableType Conformance

extension Triangle3Tests {
    func testSignedDistanceTo_pointOnTriangle() {
        let sut = Triangle(
            a: .init(x:   0, y:   0, z: 0),
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let point = sut.center
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 0.0)
    }
    
    func testSignedDistanceTo_pointAlongCenter() {
        let sut = Triangle(
            a: .init(x:   0, y:   0, z: 0),
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let point = Vector(x: sut.center.x, y: sut.center.y, z: 10)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 10)
    }
    
    func testSignedDistanceTo_pointOffCenter() {
        let sut = Triangle(
            a: .init(x:   0, y:   0, z: 0),
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let point = Vector(x: 10, y: 10, z: 10)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 10)
    }
    
    func testSignedDistanceTo_pointOffBounds_pastEdgeA() {
        let sut = Triangle(
            a: .init(x:   0, y:   0, z: 0),
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let point = Vector(x: 100, y: 100, z: 10)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 71.4142842854285)
    }
    
    func testSignedDistanceTo_pointOffBounds_pastEdgeB() {
        let sut = Triangle(
            a: .init(x:   0, y:   0, z: 0),
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let point = Vector(x: -10, y: 50, z: 10)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 14.142135623730951)
    }
    
    func testSignedDistanceTo_pointOffBounds_pastEdgeC() {
        let sut = Triangle(
            a: .init(x:   0, y:   0, z: 0),
            b: .init(x: 100, y:   0, z: 0),
            c: .init(x:   0, y: 100, z: 0)
        )
        let point = Vector(x: 50, y: -10, z: 10)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 14.142135623730951)
    }
}
