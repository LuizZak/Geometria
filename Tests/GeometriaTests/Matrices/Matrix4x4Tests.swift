import XCTest
import Geometria

class Matrix4x4Tests: XCTestCase {
    typealias Matrix = Matrix4x4<Double>
    
    func testEquality() {
        let sut = Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        
        XCTAssertEqual(sut, sut)
    }
    
    func testUnequality() {
        // [D]ifferent value
        let D = 99.0
        
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((D, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, D, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, D, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, D), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, 3), (D, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, 3), (4, D, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, 3), (4, 5, D, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, D), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (D, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, D, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, D, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, D), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (D, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, D, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, D, 15)))
        )
        XCTAssertNotEqual(
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(columns: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, D)))
        )
    }
    
    func testSubscript() {
        let sut = Matrix(columns: ((0, 1, 2, 3),
                                   (4, 5, 6, 7),
                                   (8, 9, 10, 11),
                                   (12, 13, 14, 15)))
        
        // Row 0
        XCTAssertEqual(sut[0, 0], 0)
        XCTAssertEqual(sut[1, 0], 1)
        XCTAssertEqual(sut[2, 0], 2)
        XCTAssertEqual(sut[3, 0], 3)
        // Row 1
        XCTAssertEqual(sut[0, 1], 4)
        XCTAssertEqual(sut[1, 1], 5)
        XCTAssertEqual(sut[2, 1], 6)
        XCTAssertEqual(sut[3, 1], 7)
        // Row 2
        XCTAssertEqual(sut[0, 2], 8)
        XCTAssertEqual(sut[1, 2], 9)
        XCTAssertEqual(sut[2, 2], 10)
        XCTAssertEqual(sut[3, 2], 11)
        // Row 3
        XCTAssertEqual(sut[0, 3], 12)
        XCTAssertEqual(sut[1, 3], 13)
        XCTAssertEqual(sut[2, 3], 14)
        XCTAssertEqual(sut[3, 3], 15)
    }
    
    func testSubscript_set() {
        var sut = Matrix(columns: ((0, 1, 2, 3),
                                   (4, 5, 6, 7),
                                   (8, 9, 10, 11),
                                   (12, 13, 14, 15)))
        
        // Row 1
        sut[0, 0] = 0 * 2 + 1
        sut[1, 0] = 1 * 2 + 1
        sut[2, 0] = 2 * 2 + 1
        sut[3, 0] = 3 * 2 + 1
        // Row 2
        sut[0, 1] = 4 * 2 + 1
        sut[1, 1] = 5 * 2 + 1
        sut[2, 1] = 6 * 2 + 1
        sut[3, 1] = 7 * 2 + 1
        // Row 3
        sut[0, 2] = 8 * 2 + 1
        sut[1, 2] = 9 * 2 + 1
        sut[2, 2] = 10 * 2 + 1
        sut[3, 2] = 11 * 2 + 1
        // Row 4
        sut[0, 3] = 12 * 2 + 1
        sut[1, 3] = 13 * 2 + 1
        sut[2, 3] = 14 * 2 + 1
        sut[3, 3] = 15 * 2 + 1
        
        XCTAssertTrue(sut.c0 == (1.0,   3.0,  5.0,  7.0), "\(sut.c0)")
        XCTAssertTrue(sut.c1 == (9.0,  11.0, 13.0, 15.0), "\(sut.c1)")
        XCTAssertTrue(sut.c2 == (17.0, 19.0, 21.0, 23.0), "\(sut.c2)")
        XCTAssertTrue(sut.c3 == (25.0, 27.0, 29.0, 31.0), "\(sut.c3)")
    }
}
