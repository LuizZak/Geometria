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

// MARK: VectorAdditive Conformance

extension Vector4Tests {
    func testAddition() {
        XCTAssertEqual(Vector(x: 1, y: 2, z: 3, w: 4) + Vector(x: 5, y: 6, z: 7, w: 8),
                       Vector(x: 6, y: 8, z: 10, w: 12))
    }
    
    func testAddition_isCommutative() {
        XCTAssertEqual(Vector(x: 1, y: 2, z: 3, w: 4) + Vector(x: 5, y: 6, z: 7, w: 8),
                       Vector(x: 5, y: 6, z: 7, w: 8) + Vector(x: 1, y: 2, z: 3, w: 4))
    }
    
    func testAddition_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 2, z: 3, w: 4) + 5,
                       Vector(x: 6, y: 7, z: 8, w: 9))
    }
    
    func testSubtraction() {
        XCTAssertEqual(Vector(x: 1, y: 2, z: 3, w: 4) - Vector(x: 7, y: 11, z: 13, w: 17),
                       Vector(x: -6, y: -9, z: -10, w: -13))
    }
    
    func testSubtraction_withScalar() {
        XCTAssertEqual(Vector(x: 1, y: 2, z: 3, w: 5) - 7,
                       Vector(x: -6, y: -5, z: -4, w: -2))
    }
}
