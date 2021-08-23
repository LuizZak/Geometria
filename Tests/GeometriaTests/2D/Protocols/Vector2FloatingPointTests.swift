import XCTest
import Geometria

class Vector2FloatingPointTests: XCTestCase {
    typealias Vector = Vector2D
    
    func testAddition_floatingPoint_binaryNumber() {
        let vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 4)
        
        XCTAssertEqual(vec2 + vec1, Vector(x: 4, y: 6))
        XCTAssertEqual(vec1 + vec2, Vector(x: 4, y: 6))
    }
    
    func testSubtraction_floatingPoint_binaryNumber() {
        let vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 5)
        
        XCTAssertEqual(vec2 - vec1, Vector(x: 2, y: 3))
        XCTAssertEqual(vec1 - vec2, Vector(x: -2, y: -3))
    }
    
    func testMultiplication_floatingPoint_binaryNumber() {
        let vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 4)
        
        XCTAssertEqual(vec2 * vec1, Vector(x: 3, y: 8))
        XCTAssertEqual(vec1 * vec2, Vector(x: 3, y: 8))
    }
    
    func testDivision_floatingPoint_binaryNumber() {
        let vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 4)
        
        XCTAssertEqual(vec2 / vec1, Vector(x: 3, y: 2))
        XCTAssertEqual(vec1 / vec2, Vector(x: 0.3333333333333333, y: 0.5))
    }
    
    func testAddition_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 4)
        
        vec1 += vec2
        
        XCTAssertEqual(vec1, Vector(x: 4, y: 6))
    }
    
    func testSubtraction_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 5)
        
        vec1 -= vec2
        
        XCTAssertEqual(vec1, Vector(x: -2, y: -3))
    }
    
    func testMultiplication_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 4)
        
        vec1 *= vec2
        
        XCTAssertEqual(vec1, Vector(x: 3, y: 8))
    }
    
    func testDivision_floatingPoint_binaryNumber_inPLace() {
        var vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector2i(x: 3, y: 4)
        
        vec1 /= vec2
        
        XCTAssertEqual(vec1, Vector(x: 0.3333333333333333, y: 0.5))
    }    
}
