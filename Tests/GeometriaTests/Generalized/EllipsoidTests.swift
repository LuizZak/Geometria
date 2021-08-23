import XCTest
import Geometria

class EllipsoidTests: XCTestCase {
    typealias Ellipsoid = Ellipse2D
    
    func testCodable() throws {
        let sut = Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(Ellipsoid.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testEquals() {
        XCTAssertEqual(Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5),
                       Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))
    }
    
    func testUnequals() {
        XCTAssertNotEqual(Ellipsoid(center: .init(x: 999, y: 2), radiusX: 3, radiusY: 5),
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))
        
        XCTAssertNotEqual(Ellipsoid(center: .init(x: 1, y: 999), radiusX: 3, radiusY: 5),
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))
        
        XCTAssertNotEqual(Ellipsoid(center: .init(x: 1, y: 2), radiusX: 999, radiusY: 5),
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))
        
        XCTAssertNotEqual(Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 999),
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))
    }
    
    func testHashable() {
        XCTAssertEqual(Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue,
                       Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)
        
        XCTAssertNotEqual(Ellipsoid(center: .init(x: 999, y: 2), radiusX: 3, radiusY: 5).hashValue,
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)
        
        XCTAssertNotEqual(Ellipsoid(center: .init(x: 1, y: 999), radiusX: 3, radiusY: 5).hashValue,
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)
        
        XCTAssertNotEqual(Ellipsoid(center: .init(x: 1, y: 2), radiusX: 999, radiusY: 5).hashValue,
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)
        
        XCTAssertNotEqual(Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 999).hashValue,
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)
    }
}


// MARK: VectorReal Conformance

extension EllipsoidTests {
    func testContainsVector() {
        let sut = Ellipsoid(center: .one, radiusX: 1, radiusY: 2)
        
        XCTAssertTrue(sut.contains(.one))
        XCTAssertTrue(sut.contains(.init(x: 0, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 2, y: 1)))
        XCTAssertFalse(sut.contains(.zero))
        XCTAssertFalse(sut.contains(.init(x: 2, y: 2)))
    }
}
