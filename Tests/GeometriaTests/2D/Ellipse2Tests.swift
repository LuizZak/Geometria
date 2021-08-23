import XCTest
import Geometria

class Ellipse2Tests: XCTestCase {
    typealias Ellipse = Ellipse2D
    
    func testCodable() throws {
        let sut = Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(Ellipse.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testEquals() {
        XCTAssertEqual(Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5),
                       Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))
    }
    
    func testUnequals() {
        XCTAssertNotEqual(Ellipse(center: .init(x: 999, y: 2), radiusX: 3, radiusY: 5),
                          Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))
        
        XCTAssertNotEqual(Ellipse(center: .init(x: 1, y: 999), radiusX: 3, radiusY: 5),
                          Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))
        
        XCTAssertNotEqual(Ellipse(center: .init(x: 1, y: 2), radiusX: 999, radiusY: 5),
                          Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))
        
        XCTAssertNotEqual(Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 999),
                          Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))
    }
    
    func testHashable() {
        XCTAssertEqual(Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue,
                       Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)
        
        XCTAssertNotEqual(Ellipse(center: .init(x: 999, y: 2), radiusX: 3, radiusY: 5).hashValue,
                          Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)
        
        XCTAssertNotEqual(Ellipse(center: .init(x: 1, y: 999), radiusX: 3, radiusY: 5).hashValue,
                          Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)
        
        XCTAssertNotEqual(Ellipse(center: .init(x: 1, y: 2), radiusX: 999, radiusY: 5).hashValue,
                          Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)
        
        XCTAssertNotEqual(Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 999).hashValue,
                          Ellipse(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)
    }
}


// MARK: Scalar: Real Conformance

extension Ellipse2Tests {
    func testContainsVector() {
        let sut = Ellipse(center: .one, radiusX: 1, radiusY: 2)
        
        XCTAssertTrue(sut.contains(.one))
        XCTAssertTrue(sut.contains(.init(x: 0, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 2, y: 1)))
        XCTAssertFalse(sut.contains(.zero))
        XCTAssertFalse(sut.contains(.init(x: 2, y: 2)))
    }
}

// MARK: Vector: Vector2Type, Scalar: Real Conformance

extension Ellipse2Tests {
    func testContainsXY() {
        let sut = Ellipse(center: .one, radiusX: 1, radiusY: 2)
        
        XCTAssertTrue(sut.contains(x: 1, y: 1))
        XCTAssertTrue(sut.contains(x: 0, y: 1))
        XCTAssertTrue(sut.contains(x: 2, y: 1))
        XCTAssertFalse(sut.contains(x: 0, y: 0))
        XCTAssertFalse(sut.contains(x: 2, y: 2))
    }
}
