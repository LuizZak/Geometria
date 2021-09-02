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
        
        let result = sut.project(vector: point)
        
        assertEqual(result,
                    .init(x: -3.999999999999999, y: 3.0, z: 4.000000000000001),
                    accuracy: 1e-15)
    }
}
