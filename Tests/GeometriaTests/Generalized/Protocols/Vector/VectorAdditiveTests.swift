import XCTest
import Geometria

class VectorAdditiveTests: XCTestCase {
    func testEmptyInit() {
        let sut = TestVector()
        
        XCTAssertEqual(sut.v, .zero)
    }
}

// MARK: - Test Vector

extension VectorAdditiveTests {
    fileprivate struct TestVector: VectorAdditive {
        typealias Scalar = Double
        
        static var zero = VectorAdditiveTests.TestVector()
        
        var scalarCount: Int = 1
        
        subscript(index: Int) -> Scalar {
            get {
                0
            }
            set(newValue) {
                
            }
        }
        
        
        var v: Scalar
        
        init(repeating scalar: Double) {
            v = scalar
        }
        
        static func + (lhs: Self, rhs: Self) -> Self {
            return Self()
        }
        
        static func - (lhs: Self, rhs: Self) -> Self {
            return Self()
        }
        
        static func + (lhs: Self, rhs: Scalar) -> Self {
            return Self()
        }
        
        static func - (lhs: Self, rhs: Scalar) -> Self {
            return Self()
        }
        
        static func += (lhs: inout Self, rhs: Self) {
            lhs = Self()
        }
        
        static func -= (lhs: inout Self, rhs: Self) {
            lhs = Self()
        }
        
        static func += (lhs: inout Self, rhs: Scalar) {
            lhs = Self()
        }
        
        static func -= (lhs: inout Self, rhs: Scalar) {
            lhs = Self()
        }
    }
}
