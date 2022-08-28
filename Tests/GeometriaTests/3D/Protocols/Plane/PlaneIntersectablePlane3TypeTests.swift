import XCTest

@testable import Geometria

class PlaneIntersectablePlane3TypeTests: XCTestCase {
    typealias Vector = Vector3D
    typealias Plane = PointNormalPlane3<Vector>

    func testIntersectionWithPlane_orthogonalPlanes() throws {
        let plane1 = Plane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .unitZ
        )
        let plane2 = Plane(
            point: .init(x: 5, y: 7, z: 11),
            normal: .unitX
        )

        let result = try XCTUnwrap(plane1.intersection(with: plane2))

        XCTAssertEqual(
            result.a,
            Vector(x: 5, y: 2, z: 3)
        )
        XCTAssertEqual(
            result.b,
            Vector(x: 5, y: 3, z: 3)
        )
    }

    func testIntersectionWithPlane_parallelPlanes() throws {
        let plane1 = Plane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .unitZ
        )
        let plane2 = Plane(
            point: .init(x: 5, y: 7, z: 11),
            normal: .unitZ
        )

        XCTAssertNil(plane1.intersection(with: plane2))
    }

    func testIntersectionWithPlane_coplanarPlanes() throws {
        let plane1 = Plane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .unitZ
        )
        let plane2 = Plane(
            point: .init(x: 5, y: 7, z: 3),
            normal: .unitZ
        )

        XCTAssertNil(plane1.intersection(with: plane2))
    }
}
