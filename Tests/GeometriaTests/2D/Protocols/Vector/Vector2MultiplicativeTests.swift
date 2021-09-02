import XCTest
import Geometria

class Vector2MultiplicativeTests: XCTestCase {
    typealias Vector = Vector2D
    
    func testUnitX() {
        XCTAssertEqual(Vector.unitX, .init(x: 1, y: 0))
    }
    
    func testUnitY() {
        XCTAssertEqual(Vector.unitY, .init(x: 0, y: 1))
    }
}
