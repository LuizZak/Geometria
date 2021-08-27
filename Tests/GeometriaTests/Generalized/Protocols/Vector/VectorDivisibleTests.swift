import XCTest
import Geometria

class VectorDivisibleTests: XCTestCase {
    func testAverageVector() {
        let list = [
            Vector2D(x: -1, y: -1),
            Vector2D(x: 0, y: 0),
            Vector2D(x: 10, y: 7)
        ]
        
        XCTAssertEqual(list.averageVector(), Vector2D(x: 3, y: 2))
    }
    
    func testAverageVector_emptyCollection() {
        let list: [Vector2D] = []
        
        XCTAssertEqual(list.averageVector(), Vector2D.zero)
    }
}
