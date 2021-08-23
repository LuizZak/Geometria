import XCTest
import Geometria

class LinePolygonTests: XCTestCase {
    typealias LinePolygon = LinePolygon2D
    
    func testCodable() throws {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 0),
            .init(x: 1, y: 1)
        ])
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(sut)
        let result = try decoder.decode(LinePolygon.self, from: data)
        
        XCTAssertEqual(sut, result)
    }
    
    func testEquals() {
        XCTAssertEqual(LinePolygon(), LinePolygon())
        XCTAssertEqual(LinePolygon(vertices: [.init(x: 0, y: 0)]),
                       LinePolygon(vertices: [.init(x: 0, y: 0)]))
    }
    
    func testUnequals() {
        XCTAssertNotEqual(LinePolygon(vertices: []),
                          LinePolygon(vertices: [.init(x: 0, y: 0)]))
        
        XCTAssertNotEqual(LinePolygon(vertices: [.init(x: 999, y: 0)]),
                          LinePolygon(vertices: [.init(x: 0, y: 0)]))
        
        XCTAssertNotEqual(LinePolygon(vertices: [.init(x: 0, y: 999)]),
                          LinePolygon(vertices: [.init(x: 0, y: 0)]))
    }
    
    func testHashable() {
        XCTAssertNotEqual(LinePolygon(vertices: []).hashValue,
                          LinePolygon(vertices: [.init(x: 0, y: 0)]).hashValue)
        
        XCTAssertNotEqual(LinePolygon(vertices: [.init(x: 999, y: 0)]).hashValue,
                          LinePolygon(vertices: [.init(x: 0, y: 0)]).hashValue)
        
        XCTAssertNotEqual(LinePolygon(vertices: [.init(x: 0, y: 999)]).hashValue,
                          LinePolygon(vertices: [.init(x: 0, y: 0)]).hashValue)
    }
    
    func testAddVertex() {
        var sut = LinePolygon(vertices: [])
        
        sut.addVertex(.init(x: 1, y: 2))
        sut.addVertex(.init(x: 3, y: 5))
        
        XCTAssertEqual(sut.vertices, [
            .init(x: 1, y: 2),
            .init(x: 3, y: 5)
        ])
    }
}