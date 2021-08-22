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
