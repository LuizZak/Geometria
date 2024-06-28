import XCTest
import Geometria
import TestCommons

class VectorAdditiveTests: XCTestCase {
    typealias Vector = Vector2D

    func testEmptyInit() {
        let sut = TestVector()
        
        XCTAssertEqual(sut.v, .zero)
    }

    func testNonZeroScalarCount() {
        let vec0 = TestVector(repeating: 0)
        let vec1 = TestVector(repeating: 1)

        XCTAssertEqual(vec0.nonZeroScalarCount, 0)
        XCTAssertEqual(vec1.nonZeroScalarCount, 1)
    }

    func testAddition_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector(x: 3, y: 4)
        
        vec1 += vec2
        
        XCTAssertEqual(vec1, Vector(x: 4, y: 6))
    }
    
    func testAddition_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        
        vec1 += 1
        
        XCTAssertEqual(vec1, Vector(x: 2, y: 3))
    }
    
    func testSubtraction_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector(x: 3, y: 5)
        
        vec1 -= vec2
        
        XCTAssertEqual(vec1, Vector(x: -2, y: -3))
    }
    
    func testSubtraction_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        
        vec1 -= 1
        
        XCTAssertEqual(vec1, Vector(x: 0, y: 1))
    }
}

// MARK: - Test Vector

extension VectorAdditiveTests {
    fileprivate struct TestVector: VectorAdditive {
        typealias Scalar = Double
        
        static var zero = TestVector()
        
        var scalarCount: Int = 1
        
        subscript(index: Int) -> Scalar {
            get {
                v
            }
            set {
                v = newValue
            }
        }
        
        var v: Scalar
        
        init(repeating scalar: Double) {
            v = scalar
        }
        
        static func + (lhs: Self, rhs: Self) -> Self {
            Self()
        }
        
        static func - (lhs: Self, rhs: Self) -> Self {
            Self()
        }
        
        static func + (lhs: Self, rhs: Scalar) -> Self {
            Self()
        }
        
        static func - (lhs: Self, rhs: Scalar) -> Self {
            Self()
        }
    }
}
