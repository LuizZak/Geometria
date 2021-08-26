import XCTest
import Geometria

class LineTests: XCTestCase {
    typealias Line = Line2D
    typealias Line3 = Line3D
    
    func testCodable() throws {
        let sut = Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5))
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(Line.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testEquals() {
        XCTAssertEqual(Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)),
                       Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
    }
    
    func testUnequals() {
        XCTAssertNotEqual(Line(a: .init(x: 999, y: 2), b: .init(x: 3, y: 5)),
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(Line(a: .init(x: 1, y: 999), b: .init(x: 3, y: 5)),
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(Line(a: .init(x: 1, y: 2), b: .init(x: 999, y: 5)),
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
        
        XCTAssertNotEqual(Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 999)),
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)))
    }
    
    func testHashable() {
        XCTAssertEqual(Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue,
                       Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Line(a: .init(x: 999, y: 2), b: .init(x: 3, y: 5)).hashValue,
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Line(a: .init(x: 1, y: 999), b: .init(x: 3, y: 5)).hashValue,
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Line(a: .init(x: 1, y: 2), b: .init(x: 999, y: 5)).hashValue,
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
        
        XCTAssertNotEqual(Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 999)).hashValue,
                          Line(a: .init(x: 1, y: 2), b: .init(x: 3, y: 5)).hashValue)
    }
}

// MARK: VectorFloatingPoint Conformance

extension LineTests {
    func testDistanceSquaredTo2D() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 1)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 0.5, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo2D_pastStart() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: -1, y: 0)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 0.5, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo2D_pastEnd() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 1, y: 3)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 2, accuracy: 1e-15)
    }
    
    func testDistanceSquaredTo3D() {
        let sut = Line3(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.distanceSquared(to: point), 0.6666666666666667, accuracy: 1e-15)
    }
}

// MARK: VectorReal Conformance

extension LineTests {
    func testDistanceTo2D() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 1)
        
        XCTAssertEqual(sut.distance(to: point), 0.7071067811865476, accuracy: 1e-15)
    }
    
    func testDistanceTo2D_pastStart() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: -1, y: 0)
        
        XCTAssertEqual(sut.distance(to: point), 0.7071067811865476, accuracy: 1e-15)
    }
    
    func testDistanceTo2D_pastEnd() {
        let sut = Line(x1: 0, y1: 0, x2: 1, y2: 1)
        let point = Vector2D(x: 0, y: 2)
        
        XCTAssertEqual(sut.distance(to: point), 1.4142135623730951, accuracy: 1e-15)
    }
    
    func testDistanceTo3D() {
        let sut = Line3(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 1)
        let point = Vector3D(x: 1, y: 1, z: 0)
        
        XCTAssertEqual(sut.distance(to: point), 0.816496580927726, accuracy: 1e-15)
    }
}
