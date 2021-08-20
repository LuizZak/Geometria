import XCTest
import Geometria

class Vector2Tests: XCTestCase {
    let accuracy: Double = 1.0e-15
    
    typealias Vector = Vector2<Int>
    
    func testZero() {
        XCTAssertEqual(Vector.zero.x, 0)
        XCTAssertEqual(Vector.zero.y, 0)
    }
    
    func testUnit() {
        XCTAssertEqual(Vector.unit.x, 1)
        XCTAssertEqual(Vector.unit.y, 1)
    }
    
    func testDescription() {
        XCTAssertEqual(Vector2<Int>(x: 0, y: 1).description,
                       "Vector2<Int>(x: 0, y: 1)")
        XCTAssertEqual(Vector2<Double>(x: 0, y: 1).description,
                       "Vector2<Double>(x: 0.0, y: 1.0)")
    }
    
    func testInit() {
        let sut = Vector(x: 0, y: 1)
        
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 1)
    }
    
    func testEquatable() {
        XCTAssertEqual(Vector(x: 0, y: 1), Vector(x: 0, y: 1))
        XCTAssertNotEqual(Vector(x: 1, y: 1), Vector(x: 0, y: 1))
        XCTAssertNotEqual(Vector(x: 1, y: 0), Vector(x: 0, y: 1))
        XCTAssertNotEqual(Vector(x: 0, y: 0), Vector(x: 0, y: 1))
    }
    
    func testHashable() {
        XCTAssertEqual(Vector(x: 0, y: 1).hashValue, Vector(x: 0, y: 1).hashValue)
        XCTAssertNotEqual(Vector(x: 1, y: 1).hashValue, Vector(x: 0, y: 1).hashValue)
        XCTAssertNotEqual(Vector(x: 1, y: 0).hashValue, Vector(x: 0, y: 1).hashValue)
        XCTAssertNotEqual(Vector(x: 0, y: 0).hashValue, Vector(x: 0, y: 1).hashValue)
    }
}
