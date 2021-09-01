import XCTest
import Geometria

class VectorSignedTests: XCTestCase {
    func testWithSignOf() {
        let vec1 = Vector2D(x: 5.0, y: -4.0)
        let vec2 = Vector2D(x: -1, y: 1)
        
        XCTAssertEqual(vec1.withSign(of: vec2), .init(x: -5.0, y: 4.0))
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
