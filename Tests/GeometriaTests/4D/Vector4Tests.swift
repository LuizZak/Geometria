import XCTest
import Geometria

class Vector4Tests: XCTestCase {
    typealias Vector = Vector4D
    
    func testCodable() throws {
        let sut = Vector(x: 0, y: 1, z: 2, w: 3)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(Vector.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testInitXYZW() {
        let sut = Vector(x: 1, y: 2, z: 3, w: 4)
        
        XCTAssertEqual(sut.x, 1)
        XCTAssertEqual(sut.y, 2)
        XCTAssertEqual(sut.z, 3)
        XCTAssertEqual(sut.w, 4)
    }
    
    func testInitRepeating() {
        let sut = Vector(repeating: 1)
        
        XCTAssertEqual(sut.x, 1)
        XCTAssertEqual(sut.y, 1)
        XCTAssertEqual(sut.z, 1)
        XCTAssertEqual(sut.w, 1)
    }
    
    func testInitWithTuple() {
        let sut = Vector((1, 2, 3, 4))
        
        XCTAssertEqual(sut.x, 1)
        XCTAssertEqual(sut.y, 2)
        XCTAssertEqual(sut.z, 3)
        XCTAssertEqual(sut.w, 4)
    }
    
    func testDescription() {
        let sut = Vector(x: 1, y: 2, z: 3, w: 4)
        
        XCTAssertEqual(sut.description, "Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)")
    }
}

// MARK: VectorComparable Conformance

extension Vector4Tests {
    func testPointwiseMin() {
        let vec1 = Vector(x: 2, y: -3, z: 5, w: 1)
        let vec2 = Vector(x: -1, y: 4, z: -6, w: 0)
        
        XCTAssertEqual(Vector.pointwiseMin(vec1, vec2), Vector(x: -1, y: -3, z: -6, w: 0))
    }
    
    func testPointwiseMax() {
        let vec1 = Vector(x: 2, y: -3, z: 5, w: 1)
        let vec2 = Vector(x: -1, y: 4, z: -6, w: 0)
        
        XCTAssertEqual(Vector.pointwiseMax(vec1, vec2), Vector(x: 2, y: 4, z: 5, w: 1))
    }
    
    func testGreaterThan() {
        XCTAssertTrue(Vector(x: 1, y: 1, z: 1, w: 1) > Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 0, y: 1, z: 0, w: 0) > Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 1, y: 0, z: 0, w: 0) > Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 1, y: 1, z: 0, w: 0) > Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: 0, w: 0) > Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: -1, y: 0, z: 0, w: 0) > Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 0, y: -1, z: 0, w: -1) > Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: -1, w: 0) > Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: -1, y: -1, z: -1, w: -1) > Vector(x: 0, y: 0, z: 0, w: 0))
    }
    
    func testGreaterThanOrEqualTo() {
        XCTAssertTrue(Vector(x: 1, y: 1, z: 1, w: 1) >= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertTrue(Vector(x: 0, y: 1, z: 0, w: 0) >= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertTrue(Vector(x: 1, y: 0, z: 0, w: 0) >= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertTrue(Vector(x: 1, y: 1, z: 0, w: 1) >= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertTrue(Vector(x: 0, y: 0, z: 0, w: 0) >= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: -1, y: 0, z: 0, w: 0) >= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 0, y: -1, z: 0, w: -1) >= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: -1, w: 0) >= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: -1, y: -1, z: -1, w: -1) >= Vector(x: 0, y: 0, z: 0, w: 0))
    }
    
    func testLessThan() {
        XCTAssertFalse(Vector(x: 1, y: 1, z: 1, w: 1) < Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 0, y: 1, z: 0, w: 0) < Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 1, y: 0, z: 0, w: 0) < Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 1, y: 1, z: 0, w: 1) < Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: 0, w: 0) < Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: -1, y: 0, z: 0, w: 0) < Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 0, y: -1, z: 0, w: -1) < Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: -1, w: 0) < Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertTrue(Vector(x: -1, y: -1, z: -1, w: -1) < Vector(x: 0, y: 0, z: 0, w: 0))
    }
    
    func testLessThanOrEqualTo() {
        XCTAssertFalse(Vector(x: 1, y: 1, z: 1, w: 1) <= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 0, y: 1, z: 0, w: 0) <= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 1, y: 0, z: 0, w: 0) <= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertFalse(Vector(x: 1, y: 1, z: 0, w: 1) <= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertTrue(Vector(x: 0, y: 0, z: 0, w: 0) <= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertTrue(Vector(x: -1, y: 0, z: 0, w: 0) <= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertTrue(Vector(x: 0, y: -1, z: 0, w: -1) <= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertTrue(Vector(x: 0, y: 0, z: -1, w: 0) <= Vector(x: 0, y: 0, z: 0, w: 0))
        XCTAssertTrue(Vector(x: -1, y: -1, z: -1, w: 0) <= Vector(x: 0, y: 0, z: 0, w: 0))
    }
}

// MARK: AdditiveArithmetic Conformance

extension Vector4Tests {
    func testZero() {
        let result = Vector.zero
        
        XCTAssertEqual(result.x, 0)
        XCTAssertEqual(result.y, 0)
        XCTAssertEqual(result.z, 0)
        XCTAssertEqual(result.w, 0)
    }
}

// MARK: VectorAdditive Conformance

extension Vector4Tests {
    func testAddition() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        let vec2 = Vector(x: 5, y: 6, z: 7, w: 8)
        
        let result = vec1 + vec2
        
        XCTAssertEqual(result.x, 6)
        XCTAssertEqual(result.y, 8)
        XCTAssertEqual(result.z, 10)
        XCTAssertEqual(result.w, 12)
    }
    
    func testAddition_isCommutative() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        let vec2 = Vector(x: 5, y: 6, z: 7, w: 8)
        
        XCTAssertEqual(vec1 + vec2, vec2 + vec1)
    }
    
    func testAddition_withScalar() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        let num = 5.0
        
        let result = vec1 + num
        
        XCTAssertEqual(result.x, 6)
        XCTAssertEqual(result.y, 7)
        XCTAssertEqual(result.z, 8)
        XCTAssertEqual(result.w, 9)
    }
    
    func testSubtraction() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        let vec2 = Vector(x: 7, y: 11, z: 13, w: 17)
        
        let result = vec1 - vec2
        
        XCTAssertEqual(result.x, -6)
        XCTAssertEqual(result.y, -9)
        XCTAssertEqual(result.z, -10)
        XCTAssertEqual(result.w, -13)
    }
    
    func testSubtraction_withScalar() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        let num = 5.0
        
        let result = vec1 - num
        
        XCTAssertEqual(result.x, -4)
        XCTAssertEqual(result.y, -3)
        XCTAssertEqual(result.z, -2)
        XCTAssertEqual(result.w, -1)
    }
    
    func testAddition_inPlace() {
        var vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        let vec2 = Vector(x: 5, y: 6, z: 7, w: 8)
        
        vec1 += vec2
        
        XCTAssertEqual(vec1.x, 6)
        XCTAssertEqual(vec1.y, 8)
        XCTAssertEqual(vec1.z, 10)
        XCTAssertEqual(vec1.w, 12)
    }
    
    func testAddition_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        
        vec1 += 5.0
        
        XCTAssertEqual(vec1.x, 6)
        XCTAssertEqual(vec1.y, 7)
        XCTAssertEqual(vec1.z, 8)
        XCTAssertEqual(vec1.w, 9)
    }
    
    func testSubtraction_inPlace() {
        var vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        let vec2 = Vector(x: 7, y: 11, z: 13, w: 17)
        
        vec1 -= vec2
        
        XCTAssertEqual(vec1.x, -6)
        XCTAssertEqual(vec1.y, -9)
        XCTAssertEqual(vec1.z, -10)
        XCTAssertEqual(vec1.w, -13)
    }
    
    func testSubtraction_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        
        vec1 -= 5.0
        
        XCTAssertEqual(vec1.x, -4)
        XCTAssertEqual(vec1.y, -3)
        XCTAssertEqual(vec1.z, -2)
        XCTAssertEqual(vec1.w, -1)
    }
}

// MARK: VectorMultiplicative Conformance

extension Vector4Tests {
    func testOne() {
        let result = Vector.one
        
        XCTAssertEqual(result.x, 1)
        XCTAssertEqual(result.y, 1)
        XCTAssertEqual(result.z, 1)
        XCTAssertEqual(result.w, 1)
    }
    
    func testDot() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: -5)
        let vec2 = Vector(x: -7, y: 11, z: 13, w: 17)
        
        let result = vec1.dot(vec2)
        
        XCTAssertEqual(result, -31)
    }
    
    func testMultiplication() {
        let vec1 = Vector(x: -1, y: 2, z: 3, w: 4)
        let vec2 = Vector(x: 5, y: 6, z: -7, w: 8)
        
        let result = vec1 * vec2
        
        XCTAssertEqual(result.x, -5)
        XCTAssertEqual(result.y, 12)
        XCTAssertEqual(result.z, -21)
        XCTAssertEqual(result.w, 32)
    }
    
    func testMultiplication_isCommutative() {
        let vec1 = Vector(x: -1, y: 2, z: 3, w: 4)
        let vec2 = Vector(x: 5, y: 6, z: -7, w: 8)
        
        XCTAssertEqual(vec1 * vec2, vec2 * vec1)
    }
    
    func testMultiplication_inPlace() {
        var vec1 = Vector(x: -1, y: 2, z: 3, w: 4)
        let vec2 = Vector(x: 5, y: 6, z: -7, w: 8)
        
        vec1 *= vec2
        
        XCTAssertEqual(vec1.x, -5)
        XCTAssertEqual(vec1.y, 12)
        XCTAssertEqual(vec1.z, -21)
        XCTAssertEqual(vec1.w, 32)
    }
    
    func testMultiplication_withScalar() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        let num = 5.0
        
        let result = vec1 * num
        
        XCTAssertEqual(result.x, 5)
        XCTAssertEqual(result.y, 10)
        XCTAssertEqual(result.z, 15)
        XCTAssertEqual(result.w, 20)
    }
    
    func testMultiplication_withScalar_isCommutative() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        let num = 5.0
        
        XCTAssertEqual(vec1 * num, num * vec1)
    }
    
    func testMultiplication_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        let num = 5.0
        
        vec1 *= num
        
        XCTAssertEqual(vec1.x, 5)
        XCTAssertEqual(vec1.y, 10)
        XCTAssertEqual(vec1.z, 15)
        XCTAssertEqual(vec1.w, 20)
    }
}

// MARK: VectorSigned Conformance

extension Vector4Tests {
    func testAbsolute() {
        let sut = Vector(x: 0, y: -1, z: 2, w: -3)
        
        let result = sut.absolute
        
        XCTAssertEqual(result.x, 0)
        XCTAssertEqual(result.y, 1)
        XCTAssertEqual(result.z, 2)
        XCTAssertEqual(result.w, 3)
    }
    
    func testSign_mixedSigns() {
        let sut = Vector(x: 0, y: -1, z: 2, w: -3)
        
        let result = sut.sign
        
        XCTAssertEqual(result.x, 0)
        XCTAssertEqual(result.y, -1)
        XCTAssertEqual(result.z, 1)
        XCTAssertEqual(result.w, -1)
    }
    
    func testSign_allZeros() {
        let sut = Vector(x: 0, y: 0, z: 0, w: 0)
        
        let result = sut.sign
        
        XCTAssertEqual(result.x, 0)
        XCTAssertEqual(result.y, 0)
        XCTAssertEqual(result.z, 0)
        XCTAssertEqual(result.w, 0)
    }
    
    func testSign_allPositives() {
        let sut = Vector(x: 1, y: 1, z: 1, w: 1)
        
        let result = sut.sign
        
        XCTAssertEqual(result.x, 1)
        XCTAssertEqual(result.y, 1)
        XCTAssertEqual(result.z, 1)
        XCTAssertEqual(result.w, 1)
    }
    
    func testSign_allNegatives() {
        let sut = Vector(x: -1, y: -2, z: -3, w: -4)
        
        let result = sut.sign
        
        XCTAssertEqual(result.x, -1)
        XCTAssertEqual(result.y, -1)
        XCTAssertEqual(result.z, -1)
        XCTAssertEqual(result.w, -1)
    }
    
    func testNegate() {
        let sut = Vector(x: 0, y: -1, z: 2, w: -3)
        
        let result = -sut
        
        XCTAssertEqual(result.x, 0)
        XCTAssertEqual(result.y, 1)
        XCTAssertEqual(result.z, -2)
        XCTAssertEqual(result.w, 3)
    }
}

// MARK: VectorDivisible Conformance
extension Vector4Tests {
    func testDivide() {
        let vec1 = Vector(x: 0, y: 1, z: -2, w: 3)
        let vec2 = Vector(x: 1, y: 2, z: 3, w: -4)
        
        let result = vec1 / vec2
        
        XCTAssertEqual(result.x, 0.0)
        XCTAssertEqual(result.y, 0.5)
        XCTAssertEqual(result.z, -0.6666666666666666)
        XCTAssertEqual(result.w, -0.75)
    }
    
    func testDivide_inPlace() {
        var vec1 = Vector(x: 0, y: 1, z: -2, w: 3)
        let vec2 = Vector(x: 1, y: 2, z: 3, w: -4)
        
        vec1 /= vec2
        
        XCTAssertEqual(vec1.x, 0.0)
        XCTAssertEqual(vec1.y, 0.5)
        XCTAssertEqual(vec1.z, -0.6666666666666666)
        XCTAssertEqual(vec1.w, -0.75)
    }
    
    func testDivide_withScalarOnRHS() {
        let vec1 = Vector(x: 0, y: 1, z: -2, w: 3)
        let num = 5.0
        
        let result = vec1 / num
        
        XCTAssertEqual(result.x, 0.0)
        XCTAssertEqual(result.y, 0.2)
        XCTAssertEqual(result.z, -0.4)
        XCTAssertEqual(result.w, 0.6)
    }
    
    func testDivide_withScalarOnRHS_inPlace() {
        var vec1 = Vector(x: 0, y: 1, z: -2, w: 3)
        let num = 5.0
        
        vec1 /= num
        
        XCTAssertEqual(vec1.x, 0.0)
        XCTAssertEqual(vec1.y, 0.2)
        XCTAssertEqual(vec1.z, -0.4)
        XCTAssertEqual(vec1.w, 0.6)
    }
    
    func testDivide_withScalarOnLHS() {
        let num = 5.0
        let vec1 = Vector(x: 1, y: 2, z: -3, w: 4.5)
        
        let result = num / vec1
        
        XCTAssertEqual(result.x, 5.0)
        XCTAssertEqual(result.y, 2.5)
        XCTAssertEqual(result.z, -1.6666666666666667)
        XCTAssertEqual(result.w, 1.1111111111111112)
    }
}

// MARK: VectorFloatingPoint Conformance

extension Vector4Tests {
    func testAddingProduct_vectorVector() {
        let vec1 = Vector(x: -1, y: 2, z: 3, w: 4)
        let vec2 = Vector(x: 5, y: 6, z: -7, w: 8)
        let vec3 = Vector(x: 13, y: -9, z: 2, w: 5)
        
        let result = vec1.addingProduct(vec2, vec3)
        
        XCTAssertEqual(result.x, 64)
        XCTAssertEqual(result.y, -52)
        XCTAssertEqual(result.z, -11)
        XCTAssertEqual(result.w, 44)
    }
    
    func testAddingProduct_vectorScalar() {
        let vec1 = Vector(x: -1, y: 2, z: 3, w: 4)
        let vec2 = Vector(x: 5, y: 6, z: -7, w: 8)
        let num = 5.0
        
        let result = vec1.addingProduct(vec2, num)
        
        XCTAssertEqual(result.x, 24)
        XCTAssertEqual(result.y, 32)
        XCTAssertEqual(result.z, -32)
        XCTAssertEqual(result.w, 44)
    }
    
    func testAddingProduct_scalarVector() {
        let vec1 = Vector(x: -1, y: 2, z: 3, w: 4)
        let num = 5.0
        let vec2 = Vector(x: 5, y: 6, z: -7, w: 8)
        
        let result = vec1.addingProduct(num, vec2)
        
        XCTAssertEqual(result.x, 24)
        XCTAssertEqual(result.y, 32)
        XCTAssertEqual(result.z, -32)
        XCTAssertEqual(result.w, 44)
    }
    
    func testRounded_withRoundingRule() {
        let sut = Vector(x: 0, y: 1.2, z: -2.5, w: 3.6)
        
        let result = sut.rounded(.toNearestOrEven)
        
        XCTAssertEqual(result.x, 0.0)
        XCTAssertEqual(result.y, 1.0)
        XCTAssertEqual(result.z, -2.0)
        XCTAssertEqual(result.w, 4.0)
    }
    
    func testRounded() {
        let sut = Vector(x: 0, y: 1.2, z: -2.5, w: 3.6)
        
        let result = sut.rounded()
        
        XCTAssertEqual(result.x, 0.0)
        XCTAssertEqual(result.y, 1.0)
        XCTAssertEqual(result.z, -3.0)
        XCTAssertEqual(result.w, 4.0)
    }
    
    func testCeil() {
        let sut = Vector(x: 0, y: 1.2, z: -2.5, w: 3.6)
        
        let result = sut.ceil()
        
        XCTAssertEqual(result.x, 0.0)
        XCTAssertEqual(result.y, 2.0)
        XCTAssertEqual(result.z, -2.0)
        XCTAssertEqual(result.w, 4.0)
    }
    
    func testFloor() {
        let sut = Vector(x: 0, y: 1.2, z: -2.5, w: 3.6)
        
        let result = sut.floor()
        
        XCTAssertEqual(result.x, 0.0)
        XCTAssertEqual(result.y, 1.0)
        XCTAssertEqual(result.z, -3.0)
        XCTAssertEqual(result.w, 3.0)
    }
    
    func testModulo() {
        let vec1 = Vector(x: -1, y: 2, z: 3, w: 4)
        let vec2 = Vector(x: 5, y: 6, z: -7, w: 8)
        
        let result = vec1 % vec2
        
        XCTAssertEqual(result.x, -1)
        XCTAssertEqual(result.y, 2.0)
        XCTAssertEqual(result.z, 3.0)
        XCTAssertEqual(result.w, 4.0)
    }
    
    func testModulo_withScalar() {
        let vec1 = Vector(x: -1, y: 2, z: 3, w: 4)
        let num = 3.0
        
        let result = vec1 % num
        
        XCTAssertEqual(result.x, -1)
        XCTAssertEqual(result.y, 2.0)
        XCTAssertEqual(result.z, 0.0)
        XCTAssertEqual(result.w, 1.0)
    }
}

// MARK: Vector4FloatingPoint Conformance

extension Vector4Tests {
    func testInitWithBinaryInteger() {
        let vec = Vector4i(x: 1, y: 2, z: 3, w: 4)
        
        let result = Vector(vec)
        
        XCTAssertEqual(result.x, 1.0)
        XCTAssertEqual(result.y, 2.0)
        XCTAssertEqual(result.z, 3.0)
        XCTAssertEqual(result.w, 4.0)
    }
}

// MARK: SignedDistanceMeasurableType Conformance

extension Vector4Tests {
    func testSignedDistanceTo() {
        let vec1 = Vector(x: 1, y: 2, z: 3, w: 4)
        let vec2 = Vector(x: 17, y: 19, z: 23, w: 27)
        
        let result = vec1.signedDistance(to: vec2)
        
        XCTAssertEqual(result, 38.39270764090493)
    }
}

// MARK: VectorReal Conformance

extension Vector4Tests {
    func testPowFactor_double() {
        let vec = Vector(x: 2, y: 3, z: 5, w: 7)
        
        let result = Vector.pow(vec, 6.0)
        
        XCTAssertEqual(result.x, 64.0)
        XCTAssertEqual(result.y, 729.0)
        XCTAssertEqual(result.z, 15625.0)
        XCTAssertEqual(result.w, 117649.0)
    }
    
    func testPowFactor_double_negativeBase() {
        let vec = Vector(x: -2, y: -3, z: -5, w: -7)
        
        let result = Vector.pow(vec, 6.0)
        
        XCTAssertTrue(result.x.isNaN)
        XCTAssertTrue(result.y.isNaN)
        XCTAssertTrue(result.z.isNaN)
        XCTAssertTrue(result.w.isNaN)
    }
    
    func testPowFactor_integer() {
        let vec = Vector(x: 2, y: 3, z: 5, w: 7)
        
        let result = Vector.pow(vec, 6)
        
        XCTAssertEqual(result.x, 64.0)
        XCTAssertEqual(result.y, 729.0)
        XCTAssertEqual(result.z, 15625.0)
        XCTAssertEqual(result.w, 117649.0)
    }
    
    func testPowFactor_integer_negativeBase() {
        let vec = Vector(x: -2, y: -3, z: -5, w: -7)
        
        let result = Vector.pow(vec, 6)
        
        XCTAssertEqual(result.x, 64.0)
        XCTAssertEqual(result.y, 729.0)
        XCTAssertEqual(result.z, 15625.0)
        XCTAssertEqual(result.w, 117649.0)
    }
    
    func testPowVector() {
        let vec = Vector(x: 2, y: 3, z: 5, w: 6)
        let power = Vector(x: 7, y: 8, z: 9, w: 10)
        
        let result = Vector.pow(vec, power)
        
        XCTAssertEqual(result.x, 128.0)
        XCTAssertEqual(result.y, 6561.0)
        XCTAssertEqual(result.z, 1953125.0)
        XCTAssertEqual(result.w, 60466176.0)
    }
    
    func testPowVector_negativeBase() {
        let vec = Vector(x: -2, y: -3, z: -5, w: -6)
        let power = Vector(x: 7, y: 8, z: 9, w: 10)
        
        let result = Vector.pow(vec, power)
        
        XCTAssertTrue(result.x.isNaN)
        XCTAssertTrue(result.y.isNaN)
        XCTAssertTrue(result.z.isNaN)
        XCTAssertTrue(result.w.isNaN)
    }
}
