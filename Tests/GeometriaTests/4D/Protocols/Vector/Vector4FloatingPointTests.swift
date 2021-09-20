import XCTest
import Geometria

class Vector4FloatingPointTests: XCTestCase {
    typealias Vector = Vector4D
    
    func testAddition_floatingPoint_binaryNumber() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: 5)
        let vec2 = Vector4i(x: 7, y: 11, z: 13, w: 17)
        
        XCTAssertEqual(vec2 + vec1, Vector(x: 8.0, y: 13.0, z: 16.0, w: 22.0))
        XCTAssertEqual(vec1 + vec2, Vector(x: 8.0, y: 13.0, z: 16.0, w: 22.0))
    }
    
    func testSubtraction_floatingPoint_binaryNumber() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: 5)
        let vec2 = Vector4i(x: 7, y: 11, z: 13, w: 17)
        
        XCTAssertEqual(vec2 - vec1, Vector(x: 6.0, y: 9.0, z: 10.0, w: 12.0))
        XCTAssertEqual(vec1 - vec2, Vector(x: -6.0, y: -9.0, z: -10.0, w: -12.0))
    }
    
    func testMultiplication_floatingPoint_binaryNumber() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: 5)
        let vec2 = Vector4i(x: 7, y: 11, z: 13, w: 17)
        
        XCTAssertEqual(vec2 * vec1, Vector(x: 7.0, y: 22.0, z: 39.0, w: 85.0))
        XCTAssertEqual(vec1 * vec2, Vector(x: 7.0, y: 22.0, z: 39.0, w: 85.0))
    }
    
    func testDivision_floatingPoint_binaryNumber() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: 5)
        let vec2 = Vector4i(x: 7, y: 11, z: 13, w: 17)
        
        XCTAssertEqual(vec2 / vec1, Vector(x: 7.0, y: 5.5, z: 4.333333333333333, w: 3.4))
        XCTAssertEqual(vec1 / vec2, Vector(x: 0.14285714285714285, y: 0.18181818181818182, z: 0.23076923076923078, w: 0.29411764705882354))
    }
    
    func testAddition_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector(x: 1, y: 2, z: 3, w: 5)
        let vec2 = Vector4i(x: 7, y: 11, z: 13, w: 17)
        
        vec1 += vec2
        
        XCTAssertEqual(vec1, Vector(x: 8.0, y: 13.0, z: 16.0, w: 22.0))
    }
    
    func testSubtraction_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector(x: 1, y: 2, z: 3, w: 5)
        let vec2 = Vector4i(x: 7, y: 11, z: 13, w: 17)
        
        vec1 -= vec2
        
        XCTAssertEqual(vec1, Vector(x: -6.0, y: -9.0, z: -10.0, w: -12.0))
    }
    
    func testMultiplication_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector(x: 1, y: 2, z: 3, w: 5)
        let vec2 = Vector4i(x: 7, y: 11, z: 13, w: 17)
        
        vec1 *= vec2
        
        XCTAssertEqual(vec1, Vector(x: 7.0, y: 22.0, z: 39.0, w: 85.0))
    }
    
    func testDivision_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector(x: 1, y: 2, z: 3, w: 5)
        let vec2 = Vector4i(x: 7, y: 11, z: 13, w: 17)
        
        vec1 /= vec2
        
        XCTAssertEqual(vec1, Vector(x: 0.14285714285714285, y: 0.18181818181818182, z: 0.23076923076923078, w: 0.29411764705882354))
    }
}
