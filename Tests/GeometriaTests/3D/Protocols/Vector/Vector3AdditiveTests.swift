import XCTest
import Geometria
import TestCommons

class Vector3AdditiveTests: XCTestCase {
    func testInitWithVector2() {
        let v2 = Vector2D(x: 1, y: 2)
        
        let result = Vector3D(v2)
        
        XCTAssertEqual(result.x, 1)
        XCTAssertEqual(result.y, 2)
        XCTAssertEqual(result.z, 0)
    }
}
