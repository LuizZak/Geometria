import XCTest
import Geometria

class VolumetricTypeTests: XCTestCase {
    func testContainsXY() {
        let sut = TestVolumetricType<Vector2D>()
        
        XCTAssertTrue(sut.contains(x: 1, y: 2))
        
        XCTAssertEqual(sut.queriedPoint, .init(x: 1, y: 2))
    }
    
    func testContainsXYZ() {
        let sut = TestVolumetricType<Vector3D>()
        
        XCTAssertTrue(sut.contains(x: 1, y: 2, z: 3))
        
        XCTAssertEqual(sut.queriedPoint, .init(x: 1, y: 2, z: 3))
    }
}

private class TestVolumetricType<Vector: VectorComparable>: VolumetricType {
    var queriedPoint: Vector?
    
    func contains(_ vector: Vector) -> Bool {
        queriedPoint = vector
        return true
    }
}
