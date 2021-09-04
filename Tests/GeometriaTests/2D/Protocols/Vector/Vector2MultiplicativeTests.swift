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
    
    func testCross() {
        let v1 = Vector(x: 10, y: 20)
        let v2 = Vector(x: 30, y: 40)
        
        XCTAssertEqual(v1.cross(v2), -200)
    }
}
