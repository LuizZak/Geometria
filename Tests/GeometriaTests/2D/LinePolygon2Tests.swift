import XCTest
import Geometria

class LinePolygon2Tests: XCTestCase {
    typealias LinePolygon = LinePolygon2D
    
    func testAddVertexXY() {
        var sut = LinePolygon(vertices: [])
        
        sut.addVertex(x: 1, y: 2)
        sut.addVertex(x: 3, y: 5)
        
        XCTAssertEqual(sut.vertices, [
            .init(x: 1, y: 2),
            .init(x: 3, y: 5)
        ])
    }
}

// MARK: Vector2Multiplicative & VectorComparable Conformance

extension LinePolygon2Tests {
    func testIsConvex_triangle() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 3, y: 3),
            .init(x: 3, y: 0)
        ])
        
        XCTAssertTrue(sut.isConvex())
    }
    
    func testIsConvex_arrow() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 3, y: 3),
            .init(x: 1.5, y: 2),
            .init(x: 3, y: 0)
        ])
        
        XCTAssertFalse(sut.isConvex())
    }
    
    func testIsConvex_lineSegment() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 3, y: 3)
        ])
        
        XCTAssertFalse(sut.isConvex())
    }
    
    func testIsConvex_point() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0)
        ])
        
        XCTAssertFalse(sut.isConvex())
    }
    
    func testIsConvex_empty() {
        let sut = LinePolygon()
        
        XCTAssertFalse(sut.isConvex())
    }
}
