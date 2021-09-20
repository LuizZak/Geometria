import XCTest
import Geometria

class Vector2Tests: XCTestCase {
    let accuracy: Double = 1.0e-15
    
    typealias Vector = Vector2<Int>
    
    func testCodable() throws {
        let sut = Vector(x: 0, y: 1)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(Vector.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testZero() {
        XCTAssertEqual(Vector.zero.x, 0)
        XCTAssertEqual(Vector.zero.y, 0)
    }
    
    func testOne() {
        XCTAssertEqual(Vector.one.x, 1)
        XCTAssertEqual(Vector.one.y, 1)
    }
    
    func testDescription() {
        XCTAssertEqual(Vector2<Int>(x: 0, y: 1).description,
                       "Vector2<Int>(x: 0, y: 1)")
        XCTAssertEqual(Vector2<Double>(x: 0, y: 1).description,
                       "Vector2<Double>(x: 0.0, y: 1.0)")
    }
    
    func testInit() {
        let sut = Vector(x: 0, y: 1)
        
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 1)
    }
    
    func testInitRepeating() {
        let sut = Vector(repeating: 1)
        
        XCTAssertEqual(sut.x, 1)
        XCTAssertEqual(sut.y, 1)
    }
    
    func testInitWithTuple() {
        let sut = Vector((1, 2))
        
        XCTAssertEqual(sut.x, 1)
        XCTAssertEqual(sut.y, 2)
    }
    
    func testEquatable() {
        XCTAssertEqual(Vector(x: 0, y: 1), Vector(x: 0, y: 1))
        XCTAssertNotEqual(Vector(x: 1, y: 1), Vector(x: 0, y: 1))
        XCTAssertNotEqual(Vector(x: 1, y: 0), Vector(x: 0, y: 1))
        XCTAssertNotEqual(Vector(x: 0, y: 0), Vector(x: 0, y: 1))
    }
    
    func testHashable() {
        XCTAssertEqual(Vector(x: 0, y: 1).hashValue, Vector(x: 0, y: 1).hashValue)
        XCTAssertNotEqual(Vector(x: 1, y: 1).hashValue, Vector(x: 0, y: 1).hashValue)
        XCTAssertNotEqual(Vector(x: 1, y: 0).hashValue, Vector(x: 0, y: 1).hashValue)
        XCTAssertNotEqual(Vector(x: 0, y: 0).hashValue, Vector(x: 0, y: 1).hashValue)
    }
    
    func testPointwiseMin() {
        let vec1 = Vector2i(x: 2, y: -3)
        let vec2 = Vector2i(x: -1, y: 4)
        
        XCTAssertEqual(Vector2i.pointwiseMin(vec1, vec2), Vector2i(x: -1, y: -3))
    }
    
    func testPointwiseMax() {
        let vec1 = Vector2i(x: 2, y: -3)
        let vec2 = Vector2i(x: -1, y: 4)
        
        XCTAssertEqual(Vector2i.pointwiseMax(vec1, vec2), Vector2i(x: 2, y: 4))
    }
    
    func testGreaterThan() {
        XCTAssertTrue(Vector(x: 1, y: 1) > Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: 1) > Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 1, y: 0) > Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: 0) > Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: -1, y: 0) > Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: -1) > Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: -1, y: -1) > Vector(x: 0, y: 0))
    }
    
    func testGreaterThanOrEqualTo() {
        XCTAssertTrue(Vector(x: 1, y: 1) >= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: 0, y: 1) >= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: 1, y: 0) >= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: 0, y: 0) >= Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: -1, y: 0) >= Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: -1) >= Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: -1, y: -1) >= Vector(x: 0, y: 0))
    }
    
    func testLessThan() {
        XCTAssertFalse(Vector(x: 1, y: 1) < Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: 1) < Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 1, y: 0) < Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: 0) < Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: -1, y: 0) < Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: -1) < Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: -1, y: -1) < Vector(x: 0, y: 0))
    }
    
    func testLessThanOrEqualTo() {
        XCTAssertFalse(Vector(x: 1, y: 1) <= Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 0, y: 1) <= Vector(x: 0, y: 0))
        XCTAssertFalse(Vector(x: 1, y: 0) <= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: 0, y: 0) <= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: -1, y: 0) <= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: 0, y: -1) <= Vector(x: 0, y: 0))
        XCTAssertTrue(Vector(x: -1, y: -1) <= Vector(x: 0, y: 0))
    }
    
    func testAddition() {
        XCTAssertEqual(Vector(x: 1, y: 2) + Vector(x: 3, y: 4),
                       Vector(x: 4, y: 6))
        XCTAssertEqual(Vector2D(x: 1, y: 2) + Vector2D(x: 3, y: 4),
                       Vector2D(x: 4, y: 6))
        XCTAssertEqual(Vector2F(x: 1, y: 2) + Vector2F(x: 3, y: 4),
                       Vector2F(x: 4, y: 6))
    }
    
    func testAddition_isCommutative() {
        XCTAssertEqual(Vector(x: 1, y: 2) + Vector(x: 3, y: 4),
                       Vector(x: 3, y: 4) + Vector(x: 1, y: 2))
    }
    
    func testAddition_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 2) + 3,
                       Vector(x: 4, y: 5))
        XCTAssertEqual(Vector2D(x: 1, y: 2) + 3,
                       Vector2D(x: 4, y: 5))
        XCTAssertEqual(Vector2F(x: 1, y: 2) + 3,
                       Vector2F(x: 4, y: 5))
    }
    
    func testSubtraction() {
        XCTAssertEqual(Vector(x: 1, y: 2) - Vector(x: 3, y: 5),
                       Vector(x: -2, y: -3))
        XCTAssertEqual(Vector2D(x: 1, y: 2) - Vector2D(x: 3, y: 5),
                       Vector2D(x: -2, y: -3))
        XCTAssertEqual(Vector2F(x: 1, y: 2) - Vector2F(x: 3, y: 5),
                       Vector2F(x: -2, y: -3))
    }
    
    func testSubtraction_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 2) - 3,
                       Vector(x: -2, y: -1))
        XCTAssertEqual(Vector2D(x: 1, y: 2) - 3,
                       Vector2D(x: -2, y: -1))
        XCTAssertEqual(Vector2F(x: 1, y: 2) - 3,
                       Vector2F(x: -2, y: -1))
    }
    
    func testMultiplication() {
        XCTAssertEqual(Vector(x: 1, y: 2) * Vector(x: 3, y: 4),
                       Vector(x: 3, y: 8))
        XCTAssertEqual(Vector2D(x: 1, y: 2) * Vector2D(x: 3, y: 4),
                       Vector2D(x: 3, y: 8))
        XCTAssertEqual(Vector2F(x: 1, y: 2) * Vector2F(x: 3, y: 4),
                       Vector2F(x: 3, y: 8))
    }
    
    func testMultiplication_isCommutative() {
        XCTAssertEqual(Vector2D(x: 1, y: 2) * Vector2D(x: 3, y: 4),
                       Vector2D(x: 3, y: 4) * Vector2D(x: 1, y: 2))
    }
    
    func testMultiplication_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 2) * 3,
                       Vector(x: 3, y: 6))
        XCTAssertEqual(3 * Vector(x: 1, y: 2),
                       Vector(x: 3, y: 6))
        XCTAssertEqual(Vector2D(x: 1, y: 2) * 3,
                       Vector2D(x: 3, y: 6))
        XCTAssertEqual(3 * Vector2D(x: 1, y: 2),
                       Vector2D(x: 3, y: 6))
        XCTAssertEqual(Vector2F(x: 1, y: 2) * 3,
                       Vector2F(x: 3, y: 6))
        XCTAssertEqual(3 * Vector2F(x: 1, y: 2),
                       Vector2F(x: 3, y: 6))
    }
    
    func testMultiplication_withScalar_isCommutative() {
        XCTAssertEqual(Vector2D(x: 1, y: 2) * 3,
                       3 * Vector2D(x: 1, y: 2))
    }
    
    func testDivision() {
        XCTAssertEqual(Vector2D(x: 3, y: 5) / Vector2D(x: 2, y: 3),
                       Vector2D(x: 1.5, y: 1.6666666666666667))
        XCTAssertEqual(Vector2F(x: 3, y: 5) / Vector2F(x: 2, y: 3),
                       Vector2F(x: 1.5, y: 1.6666666))
    }
    
    func testDivision_withScalarOnRHS() {
        XCTAssertEqual(Vector2D(x: 1, y: 2) / 3,
                       Vector2D(x: 0.3333333333333333, y: 0.6666666666666666))
        XCTAssertEqual(Vector2F(x: 1, y: 2) / 3,
                       Vector2F(x: 0.33333334, y: 0.6666667))
    }
    
    func testDivision_withScalarOnLHS() {
        XCTAssertEqual(3 / Vector2D(x: 1, y: 2),
                       Vector2D(x: 3.0, y: 1.5))
        XCTAssertEqual(3 / Vector2F(x: 1, y: 2),
                       Vector2F(x: 3.0, y: 1.5))
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
    
    func testMultiplication_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        let vec2 = Vector(x: 3, y: 4)
        
        vec1 *= vec2
        
        XCTAssertEqual(vec1, Vector(x: 3, y: 8))
    }
    
    func testMultiplication_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2)
        
        vec1 *= 2
        
        XCTAssertEqual(vec1, Vector(x: 2, y: 4))
    }
    
    func testDivision_inPlace() {
        var vec1 = Vector2D(x: 3, y: 5)
        
        vec1 /= Vector2D(x: 2, y: 3)
        
        XCTAssertEqual(vec1, Vector2D(x: 1.5, y: 1.6666666666666667))
    }
    
    func testDivision_withScalar_inPlace() {
        var vec1 = Vector2D(x: 1, y: 4)
        
        vec1 /= 3
        
        XCTAssertEqual(vec1, Vector2D(x: 0.3333333333333333, y: 1.3333333333333333))
    }
    
    func testAbsolute() {
        let vec = Vector2D(x: -1, y: -2)
        
        XCTAssertEqual(vec.absolute, Vector2D(x: 1, y: 2))
    }
    
    func testAbsolute_mixedPositiveNegative() {
        let vec = Vector2D(x: -1, y: 2)
        
        XCTAssertEqual(vec.absolute, Vector2D(x: 1, y: 2))
    }
    
    func testAbsolute_positive() {
        let vec = Vector2D(x: 1, y: 2)
        
        XCTAssertEqual(vec.absolute, Vector2D(x: 1, y: 2))
    }
    
    func testSign() {
        XCTAssertEqual(Vector2D(x: 0.0, y: 0.0).sign, .init(x: 0.0, y: 0.0))
        XCTAssertEqual(Vector2D(x: -0.0, y: -0.0).sign, .init(x: 0.0, y: 0.0))
        XCTAssertEqual(Vector2D(x: -1.0, y: 1.0).sign, .init(x: -1.0, y: 1.0))
        XCTAssertEqual(Vector2D(x: 5.0, y: -4.0).sign, .init(x: 1.0, y: -1.0))
    }
    
    func testNegate() {
        XCTAssertEqual(-Vector(x: 1, y: 2), Vector(x: -1, y: -2))
    }
    
    func testNegate_doubleNegateEqualsIdentity() {
        let vec = Vector(x: 1, y: 2)
        
        XCTAssertEqual(-(-vec), vec)
    }
    
    func testPerpendicular() {
        let vec = Vector(x: 5, y: 1)
        
        XCTAssertEqual(vec.perpendicular(), Vector(x: -1, y: 5))
    }
    
    func testFormPerpendicular() {
        var vec = Vector(x: 5, y: 1)
        
        vec.formPerpendicular()
        
        XCTAssertEqual(vec, Vector(x: -1, y: 5))
    }
    
    func testLeftRotated() {
        let vec = Vector(x: 5, y: 1)
        
        XCTAssertEqual(vec.leftRotated(), Vector(x: -1, y: 5))
    }
    
    func testFormLeftRotated() {
        var vec = Vector(x: 5, y: 1)
        
        vec.formLeftRotated()
        
        XCTAssertEqual(vec, Vector(x: -1, y: 5))
    }
    
    func testRightRotated() {
        let vec = Vector(x: 5, y: 1)
        
        XCTAssertEqual(vec.rightRotated(), Vector(x: 1, y: -5))
    }
    
    func testFormRightRotated() {
        var vec = Vector(x: 5, y: 1)
        
        vec.formRightRotated()
        
        XCTAssertEqual(vec, Vector(x: 1, y: -5))
    }
    
    func testAddingProduct() {
        let a = Vector2D(x: 0.5, y: 0.6)
        let b = Vector2D(x: 1, y: 2)
        let c = Vector2D(x: 3, y: 5)
        
        let result = a.addingProduct(b, c)
        
        XCTAssertEqual(result.x, 3.5)
        XCTAssertEqual(result.y, 10.6)
    }
    
    func testAddingProductScalarVector() {
        let a = Vector2D(x: 0.5, y: 0.6)
        let b = 2.0
        let c = Vector2D(x: 3, y: 5)
        
        let result = a.addingProduct(b, c)
        
        XCTAssertEqual(result.x, 6.5)
        XCTAssertEqual(result.y, 10.6)
    }
    
    func testAddingProductVectorScalar() {
        let a = Vector2D(x: 0.5, y: 0.6)
        let b = Vector2D(x: 1, y: 2)
        let c = 2.0
        
        let result = a.addingProduct(b, c)
        
        XCTAssertEqual(result.x, 2.5)
        XCTAssertEqual(result.y, 4.6)
    }
    
    func testRoundedWithRoundingRule() {
        let vec = Vector2D(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.rounded(.up), Vector2D(x: 1, y: 2))
        XCTAssertEqual(vec.rounded(.down), Vector2D(x: 0, y: 1))
        XCTAssertEqual(vec.rounded(.toNearestOrAwayFromZero), Vector2D(x: 1, y: 2))
        XCTAssertEqual(vec.rounded(.toNearestOrEven), Vector2D(x: 0, y: 2))
        XCTAssertEqual(vec.rounded(.towardZero), Vector2D(x: 0, y: 1))
        XCTAssertEqual(vec.rounded(.awayFromZero), Vector2D(x: 1, y: 2))
    }
    
    func testRounded() {
        let vec = Vector2D(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.rounded(), Vector2D(x: 1, y: 2))
    }
    
    func testFloor() {
        let vec = Vector2D(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.floor(), Vector2D(x: 0, y: 1))
    }
    
    func testCeil() {
        let vec = Vector2D(x: 0.5, y: 1.6)
        
        XCTAssertEqual(vec.ceil(), Vector2D(x: 1, y: 2))
    }
    
    func testModuloOperator_vector() {
        let vec = Vector2D(x: 3, y: 10)
        let mod = Vector2D(x: 4, y: 3)
        
        let result = vec % mod
        
        XCTAssertEqual(result.x, 3)
        XCTAssertEqual(result.y, 1)
    }
    
    func testModuloOperator_scalar() {
        let vec = Vector2D(x: 3, y: 10)
        let mod = 4.0
        
        let result = vec % mod
        
        XCTAssertEqual(result.x, 3)
        XCTAssertEqual(result.y, 2)
    }
    
    func testFloatingPointInitWithBinaryInteger() {
        let vecInt = Vector2<Int>(x: 1, y: 2)
        
        let vec = Vector2<Float>(vecInt)
        
        XCTAssertEqual(vec.x, 1)
        XCTAssertEqual(vec.y, 2)
    }
    
    func testLength() {
        XCTAssertEqual(Vector2(x: 3, y: 2).length, 3.605551275463989)
    }
    
    func testDistanceTo() {
        let v1 = Vector2D(x: 10, y: 20)
        let v2 = Vector2D(x: 30, y: 40)
        
        XCTAssertEqual(v1.distance(to: v2), 28.284271247461902, accuracy: accuracy)
    }
    
    func testDistanceTo_zeroDistance() {
        let vec = Vector2D(x: 10, y: 20)
        
        XCTAssertEqual(vec.distance(to: vec), 0.0)
    }
    
    func testSignedDistanceTo() {
        let vec = Vector2D(x: -2, y: 3)
        
        XCTAssertEqual(vec.signedDistance(to: vec), 0.0)
        XCTAssertEqual(vec.signedDistance(to: .init(x: 2, y: 5)), 4.47213595499958)
    }
    
    func testPowFactor_double() {
        let vec = Vector2D(x: 2, y: 3)
        
        let result = Vector2D.pow(vec, 5.0)
        
        XCTAssertEqual(result.x, 32)
        XCTAssertEqual(result.y, 243)
    }
    
    func testPowFactor_double_negativeBase() {
        let vec = Vector2D(x: -1, y: -2)
        
        let result = Vector2D.pow(vec, 3.0)
        
        XCTAssertTrue(result.x.isNaN)
        XCTAssertTrue(result.y.isNaN)
    }
    
    func testPowFactor_integer() {
        let vec = Vector2D(x: 2, y: 3)
        
        let result = Vector2D.pow(vec, 5)
        
        XCTAssertEqual(result.x, 32)
        XCTAssertEqual(result.y, 243)
    }
    
    func testPowFactor_integer_negativeBase() {
        let vec = Vector2D(x: -1, y: -2)
        
        let result = Vector2D.pow(vec, 3)
        
        XCTAssertEqual(result.x, -1)
        XCTAssertEqual(result.y, -8)
    }
    
    func testPowVector() {
        let vec = Vector2D(x: 2, y: 3)
        let power = Vector2D(x: 5, y: 6)
        
        let result = Vector2D.pow(vec, power)
        
        XCTAssertEqual(result.x, 32)
        XCTAssertEqual(result.y, 729)
    }
    
    func testPowVector_negativeBase() {
        let vec = Vector2D(x: -2, y: -3)
        let power = Vector2D(x: 5, y: 6)
        
        let result = Vector2D.pow(vec, power)
        
        XCTAssertTrue(result.x.isNaN)
        XCTAssertTrue(result.y.isNaN)
    }
    
    func testAngle() {
        let vec = Vector2D(x: -10, y: 10)
        
        XCTAssertEqual(vec.angle, .pi * (3.0 / 4.0))
    }
    
    func testRotatedBy() {
        let vec = Vector2D(x: 5, y: 0)
        
        let result = vec.rotated(by: .pi / 2)
        
        XCTAssertEqual(result.x, 0, accuracy: 0.0000000001)
        XCTAssertEqual(result.y, 5, accuracy: 0.0000000001)
    }
    
    func testRotateBy() {
        var vec = Vector2D(x: 5, y: 0)
        
        vec.rotate(by: .pi / 2)
        
        XCTAssertEqual(vec.x, 0, accuracy: 0.0000000001)
        XCTAssertEqual(vec.y, 5, accuracy: 0.0000000001)
    }
    
    func testRotatedByAround() {
        let vec = Vector2D(x: 5, y: 0)
        
        let result = vec.rotated(by: .pi / 2, around: Vector2D(x: 5, y: 5))
        
        XCTAssertEqual(result.x, 10, accuracy: 0.0000000001)
        XCTAssertEqual(result.y, 5, accuracy: 0.0000000001)
    }
    
    func testNormalize() {
        var vec = Vector2D(x: -10, y: 20)
        
        vec.normalize()
        
        assertEqual(vec, Vector2D(x: -0.4472135954999579, y: 0.8944271909999159),
                    accuracy: accuracy)
    }
    
    func testNormalize_zero() {
        var vec = Vector2D(x: 0, y: 0)
        
        vec.normalize()
        
        XCTAssertEqual(vec, .zero)
    }
    
    func testNormalized() {
        let vec = Vector2D(x: -10, y: 20)
        
        assertEqual(vec.normalized(), Vector2D(x: -0.4472135954999579, y: 0.8944271909999159),
                    accuracy: accuracy)
    }
    
    func testNormalized_zero() {
        let vec = Vector2D(x: 0, y: 0)
        
        XCTAssertEqual(vec.normalized(), .zero)
    }
    
    func testMatrix_identity() {
        let matrix = Vector2D.matrix()
        
        assertEqual(matrix.column1, [1.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, 1.0, 0.0], accuracy: accuracy)
    }
    
    func testMatrix_translate() {
        let matrix = Vector2D.matrix(translate: Vector2D(x: 10, y: -20))
        
        assertEqual(matrix.column1, [1.0, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, 1.0, -20.0], accuracy: accuracy)
    }
    
    func testMatrix_scale() {
        let matrix = Vector2D.matrix(scale: Vector2D(x: 10, y: -20))
        
        assertEqual(matrix.column1, [10.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, -20.0, 0.0], accuracy: accuracy)
    }
    
    func testMatrix_rotate() {
        let matrix = Vector2D.matrix(rotate: .pi)
        
        assertEqual(matrix.column1, [-1.0, 0.0, 0.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0, -1.0, 0.0], accuracy: accuracy)
    }
    
    func testMatrix_scalePrecedesRotation() {
        let matrix = Vector2D.matrix(scale: Vector2D(x: 0.5, y: 0.75),
                                     rotate: .pi)
        
        assertEqual(matrix.column1, [-0.5, 0, 0.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, -0.75, 0.0], accuracy: accuracy)
    }
    
    func testMatrix_rotationPrecedesTranslation() {
        let matrix = Vector2D.matrix(rotate: .pi,
                                     translate: Vector2D(x: 10, y: -20))
        
        assertEqual(matrix.column1, [-1.0, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, -1.0, -20.0], accuracy: accuracy)
    }
    
    func testMatrix_scaleRotateTranslate() {
        let matrix = Vector2D.matrix(scale: Vector2D(x: 0.5, y: 0.75),
                                     rotate: .pi,
                                     translate: Vector2D(x: 10, y: -20))
        
        assertEqual(matrix.column1, [-0.5, 0.0, 10.0], accuracy: accuracy)
        assertEqual(matrix.column2, [0.0, -0.75, -20.0], accuracy: accuracy)
    }
    
    func testMultiplyMatrix() {
        let matrix = Matrix3x2D(m11: 2, m12: 3, m21: 4, m22: 5, m31: 6, m32: 7)
        let vec = Vector2D(x: 1, y: 2)
        
        assertEqual(vec * matrix, Vector2D(x: 16.0, y: 20.0), accuracy: accuracy)
    }
    
    func testMultiplyMatrix_inPlace() {
        let matrix = Matrix3x2D.translation(x: 10, y: 20)
        var vec = Vector2D(x: 1, y: 2)
        
        vec *= matrix
        
        XCTAssertEqual(vec, Vector2D(x: 11.0, y: 22.0))
    }
}
