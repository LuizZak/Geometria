import XCTest
import Geometria

class LineSegmentTests: XCTestCase {
    typealias LineSegment = LineSegment2D
    
    func testCodable() throws {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(LineSegment.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testEquals() {
        XCTAssertEqual(LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)),
                       LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
    }
    
    func testUnequals() {
        XCTAssertNotEqual(LineSegment(start: .init(x: 999, y: 2), end: .init(x: 3, y: 5)),
                          LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(LineSegment(start: .init(x: 1, y: 999), end: .init(x: 3, y: 5)),
                          LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(LineSegment(start: .init(x: 1, y: 2), end: .init(x: 999, y: 5)),
                          LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 999)),
                          LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)))
    }
    
    func testHashable() {
        XCTAssertEqual(LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue,
                       LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(LineSegment(start: .init(x: 999, y: 2), end: .init(x: 3, y: 5)).hashValue,
                          LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(LineSegment(start: .init(x: 1, y: 999), end: .init(x: 3, y: 5)).hashValue,
                          LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(LineSegment(start: .init(x: 1, y: 2), end: .init(x: 999, y: 5)).hashValue,
                          LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 999)).hashValue,
                          LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5)).hashValue)
    }
}

// MARK: VectorMultiplicative Conformance

extension LineSegmentTests {
    func testLengthSquared() {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.lengthSquared, 13)
    }
}

// MARK: VectorFloatingPoint Conformance

extension LineSegmentTests {
    func testProjectScalar2D() {
        let sut = LineSegment(x1: 2, y1: 1, x2: 3, y2: 2)
        let point = Vector2D(x: 2, y: 2)
        
        XCTAssertEqual(sut.projectScalar(point), 0.5, accuracy: 1e-12)
    }
    
    func testProjectScalar2D_offBounds() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 0)
        let point = Vector2D(x: -2, y: 2)
        
        XCTAssertEqual(sut.projectScalar(point), -2)
    }
    
    func testProjectScalar2D_skewed() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 2)
        
        XCTAssertEqual(sut.projectScalar(point), 1, accuracy: 1e-12)
    }
    
    func testProjectScalar3D() {
        let sut = LineSegment3D(x1: 0, y1: 0, z1: 0, x2: 3, y2: 0, z2: 0)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.projectScalar(point), 0.3333333333333333, accuracy: 1e-12)
    }
    
    func testProjectScalar3D_offBounds() {
        let sut = LineSegment3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 0, z2: 0)
        let point = Vector3D(x: -3, y: 1, z: 0)
        
        XCTAssertEqual(sut.projectScalar(point), -3)
    }
    
    func testProjectScalar3D_skewed() {
        let sut = LineSegment3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 0, y: 2, z: 0)
        
        XCTAssertEqual(sut.projectScalar(point), 0.6666666666666666, accuracy: 1e-12)
    }
    
    func testProject2D() {
        let sut = LineSegment(x1: 2, y1: 1, x2: 3, y2: 2)
        let point = Vector2D(x: 2, y: 2)
        
        assertEqual(sut.project(point),
                    Vector2D(x: 2.5, y: 1.5),
                    accuracy: 1e-12)
    }
    
    func testProject2D_parallel() {
        let sut = LineSegment2D(x1: 0, y1: 0, x2: 3, y2: 0)
        let point = Vector2D(x: 1, y: 0)
        
        assertEqual(sut.project(point),
                    Vector2D(x: 1, y: 0),
                    accuracy: 1e-12)
    }
    
    func testProject2D_offBounds() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 0)
        let point = Vector2D(x: -2, y: 2)
        
        XCTAssertEqual(sut.project(point), Vector2D(x: -2, y: 0))
    }
    
    func testProject2D_skewed() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 2)
        
        assertEqual(sut.project(point),
                    Vector2D(x: 1, y: 1),
                    accuracy: 1e-12)
    }
    
    func testProject2D_skewed_centered() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 1)
        
        assertEqual(sut.project(point),
                    Vector2D(x: 0.5, y: 0.5),
                    accuracy: 1e-12)
    }
    
    func testProject3D_parallel() {
        let sut = LineSegment3D(x1: 0, y1: 0, z1: 0, x2: 3, y2: 0, z2: 0)
        let point = Vector3D(x: 1, y: 0, z: 0)
        
        assertEqual(sut.project(point),
                    Vector3D(x: 1, y: 0, z: 0),
                    accuracy: 1e-12)
    }
    
    func testProject3D_offBounds() {
        let sut = LineSegment3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 0, z2: 0)
        let point = Vector3D(x: -3, y: 1, z: 0)
        
        XCTAssertEqual(sut.project(point), Vector3D(x: -3, y: 0, z: 0))
    }
    
    func testProject3D_skewed() {
        let sut = LineSegment3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 0, y: 2, z: 0)
        
        assertEqual(sut.project(point),
                    Vector3D(x: 0.6666666666666666, y: 0.6666666666666666, z: 0.6666666666666666),
                    accuracy: 1e-12)
    }
    
    func testProject3D_skewed_centered() {
        let sut = LineSegment3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        assertEqual(sut.project(point),
                    Vector3D(x: 0.6666666666666666, y: 0.6666666666666666, z: 0.6666666666666666),
                    accuracy: 1e-12)
    }
    
    func testDistanceSquaredTo2D() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 1)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 0.5, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo2D_pastStart() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: -1, y: 0)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 1, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo2D_pastEnd() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 1, y: 3)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 4, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo3D() {
        let sut = LineSegment3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 0.6666666666666667, accuracy: 1e-15)
    }
}

// MARK: VectorReal Conformance

extension LineSegmentTests {
    func testLength() {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.length, 3.605551275463989, accuracy: 1e-13)
    }
    
    func testDistanceTo2D() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 1)
        
        XCTAssertEqual(sut.distance(to: point), 0.7071067811865476, accuracy: 1e-15)
    }
    
    func testDistanceTo2D_pastStart() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: -1, y: 0)
        
        XCTAssertEqual(sut.distance(to: point), 1, accuracy: 1e-15)
    }
    
    func testDistanceTo2D_pastEnd() {
        let sut = LineSegment(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 1, y: 2)
        
        XCTAssertEqual(sut.distance(to: point), 1, accuracy: 1e-15)
    }
    
    func testDistanceTo3D() {
        let sut = LineSegment3D(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.distance(to: point), 0.816496580927726, accuracy: 1e-15)
    }
}
