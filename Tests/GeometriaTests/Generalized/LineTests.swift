import XCTest
import Geometria

class LineTests: XCTestCase {
    typealias Line = Line2D
    
    func testCodable() throws {
        let sut = Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(Line.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testEquals() {
        XCTAssertEqual(Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)),
                       Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
    }
    
    func testUnequals() {
        XCTAssertNotEqual(Line(start: .init(x: 999, y: 2), end: .init(x: 3, y: 5)),
                          Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(Line(start: .init(x: 1, y: 999), end: .init(x: 3, y: 5)),
                          Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(Line(start: .init(x: 1, y: 2), end: .init(x: 999, y: 5)),
                          Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 999)),
                          Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
    }
    
    func testHashable() {
        XCTAssertEqual(Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue,
                       Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Line(start: .init(x: 999, y: 2), end: .init(x: 3, y: 5)).hashValue,
                          Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Line(start: .init(x: 1, y: 999), end: .init(x: 3, y: 5)).hashValue,
                          Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Line(start: .init(x: 1, y: 2), end: .init(x: 999, y: 5)).hashValue,
                          Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 999)).hashValue,
                          Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
    }
}

// MARK: VectorMultiplicative Conformance

extension LineTests {
    func testLengthSquared() {
        let sut = Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.lengthSquared, 13)
    }
}

// MARK: VectorDivisible Conformance

extension LineTests {
    func testProjectScalar2D() {
        let sut = Line(x1: 2, y1: 1, x2: 3, y2: 2)
        let point = Vector2D(x: 2, y: 2)
        
        XCTAssertEqual(sut.projectScalar(point), 0.5, accuracy: 1e-12)
    }
    
    func testProjectScalar2D_offBounds() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 0)
        let point = Vector2D(x: -2, y: 2)
        
        XCTAssertEqual(sut.projectScalar(point), -2)
    }
    
    func testProjectScalar2D_skewed() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 2)
        
        XCTAssertEqual(sut.projectScalar(point), 1, accuracy: 1e-12)
    }
    
    func testProjectScalar3D() {
        let sut = Line3D(x1: 0, y1: 0, z1: 0, x2: 3, y2: 0, z2: 0)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.projectScalar(point), 0.3333333333333333, accuracy: 1e-12)
    }
    
    func testProjectScalar3D_offBounds() {
        let sut = Line3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 0, z2: 0)
        let point = Vector3D(x: -3, y: 1, z: 0)
        
        XCTAssertEqual(sut.projectScalar(point), -3)
    }
    
    func testProjectScalar3D_skewed() {
        let sut = Line3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 0, y: 2, z: 0)
        
        XCTAssertEqual(sut.projectScalar(point), 0.6666666666666666, accuracy: 1e-12)
    }
    
    func testProject2D() {
        let sut = Line(x1: 2, y1: 1, x2: 3, y2: 2)
        let point = Vector2D(x: 2, y: 2)
        
        assertEqual(sut.project(point),
                    Vector2D(x: 2.5, y: 1.5),
                    accuracy: 1e-12)
    }
    
    func testProject2D_parallel() {
        let sut = Line2D(x1: 0, y1: 0, x2: 3, y2: 0)
        let point = Vector2D(x: 1, y: 0)
        
        assertEqual(sut.project(point),
                    Vector2D(x: 1, y: 0),
                    accuracy: 1e-12)
    }
    
    func testProject2D_offBounds() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 0)
        let point = Vector2D(x: -2, y: 2)
        
        XCTAssertEqual(sut.project(point), Vector2D(x: -2, y: 0))
    }
    
    func testProject2D_skewed() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 2)
        
        assertEqual(sut.project(point),
                    Vector2D(x: 1, y: 1),
                    accuracy: 1e-12)
    }
    
    func testProject2D_skewed_centered() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 1)
        
        assertEqual(sut.project(point),
                    Vector2D(x: 0.5, y: 0.5),
                    accuracy: 1e-12)
    }
    
    func testProject3D_parallel() {
        let sut = Line3D(x1: 0, y1: 0, z1: 0, x2: 3, y2: 0, z2: 0)
        let point = Vector3D(x: 1, y: 0, z: 0)
        
        assertEqual(sut.project(point),
                    Vector3D(x: 1, y: 0, z: 0),
                    accuracy: 1e-12)
    }
    
    func testProject3D_offBounds() {
        let sut = Line3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 0, z2: 0)
        let point = Vector3D(x: -3, y: 1, z: 0)
        
        XCTAssertEqual(sut.project(point), Vector3D(x: -3, y: 0, z: 0))
    }
    
    func testProject3D_skewed() {
        let sut = Line3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 0, y: 2, z: 0)
        
        assertEqual(sut.project(point),
                    Vector3D(x: 0.6666666666666666, y: 0.6666666666666666, z: 0.6666666666666666),
                    accuracy: 1e-12)
    }
    
    func testProject3D_skewed_centered() {
        let sut = Line3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        assertEqual(sut.project(point),
                    Vector3D(x: 0.6666666666666666, y: 0.6666666666666666, z: 0.6666666666666666),
                    accuracy: 1e-12)
    }
}

// MARK: VectorReal Conformance

extension LineTests {
    func testLength() {
        let sut = Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.length, 3.605551275463989, accuracy: 1e-13)
    }
    
    func testDistanceTo2D() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 1)
        
        XCTAssertEqual(sut.distance(to: point), 0.7071067811865476, accuracy: 1e-15)
    }
    
    func testDistanceTo3D() {
        let sut = Line3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.distance(to: point), 0.816496580927726, accuracy: 1e-15)
    }
}
