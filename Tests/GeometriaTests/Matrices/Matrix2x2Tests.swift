import XCTest
import Geometria

class Matrix2x2Tests: XCTestCase {
    let accuracy: Double = 1e-16
    
    typealias Matrix = Matrix2x2<Double>
    
    func testIdentity() {
        let sut = Matrix.idendity
        
        XCTAssert(sut.m == ((1, 0),
                            (0, 1)),
                  "\(sut.m)")
    }
    
    func testEquality() {
        XCTAssertEqual(
            Matrix(rows: (
                (0, 1),
                (2, 3)
            )),
            Matrix(rows: (
                (0, 1),
                (2, 3)
            ))
        )
    }
    
    func testUnequality() {
        // [D]ifferent value
        let D = 99.0
        
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1), (2, 3))),
            Matrix(rows: ((D, 1), (2, 3)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1), (2, 3))),
            Matrix(rows: ((0, D), (2, 3)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1), (2, 3))),
            Matrix(rows: ((0, 1), (D, 3)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1), (2, 3))),
            Matrix(rows: ((0, 1), (2, D)))
        )
    }
    
    func testRows() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        XCTAssertTrue(sut.r0 == (0, 1), "\(sut.r0)")
        XCTAssertTrue(sut.r1 == (2, 3), "\(sut.r1)")
    }
    
    func testRows_set() {
        var sut = Matrix(rows: ((0, 0), (0, 0)))
        
        sut.r0 = (0, 1)
        sut.r1 = (2, 3)
        
        XCTAssertTrue(sut.m == ((0, 1),
                                (2, 3)),
                      "\(sut.m)")
    }
    
    func testColumns() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        XCTAssertTrue(sut.c0 == (0, 2), "\(sut.c0)")
        XCTAssertTrue(sut.c1 == (1, 3), "\(sut.c1)")
    }
    
    func testColumns_set() {
        var sut = Matrix(rows: ((0, 0), (0, 0)))
        
        sut.c0 = (0, 1)
        sut.c1 = (2, 3)
        
        XCTAssertTrue(sut.m == ((0, 2),
                                (1, 3)),
                      "\(sut.m)")
    }
    
    func testRowsAsVectors() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        XCTAssertEqual(sut.r0Vec, Vector2D(x: 0, y: 1))
        XCTAssertEqual(sut.r1Vec, Vector2D(x: 2, y: 3))
    }
    
    func testColumnsAsVector() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        XCTAssertEqual(sut.c0Vec, Vector2D(x: 0, y: 2))
        XCTAssertEqual(sut.c1Vec, Vector2D(x: 1, y: 3))
    }
    
    func testSubscript() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        // Row 0
        XCTAssertEqual(sut[0, 0], 0)
        XCTAssertEqual(sut[1, 0], 1)
        // Row 1
        XCTAssertEqual(sut[0, 1], 2)
        XCTAssertEqual(sut[1, 1], 3)
    }
    
    func testSubscript_set() {
        var sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        // Row 0
        sut[0, 0] = 0 * 2 + 1
        sut[1, 0] = 1 * 2 + 1
        // Row 1
        sut[0, 1] = 2 * 2 + 1
        sut[1, 1] = 3 * 2 + 1
        
        XCTAssertTrue(sut.r0 == (1.0, 3.0), "\(sut.r0)")
        XCTAssertTrue(sut.r1 == (5.0, 7.0), "\(sut.r1)")
    }
    
    func testDescription() {
        let sut = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        XCTAssertEqual(
            sut.description,
            "Matrix2x2<Double>(rows: ((0.0, 1.0), (2.0, 3.0)))"
        )
    }
    
    func testDeterminant() {
        let sut = Matrix(rows: (
            (1, 2),
            (3, 5)
        ))
        
        XCTAssertEqual(sut.determinant(), -1)
    }
    
    func testTransformPointVector2() {
        let sut =
        Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        let vec = Vector2D(x: 0, y: 1)
        
        let result = sut.transformPoint(vec)
        
        XCTAssertEqual(result.x, 1.0)
        XCTAssertEqual(result.y, 3.0)
    }
    
    func testTransposed() {
        let sut =
        Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        let result = sut.transposed()
        
        XCTAssert(result.m == ((0, 2),
                               (1, 3)),
                  "\(result.m)")
    }
    
    func testTranspose() {
        var sut =
        Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        
        sut.transpose()
        
        XCTAssert(sut.m == ((0, 2),
                            (1, 3)),
                  "\(sut.m)")
    }
    
    func testMultiply() {
        let lhs = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        let rhs = Matrix(rows: (
            (4, 5),
            (6, 7)
        ))
        
        let result = lhs * rhs
        
        XCTAssertTrue(result.m == (( 6.0,  7.0),
                                   (26.0, 31.0)),
                      "\(result.m)")
    }
    
    func testMultiply_inPlace() {
        var lhs = Matrix(rows: (
            (0, 1),
            (2, 3)
        ))
        let rhs = Matrix(rows: (
            (4, 5),
            (6, 7)
        ))
        
        lhs *= rhs
        
        XCTAssertTrue(lhs.m == (( 6.0,  7.0),
                                (26.0, 31.0)),
                      "\(lhs.m)")
    }
}
