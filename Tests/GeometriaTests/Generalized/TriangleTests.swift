import XCTest
import Geometria

class TriangleTests: XCTestCase {
    typealias Triangle = Geometria.Triangle<Vector2D>
    
    func testLineAB() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 0.5, y: 0.5))
        
        let result = sut.lineAB
        
        XCTAssertEqual(result.start, .init(x: 0, y: 0))
        XCTAssertEqual(result.end, .init(x: 1, y: 1))
    }
    
    func testLineAC() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 0.5, y: 0.5))
        
        let result = sut.lineAC
        
        XCTAssertEqual(result.start, .init(x: 0, y: 0))
        XCTAssertEqual(result.end, .init(x: 0.5, y: 0.5))
    }
    
    func testLineBC() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 0.5, y: 0.5))
        
        let result = sut.lineBC
        
        XCTAssertEqual(result.start, .init(x: 1, y: 1))
        XCTAssertEqual(result.end, .init(x: 0.5, y: 0.5))
    }
    
    func testLineBA() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 0.5, y: 0.5))
        
        let result = sut.lineBA
        
        XCTAssertEqual(result.start, .init(x: 1, y: 1))
        XCTAssertEqual(result.end, .init(x: 0, y: 0))
    }
    
    func testLineCA() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 0.5, y: 0.5))
        
        let result = sut.lineCA
        
        XCTAssertEqual(result.start, .init(x: 0.5, y: 0.5))
        XCTAssertEqual(result.end, .init(x: 0, y: 0))
    }
    
    func testLineCB() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 0.5, y: 0.5))
        
        let result = sut.lineCB
        
        XCTAssertEqual(result.start, .init(x: 0.5, y: 0.5))
        XCTAssertEqual(result.end, .init(x: 1, y: 1))
    }
}

// MARK: BoundableType Conformance

extension TriangleTests {
    func testBounds_zeroTriangle() {
        let sut = Triangle(a: .zero, b: .zero, c: .zero)
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .zero)
        XCTAssertEqual(result.maximum, .zero)
    }
    
    func testBounds() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 1, y: -1))
        
        let result = sut.bounds
        
        XCTAssertEqual(result.minimum, .init(x: 0, y: -1))
        XCTAssertEqual(result.maximum, .init(x: 1, y: 1))
    }
}

// MARK: Vector: VectorDivisible

extension TriangleTests {
    func testCenter() {
        let sut = Triangle(
            a: .init(x: 1, y: 2),
            b: .init(x: 3, y: 5),
            c: .init(x: 7, y: 11)
        )
        
        let result = sut.center
        
        XCTAssertEqual(result.x, 3.6666666666666665)
        XCTAssertEqual(result.y, 6.0)
    }
    
    func testCenter_zeroTriangle_returnsZero() {
        let sut = Triangle(a: .zero, b: .zero, c: .zero)
        
        let result = sut.center
        
        XCTAssertEqual(result.x, 0.0)
        XCTAssertEqual(result.y, 0.0)
    }
}

// MARK: Vector: VectorFloatingPoint

extension TriangleTests {
    func testArea_emptyTriangle() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 0.5, y: 0.5))
        
        XCTAssertEqual(sut.area, 0.0)
    }
    
    func testArea_allZerosTriangle() {
        let sut = Triangle(a: .zero, b: .zero, c: .zero)
        
        XCTAssertEqual(sut.area, 0.0)
    }
    
    func testArea_simpleRightTriangle() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 1, y: 0))
        
        XCTAssertEqual(sut.area, 0.5)
    }
    
    func testArea_largeTriangle() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 131, y: 230),
            c: .init(x: 97, y: 10)
        )
        
        XCTAssertEqual(sut.area, 10500.0)
    }
    
    func testArea_largeTriangle_counterClockwise() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 97, y: 10),
            c: .init(x: 131, y: 230)
        )
        
        XCTAssertEqual(sut.area, 10500.0)
    }
}
