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
    
    func testLengthSquared() {
        XCTAssertEqual(Vector2D(x: 3.0, y: 2.0).lengthSquared, 13.0)
    }
    
    func testDot() {
        let v1 = Vector2D(x: 2, y: -3)
        let v2 = Vector2D(x: 5, y: 7)
        
        XCTAssertEqual(v1.dot(v2), -11.0)
    }
    
    func testLerp() {
        let v1 = Vector2D(x: 10, y: 20)
        let v2 = Vector2D(x: 30, y: 40)
        
        XCTAssertEqual(
            Vector2D.lerp(start: v1, end: v2, amount: -1),
            Vector2D(x: -10, y: 0)
        )
        XCTAssertEqual(
            Vector2D.lerp(start: v1, end: v2, amount: 0),
            v1
        )
        XCTAssertEqual(
            Vector2D.lerp(start: v1, end: v2, amount: 0.5),
            Vector2D(x: 20, y: 30)
        )
        XCTAssertEqual(
            Vector2D.lerp(start: v1, end: v2, amount: 1),
            v2
        )
        XCTAssertEqual(
            Vector2D.lerp(start: v1, end: v2, amount: 2),
            Vector2D(x: 50, y: 60)
        )
    }

    func testMultiplication_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector(x: 3, y: 4)
        
        vec1 *= vec2
        
        XCTAssertEqual(vec1, Vector(x: 3, y: 8))
    }
    
    func testMultiplication_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        
        vec1 *= 2
        
        XCTAssertEqual(vec1, Vector(x: 2, y: 4))
    }
}
