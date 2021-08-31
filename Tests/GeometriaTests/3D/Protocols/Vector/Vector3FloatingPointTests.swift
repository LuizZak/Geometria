import XCTest
import Geometria

class Vector3FloatingPointTests: XCTestCase {
    typealias Vector = Vector3D
    
    func testAddition_floatingPoint_binaryNumber() {
        let vec1 = Vector(x: 1, y: 2, z: 3)
        let vec2 = Vector3i(x: 4, y: 5, z: 6)
        
        XCTAssertEqual(vec2 + vec1, Vector(x: 5, y: 7, z: 9))
        XCTAssertEqual(vec1 + vec2, Vector(x: 5, y: 7, z: 9))
    }
    
    func testSubtraction_floatingPoint_binaryNumber() {
        let vec1 = Vector(x: 1, y: 2, z: 3)
        let vec2 = Vector3i(x: 5, y: 7, z: 11)
        
        XCTAssertEqual(vec2 - vec1, Vector(x: 4, y: 5, z: 8))
        XCTAssertEqual(vec1 - vec2, Vector(x: -4, y: -5, z: -8))
    }
    
    func testMultiplication_floatingPoint_binaryNumber() {
        let vec1 = Vector(x: 1, y: 2, z: 3)
        let vec2 = Vector3i(x: 4, y: 5, z: 6)
        
        XCTAssertEqual(vec2 * vec1, Vector(x: 4, y: 10, z: 18))
        XCTAssertEqual(vec1 * vec2, Vector(x: 4, y: 10, z: 18))
    }
    
    func testDivision_floatingPoint_binaryNumber() {
        let vec1 = Vector(x: 1, y: 2, z: 3)
        let vec2 = Vector3i(x: 4, y: 5, z: 6)
        
        XCTAssertEqual(vec2 / vec1, Vector(x: 4, y: 2.5, z: 2))
        XCTAssertEqual(vec1 / vec2, Vector(x: 0.25, y: 0.4, z: 0.5))
    }
    
    func testAddition_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector(x: 1, y: 2, z: 3)
        let vec2 = Vector3i(x: 4, y: 5, z: 6)
        
        vec1 += vec2
        
        XCTAssertEqual(vec1, Vector(x: 5, y: 7, z: 9))
    }
    
    func testSubtraction_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector(x: 1, y: 2, z: 3)
        let vec2 = Vector3i(x: 5, y: 7, z: 11)
        
        vec1 -= vec2
        
        XCTAssertEqual(vec1, Vector(x: -4, y: -5, z: -8))
    }
    
    func testMultiplication_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector(x: 1, y: 2, z: 3)
        let vec2 = Vector3i(x: 4, y: 5, z: 6)
        
        vec1 *= vec2
        
        XCTAssertEqual(vec1, Vector(x: 4, y: 10, z: 18))
    }
    
    func testDivision_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector(x: 1, y: 2, z: 3)
        let vec2 = Vector3i(x: 4, y: 5, z: 6)
        
        vec1 /= vec2
        
        XCTAssertEqual(vec1, Vector(x: 0.25, y: 0.4, z: 0.5))
    }
}
