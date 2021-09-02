import XCTest
import Geometria

class PointNormalPlaneTests: XCTestCase {
    typealias Plane = PointNormalPlane3D
    
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
}
