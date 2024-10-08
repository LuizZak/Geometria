import XCTest
import Geometria
import TestCommons

class LinePolygon2Tests: XCTestCase {
    typealias LinePolygon = LinePolygon2D

    func testAddVertexXY() {
        var sut = LinePolygon(vertices: [])

        sut.addVertex(x: 1, y: 2)
        sut.addVertex(x: 3, y: 5)

        XCTAssertEqual(sut.vertices, [
            .init(x: 1, y: 2),
            .init(x: 3, y: 5),
        ])
    }
}

// MARK: Vector2Multiplicative Conformance

extension LinePolygon2Tests {
    func testWinding_clockwise() {
        let sut = LinePolygon(vertices: [
            .init(x: 3, y: 0),
            .init(x: 3, y: 3),
            .init(x: 0, y: 0),
        ])

        XCTAssertEqual(sut.winding(), 9.0)
    }

    func testWinding_counterClockwise() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 3, y: 3),
            .init(x: 3, y: 0),
        ])

        XCTAssertEqual(sut.winding(), -9.0)
    }

    func testWinding_twoPoints() {
        let sut = LinePolygon(vertices: [
            .init(x: 3, y: 0),
            .init(x: 3, y: 3),
        ])

        XCTAssertEqual(sut.winding(), 0.0)
    }
}

// MARK: Vector2Multiplicative, Scalar: DivisibleArithmetic Conformance

extension LinePolygon2Tests {
    func testArea_clockwise() {
        let sut = LinePolygon(vertices: [
            .init(x: 3, y: 0),
            .init(x: 3, y: 3),
            .init(x: 0, y: 0),
        ])

        XCTAssertEqual(sut.area(), 4.5)
    }

    func testArea_counterClockwise() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 3, y: 3),
            .init(x: 3, y: 0),
        ])

        XCTAssertEqual(sut.area(), -4.5)
    }

    func testArea_twoPoints() {
        let sut = LinePolygon(vertices: [
            .init(x: 3, y: 0),
            .init(x: 3, y: 3),
        ])

        XCTAssertEqual(sut.area(), 0.0)
    }
}

// MARK: Vector2Multiplicative & VectorComparable Conformance

extension LinePolygon2Tests {
    func testIsConvex_triangle() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 3, y: 3),
            .init(x: 3, y: 0),
        ])

        XCTAssertTrue(sut.isConvex())
    }

    func testIsConvex_reversedTriangle() {
        let sut = LinePolygon(vertices: [
            .init(x: 3, y: 0),
            .init(x: 3, y: 3),
            .init(x: 0, y: 0),
        ])

        XCTAssertTrue(sut.isConvex())
    }

    func testIsConvex_arrow_returnsFalse() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 3, y: 3),
            .init(x: 1.5, y: 2),
            .init(x: 3, y: 0),
        ])

        XCTAssertFalse(sut.isConvex())
    }

    func testIsConvex_lineSegment_returnsFalse() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 3, y: 3),
        ])

        XCTAssertFalse(sut.isConvex())
    }

    func testIsConvex_point_returnsFalse() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
        ])

        XCTAssertFalse(sut.isConvex())
    }

    func testIsConvex_empty_returnsFalse() {
        let sut = LinePolygon()

        XCTAssertFalse(sut.isConvex())
    }

    func testIsConvex_selfIntersectingWindingShape_doubleXFlip_returnsFalse() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 15),
            .init(x: 6, y: 10),
            .init(x: 12, y: 7),
            .init(x: 10, y: 15),
            .init(x: 4, y: 12),
            .init(x: 6, y: 5),
            .init(x: 13, y: 10),
            .init(x: 10, y: 20),
            .init(x: 3, y: 17),
        ])

        XCTAssertFalse(sut.isConvex())
    }

    func testIsConvex_selfIntersectingWindingShape_doubleYFlip_returnsFalse() {
        let sut = LinePolygon(vertices: [
            .init(x: -15.0, y: 0),
            .init(x: -10.0, y: 6),
            .init(x: -7.0, y: 12.0),
            .init(x: -15.0, y: 10.0),
            .init(x: -12.0, y: 4.0),
            .init(x: -5.0, y: 6.0),
            .init(x: -10.0, y: 13.0),
            .init(x: -20.0, y: 10.0),
            .init(x: -17.0, y: 3.0),
        ])

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
            .init(x: 0, y: 2),
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
            .init(x: 0, y: 2),
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
            .init(x: 0, y: 2),
        ])

        XCTAssertTrue(sut.contains(x: 0.5, y: 0.5))
        XCTAssertTrue(sut.contains(x: 0.2, y: 0.5))
        XCTAssertFalse(sut.contains(x: 1, y: 0.5))
        XCTAssertTrue(sut.contains(x: 1.8, y: 0.5))
        XCTAssertTrue(sut.contains(x: 1, y: 1))
        XCTAssertTrue(sut.contains(x: 0.5, y: 1))
    }
}

// MARK: Vector: VectorFloatingPoint Conformance

extension LinePolygon2Tests {
    func testIsPointOnEdge() {
        let sut = LinePolygon(vertices: [
            .init(x: 0, y: 0),
            .init(x: 1, y: 1),
            .init(x: 2, y: 0),
            .init(x: 2, y: 2),
            .init(x: 0, y: 2),
        ])
        let test1 = Vector2D(x: 0, y: 0)
        let test2 = Vector2D(x: 1, y: 1)
        let test3 = Vector2D(x: 2, y: 1)
        let test4 = Vector2D(x: 1, y: 1.5)

        TestFixture.beginFixture(lineScale: 100, renderScale: 50) { fixture in
            fixture.add(sut)

            fixture.assertions(on: test1)
                .assertTrue(sut.isPointOnEdge(test1, toleranceSquared: 1e-5))

            fixture.assertions(on: test2)
                .assertTrue(sut.isPointOnEdge(test2, toleranceSquared: 1e-5))

            fixture.assertions(on: test3)
                .assertTrue(sut.isPointOnEdge(test3, toleranceSquared: 1e-5))

            fixture.assertions(on: test4)
                .assertFalse(sut.isPointOnEdge(test4, toleranceSquared: 1e-5))

            fixture.assertions(on: test4)
                .assertTrue(sut.isPointOnEdge(test4, toleranceSquared: 0.51))
        }
    }
}
