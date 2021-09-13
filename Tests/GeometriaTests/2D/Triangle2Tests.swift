import XCTest
import Geometria

class Triangle2Tests: XCTestCase {
    typealias Vector = Vector2D
    typealias Triangle = Triangle2<Vector>
    
    func testIsClockwise() {
        let sut =
        Triangle(
            a: .zero,
            b: .one,
            c: .init(x: 1, y: 0)
        )
        
        XCTAssertTrue(sut.isClockwise)
    }
    
    func testIsClockwise_counterClockwise() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 1, y: 0),
            c: .one
        )
        
        XCTAssertFalse(sut.isClockwise)
    }
    
    func testIsClockwise_colinear_returnsFalse() {
        let sut =
        Triangle(
            a: .zero,
            b: .one,
            c: .init(x: 2, y: 2)
        )
        
        XCTAssertFalse(sut.isClockwise)
    }
    
    func testIsClockwise_colinear_cBeforeB_returnsFalse() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 2, y: 2),
            c: .one
        )
        
        XCTAssertFalse(sut.isClockwise)
    }
}

// MARK: VolumetricType Conformance

extension Triangle2Tests {
    func testContains_emptyTriangle() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 1, y: 0),
            c: .init(x: 2, y: 0)
        )
        
        XCTAssertFalse(sut.contains(x: 0, y: 0))
        XCTAssertFalse(sut.contains(x: 0, y: 1))
        XCTAssertFalse(sut.contains(x: -1, y: 0))
    }
    
    // Some test cases derived from: https://jsfiddle.net/PerroAZUL/zdaY8/1/

    func testContains_triangle1() {
        let sut =
        Triangle(
            a: .init(x: 91, y: 34),
            b: .init(x: 432, y: 12),
            c: .init(x: 227, y: 230)
        )
        
        XCTAssertTrue(sut.contains(x: 282, y: 103))
        XCTAssertTrue(sut.contains(x: 339, y: 46))
        XCTAssertTrue(sut.contains(x: 301, y: 100))
        XCTAssertTrue(sut.contains(x: 191, y: 104))
        XCTAssertFalse(sut.contains(x: 213, y: 12))
        XCTAssertFalse(sut.contains(x: 385, y: 91))
        XCTAssertFalse(sut.contains(x: 114, y: 101))
        XCTAssertFalse(sut.contains(x: 53, y: 25))
        XCTAssertFalse(sut.contains(x: 450, y: 6))
        XCTAssertFalse(sut.contains(x: 228, y: 270))
    }
    
    func testContains_triangle1_counterClockwise() {
        let sut =
        Triangle(
            a: .init(x: 91, y: 34),
            b: .init(x: 227, y: 230),
            c: .init(x: 432, y: 12)
        )
        
        XCTAssertTrue(sut.contains(x: 282, y: 103))
        XCTAssertTrue(sut.contains(x: 339, y: 46))
        XCTAssertTrue(sut.contains(x: 301, y: 100))
        XCTAssertTrue(sut.contains(x: 191, y: 104))
        XCTAssertFalse(sut.contains(x: 213, y: 12))
        XCTAssertFalse(sut.contains(x: 385, y: 91))
        XCTAssertFalse(sut.contains(x: 114, y: 101))
        XCTAssertFalse(sut.contains(x: 53, y: 25))
        XCTAssertFalse(sut.contains(x: 450, y: 6))
        XCTAssertFalse(sut.contains(x: 228, y: 270))
    }
    
    func testContains_trianglePoints_returnsFalse() {
        let sut =
        Triangle(
            a: .zero,
            b: .one,
            c: .init(x: 1, y: 0)
        )
        
        XCTAssertFalse(sut.contains(sut.a))
        XCTAssertFalse(sut.contains(sut.b))
        XCTAssertFalse(sut.contains(sut.c))
    }
    
    func testContains_nonEmptyTriangle() {
        let sut =
        Triangle(
            a: .zero,
            b: .one,
            c: .init(x: 1, y: 0)
        )
        
        XCTAssertTrue(sut.contains(x: 0.25, y: 0.1))
        XCTAssertTrue(sut.contains(x: 0.5, y: 0.1))
        XCTAssertTrue(sut.contains(x: 0.75, y: 0.5))
        XCTAssertFalse(sut.contains(x: 0, y: 0))
        XCTAssertFalse(sut.contains(x: 1, y: 1))
        XCTAssertFalse(sut.contains(x: 1, y: 0))
        XCTAssertFalse(sut.contains(x: -1, y: 0))
        XCTAssertFalse(sut.contains(x: 0, y: -1))
        XCTAssertFalse(sut.contains(x: 0, y: 1))
    }
    
    func testContains_nonEmptyTriangle_counterClockwise() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 1, y: 0),
            c: .one
        )
        
        XCTAssertTrue(sut.contains(x: 0.25, y: 0.1))
        XCTAssertTrue(sut.contains(x: 0.5, y: 0.1))
        XCTAssertTrue(sut.contains(x: 0.75, y: 0.5))
        XCTAssertFalse(sut.contains(x: 0, y: 0))
        XCTAssertFalse(sut.contains(x: 1, y: 1))
        XCTAssertFalse(sut.contains(x: 1, y: 0))
        XCTAssertFalse(sut.contains(x: -1, y: 0))
        XCTAssertFalse(sut.contains(x: 0, y: -1))
        XCTAssertFalse(sut.contains(x: 0, y: 1))
    }
}
