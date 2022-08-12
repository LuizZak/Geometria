import XCTest
import Geometria

class Vector4AdditiveTests: XCTestCase {
    private typealias Vector = TestVector

    func testInitWithVector2() {
        let v2 = Vector2D(x: 1, y: 2)
        
        let result = Vector(v2)
        
        XCTAssertEqual(result.x, 1)
        XCTAssertEqual(result.y, 2)
        XCTAssertEqual(result.z, 0)
        XCTAssertEqual(result.w, 0)
    }
    
    func testInitWithVector3() {
        let v2 = Vector3D(x: 1, y: 2, z: 3)
        
        let result = Vector(v2)
        
        XCTAssertEqual(result.x, 1)
        XCTAssertEqual(result.y, 2)
        XCTAssertEqual(result.z, 3)
        XCTAssertEqual(result.w, 0)
    }
}

// MARK: - Test Vector

extension Vector4AdditiveTests {
    fileprivate struct TestVector: Vector4Additive {
        static var zero = Vector4AdditiveTests.TestVector()
        
        typealias Scalar = Double
        typealias SubVector3 = Vector3D
        typealias TakeDimensions = Vector4D.TakeDimensions
        
        var x: Scalar
        var y: Scalar
        var z: Scalar
        var w: Scalar
        
        init(x: Scalar, y: Scalar, z: Scalar, w: Scalar) {
            self.x = x
            self.y = y
            self.z = z
            self.w = w
        }
        
        init(repeating scalar: Double) {
            (x, y, z, w) = (scalar, scalar, scalar, scalar)
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
