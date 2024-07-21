import XCTest
import Geometria
import TestCommons

class EllipsoidTests: XCTestCase {
    typealias Ellipsoid = Ellipse2D

    func testCodable() throws {
        let sut = Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(sut)
        let result = try decoder.decode(Ellipsoid.self, from: data)

        XCTAssertEqual(sut, result)
    }

    func testEquals() {
        XCTAssertEqual(
            Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5),
            Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5)
        )
    }

    func testUnequals() {
        XCTAssertNotEqual(Ellipsoid(center: .init(x: 999, y: 2), radiusX: 3, radiusY: 5),
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))

        XCTAssertNotEqual(Ellipsoid(center: .init(x: 1, y: 999), radiusX: 3, radiusY: 5),
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))

        XCTAssertNotEqual(Ellipsoid(center: .init(x: 1, y: 2), radiusX: 999, radiusY: 5),
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))

        XCTAssertNotEqual(Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 999),
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5))
    }

    func testHashable() {
        XCTAssertEqual(Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue,
                       Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)

        XCTAssertNotEqual(Ellipsoid(center: .init(x: 999, y: 2), radiusX: 3, radiusY: 5).hashValue,
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)

        XCTAssertNotEqual(Ellipsoid(center: .init(x: 1, y: 999), radiusX: 3, radiusY: 5).hashValue,
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)

        XCTAssertNotEqual(Ellipsoid(center: .init(x: 1, y: 2), radiusX: 999, radiusY: 5).hashValue,
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)

        XCTAssertNotEqual(Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 999).hashValue,
                          Ellipsoid(center: .init(x: 1, y: 2), radiusX: 3, radiusY: 5).hashValue)
    }
}

// MARK: BoundableType Conformance

extension EllipsoidTests {
    func testBounds() {
        let sut = Ellipsoid(center: .init(x: 1, y: 2), radius: .init(x: 3, y: 4))

        let result = sut.bounds

        XCTAssertEqual(result.minimum, .init(x: -2, y: -2))
        XCTAssertEqual(result.maximum, .init(x: 4, y: 6))
    }
}

// MARK: Vector: VectorMultiplicative Conformance

extension EllipsoidTests {
    func testUnit() {
        let sut = Ellipsoid.unit

        XCTAssertEqual(sut.center, .zero)
        XCTAssertEqual(sut.radius, .one)
    }
}

// MARK: Vector: VectorReal Conformance

extension EllipsoidTests {
    func testContainsVector() {
        let sut = Ellipsoid(center: .one, radiusX: 1, radiusY: 2)

        XCTAssertTrue(sut.contains(.one))
        XCTAssertTrue(sut.contains(.init(x: 0, y: 1)))
        XCTAssertTrue(sut.contains(.init(x: 2, y: 1)))
        XCTAssertFalse(sut.contains(.zero))
        XCTAssertFalse(sut.contains(.init(x: 2, y: 2)))
    }
}

// MARK: ConvexType Conformance

extension EllipsoidTests {

    // MARK: 2D

    func testIntersectionWith_line_noIntersection() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 5, y: 7))
        let line = Line2D(x1: -20, y1: -20, x2: 20, y2: -20)

        assertEqual(sut.intersection(with: line), .noIntersection)
    }

    func testIntersectionWith_line_tangent_top() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 5, y: 7))
        let line = Line2D(x1: -20, y1: -4, x2: 20, y2: -4)

        assertEqual(
            sut.intersection(with: line),
            .singlePoint(
                PointNormal(
                    point: .init(x: 2.0000000000000018, y: -4.0),
                    normal: .init(x: 4.973799150320702e-16, y: -1.0)
                )
            )
        )
    }

    func testIntersectionWith_line_tangent_bottom() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 5, y: 7))
        let line = Line2D(x1: -20, y1: 10, x2: 20, y2: 10)

        assertEqual(
            sut.intersection(with: line),
            .singlePoint(
                PointNormal(
                    point: .init(x: 2.0000000000000018, y: 10.0),
                    normal: .init(x: 4.973799150320702e-16, y: 1.0)
                )
            )
        )
    }

    func testIntersectionWith_line_tangent_left() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 5, y: 7))
        let line = Line2D(x1: -3, y1: -20, x2: -3, y2: 20)

        assertEqual(
            sut.intersection(with: line),
            .singlePoint(
                PointNormal(
                    point: .init(x: -3.0, y: 3.000000000000003),
                    normal: .init(x: -1.0, y: 3.1720657846433045e-16)
                )
            )
        )
    }

    func testIntersectionWith_line_horizontal_fromLeft_acrossCenter() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 5, y: 7))
        let line = Line2D(x1: -20, y1: 3, x2: 20, y2: 3)

        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: -2.9999999999999982, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: 7.000000000000002, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }

    func testIntersectionWith_line_horizontal_fromRight_acrossCenter() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 5, y: 7))
        let line = Line2D(x1: 20, y1: 3, x2: -20, y2: 3)

        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 7.0, y: 3.0),
                    normal: .init(x: 1.0, y: 0.0)
                ),
                PointNormal(
                    point: .init(x: -2.9999999999999982, y: 3.0),
                    normal: .init(x: 1.0, y: 0.0)
                )
            )
        )
    }

    func testIntersectionWith_line_vertical_fromTop_acrossCenter() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 5, y: 7))
        let line = Line2D(x1: 2, y1: -20, x2: 2, y2: 20)

        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: -3.999999999999997),
                    normal: .init(x: 0.0, y: -1.0)
                ),
                PointNormal(
                    point: .init(x: 2.0, y: 10.0),
                    normal: .init(x: 0.0, y: -1.0)
                )
            )
        )
    }

    func testIntersectionWith_line_vertical_fromBottom_acrossCenter() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 5, y: 7))
        let line = Line2D(x1: 2, y1: 20, x2: 2, y2: -20)

        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 2.0, y: 9.999999999999998),
                    normal: .init(x: 0.0, y: 1.0)
                ),
                PointNormal(
                    point: .init(x: 2.0, y: -4.0000000000000036),
                    normal: .init(x: 0.0, y: 1.0)
                )
            )
        )
    }

    func testIntersectionWith_lineSegment_across_slanted() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 2, y: 7))
        let line = LineSegment2D(x1: -2, y1: -3, x2: 8, y2: 12)

        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                PointNormal(
                    point: .init(x: 0.16170993996388394, y: 0.242564909945826),
                    normal: .init(x: -0.9925863886954069, y: -0.12154119045249878)
                ),
                PointNormal(
                    point: .init(x: 3.8382900600361154, y: 5.757435090054173),
                    normal: .init(x: -0.9925863886954069, y: -0.1215411904524988)
                )
            )
        )
    }

    func testIntersectionWith_lineSegment_contained() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 5, y: 7))
        let line = LineSegment2D(x1: -1, y1: -2, x2: 5, y2: 7)

        assertEqual(sut.intersection(with: line), .contained)
    }

    func testIntersectionWith_lineSegment_enter_slanted() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 5, y: 7))
        let line = LineSegment2D(x1: -2, y1: -3, x2: 5, y2: 7)

        assertEqual(
            sut.intersection(with: line),
            .enter(
                PointNormal(
                    point: .init(x: -1.3961944901412948, y: -2.13742070020185),
                    normal: .init(x: -0.7916456562399941, y: -0.6109804865593902)
                )
            )
        )
    }

    func testIntersectionWith_lineSegment_enter() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 5, y: 7))
        let line = LineSegment2D(x1: -10, y1: 3, x2: 2, y2: 3)

        assertEqual(
            sut.intersection(with: line),
            .enter(
                PointNormal(
                    point: .init(x: -3.000000000000001, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }

    func testIntersectionWith_lineSegment_exit() {
        let sut = Ellipsoid(center: .init(x: 2, y: 3), radius: .init(x: 5, y: 7))
        let line = LineSegment2D(x1: 2, y1: 3, x2: 10, y2: 3)

        assertEqual(
            sut.intersection(with: line),
            .exit(
                PointNormal(
                    point: .init(x: 7.0, y: 3.0),
                    normal: .init(x: -1.0, y: 0.0)
                )
            )
        )
    }

    // MARK: 3D

    func testIntersectionWith3d_lineSegment_enter_slanted() {
        let sut = Ellipse3D(center: .init(x: 2, y: 3, z: 5), radius: .init(x: 7, y: 5, z: 11))
        let line = LineSegment3D(x1: -2, y1: -3, z1: -5, x2: 5, y2: 7, z2: 12)

        assertEqual(
            sut.intersection(with: line),
            .enterExit(
                .init(
                    point: .init(x: -0.4280392587358917, y: -0.7543417981941309, z: -1.1823810569300226),
                    normal: .init(x: -0.29816906779895935, y: -0.9036427383419159, z: -0.3074491965346851)
                ),
                .init(
                    point: .init(x: 4.7206567084003215, y: 6.600938154857603, z: 11.321594863257925),
                    normal: .init(x: -0.3406986111872821, y: -0.8838292108316562, z: -0.32057820015676225)
                )
            )
        )
    }
}
