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
