import XCTest
import Geometria

class Vector3TypeTests: XCTestCase {
    func testMinimalComponent() {
        XCTAssertEqual(Vector3D(x: -1, y: 2, z: 3).minimalComponent, -1)
        XCTAssertEqual(Vector3D(x: 1, y: -2, z: 3).minimalComponent, -2)
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: -3).minimalComponent, -3)
    }
    
    func testMaximalComponent() {
        XCTAssertEqual(Vector3D(x: -1, y: 2, z: 3).maximalComponent, 3)
        XCTAssertEqual(Vector3D(x: 1, y: -2, z: 3).maximalComponent, 3)
        XCTAssertEqual(Vector3D(x: 1, y: 3, z: 2).maximalComponent, 3)
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: -3).maximalComponent, 2)
    }
}
