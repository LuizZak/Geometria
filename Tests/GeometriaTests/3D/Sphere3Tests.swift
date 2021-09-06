import XCTest
import Geometria

class Sphere3Tests: XCTestCase {
    // MARK: SphereProjectiveSpace Conformance
    
    func testAttemptProject() throws {
        let sut = Sphere3D(center: .init(x: 1, y: 2, z: 3), radius: 10)
        let point = Vector3D(x: 11, y: 12, z: 13)
        
        let coord = try XCTUnwrap(sut.attemptProjection(point))
        
        XCTAssertEqual(coord.azimuth, 0.7853981633974483)
        XCTAssertEqual(coord.elevation, 0.6154797086703873)
    }
    
    func testAttemptProject_returnsNilForCenterPoint() throws {
        let sut = Sphere3D(center: .init(x: 1, y: 2, z: 3), radius: 4)
        
        XCTAssertNil(sut.attemptProjection(.init(x: 1, y: 2, z: 3)))
    }
    
    func testProjectOut() {
        let sut = Sphere3D(center: .init(x: 1, y: 2, z: 3), radius: 10)
        let coord = SphereCoordinates(azimuth: 0.7853981633974483, elevation: 0.6154797086703873)
        
        let vector = sut.projectOut(coord)
        
        XCTAssertEqual(vector, .init(x: 6.773502691896258, y: 7.773502691896257, z: 8.773502691896258))
    }
    
    func testProjectOut_originCoord() {
        let sut = Sphere3D(center: .init(x: 1, y: 2, z: 3), radius: 10)
        let coord = SphereCoordinates(azimuth: 0.0, elevation: 0.0)
        
        let vector = sut.projectOut(coord)
        
        XCTAssertEqual(vector, .init(x: 11, y: 2, z: 3))
    }
    
    func testProjectOut_yPositive() {
        let sut = Sphere3D(center: .init(x: 1, y: 2, z: 3), radius: 10)
        let coord = SphereCoordinates(azimuth: Double.pi / 2, elevation: 0.0)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: 1, y: 12, z: 3),
                    accuracy: 1e-15)
    }
    
    func testProjectOut_xNegative() {
        let sut = Sphere3D(center: .init(x: 1, y: 2, z: 3), radius: 10)
        let coord = SphereCoordinates(azimuth: Double.pi, elevation: 0.0)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: -9, y: 2, z: 3),
                    accuracy: 1e-14)
    }
    
    func testProjectOut_yNegative() {
        let sut = Sphere3D(center: .init(x: 1, y: 2, z: 3), radius: 10)
        let coord = SphereCoordinates(azimuth: -Double.pi / 2, elevation: 0.0)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: 1, y: -8, z: 3),
                    accuracy: 1e-15)
    }
    
    func testProjectOut_zPositive() {
        let sut = Sphere3D(center: .init(x: 1, y: 2, z: 3), radius: 10)
        let coord = SphereCoordinates(azimuth: 0.0, elevation: Double.pi / 2)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: 1, y: 2, z: 13),
                    accuracy: 1e-15)
    }
    
    func testProjectOut_zNegative() {
        let sut = Sphere3D(center: .init(x: 1, y: 2, z: 3), radius: 10)
        let coord = SphereCoordinates(azimuth: 0.0, elevation: -Double.pi / 2)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: 1, y: 2, z: -7),
                    accuracy: 1e-15)
    }
}
