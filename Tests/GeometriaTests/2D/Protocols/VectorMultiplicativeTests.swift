import XCTest
import Geometria

class VectorMultiplicativeTests: XCTestCase {
    typealias Vector = Vector2D

    func testDistanceSquared() {
        let v1 = Vector(x: 10, y: 20)
        let v2 = Vector(x: 30, y: 40)

        XCTAssertEqual(v1.distanceSquared(to: v2), 800)
    }

    func testDistanceSquared_zeroDistance() {
        let vec = Vector2D(x: 10, y: 20)

        XCTAssertEqual(vec.distanceSquared(to: vec), 0.0)
    }
}