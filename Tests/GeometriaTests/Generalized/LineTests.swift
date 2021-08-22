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

// MARK: VectorReal Conformance

extension LineTests {
    func testLength() {
        let sut = Line(start: .init(x: 1, y: 2), end: .init(x: 3, y: 5))
        
        XCTAssertEqual(sut.length, 3.605551275463989, accuracy: 1e-13)
    }
}
