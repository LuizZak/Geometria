import XCTest
import Geometria
import TestCommons

class VectorTakeableTests: XCTestCase {

    // MARK: - 2D

    func testSubscript_2D_2D() {
        let sut = Vector2D(x: 1, y: 2)

        XCTAssertEqual(sut[.x, .y], .init(x: 1, y: 2))
    }

    func testSubscript_2D_3D() {
        let sut = Vector2D(x: 1, y: 2)

        XCTAssertEqual(sut[.x, .y, .x], .init(x: 1, y: 2, z: 1))
    }

    func testSubscript_2D_4D() {
        let sut = Vector3D(x: 1, y: 2, z: 3)

        XCTAssertEqual(sut[.x, .y, .x, .y], .init(x: 1, y: 2, z: 1, w: 2))
    }

    // MARK: - 3D

    func testSubscript_3D_2D() {
        let sut = Vector3D(x: 1, y: 2, z: 3)

        XCTAssertEqual(sut[.x, .y], .init(x: 1, y: 2))
    }

    func testSubscript_3D_3D() {
        let sut = Vector3D(x: 1, y: 2, z: 3)

        XCTAssertEqual(sut[.x, .y, .z], .init(x: 1, y: 2, z: 3))
    }

    func testSubscript_3D_4D() {
        let sut = Vector3D(x: 1, y: 2, z: 3)

        XCTAssertEqual(sut[.x, .y, .z, .x], .init(x: 1, y: 2, z: 3, w: 1))
    }

    // MARK: - 3D

    func testSubscript_4D_2D() {
        let sut = Vector4D(x: 1, y: 2, z: 3, w: 5)

        XCTAssertEqual(sut[.x, .y], .init(x: 1, y: 2))
    }

    func testSubscript_4D_3D() {
        let sut = Vector4D(x: 1, y: 2, z: 3, w: 5)

        XCTAssertEqual(sut[.x, .y, .z], .init(x: 1, y: 2, z: 3))
    }

    func testSubscript_4D_4D() {
        let sut = Vector4D(x: 1, y: 2, z: 3, w: 5)

        XCTAssertEqual(sut[.x, .y, .z, .w], .init(x: 1, y: 2, z: 3, w: 5))
    }
}
