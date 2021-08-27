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
