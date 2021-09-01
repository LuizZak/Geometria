import XCTest
import Geometria

class Vector3TypeTests: XCTestCase {
    func testScalarCount() {
        XCTAssertEqual(Vector3D().scalarCount, 3)
    }
    
    func testSubscript_x() {
        XCTAssertEqual(Vector3D(x: 0, y: 2, z: 3)[0], 0)
    }
    
    func testSubscript_x_set() {
        var sut = Vector3D.zero
        
        sut[0] = 3
        
        XCTAssertEqual(sut, .init(x: 3, y: 0, z: 0))
    }
    
    func testSubscript_y() {
        XCTAssertEqual(Vector3D(x: 0, y: 2, z: 3)[1], 2)
    }
    
    func testSubscript_y_set() {
        var sut = Vector3D.zero
        
        sut[1] = 3
        
        XCTAssertEqual(sut, .init(x: 0, y: 3, z: 0))
    }
    
    func testSubscript_z() {
        XCTAssertEqual(Vector3D(x: 0, y: 2, z: 3)[2], 3)
    }
    
    func testSubscript_z_set() {
        var sut = Vector3D.zero
        
        sut[2] = 3
        
        XCTAssertEqual(sut, .init(x: 0, y: 0, z: 3))
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
