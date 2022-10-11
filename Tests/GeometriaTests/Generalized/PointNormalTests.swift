import XCTest
import Geometria

class PointNormalTests: XCTestCase {
    typealias PointNormal = Geometria.PointNormal<Vector2D>
    
    func testDescription() {
        let sut = PointNormal(
            point: .init(x: 1, y: 2),
            normal: .init(x: 3, y: 5)
        )
        
        XCTAssertEqual(
            sut.description,
            "PointNormal(point: Vector2<Double>(x: 1.0, y: 2.0), normal: Vector2<Double>(x: 3.0, y: 5.0))"
        )
    }
    
    func testInit() {
        let sut = PointNormal(
            point: .init(x: 1, y: 2),
            normal: .init(x: 3, y: 5)
        )
        
        XCTAssertEqual(sut.point, .init(x: 1, y: 2))
        XCTAssertEqual(sut.normal, .init(x: 3, y: 5))
    }
}

// MARK: PlaneType Conformance

extension PointNormalTests {
    func testPointOnPlane() {
        let sut = PointNormal(point: .init(x: 1, y: 2), normal: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.pointOnPlane, .init(x: 1, y: 2))
    }
    
    func testAsPlane() {
        let sut = PointNormal(
            point: .init(x: 1, y: 2),
            normal: .init(x: 3, y: 5)
        )
        
        let result = sut.asPlane
        
        XCTAssertEqual(result.point, .init(x: 1, y: 2))
        XCTAssertEqual(result.normal, .init(x: 0.5144957554275265, y: 0.8574929257125441))
    }
    
    func testInitWithPlane() {
        let plane = PointNormalPlane<Vector3D>(
            point: .init(x: 1, y: 2, z: 3),
            normal: .init(x: 4, y: 5, z: 6)
        )
        
        let result = Geometria.PointNormal(plane)
        
        XCTAssertEqual(result.point, .init(x: 1, y: 2, z: 3))
        XCTAssertEqual(
            result.normal,
            .init(
                x: 0.4558423058385518,
                y: 0.5698028822981898,
                z: 0.6837634587578276
            )
        )
    }
}
