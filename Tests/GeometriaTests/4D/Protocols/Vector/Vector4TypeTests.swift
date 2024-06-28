import XCTest
import Geometria
import TestCommons

class Vector4TypeTests: XCTestCase {
    private typealias Vector = TestVector
    
    func testScalarCount() {
        let sut = Vector(x: 0, y: 0, z: 0, w: 0)
        
        XCTAssertEqual(sut.scalarCount, 4)
    }
    
    func testSubscript() {
        let sut = Vector(x: 0, y: 1, z: 2, w: 3)
        
        XCTAssertEqual(sut[0], 0)
        XCTAssertEqual(sut[1], 1)
        XCTAssertEqual(sut[2], 2)
        XCTAssertEqual(sut[3], 3)
    }
    
    func testSubscript_set() {
        var sut = Vector(x: 0, y: 0, z: 0, w: 0)
        
        sut[0] = 1
        sut[1] = 2
        sut[2] = 3
        sut[3] = 4
        
        XCTAssertEqual(sut.x, 1)
        XCTAssertEqual(sut.y, 2)
        XCTAssertEqual(sut.z, 3)
        XCTAssertEqual(sut.w, 4)
    }
    
    func testInitWithVector2ZW() {
        let vec = Vector2D(x: 1, y: 2)
        
        let result = Vector(vec, z: 3, w: 4)
        
        XCTAssertEqual(result.x, 1)
        XCTAssertEqual(result.y, 2)
        XCTAssertEqual(result.z, 3)
        XCTAssertEqual(result.w, 4)
    }
    
    func testInitWithVector3W() {
        let vec = Vector3D(x: 1, y: 2, z: 3)
        
        let result = Vector(vec, w: 4)
        
        XCTAssertEqual(result.x, 1)
        XCTAssertEqual(result.y, 2)
        XCTAssertEqual(result.z, 3)
        XCTAssertEqual(result.w, 4)
    }
    
    func testInitWithVector4() {
        let vec = Vector(x: 1, y: 2, z: 3, w: 4)
        
        let result = Vector(vec)
        
        XCTAssertEqual(result.x, 1)
        XCTAssertEqual(result.y, 2)
        XCTAssertEqual(result.z, 3)
        XCTAssertEqual(result.w, 4)
    }
    
    func testMaximalComponentIndex() {
        // Permutation: X > ...
        XCTAssertEqual(Vector(x: 3, y: 2, z: 1, w: 0).maximalComponentIndex, 0)
        XCTAssertEqual(Vector(x: 3, y: 1, z: 2, w: 0).maximalComponentIndex, 0)
        XCTAssertEqual(Vector(x: 3, y: 0, z: 1, w: 2).maximalComponentIndex, 0)
        XCTAssertEqual(Vector(x: 3, y: 0, z: 2, w: 1).maximalComponentIndex, 0)
        XCTAssertEqual(Vector(x: 3, y: 2, z: 0, w: 1).maximalComponentIndex, 0)
        
        // Permutation: Y > ...
        XCTAssertEqual(Vector(x: 0, y: 3, z: 2, w: 1).maximalComponentIndex, 1)
        XCTAssertEqual(Vector(x: 0, y: 3, z: 1, w: 2).maximalComponentIndex, 1)
        XCTAssertEqual(Vector(x: 2, y: 3, z: 0, w: 1).maximalComponentIndex, 1)
        XCTAssertEqual(Vector(x: 1, y: 3, z: 0, w: 2).maximalComponentIndex, 1)
        XCTAssertEqual(Vector(x: 1, y: 3, z: 2, w: 0).maximalComponentIndex, 1)
        
        // Permutation: Z > ...
        XCTAssertEqual(Vector(x: 1, y: 0, z: 3, w: 2).maximalComponentIndex, 2)
        XCTAssertEqual(Vector(x: 2, y: 0, z: 3, w: 1).maximalComponentIndex, 2)
        XCTAssertEqual(Vector(x: 1, y: 2, z: 3, w: 0).maximalComponentIndex, 2)
        XCTAssertEqual(Vector(x: 2, y: 1, z: 3, w: 0).maximalComponentIndex, 2)
        XCTAssertEqual(Vector(x: 0, y: 1, z: 3, w: 2).maximalComponentIndex, 2)
        
        // Permutation: W > ...
        XCTAssertEqual(Vector(x: 2, y: 1, z: 0, w: 3).maximalComponentIndex, 3)
        XCTAssertEqual(Vector(x: 1, y: 2, z: 0, w: 3).maximalComponentIndex, 3)
        XCTAssertEqual(Vector(x: 0, y: 1, z: 2, w: 3).maximalComponentIndex, 3)
        XCTAssertEqual(Vector(x: 0, y: 2, z: 1, w: 3).maximalComponentIndex, 3)
        XCTAssertEqual(Vector(x: 2, y: 0, z: 1, w: 3).maximalComponentIndex, 3)
    }
    
    func testMinimalComponentIndex() {
        // Permutation: X < ...
        XCTAssertEqual(Vector(x: -1, y: 2, z: 1, w: 0).minimalComponentIndex, 0)
        XCTAssertEqual(Vector(x: -1, y: 1, z: 2, w: 0).minimalComponentIndex, 0)
        XCTAssertEqual(Vector(x: -1, y: 0, z: 1, w: 2).minimalComponentIndex, 0)
        XCTAssertEqual(Vector(x: -1, y: 0, z: 2, w: 1).minimalComponentIndex, 0)
        XCTAssertEqual(Vector(x: -1, y: 2, z: 0, w: 1).minimalComponentIndex, 0)
        
        // Permutation: Y < ...
        XCTAssertEqual(Vector(x: 0, y: -1, z: 2, w: 1).minimalComponentIndex, 1)
        XCTAssertEqual(Vector(x: 0, y: -1, z: 1, w: 2).minimalComponentIndex, 1)
        XCTAssertEqual(Vector(x: 2, y: -1, z: 0, w: 1).minimalComponentIndex, 1)
        XCTAssertEqual(Vector(x: 1, y: -1, z: 0, w: 2).minimalComponentIndex, 1)
        XCTAssertEqual(Vector(x: 1, y: -1, z: 2, w: 0).minimalComponentIndex, 1)
        
        // Permutation: Z < ...
        XCTAssertEqual(Vector(x: 1, y: 0, z: -1, w: 2).minimalComponentIndex, 2)
        XCTAssertEqual(Vector(x: 2, y: 0, z: -1, w: 1).minimalComponentIndex, 2)
        XCTAssertEqual(Vector(x: 1, y: 2, z: -1, w: 0).minimalComponentIndex, 2)
        XCTAssertEqual(Vector(x: 2, y: 1, z: -1, w: 0).minimalComponentIndex, 2)
        XCTAssertEqual(Vector(x: 0, y: 1, z: -1, w: 2).minimalComponentIndex, 2)
        
        // Permutation: W < ...
        XCTAssertEqual(Vector(x: 2, y: 1, z: 0, w: -1).minimalComponentIndex, 3)
        XCTAssertEqual(Vector(x: 1, y: 2, z: 0, w: -1).minimalComponentIndex, 3)
        XCTAssertEqual(Vector(x: 0, y: 1, z: 2, w: -1).minimalComponentIndex, 3)
        XCTAssertEqual(Vector(x: 0, y: 2, z: 1, w: -1).minimalComponentIndex, 3)
        XCTAssertEqual(Vector(x: 2, y: 0, z: 1, w: -1).minimalComponentIndex, 3)
    }
    
    func testMaximalComponent() {
        XCTAssertEqual(Vector(x: 3, y: 2, z: 1, w: 0).maximalComponent, 3)
        XCTAssertEqual(Vector(x: 0, y: 3, z: 2, w: 1).maximalComponent, 3)
        XCTAssertEqual(Vector(x: 1, y: 0, z: 3, w: 2).maximalComponent, 3)
        XCTAssertEqual(Vector(x: 2, y: 1, z: 0, w: 3).maximalComponent, 3)
    }
    
    func testMinimalComponent() {
        XCTAssertEqual(Vector(x: 0, y: 3, z: 2, w: 1).minimalComponent, 0)
        XCTAssertEqual(Vector(x: 1, y: 0, z: 3, w: 2).minimalComponent, 0)
        XCTAssertEqual(Vector(x: 2, y: 1, z: 0, w: 3).minimalComponent, 0)
        XCTAssertEqual(Vector(x: 3, y: 2, z: 1, w: 0).minimalComponent, 0)
    }
}

// MARK: - Test Vector

extension Vector4TypeTests {
    fileprivate struct TestVector: Vector4Type, VectorComparable {
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
        
        static func pointwiseMin(_ lhs: Vector4TypeTests.TestVector, _ rhs: Vector4TypeTests.TestVector) -> Vector4TypeTests.TestVector {
            .init(x: min(lhs.x, rhs.x),
                  y: min(lhs.y, rhs.y),
                  z: min(lhs.z, rhs.z),
                  w: min(lhs.w, rhs.w))
        }
        
        static func pointwiseMax(_ lhs: Vector4TypeTests.TestVector, _ rhs: Vector4TypeTests.TestVector) -> Vector4TypeTests.TestVector {
            .init(x: max(lhs.x, rhs.x),
                  y: max(lhs.y, rhs.y),
                  z: max(lhs.z, rhs.z),
                  w: max(lhs.w, rhs.w))
        }
    }
}
