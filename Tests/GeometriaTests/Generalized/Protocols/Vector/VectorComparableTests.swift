import XCTest
import Geometria

class VectorComparableTests: XCTestCase {
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
}
