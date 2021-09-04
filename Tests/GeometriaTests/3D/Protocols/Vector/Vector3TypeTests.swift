import XCTest
@testable import Geometria

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
    
    func testTake() {
        let sut = Vector3D(x: 1, y: 2, z: 3)
        
        XCTAssertEqual(sut.take.underlying, sut)
    }
    
    func testInitRepeating() {
        let sut = Vector3D(repeating: 1)
        
        XCTAssertEqual(sut.x, 1)
        XCTAssertEqual(sut.y, 1)
        XCTAssertEqual(sut.z, 1)
    }
    
    func testInitWithVector2Z() {
        let v2 = Vector2D(x: 1, y: 2)
        
        let result = Vector3D(v2, z: 3)
        
        XCTAssertEqual(result.x, 1)
        XCTAssertEqual(result.y, 2)
        XCTAssertEqual(result.z, 3)
    }
    
    func testMaximalComponentIndex() {
        XCTAssertEqual(Vector3D(x: 4, y: 2, z: 3).maximalComponentIndex, 0)
        XCTAssertEqual(Vector3D(x: 4, y: 3, z: 2).maximalComponentIndex, 0)
        XCTAssertEqual(Vector3D(x: 1, y: 4, z: 3).maximalComponentIndex, 1)
        XCTAssertEqual(Vector3D(x: 3, y: 4, z: 1).maximalComponentIndex, 1)
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: 4).maximalComponentIndex, 2)
        XCTAssertEqual(Vector3D(x: 3, y: 2, z: 4).maximalComponentIndex, 2)
    }
    
    func testMaximalComponentIndex_equalMaxXY() {
        XCTAssertEqual(Vector3D(x: 4, y: 4, z: 3).maximalComponentIndex, 1)
    }
    
    func testMaximalComponentIndex_equalMaxXZ() {
        XCTAssertEqual(Vector3D(x: 4, y: 2, z: 4).maximalComponentIndex, 2)
    }
    
    func testMaximalComponentIndex_equalMaxYZ() {
        XCTAssertEqual(Vector3D(x: 1, y: 4, z: 4).maximalComponentIndex, 2)
    }
    
    func testMinimalComponentIndex() {
        XCTAssertEqual(Vector3D(x: -1, y: 2, z: 3).minimalComponentIndex, 0)
        XCTAssertEqual(Vector3D(x: -1, y: 3, z: 2).minimalComponentIndex, 0)
        XCTAssertEqual(Vector3D(x: 1, y: -2, z: 3).minimalComponentIndex, 1)
        XCTAssertEqual(Vector3D(x: 3, y: -2, z: 1).minimalComponentIndex, 1)
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: -3).minimalComponentIndex, 2)
        XCTAssertEqual(Vector3D(x: 2, y: 1, z: -3).minimalComponentIndex, 2)
    }
    
    func testMinimalComponentIndex_equalMinXY() {
        XCTAssertEqual(Vector3D(x: -1, y: -1, z: 3).minimalComponentIndex, 1)
    }
    
    func testMinimalComponentIndex_equalMinXZ() {
        XCTAssertEqual(Vector3D(x: -1, y: 2, z: -1).minimalComponentIndex, 2)
    }
    
    func testMinimalComponentIndex_equalMinYZ() {
        XCTAssertEqual(Vector3D(x: 1, y: -1, z: -1).minimalComponentIndex, 2)
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
