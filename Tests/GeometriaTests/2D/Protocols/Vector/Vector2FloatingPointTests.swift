import XCTest
import Geometria
import TestCommons

class Vector2FloatingPointTests: XCTestCase {
    let accuracy: Double = 1.0e-15
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
    
    func testDistanceTo() {
        let v1 = Vector3D(x: 10, y: 20, z: 30)
        let v2 = Vector3D(x: 40, y: 50, z: 60)
        
        XCTAssertEqual(v1.distance(to: v2), 51.96152422706632, accuracy: accuracy)
    }
    
    func testDistanceTo_zeroDistance() {
        let vec = Vector3D(x: 10, y: 20, z: 30)
        
        XCTAssertEqual(vec.distance(to: vec), 0.0)
    }
    
    func testNormalize() {
        var vec = Vector3D(x: -10, y: 20, z: 15.0)
        
        vec.normalize()
        
        assertEqual(vec, Vector3D(x: -0.3713906763541037,
                                  y: 0.7427813527082074,
                                  z: 0.5570860145311556),
                    accuracy: accuracy)
    }
    
    func testNormalize_zero() {
        var vec = Vector3D(x: 0, y: 0, z: 0)
        
        vec.normalize()
        
        XCTAssertEqual(vec, .zero)
    }
    
    func testNormalized() {
        let vec = Vector3D(x: -10, y: 20, z: 15.0)
        
        assertEqual(vec.normalized(), Vector3D(x: -0.3713906763541037,
                                               y: 0.7427813527082074,
                                               z: 0.5570860145311556),
                    accuracy: accuracy)
    }
    
    func testNormalized_zero() {
        let vec = Vector3D(x: 0, y: 0, z: 0)
        
        XCTAssertEqual(vec.normalized(), .zero)
    }
}
