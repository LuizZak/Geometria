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

// MARK: BoundableType Conformance

extension LinePolygonTests {
    func testBounds() {
        let sut = LinePolygon(vertices: [
            .init(x: -2, y: 3),
            .init(x: 4, y: 1),
            .init(x: 3, y: -4)
        ])
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: -2, y: -4))
        XCTAssertEqual(result.maximum, .init(x: 4, y: 3))
    }
    
    func testBounds_empty() {
        let sut = LinePolygon()
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .zero)
        XCTAssertEqual(result.maximum, .zero)
    }
}

// MARK: VectorFloatingPoint Conformance

extension LinePolygonTests {
    func testAverage_emptyVertices() {
        let sut = LinePolygon(vertices: [])
        
        XCTAssertEqual(sut.average, .zero)
    }
    
    func testAverage_singleVertex() {
        let sut = LinePolygon(vertices: [
            .init(x: 1, y: 2)
        ])
        
        XCTAssertEqual(sut.average, .init(x: 1, y: 2))
    }
    
    func testAverage_multiVertices() {
        let sut = LinePolygon(vertices: [
            .init(x: 1, y: 2),
            .init(x: 3, y: 5),
            .init(x: 7, y: 11),
            .init(x: 13, y: 17),
        ])
        
        XCTAssertEqual(sut.average, .init(x: 6, y: 8.75))
    }
}
