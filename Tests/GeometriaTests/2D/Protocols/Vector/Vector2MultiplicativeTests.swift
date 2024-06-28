import XCTest
import Geometria
import TestCommons

class Vector2MultiplicativeTests: XCTestCase {
    typealias Vector = Vector2D
    
    func testUnitX() {
        XCTAssertEqual(Vector.unitX, .init(x: 1, y: 0))
    }
    
    func testUnitY() {
        XCTAssertEqual(Vector.unitY, .init(x: 0, y: 1))
    }
    
    func testCross() {
        let v1 = Vector(x: 10, y: 20)
        let v2 = Vector(x: 30, y: 40)
        
        XCTAssertEqual(v1.cross(v2), -200)
    }

    func testTripleProduct() {
        let a = Vector(x: 20, y: 3)
        let b = Vector(x: -5, y: 15)
        let c = Vector.zero

        let ab = b - a
        let ac = c - a

        let result = ab.tripleProduct(ac, ab)

        assertEqual(
            result,
            .init(x: -3780.0, y: -7875.0),
            accuracy: 1e-15
        )
        assertEqual(
            result.normalized(),
            ab.leftRotated().normalized(),
            accuracy: 1e-15
        )
    }

    func testTripleProduct_flippedOnOrigin() {
        let a = Vector(x: 5, y: -15)
        let b = Vector(x: -20, y: -3)
        let c = Vector.zero

        let ab = b - a
        let ac = c - a

        let result = ab.tripleProduct(ac, ab)

        assertEqual(
            result,
            .init(x: 3780.0, y: 7875.0),
            accuracy: 1e-15
        )
        assertEqual(
            result.normalized(),
            ab.rightRotated().normalized(),
            accuracy: 1e-15
        )
    }
}
