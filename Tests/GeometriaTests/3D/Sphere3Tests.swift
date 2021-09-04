import XCTest
import Geometria

class Sphere3Tests: XCTestCase {
    // MARK: SphereProjectiveSpace Conformance
    
    func testAttemptProject() throws {
        let sut = Sphere3D(center: .zero, radius: 10)
        let point = Vector3D(x: 10, y: 10, z: 10)
        
        let coord = try XCTUnwrap(sut.attemptProjection(point))
        
        XCTAssertEqual(coord.azimuth, 0.7853981633974483)
        XCTAssertEqual(coord.elevation, 0.6154797086703873)
    }
    
    func testAttemptProject_returnsNilForCenterPoint() throws {
        let sut = Sphere3D(center: .init(x: 1, y: 2, z: 3), radius: 4)
        
        XCTAssertNil(sut.attemptProjection(.init(x: 1, y: 2, z: 3)))
    }
    
    func testProjectOut() {
        let sut = Sphere3D(center: .zero, radius: 10)
        let coord = SphereCoordinates(azimuth: 0.7853981633974483, elevation: 0.6154797086703873)
        
        let vector = sut.projectOut(coord)
        
        XCTAssertEqual(vector, .init(x: 5.773502691896258, y: 5.773502691896257, z: 5.773502691896257))
    }
    
    func testProjectOut_originCoord() {
        let sut = Sphere3D(center: .zero, radius: 10)
        let coord = SphereCoordinates(azimuth: 0.0, elevation: 0.0)
        
        let vector = sut.projectOut(coord)
        
        XCTAssertEqual(vector, .init(x: 10, y: 0, z: 0))
    }
    
    func testProjectOut_yPositive() {
        let sut = Sphere3D(center: .zero, radius: 10)
        let coord = SphereCoordinates(azimuth: Double.pi / 2, elevation: 0.0)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: 0, y: 10, z: 0),
                    accuracy: 1e-15)
    }
    
    func testProjectOut_xNegative() {
        let sut = Sphere3D(center: .zero, radius: 10)
        let coord = SphereCoordinates(azimuth: Double.pi, elevation: 0.0)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: -10, y: 0, z: 0),
                    accuracy: 1e-14)
    }
    
    func testProjectOut_yNegative() {
        let sut = Sphere3D(center: .zero, radius: 10)
        let coord = SphereCoordinates(azimuth: -Double.pi / 2, elevation: 0.0)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: 0, y: -10, z: 0),
                    accuracy: 1e-15)
    }
    
    func testProjectOut_zPositive() {
        let sut = Sphere3D(center: .zero, radius: 10)
        let coord = SphereCoordinates(azimuth: 0.0, elevation: Double.pi / 2)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: 0, y: 0, z: 10),
                    accuracy: 1e-15)
    }
    
    func testProjectOut_zNegative() {
        let sut = Sphere3D(center: .zero, radius: 10)
        let coord = SphereCoordinates(azimuth: 0.0, elevation: -Double.pi / 2)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: 0, y: 0, z: -10),
                    accuracy: 1e-15)
    }
}
