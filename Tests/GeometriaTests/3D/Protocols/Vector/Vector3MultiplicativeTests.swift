import XCTest
import Geometria

class Vector3MultiplicativeTests: XCTestCase {
    typealias Vector = Vector3D
    
    func testUnitX() {
        XCTAssertEqual(Vector.unitX, .init(x: 1, y: 0, z: 0))
    }
    
    func testUnitY() {
        XCTAssertEqual(Vector.unitY, .init(x: 0, y: 1, z: 0))
    }
    
    func testUnitZ() {
        XCTAssertEqual(Vector.unitZ, .init(x: 0, y: 0, z: 1))
    }
    
    func testCross() {
        let v1 = Vector(x: 1, y: 2, z: 3)
        let v2 = Vector(x: 7, y: 11, z: 13)
        
        let result = v1.cross(v2)
        
        XCTAssertEqual(result.x, -7.0)
        XCTAssertEqual(result.y, 8.0)
        XCTAssertEqual(result.z, -3.0)
    }
    
    func testCross_oppositVectors() {
        let v1 = Vector(x: 1, y: 2, z: 3)
        let v2 = Vector(x: -1, y: -2, z: -3)
        
        let result = v1.cross(v2)
        
        XCTAssertEqual(result.x, 0)
        XCTAssertEqual(result.y, 0)
        XCTAssertEqual(result.z, 0)
    }
    
    func testCross_perpendicularVectors() {
        let v1 = Vector(x: 3, y: 3, z: 0)
        let v2 = Vector(x: 0, y: 3, z: 3)
        
        let result = v1.cross(v2)
        
        XCTAssertEqual(result.x, 9.0)
        XCTAssertEqual(result.y, -9.0)
        XCTAssertEqual(result.z, 9.0)
    }

    func testTripleProduct() {
        let a = Vector(x: 20, y: 3, z: 4)
        let b = Vector(x: -5, y: 15, z: 8)
        let c = Vector.zero

        let ab = b - a
        let ac = c - a

        let result = ab.tripleProduct(ac, ab)

        assertEqual(
            result,
            .init(x: -4500.0, y: -7731.0, z: -4932.0),
            accuracy: 1e-15
        )
    }
}
