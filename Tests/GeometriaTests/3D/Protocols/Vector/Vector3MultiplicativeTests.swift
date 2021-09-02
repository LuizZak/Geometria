import XCTest
import Geometria

class Vector3MultiplicativeTests: XCTestCase {
    typealias Vector = Vector3D
    
    func testUnitX() {
        XCTAssertEqual(Vector.unitX, .init(x: 1, y: 0, z: 0))
    }
    
    func testUnitY() {
        XCTAssertEqual(Vector.unitY, .init(x: 0, y: 1, z: 0))
    }
    
    func testUnitZ() {
        XCTAssertEqual(Vector.unitZ, .init(x: 0, y: 0, z: 1))
    }
}
