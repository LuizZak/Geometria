import XCTest
import Geometria

class Vector3Tests: XCTestCase {
    let accuracy: Double = 1.0e-15
    
    typealias Vector = Vector3<Int>
    
    func testCodable() throws {
        let sut = Vector(x: 0, y: 1, z: 2)
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
        XCTAssertEqual(Vector3<Int>(x: 0, y: 1, z: 2).description,
                       "Vector3<Int>(x: 0, y: 1, z: 2)")
        XCTAssertEqual(Vector3<Double>(x: 0, y: 1, z: 2).description,
                       "Vector3<Double>(x: 0.0, y: 1.0, z: 2.0)")
    }
    
    func testInit() {
        let sut = Vector(x: 0, y: 1, z: 2)
        
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 1)
        XCTAssertEqual(sut.z, 2)
    }
    
    func testEquatable() {
        XCTAssertEqual(Vector(x: 0, y: 1, z: 2), Vector(x: 0, y: 1, z: 2))
        XCTAssertNotEqual(Vector(x: 1, y: 1, z: 2), Vector(x: 0, y: 1, z: 2))
        XCTAssertNotEqual(Vector(x: 1, y: 0, z: 2), Vector(x: 0, y: 1, z: 2))
        XCTAssertNotEqual(Vector(x: 0, y: 0, z: 2), Vector(x: 0, y: 1, z: 2))
        XCTAssertNotEqual(Vector(x: 0, y: 1, z: 0), Vector(x: 0, y: 1, z: 2))
    }
    
    func testHashable() {
        XCTAssertEqual(Vector(x: 0, y: 1, z: 2).hashValue, Vector(x: 0, y: 1, z: 2).hashValue)
        XCTAssertNotEqual(Vector(x: 1, y: 1, z: 2).hashValue, Vector(x: 0, y: 1, z: 2).hashValue)
        XCTAssertNotEqual(Vector(x: 1, y: 0, z: 2).hashValue, Vector(x: 0, y: 1, z: 2).hashValue)
        XCTAssertNotEqual(Vector(x: 0, y: 0, z: 2).hashValue, Vector(x: 0, y: 1, z: 2).hashValue)
        XCTAssertNotEqual(Vector(x: 0, y: 1, z: 0).hashValue, Vector(x: 0, y: 1, z: 2).hashValue)
    }
    
    func testInitZero() {
        let sut = Vector()
        
        XCTAssertEqual(sut.x, 0)
        XCTAssertEqual(sut.y, 0)
        XCTAssertEqual(sut.z, 0)
    }
    
    func testInitRepeating() {
        let sut = Vector(repeating: 1)
        
        XCTAssertEqual(sut.x, 1)
        XCTAssertEqual(sut.y, 1)
        XCTAssertEqual(sut.z, 1)
    }
    
    func testPointwiseMin() {
        let vec1 = Vector3i(x: 2, y: -3, z: 5)
        let vec2 = Vector3i(x: -1, y: 4, z: -6)
        
        XCTAssertEqual(Vector3i.pointwiseMin(vec1, vec2), Vector3i(x: -1, y: -3, z: -6))
    }
    
    func testPointwiseMax() {
        let vec1 = Vector3i(x: 2, y: -3, z: 5)
        let vec2 = Vector3i(x: -1, y: 4, z: -6)
        
        XCTAssertEqual(Vector3i.pointwiseMax(vec1, vec2), Vector3i(x: 2, y: 4, z: 5))
    }
    
    func testGreaterThan() {
        XCTAssertTrue(Vector(x: 1, y: 1, z: 1) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 1, z: 0) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 1, y: 0, z: 0) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 1, y: 1, z: 0) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: 0) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: -1, y: 0, z: 0) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: -1, z: 0) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: -1) > Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: -1, y: -1, z: -1) > Vector(x: 0, y: 0, z: 0))
    }
    
    func testGreaterThanOrEqualTo() {
        XCTAssertTrue(Vector(x: 1, y: 1, z: 1) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 0, y: 1, z: 0) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 1, y: 0, z: 0) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 1, y: 1, z: 0) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 0, y: 0, z: 0) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: -1, y: 0, z: 0) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: -1, z: 0) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: -1) >= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: -1, y: -1, z: -1) >= Vector(x: 0, y: 0, z: 0))
    }
    
    func testLessThan() {
        XCTAssertFalse(Vector(x: 1, y: 1, z: 1) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 1, z: 0) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 1, y: 0, z: 0) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 1, y: 1, z: 0) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: 0) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: -1, y: 0, z: 0) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: -1, z: 0) < Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 0, z: -1) < Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: -1, y: -1, z: -1) < Vector(x: 0, y: 0, z: 0))
    }
    
    func testLessThanOrEqualTo() {
        XCTAssertFalse(Vector(x: 1, y: 1, z: 1) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 0, y: 1, z: 0) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 1, y: 0, z: 0) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertFalse(Vector(x: 1, y: 1, z: 0) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 0, y: 0, z: 0) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: -1, y: 0, z: 0) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 0, y: -1, z: 0) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: 0, y: 0, z: -1) <= Vector(x: 0, y: 0, z: 0))
        XCTAssertTrue(Vector(x: -1, y: -1, z: -1) <= Vector(x: 0, y: 0, z: 0))
    }
    
    func testAddition() {
        XCTAssertEqual(Vector(x: 1, y: 2, z: 3) + Vector(x: 4, y: 5, z: 6),
                       Vector(x: 5, y: 7, z: 9))
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: 3) + Vector3D(x: 4, y: 5, z: 6),
                       Vector3D(x: 5, y: 7, z: 9))
        XCTAssertEqual(Vector3F(x: 1, y: 2, z: 3) + Vector3F(x: 4, y: 5, z: 6),
                       Vector3F(x: 5, y: 7, z: 9))
    }
    
    func testAddition_isCommutative() {
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: 3) + Vector3D(x: 4, y: 5, z: 6),
                       Vector3D(x: 4, y: 5, z: 6) + Vector3D(x: 1, y: 2, z: 3))
    }
    
    func testAddition_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 2, z: 3) + 4,
                       Vector(x: 5, y: 6, z: 7))
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: 3) + 4,
                       Vector3D(x: 5, y: 6, z: 7))
        XCTAssertEqual(Vector3F(x: 1, y: 2, z: 3) + 4,
                       Vector3F(x: 5, y: 6, z: 7))
    }
    
    func testSubtraction() {
        XCTAssertEqual(Vector(x: 1, y: 2, z: 3) - Vector(x: 5, y: 7, z: 11),
                       Vector(x: -4, y: -5, z: -8))
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: 3) - Vector3D(x: 5, y: 7, z: 11),
                       Vector3D(x: -4, y: -5, z: -8))
        XCTAssertEqual(Vector3F(x: 1, y: 2, z: 3) - Vector3F(x: 5, y: 7, z: 11),
                       Vector3F(x: -4, y: -5, z: -8))
    }
    
    func testSubtraction_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 2, z: 3) - 5,
                       Vector(x: -4, y: -3, z: -2))
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: 3) - 5,
                       Vector3D(x: -4, y: -3, z: -2))
        XCTAssertEqual(Vector3F(x: 1, y: 2, z: 3) - 5,
                       Vector3F(x: -4, y: -3, z: -2))
    }
    
    func testMultiplication() {
        XCTAssertEqual(Vector(x: 1, y: 2, z: 3) * Vector(x: 4, y: 5, z: 6),
                       Vector(x: 4, y: 10, z: 18))
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: 3) * Vector3D(x: 4, y: 5, z: 6),
                       Vector3D(x: 4, y: 10, z: 18))
        XCTAssertEqual(Vector3F(x: 1, y: 2, z: 3) * Vector3F(x: 4, y: 5, z: 6),
                       Vector3F(x: 4, y: 10, z: 18))
    }
    
    func testMultiplication_isCommutative() {
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: 3) * Vector3D(x: 4, y: 5, z: 6),
                       Vector3D(x: 4, y: 5, z: 6) * Vector3D(x: 1, y: 2, z: 3))
    }
    
    func testMultiplication_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 2, z: 3) * 4,
                       Vector(x: 4, y: 8, z: 12))
        XCTAssertEqual(4 * Vector(x: 1, y: 2, z: 3),
                       Vector(x: 4, y: 8, z: 12))
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: 3) * 4,
                       Vector3D(x: 4, y: 8, z: 12))
        XCTAssertEqual(4 * Vector3D(x: 1, y: 2, z: 3),
                       Vector3D(x: 4, y: 8, z: 12))
        XCTAssertEqual(Vector3F(x: 1, y: 2, z: 3) * 4,
                       Vector3F(x: 4, y: 8, z: 12))
        XCTAssertEqual(4 * Vector3F(x: 1, y: 2, z: 3),
                       Vector3F(x: 4, y: 8, z: 12))
    }
    
    func testMultiplication_withScalar_isCommutative() {
        XCTAssertEqual(Vector3D(x: 1, y: 2, z: 3) * 4,
                       4 * Vector3D(x: 1, y: 2, z: 3))
    }
    
    func testDivision() {
        XCTAssertEqual(Vector(x: 3, y: 5, z: 7) / Vector(x: 2, y: 3, z: 5),
                       Vector(x: 1, y: 1, z: 1))
        XCTAssertEqual(Vector3D(x: 3, y: 5, z: 7) / Vector3D(x: 2, y: 3, z: 5),
                       Vector3D(x: 1.5, y: 1.6666666666666667, z: 1.4))
        XCTAssertEqual(Vector3F(x: 3, y: 5, z: 7) / Vector3F(x: 2, y: 3, z: 5),
                       Vector3F(x: 1.5, y: 1.6666666, z: 1.4))
    }
    
    func testDivision_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 4, z: 7) / 3,
                       Vector(x: 0, y: 1, z: 2))
        XCTAssertEqual(Vector3D(x: 1, y: 4, z: 7) / 3,
                       Vector3D(x: 0.3333333333333333, y: 1.3333333333333333, z: 2.3333333333333335))
        XCTAssertEqual(Vector3F(x: 1, y: 4, z: 7) / 3,
                       Vector3F(x: 0.33333334, y: 1.3333334, z: 2.3333333))
    }
    
    func testAddition_inPlace() {
        var vec1 = Vector(x: 1, y: 2, z: 3)
        let vec2 = Vector(x: 4, y: 5, z: 6)
        
        vec1 += vec2
        
        XCTAssertEqual(vec1, Vector(x: 5, y: 7, z: 9))
    }
    
    func testAddition_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2, z: 3)
        
        vec1 += 1
        
        XCTAssertEqual(vec1, Vector(x: 2, y: 3, z: 4))
    }
    
    func testSubtraction_inPlace() {
        var vec1 = Vector(x: 1, y: 2, z: 3)
        let vec2 = Vector(x: 5, y: 7, z: 11)
        
        vec1 -= vec2
        
        XCTAssertEqual(vec1, Vector(x: -4, y: -5, z: -8))
    }
    
    func testSubtraction_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2, z: 3)
        
        vec1 -= 1
        
        XCTAssertEqual(vec1, Vector(x: 0, y: 1, z: 2))
    }
    
    func testMultiplication_inPlace() {
        var vec1 = Vector(x: 1, y: 2, z: 3)
        let vec2 = Vector(x: 4, y: 5, z: 6)
        
        vec1 *= vec2
        
        XCTAssertEqual(vec1, Vector(x: 4, y: 10, z: 18))
    }
    
    func testMultiplication_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 2, z: 3)
        
        vec1 *= 2
        
        XCTAssertEqual(vec1, Vector(x: 2, y: 4, z: 6))
    }
    
    func testDivision_inPlace() {
        var vec1 = Vector(x: 3, y: 5, z: 7)
        
        vec1 /= Vector(x: 2, y: 3, z: 5)
        
        XCTAssertEqual(vec1, Vector(x: 1, y: 1, z: 1))
    }
    
    func testDivision_withScalar_inPlace() {
        var vec1 = Vector(x: 1, y: 4, z: 12)
        
        vec1 /= 3
        
        XCTAssertEqual(vec1, Vector(x: 0, y: 1, z: 4))
    }
    
    func testLengthSquared() {
        XCTAssertEqual(Vector(x: 3, y: 2, z: 1).lengthSquared, 14)
        XCTAssertEqual(Vector3D(x: 3.0, y: 2.0, z: 1.0).lengthSquared, 14.0)
    }
    
    func testDot() {
        let v1 = Vector(x: 10, y: 20, z: 30)
        let v2 = Vector(x: 40, y: 50, z: 60)
        
        XCTAssertEqual(v1.dot(v2), 3200)
    }
    
    func testRatio() {
        let v1 = Vector3D(x: 10, y: 20, z: 30)
        let v2 = Vector3D(x: 40, y: 50, z: 60)
        
        XCTAssertEqual(v1.ratio(-1, to: v2), Vector3D(x: -20, y: -10, z: 0))
        XCTAssertEqual(v1.ratio(0, to: v2), v1)
        XCTAssertEqual(v1.ratio(0.5, to: v2), Vector3D(x: 25, y: 35, z: 45))
        XCTAssertEqual(v1.ratio(1, to: v2), v2)
        XCTAssertEqual(v1.ratio(2, to: v2), Vector3D(x: 70, y: 80, z: 90))
    }
    
    func testLerp() {
        let v1 = Vector3D(x: 10, y: 20, z: 30)
        let v2 = Vector3D(x: 70, y: 110, z: 130)
        
        XCTAssertEqual(Vector3D.lerp(start: v1, end: v2, amount: -1), Vector3D(x: -50, y: -70, z: -70))
        XCTAssertEqual(Vector3D.lerp(start: v1, end: v2, amount: 0), v1)
        XCTAssertEqual(Vector3D.lerp(start: v1, end: v2, amount: 0.5), Vector3D(x: 40.0, y: 65.0, z: 80.0))
        XCTAssertEqual(Vector3D.lerp(start: v1, end: v2, amount: 1), v2)
        XCTAssertEqual(Vector3D.lerp(start: v1, end: v2, amount: 2), Vector3D(x: 130.0, y: 200.0, z: 230.0))
    }
    
    func testAbsolute() {
        let vec = Vector3D(x: -1, y: -2, z: -3)
        
        XCTAssertEqual(vec.absolute, Vector3D(x: 1, y: 2, z: 3))
    }
    
    func testAbsolute_mixedPositiveNegative() {
        let vec = Vector3D(x: -1, y: 2, z: 3)
        
        XCTAssertEqual(vec.absolute, Vector3D(x: 1, y: 2, z: 3))
    }
    
    func testAbsolute_positive() {
        let vec = Vector3D(x: 1, y: 2, z: 3)
        
        XCTAssertEqual(vec.absolute, Vector3D(x: 1, y: 2, z: 3))
    }
    
    func testNegate() {
        XCTAssertEqual(-Vector(x: 1, y: 2, z: 3), Vector(x: -1, y: -2, z: -3))
    }
    
    func testNegate_doubleNegateEqualsIdentity() {
        let vec = Vector(x: 1, y: 2, z: 3)
        
        XCTAssertEqual(-(-vec), vec)
    }
    
    func testAddingProduct() {
        let a = Vector3D(x: 0.5, y: 0.6, z: 0.7)
        let b = Vector3D(x: 1, y: 2, z: 3)
        let c = Vector3D(x: 5, y: 7, z: 11)
        
        let result = a.addingProduct(b, c)
        
        XCTAssertEqual(result.x, 5.5)
        XCTAssertEqual(result.y, 14.6)
        XCTAssertEqual(result.z, 33.7)
    }
    
    func testAddingProductScalarVector() {
        let a = Vector3D(x: 0.5, y: 0.6, z: 0.7)
        let b = 2.0
        let c = Vector3D(x: 5, y: 7, z: 11)
        
        let result = a.addingProduct(b, c)
        
        XCTAssertEqual(result.x, 10.5)
        XCTAssertEqual(result.y, 14.6)
        XCTAssertEqual(result.z, 22.7)
    }
    
    func testAddingProductVectorScalar() {
        let a = Vector3D(x: 0.5, y: 0.6, z: 0.7)
        let b = Vector3D(x: 1, y: 2, z: 3)
        let c = 2.0
        
        let result = a.addingProduct(b, c)
        
        XCTAssertEqual(result.x, 2.5)
        XCTAssertEqual(result.y, 4.6)
        XCTAssertEqual(result.z, 6.7)
    }
    
    func testRoundedWithRoundingRule() {
        let vec = Vector3D(x: 0.5, y: 1.6, z: 3.1)
        
        XCTAssertEqual(vec.rounded(.up), Vector3D(x: 1, y: 2, z: 4))
        XCTAssertEqual(vec.rounded(.down), Vector3D(x: 0, y: 1, z: 3))
        XCTAssertEqual(vec.rounded(.toNearestOrAwayFromZero), Vector3D(x: 1, y: 2, z: 3))
        XCTAssertEqual(vec.rounded(.toNearestOrEven), Vector3D(x: 0, y: 2, z: 3))
        XCTAssertEqual(vec.rounded(.towardZero), Vector3D(x: 0, y: 1, z: 3))
        XCTAssertEqual(vec.rounded(.awayFromZero), Vector3D(x: 1, y: 2, z: 4))
    }
    
    func testRounded() {
        let vec = Vector3D(x: 0.5, y: 1.6, z: 3.1)
        
        XCTAssertEqual(vec.rounded(), Vector3D(x: 1, y: 2, z: 3))
    }
    
    func testFloor() {
        let vec = Vector3D(x: 0.5, y: 1.6, z: 3.1)
        
        XCTAssertEqual(vec.floor(), Vector3D(x: 0, y: 1, z: 3))
    }
    
    func testCeil() {
        let vec = Vector3D(x: 0.5, y: 1.6, z: 3.1)
        
        XCTAssertEqual(vec.ceil(), Vector3D(x: 1, y: 2, z: 4))
    }
    
    func testModuloOperator_vector() {
        let vec = Vector3D(x: 3, y: 10, z: 7)
        let mod = Vector3D(x: 4, y: 3, z: 5)
        
        let result = vec % mod
        
        XCTAssertEqual(result.x, 3)
        XCTAssertEqual(result.y, 1)
        XCTAssertEqual(result.z, 2)
    }
    
    func testModuloOperator_scalar() {
        let vec = Vector3D(x: 3, y: 10, z: 7)
        let mod = 4.0
        
        let result = vec % mod
        
        XCTAssertEqual(result.x, 3)
        XCTAssertEqual(result.y, 2)
        XCTAssertEqual(result.z, 3)
    }
    
    func testFloatingPointInitWithBinaryInteger() {
        let vecInt = Vector3<Int>(x: 1, y: 2, z: 3)
        
        let vec = Vector3<Float>(vecInt)
        
        XCTAssertEqual(vec.x, 1)
        XCTAssertEqual(vec.y, 2)
        XCTAssertEqual(vec.z, 3)
    }
    
    func testLength() {
        XCTAssertEqual(Vector3(x: 3, y: 2, z: 1).length, 3.7416573867739413, accuracy: accuracy)
    }
    
    func testPowFactor_double() {
        let vec = Vector3D(x: 2, y: 3, z: 5)
        
        let result = Vector3D.pow(vec, 6.0)
        
        XCTAssertEqual(result.x, 64)
        XCTAssertEqual(result.y, 729)
        XCTAssertEqual(result.z, 15625)
    }
    
    func testPowFactor_double_negativeBase() {
        let vec = Vector3D(x: -2, y: -3, z: -5)
        
        let result = Vector3D.pow(vec, 6.0)
        
        XCTAssertTrue(result.x.isNaN)
        XCTAssertTrue(result.y.isNaN)
        XCTAssertTrue(result.z.isNaN)
    }
    
    func testPowFactor_integer() {
        let vec = Vector3D(x: 2, y: 3, z: 5)
        
        let result = Vector3D.pow(vec, 6)
        
        XCTAssertEqual(result.x, 64)
        XCTAssertEqual(result.y, 729)
        XCTAssertEqual(result.z, 15625)
    }
    
    func testPowFactor_integer_negativeBase() {
        let vec = Vector3D(x: -2, y: -3, z: -5)
        
        let result = Vector3D.pow(vec, 6)
        
        XCTAssertEqual(result.x, 64)
        XCTAssertEqual(result.y, 729)
        XCTAssertEqual(result.z, 15625)
    }
    
    func testPowVector() {
        let vec = Vector3D(x: 2, y: 3, z: 5)
        let power = Vector3D(x: 6, y: 7, z: 8)
        
        let result = Vector3D.pow(vec, power)
        
        XCTAssertEqual(result.x, 64)
        XCTAssertEqual(result.y, 2187)
        XCTAssertEqual(result.z, 390625)
    }
    
    func testPowVector_negativeBase() {
        let vec = Vector3D(x: -2, y: -3, z: -5)
        let power = Vector3D(x: 6, y: 7, z: 8)
        
        let result = Vector3D.pow(vec, power)
        
        XCTAssertTrue(result.x.isNaN)
        XCTAssertTrue(result.y.isNaN)
        XCTAssertTrue(result.z.isNaN)
    }
    
    func testAzimuth() {
        XCTAssertEqual(Vector3D(x: 1, y: 1, z: -1).azimuth, 0.7853981633974483)
        XCTAssertEqual(Vector3D(x: 1, y: 1, z: 0).azimuth, 0.7853981633974483)
        XCTAssertEqual(Vector3D(x: 1, y: 1, z: 1).azimuth, 0.7853981633974483)
    }
    
    func testElevation() {
        XCTAssertEqual(Vector3D(x: 0, y: 0, z: 1).elevation, .pi / 2)
        XCTAssertEqual(Vector3D(x: 0, y: 0, z: -1).elevation, -.pi / 2)
        XCTAssertEqual(Vector3D(x: -1, y: -1, z: 1).elevation, 0.6154797086703875)
        XCTAssertEqual(Vector3D(x: 1, y: -1, z: 1).elevation, 0.6154797086703875)
        XCTAssertEqual(Vector3D(x: 1, y: 1, z: 1).elevation, 0.6154797086703875)
        XCTAssertEqual(Vector3D(x: -1, y: 1, z: 1).elevation, 0.6154797086703875)
    }
    
    func testElevation_zeroZ() {
        XCTAssertEqual(Vector3D(x: -1, y: -1, z: 0).elevation, 0)
        XCTAssertEqual(Vector3D(x: 1, y: -1, z: 0).elevation, 0)
        XCTAssertEqual(Vector3D(x: 1, y: 1, z: 0).elevation, 0)
        XCTAssertEqual(Vector3D(x: -1, y: 1, z: 0).elevation, 0)
    }
    
    func testElevation_zeroLength() {
        XCTAssertEqual(Vector3D.zero.elevation, 0)
    }
}
