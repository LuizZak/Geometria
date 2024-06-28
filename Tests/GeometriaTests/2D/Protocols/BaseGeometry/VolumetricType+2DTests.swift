import XCTest
import Geometria
import TestCommons

class VolumetricType_2DTests: XCTestCase {
    func testContainsXY() {
        let sut = TestVolumetricType<Vector2D>()
        
        XCTAssertTrue(sut.contains(x: 1, y: 2))
        
        XCTAssertEqual(sut.queriedPoint, .init(x: 1, y: 2))
    }
}

private class TestVolumetricType<Vector: VectorComparable>: VolumetricType {
    var queriedPoint: Vector?
    
    func contains(_ vector: Vector) -> Bool {
        queriedPoint = vector
        return true
    }
}
