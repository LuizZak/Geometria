import XCTest
import Geometria

class VectorFloatingPointTests: XCTestCase {
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
}
