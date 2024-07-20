import XCTest

@testable import Geometria
import TestCommons

class PlaneIntersectablePlane2TypeTests: XCTestCase {
    typealias Vector = Vector2D
    typealias Plane = PointNormalPlane2<Vector>

    func testIntersectionWithPlane_orthogonalPlanes() throws {
        let plane1 = Plane(
            point: .init(x: 1, y: 2),
            normal: .unitX
        )
        let plane2 = Plane(
            point: .init(x: 5, y: 7),
            normal: .unitY
        )

        let result = try XCTUnwrap(plane1.intersection(with: plane2))

        XCTAssertEqual(
            result,
            Vector(x: 1, y: 7)
        )
    }

    func testIntersectionWithPlane_parallelPlanes() throws {
        let plane1 = Plane(
            point: .init(x: 1, y: 2),
            normal: .unitX
        )
        let plane2 = Plane(
            point: .init(x: 5, y: 7),
            normal: .unitX
        )

        XCTAssertNil(plane1.intersection(with: plane2))
    }

    func testIntersectionWithPlane_coplanarPlanes() throws {
        let plane1 = Plane(
            point: .init(x: 1, y: 2),
            normal: .unitX
        )
        let plane2 = Plane(
            point: .init(x: 1, y: 5),
            normal: .unitX
        )

        XCTAssertNil(plane1.intersection(with: plane2))
    }
}
