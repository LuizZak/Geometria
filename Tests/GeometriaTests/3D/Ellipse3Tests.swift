import XCTest
import Geometria

class Ellipse3Tests: XCTestCase {
    typealias Ellipse = Ellipse3D
    
    func testInitWithRadiusXRadiusYRadiusZ() {
        let sut = Ellipse(center: .init(x: 1, y: 2, z: 3), radiusX: 4, radiusY: 5, radiusZ: 6)
        
        XCTAssertEqual(sut.center.x, 1)
        XCTAssertEqual(sut.center.y, 2)
        XCTAssertEqual(sut.center.z, 3)
        XCTAssertEqual(sut.radius.x, 4)
        XCTAssertEqual(sut.radius.y, 5)
        XCTAssertEqual(sut.radius.z, 6)
    }
    
    func testRadiusX() {
        let sut = Ellipse(center: .init(x: 1, y: 2, z: 3), radius: .init(x: 4, y: 5, z: 6))
        
        XCTAssertEqual(sut.radiusX, 4)
    }
    
    func testRadiusX_set() {
        var sut = Ellipse(center: .init(x: 1, y: 2, z: 3), radius: .init(x: 4, y: 5, z: 6))
        
        sut.radiusX = 7
        
        XCTAssertEqual(sut.center.x, 1)
        XCTAssertEqual(sut.center.y, 2)
        XCTAssertEqual(sut.center.z, 3)
        XCTAssertEqual(sut.radius.x, 7)
        XCTAssertEqual(sut.radius.y, 5)
        XCTAssertEqual(sut.radius.z, 6)
    }
    
    func testRadiusY() {
        let sut = Ellipse(center: .init(x: 1, y: 2, z: 3), radius: .init(x: 4, y: 5, z: 6))
        
        XCTAssertEqual(sut.radiusY, 5)
    }
    
    func testRadiusY_set() {
        var sut = Ellipse(center: .init(x: 1, y: 2, z: 3), radius: .init(x: 4, y: 5, z: 6))
        
        sut.radiusY = 7
        
        XCTAssertEqual(sut.center.x, 1)
        XCTAssertEqual(sut.center.y, 2)
        XCTAssertEqual(sut.center.z, 3)
        XCTAssertEqual(sut.radius.x, 4)
        XCTAssertEqual(sut.radius.y, 7)
        XCTAssertEqual(sut.radius.z, 6)
    }
    
    func testRadiusZ() {
        let sut = Ellipse(center: .init(x: 1, y: 2, z: 3), radius: .init(x: 4, y: 5, z: 6))
        
        XCTAssertEqual(sut.radiusZ, 6)
    }
    
    func testRadiusZ_set() {
        var sut = Ellipse(center: .init(x: 1, y: 2, z: 3), radius: .init(x: 4, y: 5, z: 6))
        
        sut.radiusZ = 7
        
        XCTAssertEqual(sut.center.x, 1)
        XCTAssertEqual(sut.center.y, 2)
        XCTAssertEqual(sut.center.z, 3)
        XCTAssertEqual(sut.radius.x, 4)
        XCTAssertEqual(sut.radius.y, 5)
        XCTAssertEqual(sut.radius.z, 7)
    }
}

// MARK: Scalar: Real Conformance

extension Ellipse3Tests {
    func testContainsXY() {
        let sut = Ellipse(center: .one, radius: .init(x: 1, y: 2, z: 3))
        
        XCTAssertTrue(sut.contains(x: 1, y: 1, z: 1))
        XCTAssertTrue(sut.contains(x: 0, y: 1, z: 1))
        XCTAssertTrue(sut.contains(x: 2, y: 1, z: 1))
        XCTAssertFalse(sut.contains(x: 0, y: 0, z: 1))
        XCTAssertFalse(sut.contains(x: 2, y: 2, z: 1))
    }
}

// MARK: SphereProjectiveSpace Conformance

extension Ellipse3Tests {
    func testAttemptProject() throws {
        let sut = Ellipse3D(center: .zero, radius: .init(x: 5, y: 7, z: 9))
        let point = Vector3D(x: 10, y: 10, z: 10)
        
        let coord = try XCTUnwrap(sut.attemptProjection(point))
        
        XCTAssertEqual(coord.azimuth, 0.7853981633974483)
        XCTAssertEqual(coord.elevation, 0.6154797086703873)
    }
    
    func testAttemptProject_returnsNilForCenterPoint() throws {
        let sut = Ellipse3D(center: .init(x: 1, y: 2, z: 3), radius: .init(x: 5, y: 7, z: 9))
        
        XCTAssertNil(sut.attemptProjection(.init(x: 1, y: 2, z: 3)))
    }
    
    func testProjectOut() {
        let sut = Ellipse3D(center: .zero, radius: .init(x: 5, y: 7, z: 9))
        let coord = SphereCoordinates(azimuth: 0.7853981633974483, elevation: 0.6154797086703873)
        
        let vector = sut.projectOut(coord)
        
        XCTAssertEqual(vector, .init(x: 2.886751345948129, y: 4.04145188432738, z: 5.196152422706632))
    }
    
    func testProjectOut_originCoord() {
        let sut = Ellipse3D(center: .zero, radius: .init(x: 5, y: 7, z: 9))
        let coord = SphereCoordinates(azimuth: 0.0, elevation: 0.0)
        
        let vector = sut.projectOut(coord)
        
        XCTAssertEqual(vector, .init(x: 5, y: 0, z: 0))
    }
    
    func testProjectOut_yPositive() {
        let sut = Ellipse3D(center: .zero, radius: .init(x: 5, y: 7, z: 9))
        let coord = SphereCoordinates(azimuth: Double.pi / 2, elevation: 0.0)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: 0, y: 7, z: 0),
                    accuracy: 1e-15)
    }
    
    func testProjectOut_xNegative() {
        let sut = Ellipse3D(center: .zero, radius: .init(x: 5, y: 7, z: 9))
        let coord = SphereCoordinates(azimuth: Double.pi, elevation: 0.0)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: -5, y: 0, z: 0),
                    accuracy: 1e-14)
    }
    
    func testProjectOut_yNegative() {
        let sut = Ellipse3D(center: .zero, radius: .init(x: 5, y: 7, z: 9))
        let coord = SphereCoordinates(azimuth: -Double.pi / 2, elevation: 0.0)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: 0, y: -7, z: 0),
                    accuracy: 1e-15)
    }
    
    func testProjectOut_zPositive() {
        let sut = Ellipse3D(center: .zero, radius: .init(x: 5, y: 7, z: 9))
        let coord = SphereCoordinates(azimuth: 0.0, elevation: Double.pi / 2)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: 0, y: 0, z: 9),
                    accuracy: 1e-15)
    }
    
    func testProjectOut_zNegative() {
        let sut = Ellipse3D(center: .zero, radius: .init(x: 5, y: 7, z: 9))
        let coord = SphereCoordinates(azimuth: 0.0, elevation: -Double.pi / 2)
        
        let vector = sut.projectOut(coord)
        
        assertEqual(vector,
                    .init(x: 0, y: 0, z: -9),
                    accuracy: 1e-15)
    }
}
