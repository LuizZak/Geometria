import XCTest

@testable import Geometria

class Hyperplane2Tests: XCTestCase {
    typealias Vector = Vector2D
    typealias Hyperplane = Hyperplane2<Vector>

    func testIntersectionWithPlane_orthogonalPlanes() throws {
        let plane1 = Hyperplane(
            point: .init(x: 1, y: 2),
            normal: .unitX
        )
        let plane2 = Hyperplane(
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
        let plane1 = Hyperplane(
            point: .init(x: 1, y: 2),
            normal: .unitX
        )
        let plane2 = Hyperplane(
            point: .init(x: 5, y: 7),
            normal: .unitX
        )

        XCTAssertNil(plane1.intersection(with: plane2))
    }

    func testIntersectionWithPlane_coplanarPlanes() throws {
        let plane1 = Hyperplane(
            point: .init(x: 1, y: 2),
            normal: .unitX
        )
        let plane2 = Hyperplane(
            point: .init(x: 1, y: 5),
            normal: .unitX
        )

        XCTAssertNil(plane1.intersection(with: plane2))
    }
}
