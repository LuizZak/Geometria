import XCTest
import Geometria
import TestCommons

class AdditiveRectangleTypeTests: XCTestCase {
    typealias Rectangle = Rectangle2D
    
    func testOffsetBy() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.offsetBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(result.location, .init(x: 8, y: 13))
        XCTAssertEqual(result.size, .init(x: 3, y: 5))
    }
    
    func testResizedBy() {
        let sut = Rectangle(x: 1, y: 2, width: 3, height: 5)
        
        let result = sut.resizedBy(.init(x: 7, y: 11))
        
        XCTAssertEqual(result.location, .init(x: 1, y: 2))
        XCTAssertEqual(result.size, .init(x: 10, y: 16))
    }

    func testVertices_2d() {
        let sut = Rectangle(
            minimum: .init(x: 1, y: 2),
            maximum: .init(x: 3, y: 5)
        )

        let result = sut.vertices

        XCTAssertEqual(Set(result), [
            .init(x: 1, y: 2),
            .init(x: 3, y: 2),
            .init(x: 1, y: 5),
            .init(x: 3, y: 5),
        ])
    }

    func testVertices_3d() {
        let sut = NRectangle<Vector3D>(
            minimum: .init(x: 1, y: 2, z: 3),
            maximum: .init(x: 5, y: 7, z: 11)
        )

        let result = sut.vertices

        XCTAssertEqual(Set(result), [
            .init(x: 1, y: 2, z: 3),
            .init(x: 5, y: 2, z: 3),
            .init(x: 1, y: 7, z: 3),
            .init(x: 5, y: 7, z: 3),

            .init(x: 1, y: 2, z: 11),
            .init(x: 5, y: 2, z: 11),
            .init(x: 1, y: 7, z: 11),
            .init(x: 5, y: 7, z: 11),
        ])
    }
}
