import XCTest
import Geometria
import TestCommons

class Cylinder3Tests: XCTestCase {
    let accuracy: Double = 1e-14
    typealias Cylinder = Cylinder3<Vector3D>
    
    func testAsLine() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 3),
            end: .init(x: 5, y: 7, z: 11),
            radius: 1
        )
        
        let result = sut.asLineSegment
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2, z: 3))
        XCTAssertEqual(result.end, .init(x: 5, y: 7, z: 11))
    }
    
    func testAsCapsule() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 3),
            end: .init(x: 5, y: 7, z: 11),
            radius: 1
        )
        
        let result = sut.asCapsule
        
        XCTAssertEqual(result.start, sut.start)
        XCTAssertEqual(result.end, sut.end)
        XCTAssertEqual(result.radius, sut.radius)
    }
    
    func testIsValid() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 3),
            end: .init(x: 1, y: 2, z: 5),
            radius: 1
        )
        
        XCTAssertTrue(sut.isValid)
    }
    
    func testIsValid_zeroLengthCylinder_returnsFalse() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 3),
            end: .init(x: 1, y: 2, z: 3),
            radius: 1
        )
        
        XCTAssertFalse(sut.isValid)
    }
    
    func testIsValid_zeroRadiusCylinder_returnsFalse() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 3),
            end: .init(x: 1, y: 2, z: 5),
            radius: 0
        )
        
        XCTAssertFalse(sut.isValid)
    }
    
    func testIsValid_negativeRadiusCylinder_returnsFalse() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 3),
            end: .init(x: 1, y: 2, z: 5),
            radius: -4
        )
        
        XCTAssertFalse(sut.isValid)
    }
}

// MARK: BoundableType Conformance

extension Cylinder3Tests {
    func testBounds_zeroHeightCylinder() {
        let sut = Cylinder(
            start: .unitY,
            end: .unitY,
            radius: 1
        )
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .zero)
        XCTAssertEqual(result.maximum, .zero)
    }
    
    func testBounds_unitLengthCylinder() {
        let sut = Cylinder(
            start: .zero,
            end: .unitZ,
            radius: 1
        )
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -1, y: -1, z: 0))
        XCTAssertEqual(result.maximum, .init(x: 1, y: 1, z: 1))
    }
    
    func testBounds_verticalCylinder() {
        let sut = Cylinder(
            start: .zero,
            end: .unitZ * 20,
            radius: 3
        )
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -3, y: -3, z: 0))
        XCTAssertEqual(result.maximum, .init(x: 3, y: 3, z: 20))
    }
    
    func testBounds_skewedCylinder() {
        let sut = Cylinder(
            start: .init(x: -2, y: 0, z: 0),
            end: .init(x: 3, y: 5, z: 40),
            radius: 4
        )
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -5.969581307590985, y: -3.9691115068546705, z: -0.4961389383568338))
        XCTAssertEqual(result.maximum, .init(x: 6.969581307590985, y: 8.96911150685467, z: 40.496138938356836))
    }
}

// MARK: VolumetricType Conformance

extension Cylinder3Tests {
    func testStartAsDisk() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 3),
            end: .init(x: 29, y: 31, z: 37),
            radius: 5
        )
        
        let result = sut.startAsDisk
        
        XCTAssertEqual(result.center, .init(x: 1, y: 2, z: 3))
        XCTAssertEqual(result.normal, .init(x: -0.530954782389336, y: -0.5499174531889551, z: -0.6447308071870509))
        XCTAssertEqual(result.radius, 5)
    }
    
    func testEndAsDisk() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 3),
            end: .init(x: 29, y: 31, z: 37),
            radius: 5
        )
        
        let result = sut.endAsDisk
        
        XCTAssertEqual(result.center, .init(x: 29, y: 31, z: 37))
        XCTAssertEqual(result.normal, .init(x: 0.530954782389336, y: 0.5499174531889551, z: 0.6447308071870509))
        XCTAssertEqual(result.radius, 5)
    }
    
    func testContains_withinLineProjection_returnsTrue() {
        let sut = Cylinder(
            start: .init(x: 13, y: 17, z: 5),
            end: .init(x: 13, y: 29, z: 5),
            radius: 3
        )
        
        XCTAssertTrue(sut.contains(x: 12, y: 20, z: 5))
        XCTAssertTrue(sut.contains(x: 14, y: 20, z: 5))
    }
    
    func testContains_outOfBounds_returnsFalse() {
        let sut = Cylinder(
            start: .init(x: 13, y: 17, z: 5),
            end: .init(x: 13, y: 29, z: 5),
            radius: 3
        )
        
        XCTAssertFalse(sut.contains(.init(x: 9, y: 20, z: 5)))
        XCTAssertFalse(sut.contains(.init(x: 17, y: 20, z: 5)))
        XCTAssertFalse(sut.contains(.init(x: 13, y: 13, z: 5)))
        XCTAssertFalse(sut.contains(.init(x: 13, y: 33, z: 5)))
    }
    
    func testContains_withinLineDistanceAtEnds_returnsFalse() {
        let sut = Cylinder(
            start: .init(x: 13, y: 17, z: 5),
            end: .init(x: 13, y: 29, z: 5),
            radius: 3
        )
        
        XCTAssertFalse(sut.contains(x: 12, y: 16, z: 5))
        XCTAssertFalse(sut.contains(x: 14, y: 30, z: 5))
    }
}

// MARK: PointProjectableType Conformance

extension Cylinder3Tests {
    func testProject_pointOnTopOfStart_center() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 1, y: 2, z: 20)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 1, y: 2, z: 10))
    }
    
    func testProject_pointOnTopOfStart_offCenter() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 0, y: -1, z: 20)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 0, y: -1, z: 10))
    }
    
    func testProject_pointOnTopOfStart_offRadius() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: -10, y: -10, z: 20)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: -2.3786231425867315, y: -1.6857707010037073, z: 10.0))
    }
    
    func testProject_pointBelowEnd_center() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 1, y: 2, z: -10)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 1, y: 2, z: 0))
    }
    
    func testProject_pointBelowEnd_offCenter() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 0, y: -1, z: -10)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 0, y: -1, z: 0))
    }
    
    func testProject_pointBelowEnd_offRadius() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: -10, y: -10, z: -10)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: -2.3786231425867315, y: -1.6857707010037073, z: 0.0))
    }
    
    func testProject_betweenEnds() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: -10, y: -10, z: 5)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: -2.3786231425867315, y: -1.6857707010037073, z: 5.0))
    }
    
    func testProject_withinCylinder_closerToEdge() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: -1, y: -2, z: 5)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: -1.2360679774997898, y: -2.4721359549995796, z: 5.0))
    }
    
    func testProjection_withinCylinder_closerToStartEdge() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 1, y: 1, z: 9)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 1, y: 1, z: 10.0))
    }
    
    func testProjection_withinCylinder_closerToEndEdge() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 1, y: 1, z: 1)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 1, y: 1, z: 0.0))
    }
    
    func testProject_withinCylinder_onLine() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 1, y: 2, z: 5)
        
        let result = sut.project(point)
        
        XCTAssertEqual(result, .init(x: 6.0, y: 2.0, z: 5.0))
    }
}

// MARK: SignedDistanceMeasurableType Conformance

extension Cylinder3Tests {
    func testSignedDistanceTo_pointOnTopOfStart_center() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 1, y: 2, z: 20)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 10.0)
        XCTAssertEqual(result, sut.project(point).distance(to: point), accuracy: accuracy)
    }
    
    func testSignedDistanceTo_pointOnTopOfStart_offCenter() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 0, y: -1, z: 20)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 10.0)
        XCTAssertEqual(result, sut.project(point).distance(to: point), accuracy: accuracy)
    }
    
    func testSignedDistanceTo_pointOnTopOfStart_offRadius() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: -10, y: -10, z: 20)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 15.073546166678991)
        XCTAssertEqual(result, sut.project(point).distance(to: point), accuracy: accuracy)
    }
    
    func testSignedDistanceTo_pointBelowEnd_center() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 1, y: 2, z: -10)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 10.0)
        XCTAssertEqual(result, sut.project(point).distance(to: point), accuracy: accuracy)
    }
    
    func testSignedDistanceTo_pointBelowEnd_offCenter() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 0, y: -1, z: -10)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 10.0)
        XCTAssertEqual(result, sut.project(point).distance(to: point), accuracy: accuracy)
    }
    
    func testSignedDistanceTo_pointBelowEnd_offRadius() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: -10, y: -10, z: -10)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 15.073546166678991)
        XCTAssertEqual(result, sut.project(point).distance(to: point), accuracy: accuracy)
    }
    
    func testSignedDistanceTo_betweenEnds() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: -10, y: -10, z: 5)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 11.278820596099706)
        XCTAssertEqual(result, sut.project(point).distance(to: point), accuracy: accuracy)
    }
    
    func testSignedDistanceTo_withinCylinder_closerToEdge() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: -1, y: -2, z: 5)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, -0.5278640450004207)
        XCTAssertEqual(result, -sut.project(point).distance(to: point), accuracy: accuracy)
    }
    
    func testSignedDistanceTo_withinCylinder_closerToStart() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 1, y: 1, z: 9)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, -1.0)
        XCTAssertEqual(result, -sut.project(point).distance(to: point), accuracy: accuracy)
    }
    
    func testSignedDistanceTo_withinCylinder_closerToEnd() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 1, y: 1, z: 1)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, -1.0)
        XCTAssertEqual(result, -sut.project(point).distance(to: point), accuracy: accuracy)
    }
    
    func testSignedDistanceTo_withinCylinder_onLine() {
        let sut = Cylinder(
            start: .init(x: 1, y: 2, z: 10),
            end: .init(x: 1, y: 2, z: 0),
            radius: 5
        )
        let point = Vector3D(x: 1, y: 2, z: 5)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, -5.0)
        XCTAssertEqual(result, -sut.project(point).distance(to: point), accuracy: accuracy)
    }
}

// MARK: ConvexType Conformance

extension Cylinder3Tests {
    typealias Line = Line3D
    typealias LineSegment = LineSegment3D
    typealias Ray = Ray3D
    
    // MARK: Line
    
    func testIntersectionWith_line_noIntersection() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = Line(
            x1: -25, y1: 0, z1: 5,
            x2: -20, y2: 0, z2: 15
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(result, .noIntersection)
    }
    
    func testIntersectionWith_line_slantedIntersection() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = Line(
            x1: -25, y1: 0, z1: 5,
            x2: 25, y2: 0, z2: 15
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enterExit(
                PointNormal(
                    point: .init(x: -5.0, y: 0.0, z: 9.0),
                    normal: .init(x: -1.0, y: 0.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 0.0, y: 0.0, z: 10.0),
                    normal: .init(x: 0.0, y: 0.0, z: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_parallel_alongCenter() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = Line(
            x1: -20, y1: 0, z1: 5,
            x2: 20, y2: 0, z2: 5
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enterExit(
                .init(
                    point: .init(x: -5, y: 0, z: 5),
                    normal: .init(x: -1, y: 0, z: 0)
                ),
                .init(
                    point: .init(x: 5, y: 0, z: 5),
                    normal: .init(x: -1, y: 0, z: 0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_parallel_offCenter() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = Line(
            x1: -20, y1: 2, z1: 5,
            x2: 20, y2: 2, z2: 5
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enterExit(
                PointNormal(
                    point: .init(x: -4.582575694955839, y: 2.0, z: 5.0),
                    normal: .init(x: -0.916515138991168, y: 0.4000000000000001, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 4.582575694955835, y: 2.0, z: 5.0),
                    normal: .init(x: -0.9165151389911679, y: -0.40000000000000036, z: -0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_slanted_center() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 20),
            radius: 5
        )
        let line = Line(
            x1: -7, y1: 0, z1: 8,
            x2: 7, y2: 0, z2: 12
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enterExit(
                .init(
                    point: .init(x: -5.0, y: 0.0, z: 8.571428571428571),
                    normal: .init(x: -1.0, y: 0.0, z: 0.0)
                ),
                .init(
                    point: .init(x: 5.0, y: 0.0, z: 11.428571428571429),
                    normal: .init(x: -1.0, y: -0.0, z: 3.552713678800501e-16)
                )
            )
        )
    }
    
    func testIntersectionWith_line_exitOnEnd() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = Line(
            x1: -7, y1: 0, z1: 8,
            x2: 7, y2: 0, z2: 12
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enterExit(
                PointNormal(
                    point: .init(x: -5.0, y: 0.0, z: 8.571428571428571),
                    normal: .init(x: -1.0, y: 0.0, z: 0.0)
                ),
                PointNormal(
                    point: .init(x: 0.0, y: 0.0, z: 10.0),
                    normal: .init(x: -0.0, y: -0.0, z: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_exitOnStart() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = Line(
            x1: -7, y1: 0, z1: 2,
            x2: 7, y2: 0, z2: -2
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enterExit(
                PointNormal(
                    point: .init(x: -5.0, y: 0.0, z: 1.4285714285714286),
                    normal: .init(x: -1.0, y: 0.0, z: -4.4408920985006264e-17)
                ),
                PointNormal(
                    point: .init(x: 0.0, y: 0.0, z: 0.0),
                    normal: .init(x: 0.0, y: 0.0, z: 1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_acrossCylinderHeight() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = Line(
            x1: 2, y1: 1, z1: -10,
            x2: 2, y2: 1, z2: 20
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enterExit(
                PointNormal(
                    point: .init(x: 2.000000000000002, y: 1.000000000000001, z: 0.0),
                    normal: .init(x: -0.0, y: -0.0, z: -1.0)
                ),
                PointNormal(
                    point: .init(x: 2.0000000000000044, y: 1.0000000000000022, z: 10.0),
                    normal: .init(x: -0.0, y: -0.0, z: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_acrossCylinderHeight_offRadiusWithinBounds() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = Line(
            x1: 4, y1: 4, z1: -10,
            x2: 4, y2: 4, z2: 20
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(result, .noIntersection)
    }
    
    func testIntersectionWith_line_acrossCylinderHeight_offRadiusOffBounds() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = Line(
            x1: 10, y1: 10, z1: -10,
            x2: 10, y2: 10, z2: 20
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(result, .noIntersection)
    }
    
    // MARK: Line Segment
    
    func testIntersectionWith_lineSegment_parallel_alongCenter_endsWithinCylinder() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = LineSegment(
            x1: -20, y1: 0, z1: 5,
            x2: 0, y2: 0, z2: 5
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enter(
                .init(
                    point: .init(x: -5, y: 0, z: 5),
                    normal: .init(x: -1, y: 0, z: 0)
                )
            )
        )
    }
    
    func testIntersectionWith_lineSegment_parallel_alongCenter_startWithinCylinder() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = LineSegment(
            x1: 0, y1: 0, z1: 5,
            x2: 20, y2: 0, z2: 5
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .exit(
                .init(
                    point: .init(x: 5, y: 0, z: 5),
                    normal: .init(x: -1, y: 0, z: 0)
                )
            )
        )
    }
    
    func testIntersectionWith_lineSegment_parallel_offCenter_endsWithinCylinder() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = LineSegment(
            x1: -20, y1: 2, z1: 5,
            x2: 0, y2: 2, z2: 5
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enter(
                PointNormal(
                    point: .init(x: -4.582575694955839, y: 2.0, z: 5.0),
                    normal: .init(x: -0.916515138991168, y: 0.4000000000000001, z: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_lineSegment_parallel_offCenter_startsWithinCylinder() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = LineSegment(
            x1: 0, y1: 2, z1: 5,
            x2: 20, y2: 2, z2: 5
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .exit(
                PointNormal(
                    point: .init(x: 4.58257569495584, y: 2.0, z: 5.0),
                    normal: .init(x: -0.916515138991168, y: -0.4, z: -0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_lineSegment_slanted_center_endsWithinCylinder() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 20),
            radius: 5
        )
        let line = LineSegment(
            x1: -7, y1: 0, z1: 8,
            x2: 0, y2: 0, z2: 12
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enter(
                PointNormal(
                    point: .init(x: -5.0, y: 0.0, z: 9.142857142857142),
                    normal: .init(x: -1.0, y: 0.0, z: 0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_lineSegment_slanted_center_startsWithinCylinder() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 20),
            radius: 5
        )
        let line = LineSegment(
            x1: 0, y1: 0, z1: 8,
            x2: -7, y2: 0, z2: 12
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .exit(
                PointNormal(
                    point: .init(x: -5.0, y: 0.0, z: 10.857142857142858),
                    normal: .init(x: 1.0, y: -0.0, z: -0.0)
                )
            )
        )
    }
    
    func testIntersectionWith_lineSegment_exitOnEnd_endsWithinCylinder() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = LineSegment(
            x1: -7, y1: 0, z1: 6,
            x2: 0, y2: 0, z2: 9
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enter(
                PointNormal(
                    point: .init(x: -5.0, y: 0.0, z: 6.857142857142857),
                    normal: .init(x: -1.0, y: 0.0, z: -1.7763568394002506e-16)
                )
            )
        )
    }
    
    func testIntersectionWith_lineSegment_exitOnEnd_startsWithinCylinder() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = LineSegment(
            x1: 0, y1: 0, z1: 8,
            x2: 5, y2: 0, z2: 12
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .exit(
                PointNormal(
                    point: .init(x: 2.5, y: 0.0, z: 10.0),
                    normal: .init(x: -0.0, y: -0.0, z: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_exitOnStart_endsWithinCylinder() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = LineSegment(
            x1: -7, y1: 0, z1: -2,
            x2: 0, y2: 0, z2: 2
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enter(
                PointNormal(
                    point: .init(x: -3.5, y: 0.0, z: 0.0),
                    normal: .init(x: -0.0, y: -0.0, z: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_acrossCylinderHeight_startsWithinCylinder() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = LineSegment(
            x1: 2, y1: 1, z1: 2,
            x2: 2, y2: 1, z2: 20
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .exit(
                .init(
                    point: .init(x: 1.9999999999999996, y: 0.9999999999999998, z: 10.0),
                    normal: .init(x: 0, y: 0, z: -1)
                )
            )
        )
    }
    
    func testIntersectionWith_line_acrossCylinderHeight_endsWithinCylinder() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = LineSegment(
            x1: 2, y1: 1, z1: -10,
            x2: 2, y2: 1, z2: 5
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enter(
                PointNormal(
                    point: .init(x: 2.000000000000002, y: 1.000000000000001, z: 0.0),
                    normal: .init(x: -0.0, y: -0.0, z: -1.0)
                )
            )
        )
    }
    
    func testIntersectionWith_line_contained() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = LineSegment(
            x1: 2, y1: 1, z1: 2,
            x2: -2, y2: -1, z2: 7
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(result, .contained)
    }
    
    // Ray
    func testIntersectionWith_ray_parallel_alongCenter_endsBeforeCylinder() {
        let sut = Cylinder(
            start: .init(x: 0, y: 0, z: 0),
            end: .init(x: 0, y: 0, z: 10),
            radius: 5
        )
        let line = Ray(
            x1: -20, y1: 0, z1: 5,
            x2: -15, y2: 0, z2: 5
        )
        
        let result = sut.intersection(with: line)
        
        assertEqual(
            result,
            .enterExit(
                .init(
                    point: .init(x: -5, y: 0, z: 5),
                    normal: .init(x: -1, y: 0, z: 0)
                ),
                .init(
                    point: .init(x: 5, y: 0, z: 5),
                    normal: .init(x: -1, y: 0, z: 0)
                )
            )
        )
    }
}
