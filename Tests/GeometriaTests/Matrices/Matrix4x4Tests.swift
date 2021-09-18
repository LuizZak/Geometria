import XCTest
import Geometria

class Matrix4x4Tests: XCTestCase {
    typealias Matrix = Matrix4x4<Double>
    
    func testEquality() {
        let sut = Matrix(rows: ((0, 1, 2, 3),
                                (4, 5, 6, 7),
                                (8, 9, 10, 11),
                                (12, 13, 14, 15)))
        
        XCTAssertEqual(sut, sut)
    }
    
    func testUnequality() {
        // [D]ifferent value
        let D = 99.0
        
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((D, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, D, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, D, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, D), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (D, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, D, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, D, 7), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, D), (8, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (D, 9, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, D, 10, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, D, 11), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, D), (12, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (D, 13, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, D, 14, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, D, 15)))
        )
        XCTAssertNotEqual(
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, 15))),
            Matrix(rows: ((0, 1, 2, 3), (4, 5, 6, 7), (8, 9, 10, 11), (12, 13, 14, D)))
        )
    }
    
    func testRows() {
        let sut = Matrix(rows: ((0, 1, 2, 3),
                                (4, 5, 6, 7),
                                (8, 9, 10, 11),
                                (12, 13, 14, 15)))
        
        XCTAssertTrue(sut.r0 == (0, 1, 2, 3), "\(sut.r0)")
        XCTAssertTrue(sut.r1 == (4, 5, 6, 7), "\(sut.r1)")
        XCTAssertTrue(sut.r2 == (8, 9, 10, 11), "\(sut.r2)")
        XCTAssertTrue(sut.r3 == (12, 13, 14, 15), "\(sut.r3)")
    }
    
    func testRows_set() {
        var sut = Matrix(rows: ((0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0)))
        
        sut.r0 = (0, 1, 2, 3)
        sut.r1 = (4, 5, 6, 7)
        sut.r2 = (8, 9, 10, 11)
        sut.r3 = (12, 13, 14, 15)
        
        XCTAssertTrue(sut.m == ((0, 1, 2, 3),
                                (4, 5, 6, 7),
                                (8, 9, 10, 11),
                                (12, 13, 14, 15)),
                      "\(sut.m)")
    }
    
    func testColumns() {
        let sut = Matrix(rows: ((0, 1, 2, 3),
                                (4, 5, 6, 7),
                                (8, 9, 10, 11),
                                (12, 13, 14, 15)))
        
        XCTAssertTrue(sut.c0 == (0.0, 4.0, 8.0, 12.0), "\(sut.c0)")
        XCTAssertTrue(sut.c1 == (1.0, 5.0, 9.0, 13.0), "\(sut.c1)")
        XCTAssertTrue(sut.c2 == (2.0, 6.0, 10.0, 14.0), "\(sut.c2)")
        XCTAssertTrue(sut.c3 == (3.0, 7.0, 11.0, 15.0), "\(sut.c3)")
    }
    
    func testColumns_set() {
        var sut = Matrix(rows: ((0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0)))
        
        sut.c0 = (0, 1, 2, 3)
        sut.c1 = (4, 5, 6, 7)
        sut.c2 = (8, 9, 10, 11)
        sut.c3 = (12, 13, 14, 15)
        
        XCTAssertTrue(sut.m == ((0, 4, 8, 12),
                                (1, 5, 9, 13),
                                (2, 6, 10, 14),
                                (3, 7, 11, 15)),
                      "\(sut.m)")
    }
    
    func testSubscript() {
        let sut = Matrix(rows: ((0, 1, 2, 3),
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
        var sut = Matrix(rows: ((0, 1, 2, 3),
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
        
        XCTAssertTrue(sut.r0 == (1.0,   3.0,  5.0,  7.0), "\(sut.r0)")
        XCTAssertTrue(sut.r1 == (9.0,  11.0, 13.0, 15.0), "\(sut.r1)")
        XCTAssertTrue(sut.r2 == (17.0, 19.0, 21.0, 23.0), "\(sut.r2)")
        XCTAssertTrue(sut.r3 == (25.0, 27.0, 29.0, 31.0), "\(sut.r3)")
    }
    
    func testDescription() {
        let sut = Matrix(rows: ((0, 1, 2, 3),
                                (4, 5, 6, 7),
                                (8, 9, 10, 11),
                                (12, 13, 14, 15)))
        
        XCTAssertEqual(
            sut.description,
            """
            [M00:0.0 M01:1.0 M02:2.0 M03:3.0]\
            [M10:4.0 M11:5.0 M12:6.0 M13:7.0]\
            [M20:8.0 M21:9.0 M22:10.0 M23:11.0]\
            [M30:12.0 M31:13.0 M32:14.0 M33:15.0]
            """
        )
    }
}
