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

// MARK: VolumetricType Conformance

extension LinePolygon2Tests {
    func testContains_emptyPolygon() {
        let sut = LinePolygon()
        
        XCTAssertFalse(sut.contains(x: 0, y: 0))
    }
    
    func testContains_singlePointPolygon() {
        let sut = LinePolygon(vertices: [.zero])
        
        XCTAssertFalse(sut.contains(x: 0, y: 0))
    }
    
    func testContains_dualPointPolygon() {
        let sut = LinePolygon(vertices: [.zero, .one])
        
        XCTAssertFalse(sut.contains(x: 0, y: 0))
    }
    
    func testContains_convex() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 2),
            .init(x: 0, y: 2)
        ])
        
        XCTAssertTrue(sut.contains(x: 0.5, y: 0.5))
        XCTAssertTrue(sut.contains(x: 1, y: 0.5))
        XCTAssertTrue(sut.contains(x: 1, y: 1))
        XCTAssertTrue(sut.contains(x: 0.5, y: 1))
    }
    
    func testContains_outsideAABB() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 2, y: 0),
            .init(x: 2, y: 2),
            .init(x: 0, y: 2)
        ])
        
        XCTAssertFalse(sut.contains(x: -1, y: -1))
        XCTAssertFalse(sut.contains(x: 3, y: -1))
        XCTAssertFalse(sut.contains(x: 3, y: 3))
        XCTAssertFalse(sut.contains(x: -1, y: 3))
    }
    
    func testContains_concave() {
        /// Create a square shape with a triangle-shaped wedge on the top edge:
        ///
        /// ┌╲    ╱┐
        /// │  ╲╱  │
        /// │      │
        /// └──────┘
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 1),
            .init(x: 2, y: 0),
            .init(x: 2, y: 2),
            .init(x: 0, y: 2)
        ])
        
        XCTAssertTrue(sut.contains(x: 0.5, y: 0.5))
        XCTAssertTrue(sut.contains(x: 0.2, y: 0.5))
        XCTAssertFalse(sut.contains(x: 1, y: 0.5))
        XCTAssertTrue(sut.contains(x: 1.8, y: 0.5))
        XCTAssertTrue(sut.contains(x: 1, y: 1))
        XCTAssertTrue(sut.contains(x: 0.5, y: 1))
    }
}