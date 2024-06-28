import XCTest
import Geometria
import TestCommons

class VectorDivisibleTests: XCTestCase {
    typealias Vector = Vector2D

    func testAverageVector() {
        let list = [
            Vector(x: -1, y: -1),
            Vector(x: 0, y: 0),
            Vector(x: 10, y: 7)
        ]
        
        XCTAssertEqual(list.averageVector(), Vector(x: 3, y: 2))
    }
    
    func testAverageVector_emptyCollection() {
        let list: [Vector] = []
        
        XCTAssertEqual(list.averageVector(), Vector.zero)
    }

    func testDivision_inPlace() {
        var vec1 = Vector2i(x: 3, y: 5)
        
        vec1 /= Vector2i(x: 2, y: 3)
        
        XCTAssertEqual(vec1, Vector2i(x: 1, y: 1))
    }
    
    func testDivision_withScalar_inPlace() {
        var vec1 = Vector2i(x: 1, y: 4)
        
        vec1 /= 3
        
        XCTAssertEqual(vec1, Vector2i(x: 0, y: 1))
    }
}
