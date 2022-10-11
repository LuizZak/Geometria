import XCTest
import Geometria

class EdgeInsets2Tests: XCTestCase {
    typealias EdgeInsets = EdgeInsets2D
    
    func testCodable() throws {
        let sut = EdgeInsets(left: 1, top: 2, right: 3, bottom: 5)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(EdgeInsets.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testInitWithScalar() {
        let sut = EdgeInsets(2)
        
        XCTAssertEqual(sut.left, 2)
        XCTAssertEqual(sut.top, 2)
        XCTAssertEqual(sut.right, 2)
        XCTAssertEqual(sut.bottom, 2)
    }
    
    func testEquals() {
        XCTAssertEqual(
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 5),
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 5)
        )
    }
    
    func testUnequals() {
        XCTAssertNotEqual(
            EdgeInsets(left: 2, top: 999, right: 5, bottom: 3),
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 5)
        )
        XCTAssertNotEqual(
            EdgeInsets(left: 999, top: 1, right: 5, bottom: 3),
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 5)
        )
        XCTAssertNotEqual(
            EdgeInsets(left: 2, top: 1, right: 5, bottom: 999),
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 5)
        )
        XCTAssertNotEqual(
            EdgeInsets(left: 2, top: 1, right: 999, bottom: 3),
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 5)
        )
    }
    
    func testHashable() {
        XCTAssertEqual(
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 5).hashValue,
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 5).hashValue
        )
        XCTAssertNotEqual(
            EdgeInsets(left: 2, top: 999, right: 3, bottom: 5).hashValue,
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 5).hashValue
        )
        XCTAssertNotEqual(
            EdgeInsets(left: 999, top: 1, right: 3, bottom: 5).hashValue,
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 5).hashValue
        )
        XCTAssertNotEqual(
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 999).hashValue,
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 5).hashValue
        )
        XCTAssertNotEqual(
            EdgeInsets(left: 1, top: 2, right: 999, bottom: 5).hashValue,
            EdgeInsets(left: 1, top: 2, right: 3, bottom: 5).hashValue
        )
    }
    
    func testZero() {
        let result = EdgeInsets.zero
        
        XCTAssertEqual(result.left, 0)
        XCTAssertEqual(result.top, 0)
        XCTAssertEqual(result.right, 0)
        XCTAssertEqual(result.bottom, 0)
    }
    
    func testInsetRectangle() {
        let rect = Rectangle2D(x: 1, y: 2, width: 13, height: 17)
        let sut = EdgeInsets(left: 1, top: 2, right: 3, bottom: 5)
        
        let result = sut.inset(rectangle: rect)
        
        XCTAssertEqual(result.x, 2)
        XCTAssertEqual(result.y, 4)
        XCTAssertEqual(result.width, 9)
        XCTAssertEqual(result.height, 10)
    }
}
