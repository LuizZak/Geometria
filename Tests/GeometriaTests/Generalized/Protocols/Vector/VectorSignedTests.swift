import XCTest
import Geometria

class VectorSignedTests: XCTestCase {
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
