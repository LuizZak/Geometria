import XCTest
import Geometria

class Vector2Type_Tests: XCTestCase {
    typealias Vector = Vector2D
    
    func testMin() {
        let vec1 = Vector2i(x: 2, y: -3)
        let vec2 = Vector2i(x: -1, y: 4)
        
        XCTAssertEqual(min(vec1, vec2), Vector2i(x: -1, y: -3))
    }
    
    func testMax() {
        let vec1 = Vector2i(x: 2, y: -3)
        let vec2 = Vector2i(x: -1, y: 4)
        
        XCTAssertEqual(max(vec1, vec2), Vector2i(x: 2, y: 4))
    }
    
    func testRound() {
        let vec = Vector2D(x: 0.5, y: 1.6)
        
        XCTAssertEqual(round(vec), Vector2D(x: 1, y: 2))
    }
    
    func testFloor() {
        let vec = Vector2D(x: 0.5, y: 1.6)
        
        XCTAssertEqual(floor(vec), Vector2D(x: 0, y: 1))
    }
    
    func testCeil() {
        let vec = Vector2D(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.ceil(), Vector2D(x: 1, y: 2))
        XCTAssertEqual(ceil(vec), Vector2D(x: 1, y: 2))
    }
    
    func testAbsolute() {
        let vec = Vector2D(x: -1, y: -2)
        
        XCTAssertEqual(abs(vec), Vector2D(x: 1, y: 2))
    }
    
    func testAbsolute_mixedPositiveNegative() {
        let vec = Vector2D(x: -1, y: 2)
        
        XCTAssertEqual(abs(vec), Vector2D(x: 1, y: 2))
    }
    
    func testAbsolute_positive() {
        let vec = Vector2D(x: 1, y: 2)
        
        XCTAssertEqual(abs(vec), Vector2D(x: 1, y: 2))
    }
}
