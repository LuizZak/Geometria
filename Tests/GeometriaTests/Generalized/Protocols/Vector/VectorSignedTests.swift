import XCTest
import Geometria
import TestCommons

class VectorSignedTests: XCTestCase {
    func testWithSignOf() {
        let vec1 = Vector3D(x: 5.0, y: -4.0, z: 3.0)
        let vec2 = Vector3D(x: -1.0, y: 1.0, z: 0.0)
        
        XCTAssertEqual(vec1.withSign(of: vec2), .init(x: -5.0, y: 4.0, z: 0.0))
    }
    
    func testAbsolute() {
        let vec = Vector2D(x: -1, y: -2)
        
        XCTAssertEqual(abs(vec), Vector2D(x: 1, y: 2))
    }
    
    func testAbsolute_mixedPositiveNegative() {
        let vec = Vector2D(x: -1, y: 2)
        
        XCTAssertEqual(abs(vec), Vector2D(x: 1, y: 2))
    }
    
    func testAbsolute_positive() {
        let vec = Vector2D(x: 1, y: 2)
        
        XCTAssertEqual(abs(vec), Vector2D(x: 1, y: 2))
    }
}
