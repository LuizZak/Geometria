import XCTest
import Geometria

class LineSegmentTests: XCTestCase {
    typealias LineSegment = LineSegment2D
    typealias LineSegment3 = LineSegment3D
    
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
    
    func testAsLine() {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        let result = sut.asLine
        
        XCTAssertEqual(result.a, .init(x: 1, y: 2))
        XCTAssertEqual(result.b, .init(x: 3, y: 5))
    }
    
    func testAsRay() {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        let result = sut.asRay
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.b, .init(x: 3, y: 5))
    }
}

// MARK: LineType Conformance

extension LineSegmentTests {
    func testA() {
        let sut = LineSegment(start: .zero, end: .one)
        
        XCTAssertEqual(sut.a, .zero)
    }
    
    func testB() {
        let sut = LineSegment(start: .zero, end: .one)
        
        XCTAssertEqual(sut.b, .one)
    }
}

// MARK: BoundedVolumeType Conformance

extension LineSegmentTests {
    func testBounds() {
        let sut = LineSegment(start: .init(x: 1, y: -2), end: .init(x: -3, y: 5))
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -3, y: -2))
        XCTAssertEqual(result.maximum, .init(x: 1, y: 5))
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
        let sut = LineSegment3(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
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
        let sut = LineSegment3(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.distance(to: point), 0.816496580927726, accuracy: 1e-15)
    }
}

// MARK: VectorNormalizable Conformance

extension LineSegmentTests {
    func testAsDirectionalRay() {
        let sut = LineSegment(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        let result = sut.asDirectionalRay
        
        XCTAssertEqual(result.start, .init(x: 1, y: 2))
        XCTAssertEqual(result.direction, .init(x: 0.5547001962252291, y: 0.8320502943378437))
        XCTAssertEqual(result.angle, sut.angle)
    }
}
