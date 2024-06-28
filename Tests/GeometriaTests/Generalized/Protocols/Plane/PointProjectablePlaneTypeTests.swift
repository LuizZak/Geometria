import XCTest
import Geometria
import TestCommons

class PointProjectablePlaneTypeTests: XCTestCase {
    typealias Vector = Vector3D
    typealias Plane = PointNormalPlane<Vector>
    
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
