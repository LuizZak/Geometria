import XCTest
import Geometria
import TestCommons

class Triangle2Tests: XCTestCase {
    typealias Vector = Vector2D
    typealias Triangle = Triangle2<Vector>
}

// MARK: Vector: Vector2Multiplicative Conformance

extension Triangle2Tests {
    func testUnitTriangle() {
        let sut = Triangle.unitTriangle

        XCTAssertEqual(sut.a, .init(x: 0, y: 0))
        XCTAssertEqual(sut.b, .init(x: 1, y: 0))
        XCTAssertEqual(sut.c, .init(x: 0, y: 1))
    }

    func testSignedDoubleArea_emptyTriangle() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 0.5, y: 0.5))

        XCTAssertEqual(sut.signedDoubleArea, 0.0)
    }

    func testSignedDoubleArea_allZerosTriangle() {
        let sut = Triangle(a: .zero, b: .zero, c: .zero)

        XCTAssertEqual(sut.signedDoubleArea, 0.0)
    }

    func testSignedDoubleArea_simpleRightTriangle() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 1, y: 0))

        XCTAssertEqual(sut.signedDoubleArea, 1.0)
    }

    func testSignedDoubleArea_largeTriangle() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 131, y: 230),
            c: .init(x: 97, y: 10)
        )

        XCTAssertEqual(sut.signedDoubleArea, 21_000.0)
    }

    func testSignedDoubleArea_largeTriangle_counterClockwise() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 97, y: 10),
            c: .init(x: 131, y: 230)
        )

        XCTAssertEqual(sut.signedDoubleArea, -21_000.0)
    }
}

// MARK: Vector: Vector2Multiplicative & VectorDivisible Conformance

extension Triangle2Tests {
    func testSignedArea_emptyTriangle() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 0.5, y: 0.5))

        XCTAssertEqual(sut.signedArea, 0.0)
    }

    func testSignedArea_allZerosTriangle() {
        let sut = Triangle(a: .zero, b: .zero, c: .zero)

        XCTAssertEqual(sut.signedArea, 0.0)
    }

    func testSignedArea_simpleRightTriangle() {
        let sut = Triangle(a: .zero, b: .one, c: .init(x: 1, y: 0))

        XCTAssertEqual(sut.signedArea, 0.5)
    }

    func testSignedArea_largeTriangle() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 131, y: 230),
            c: .init(x: 97, y: 10)
        )

        XCTAssertEqual(sut.signedArea, 10500.0)
    }

    func testSignedArea_largeTriangle_counterClockwise() {
        let sut = Triangle(
            a: .zero,
            b: .init(x: 97, y: 10),
            c: .init(x: 131, y: 230)
        )

        XCTAssertEqual(sut.signedArea, -10500.0)
    }
}

// MARK: Vector: Vector2Multiplicative & VectorDivisible, Scalar: Comparable Conformance

extension Triangle2Tests {

    func testWinding_clockwiseCartesian() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 1, y: 0),
            c: .one
        )

        XCTAssertEqual(sut.winding, -1)
    }

    func testWinding_counterClockwiseCartesian() {
        let sut =
        Triangle(
            a: .zero,
            b: .one,
            c: .init(x: 1, y: 0)
        )

        XCTAssertEqual(sut.winding, 1)
    }

    func testWinding_colinear_returnsZero() {
        let sut =
        Triangle(
            a: .zero,
            b: .one,
            c: .init(x: 2, y: 2)
        )

        XCTAssertEqual(sut.winding, 0)
    }

    func testWinding_colinear_cBeforeB_returnsZero() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 2, y: 2),
            c: .one
        )

        XCTAssertEqual(sut.winding, 0)
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

    func testContains_trianglePoints_returnsTrue() {
        let sut =
        Triangle(
            a: .zero,
            b: .one,
            c: .init(x: 1, y: 0)
        )

        XCTAssertTrue(sut.contains(sut.a))
        XCTAssertTrue(sut.contains(sut.b))
        XCTAssertTrue(sut.contains(sut.c))
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
        XCTAssertTrue(sut.contains(x: 0, y: 0))
        XCTAssertTrue(sut.contains(x: 1, y: 1))
        XCTAssertTrue(sut.contains(x: 1, y: 0))
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
        XCTAssertTrue(sut.contains(x: 0, y: 0))
        XCTAssertTrue(sut.contains(x: 1, y: 1))
        XCTAssertTrue(sut.contains(x: 1, y: 0))
        XCTAssertFalse(sut.contains(x: -1, y: 0))
        XCTAssertFalse(sut.contains(x: 0, y: -1))
        XCTAssertFalse(sut.contains(x: 0, y: 1))
    }

    func testToBarycentricXY() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 10, y: 10),
            c: .init(x: 10, y: 0)
        )

        let result = sut.toBarycentric(x: sut.center.x, y: sut.center.y)

        XCTAssertEqual(result.wa, 0.33333333333333326)
        XCTAssertEqual(result.wb, 0.33333333333333337)
        XCTAssertEqual(result.wc, 0.33333333333333337)
    }

    func testToBarycentric_aPoint() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 10, y: 10),
            c: .init(x: 10, y: 0)
        )

        let result = sut.toBarycentric(sut.a)

        XCTAssertEqual(result.wa, 1.0)
        XCTAssertEqual(result.wb, 0.0)
        XCTAssertEqual(result.wc, 0.0)
    }

    func testToBarycentric_bPoint() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 10, y: 10),
            c: .init(x: 10, y: 0)
        )

        let result = sut.toBarycentric(sut.b)

        XCTAssertEqual(result.wa, 0.0)
        XCTAssertEqual(result.wb, 1.0)
        XCTAssertEqual(result.wc, 0.0)
    }

    func testToBarycentric_cPoint() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 10, y: 10),
            c: .init(x: 10, y: 0)
        )

        let result = sut.toBarycentric(sut.c)

        XCTAssertEqual(result.wa, 0.0)
        XCTAssertEqual(result.wb, 0.0)
        XCTAssertEqual(result.wc, 1.0)
    }

    func testToBarycentric_center() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 10, y: 10),
            c: .init(x: 10, y: 0)
        )

        let result = sut.toBarycentric(sut.center)

        XCTAssertEqual(result.wa, 0.33333333333333326)
        XCTAssertEqual(result.wb, 0.33333333333333337)
        XCTAssertEqual(result.wc, 0.33333333333333337)
    }

    func testToBarycentric_extrapolated() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 10, y: 10),
            c: .init(x: 10, y: 0)
        )

        let result = sut.toBarycentric(.init(x: 20, y: 20))

        XCTAssertEqual(result.wa, -1.0)
        XCTAssertEqual(result.wb, 2.0)
        XCTAssertEqual(result.wc, 0.0)
    }

    func testToBarycentric_extrapolated_reversedTriangle() {
        let sut =
        Triangle(
            a: .zero,
            b: .init(x: 10, y: 0),
            c: .init(x: 10, y: 10)
        )

        let result = sut.toBarycentric(.init(x: 20, y: 20))

        XCTAssertEqual(result.wa, -1.0)
        XCTAssertEqual(result.wb, 0.0)
        XCTAssertEqual(result.wc, 2.0)
    }

    func testToBarycentric_emptyAreaTriangle_returnsZero() {
        let sut = Triangle(a: .zero, b: .one, c: .zero)

        let result = sut.toBarycentric(.init(x: 20, y: 20))

        XCTAssertEqual(result.wa, 0.0)
        XCTAssertEqual(result.wb, 0.0)
        XCTAssertEqual(result.wc, 0.0)
    }
}

// MARK: ConvexType Conformance

extension Triangle2Tests {
    typealias Line = Line2D
    typealias LineSegment = LineSegment2D

    func testIntersectionWith_line_noIntersection() {
        let sut = Triangle(
            a: .init(x: 1, y: 2),
            b: .init(x: 7, y: 2),
            c: .init(x: 2, y: 8)
        )
        let line = Line(x1: 0, y1: 9, x2: 10, y2: 9)

        assertEqual(
            sut.intersection(with: line),
            .noIntersection
        )
    }

    // TODO: Fix normal of point intersections to be an average of the two edge
    // TODO: normals.
    func testIntersectionWith_line_singlePoint() {
        let sut = Triangle(
            a: .init(x: 1, y: 2),
            b: .init(x: 7, y: 2),
            c: .init(x: 2, y: 8)
        )
        let line = Line(x1: 0, y1: 8, x2: 4, y2: 8)

        assertEqual(
            sut.intersection(with: line),
            .singlePoint(
                .init(
                    normalizedMagnitude: 0.5,
                    point: .init(x: 2.0, y: 8.0),
                    normal: .init(x: -0.9863939238321437, y: 0.1643989873053573)
                )
            )
        )
    }

    func testIntersectionWith_line_acrossEdge() {
        let sut = Triangle(
            a: .init(x: 1, y: 2),
            b: .init(x: 7, y: 2),
            c: .init(x: 2, y: 8)
        )
        let line = Line(x1: 0, y1: 2, x2: 10, y2: 2)

        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                .init(
                    normalizedMagnitude: 0.1,
                    point: .init(x: 1.0, y: 2.0),
                    normal: .init(x: -0.9863939238321437, y: 0.1643989873053573)
                ),
                .init(
                    normalizedMagnitude: 0.7,
                    point: .init(x: 7.0, y: 2.0),
                    normal: .init(x: -0.9863939238321437, y: 0.1643989873053573)
                )
            )
        )
    }

    func testIntersectionWith_line_enterExit_across_pointingRight() {
        let sut = Triangle(
            a: .init(x: 1, y: 2),
            b: .init(x: 7, y: 2),
            c: .init(x: 2, y: 8)
        )
        let line = Line(x1: 0, y1: 5, x2: 10, y2: 5)

        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                .init(
                    normalizedMagnitude: 0.15,
                    point: .init(x: 1.5, y: 5.0),
                    normal: .init(x: -0.9863939238321437, y: 0.1643989873053573)
                ),
                .init(
                    normalizedMagnitude: 0.45,
                    point: .init(x: 4.5, y: 5.0),
                    normal: .init(x: -0.9863939238321437, y: 0.1643989873053573)
                )
            )
        )
    }

    func testIntersectionWith_line_enterExit_across_pointingLeft() {
        let sut = Triangle(
            a: .init(x: 1, y: 2),
            b: .init(x: 7, y: 2),
            c: .init(x: 2, y: 8)
        )
        let line = Line(x1: 10, y1: 5, x2: 0, y2: 5)

        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                .init(
                    normalizedMagnitude: 0.55,
                    point: .init(x: 4.5, y: 5.0),
                    normal: .init(x: 0.9863939238321437, y: -0.1643989873053573)
                ),
                .init(
                    normalizedMagnitude: 0.85,
                    point: .init(x: 1.5000000000000002, y: 5.0),
                    normal: .init(x: 0.9863939238321437, y: -0.1643989873053573)
                )
            )
        )
    }

    func testIntersectionWith_lineSegment_enter() {
        let sut = Triangle(
            a: .init(x: 1, y: 2),
            b: .init(x: 7, y: 2),
            c: .init(x: 2, y: 8)
        )
        let line = LineSegment(x1: 0, y1: 5, x2: 2, y2: 5)

        assertEqual(
            sut.intersection(with: line),
            .enter(
                .init(
                    normalizedMagnitude: 0.75,
                    point: .init(x: 1.5, y: 5.0),
                    normal: .init(x: -0.9863939238321437, y: 0.1643989873053573)
                )
            )
        )
    }

    func testIntersectionWith_lineSegment_exit() {
        let sut = Triangle(
            a: .init(x: 1, y: 2),
            b: .init(x: 7, y: 2),
            c: .init(x: 2, y: 8)
        )
        let line = LineSegment(x1: 2, y1: 5, x2: 10, y2: 5)

        assertEqual(
            sut.intersection(with: line),
            .exit(
                .init(
                    normalizedMagnitude: 0.3125,
                    point: .init(x: 4.5, y: 5.0),
                    normal: .init(x: -0.7682212795973759, y: -0.6401843996644799)
                )
            )
        )
    }

    func testIntersectionWith_lineSegment_contained() {
        let sut = Triangle(
            a: .init(x: 1, y: 2),
            b: .init(x: 7, y: 2),
            c: .init(x: 2, y: 8)
        )
        let line = LineSegment(x1: 2, y1: 3, x2: 3, y2: 3)

        assertEqual(
            sut.intersection(with: line),
            .contained
        )
    }

    func testIntersectionWith_lineSegment_startsAfterIntersection() {
        let sut = Triangle(
            a: .init(x: 1, y: 2),
            b: .init(x: 7, y: 2),
            c: .init(x: 2, y: 8)
        )
        let line = LineSegment(x1: 10, y1: 5, x2: 11, y2: 5)

        assertEqual(
            sut.intersection(with: line),
            .noIntersection
        )
    }

    func testIntersectionWith_lineSegment_endsBeforeIntersection() {
        let sut = Triangle(
            a: .init(x: 1, y: 2),
            b: .init(x: 7, y: 2),
            c: .init(x: 2, y: 8)
        )
        let line = LineSegment(x1: -1, y1: 5, x2: 0, y2: 5)

        assertEqual(
            sut.intersection(with: line),
            .noIntersection
        )
    }
}
