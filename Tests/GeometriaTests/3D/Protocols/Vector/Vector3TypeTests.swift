import XCTest
import Geometria

class Vector3TypeTests: XCTestCase {
    func testScalarCount() {
        XCTAssertEqual(Vector3D().scalarCount, 3)
    }
    
    func testSubscript_x() {
        XCTAssertEqual(Vector3D(x: 0, y: 2, z: 3)[0], 0)
    }
    
    func testSubscript_y() {
        XCTAssertEqual(Vector3D(x: 0, y: 2, z: 3)[1], 2)
    }
    
    func testSubscript_z() {
        XCTAssertEqual(Vector3D(x: 0, y: 2, z: 3)[2], 3)
    }
    
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
