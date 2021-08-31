import XCTest
import Geometria

class VolumetricType_3DTests: XCTestCase {
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
