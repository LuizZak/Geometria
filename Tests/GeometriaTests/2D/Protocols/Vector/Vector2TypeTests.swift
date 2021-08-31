import XCTest
import Geometria

class Vector2TypeTests: XCTestCase {
    func testMinimalComponent() {
        XCTAssertEqual(Vector2D(x: -1, y: 2).minimalComponent, -1)
        XCTAssertEqual(Vector2D(x: 1, y: -2).minimalComponent, -2)
    }
    
    func testMaximalComponent() {
        XCTAssertEqual(Vector2D(x: -1, y: 2).maximalComponent, 2)
        XCTAssertEqual(Vector2D(x: 1, y: -2).maximalComponent, 1)
    }
}
