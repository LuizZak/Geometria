import XCTest
import Geometria
import TestCommons

class PointNormalPlaneTests: XCTestCase {
    typealias Vector = Vector3D
    typealias Plane = PointNormalPlane3<Vector>

    func testEquatable() {
        XCTAssertEqual(Plane(point: .unitZ, normal: .unitY),
                       Plane(point: .unitZ, normal: .unitY))
        XCTAssertNotEqual(Plane(point: .unitZ, normal: .unitY),
                          Plane(point: .unitX, normal: .unitY))
        XCTAssertNotEqual(Plane(point: .unitZ, normal: .unitY),
                          Plane(point: .unitX, normal: .unitX))
    }

    func testHashable() {
        XCTAssertEqual(Plane(point: .unitZ, normal: .unitY).hashValue,
                       Plane(point: .unitZ, normal: .unitY).hashValue)
        XCTAssertNotEqual(Plane(point: .unitZ, normal: .unitY).hashValue,
                          Plane(point: .unitX, normal: .unitY).hashValue)
        XCTAssertNotEqual(Plane(point: .unitZ, normal: .unitY).hashValue,
                          Plane(point: .unitX, normal: .unitX).hashValue)
    }

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

    func testInitWithPlane() {
        let plane = PointNormal<Vector3D>(point: .init(x: 1, y: 2, z: 3),
                                          normal: .init(x: 4, y: 5, z: 6))

        let result = PointNormalPlane(plane)

        XCTAssertEqual(result.point, .init(x: 1, y: 2, z: 3))
        XCTAssertEqual(
            result.normal,
            .init(x: 0.45584230583855184,
                  y: 0.5698028822981899,
                  z: 0.6837634587578277)
        )
    }
}
