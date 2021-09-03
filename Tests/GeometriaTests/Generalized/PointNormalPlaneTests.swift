import XCTest
import Geometria

class PointNormalPlaneTests: XCTestCase {
    typealias Vector = Vector3D
    typealias Plane = PointNormalPlane3<Vector>
    
    func testDescription() {
        let sut = Plane(point: .init(x: 1, y: 2, z: 3),
                        normal: .init(x: 0, y: 0, z: 1))
        
        XCTAssertEqual(
            sut.description,
            "PointNormalPlane(point: Vector3<Double>(x: 1.0, y: 2.0, z: 3.0), normal: Vector3<Double>(x: 0.0, y: 0.0, z: 1.0))"
        )
    }
    
    func testNormal_normalizesAssignedValues_onInit() {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 1, y: 1, z: 1))
        
        XCTAssertEqual(sut.normal, Vector3(x: 0.5773502691896258, y: 0.5773502691896258, z: 0.5773502691896258))
    }
    
    func testNormal_normalizesAssignedValues_onAssign() {
        var sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 1, y: 0, z: 0))
        
        sut.normal = .init(x: 1, y: 1, z: 1)
        
        XCTAssertEqual(sut.normal, Vector3(x: 0.5773502691896258, y: 0.5773502691896258, z: 0.5773502691896258))
    }
    
    func testAsPointNormal() {
        let sut = Plane(point: .init(x: 1, y: 2, z: 3),
                        normal: .init(x: 4, y: 5, z: 7))
        
        let result = sut.asPointNormal
        
        XCTAssertEqual(result.point, .init(x: 1, y: 2, z: 3))
        XCTAssertEqual(result.normal, .init(x: 0.4216370213557839, y: 0.5270462766947299, z: 0.7378647873726218))
    }
}

// MARK: - Line intersection

extension PointNormalPlaneTests {
    typealias Line = Line3<Vector>
    typealias LineSegment = LineSegment3<Vector>
    typealias Ray = Ray3<Vector>
    typealias DirectionalRay = DirectionalRay3<Vector>
    
    // MARK: Magnitude
    
    // MARK: Line - Plane intersection

    func testUnclampedNormalMagnitudeForIntersection_line() {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 0, y: 0, z: 1))
        let line = Line(x1: 0, y1: 0, z1: 3, x2: 1, y2: 1, z2: 2)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, 3.0)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_negativeMagnitude() {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 0, y: 0, z: 1))
        let line = Line(x1: 0, y1: 0, z1: -2, x2: 1, y2: 1, z2: -3)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, -2.0)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_line_parallel() {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 0, y: 0, z: 1))
        let line = Line(x1: 0, y1: 0, z1: 1, x2: 0, y2: 0, z2: 1)
        
        XCTAssertNil(sut.unclampedNormalMagnitudeForIntersection(with: line))
    }
    
    // MARK: Ray - Plane intersection
    
    func testUnclampedNormalMagnitudeForIntersection_ray() {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 0, y: 0, z: 1))
        let line = Ray(x1: 0, y1: 0, z1: 3, x2: 1, y2: 1, z2: 2)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, 3.0)
    }
    
    func testUnclampedNormalMagnitudeForIntersection_ray_negativeMagnitude() {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 0, y: 0, z: 1))
        let line = Ray(x1: 0, y1: 0, z1: -2, x2: 1, y2: 1, z2: -3)
        
        let result = sut.unclampedNormalMagnitudeForIntersection(with: line)
        
        XCTAssertEqual(result, -2.0)
    }
    
    // MARK: Vector
    
    // MARK: Line - Plane intersection

    func testIntersection_line() throws {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 0, y: 0, z: 1))
        let line = Line(x1: 0, y1: 0, z1: 3, x2: 1, y2: 1, z2: 2)
        
        let result = try XCTUnwrap(sut.intersection(with: line))
        
        assertEqual(result,
                    .init(x: 3.0, y: 3.0, z: 0),
                    accuracy: 1e-15)
    }
    
    func testIntersection_line_negativeMagnitude() throws {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 0, y: 0, z: 1))
        let line = Line(x1: 0, y1: 0, z1: -2, x2: 1, y2: 1, z2: -3)
        
        let result = try XCTUnwrap(sut.intersection(with: line))
        
        assertEqual(result,
                    .init(x: -2.0, y: -2.0, z: 0.0),
                    accuracy: 1e-15)
    }
    
    func testIntersection_line_parallel() {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 0, y: 0, z: 1))
        let line = Line(x1: 0, y1: 0, z1: 1, x2: 0, y2: 0, z2: 1)
        
        XCTAssertNil(sut.intersection(with: line))
    }
    
    // MARK: Ray - Plane intersection
    
    func testIntersection_ray() throws {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 0, y: 0, z: 1))
        let line = Ray(x1: 0, y1: 0, z1: 3, x2: 1, y2: 1, z2: 2)
        
        let result = try XCTUnwrap(sut.intersection(with: line))
        
        assertEqual(result,
                    .init(x: 3.0, y: 3.0, z: 0.0),
                    accuracy: 1e-15)
    }
    
    func testIntersection_ray_negativeMagnitude() {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 0, y: 0, z: 1))
        let line = Ray(x1: 0, y1: 0, z1: -2, x2: 1, y2: 1, z2: -3)
        
        XCTAssertNil(sut.intersection(with: line))
    }
}

// MARK: - PointProjectiveType Conformance

extension PointNormalPlaneTests {
    func testSignedDistanceTo_parallelAxisPlane() {
        let sut = Plane(point: .init(x: 1, y: 2, z: 3),
                        normal: .init(x: 0, y: 0, z: 1))
        let point = Vector(x: 1, y: 2, z: 10)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 7)
    }
    
    func testSignedDistanceTo_parallelAxisPlane_negativeDistance() {
        let sut = Plane(point: .init(x: 1, y: 2, z: 3),
                        normal: .init(x: 0, y: 0, z: 1))
        let point = Vector(x: 1, y: 2, z: -4)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, -7)
    }
    
    func testSignedDistanceTo_tiltedAxisPlane() {
        let sut = Plane(point: .init(x: 1, y: 2, z: 3),
                        normal: .init(x: -1, y: 0, z: 1))
        let point = Vector(x: 1, y: 2, z: 10)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 4.949747468305832)
    }
    
    func testSignedDistanceTo_tiltedAxisPlane_negativeDistance() {
        let sut = Plane(point: .init(x: 1, y: 2, z: 3),
                        normal: .init(x: -1, y: 0, z: 1))
        let point = Vector(x: 1, y: 2, z: -4)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, -4.949747468305832)
    }
    
    func testSignedDistanceTo_diagonalPlane() {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 1, y: 0, z: 1))
        let point = Vector(x: 10, y: 0, z: 10)
        
        let result = sut.signedDistance(to: point)
        
        XCTAssertEqual(result, 14.14213562373095)
    }
    
    func testProjectVector() {
        let sut = Plane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 1, y: 0, z: 1))
        let point = Vector(x: 2, y: 3, z: 10)
        
        let result = sut.project(point)
        
        assertEqual(result,
                    .init(x: -3.999999999999999, y: 3.0, z: 4.000000000000001),
                    accuracy: 1e-15)
    }
}
