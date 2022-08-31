import XCTest

@testable import Geometria

class HyperplaneTests: XCTestCase {
    typealias Vector = Vector3D
    typealias Hyperplane = Hyperplane3<Vector>
    
    func testEquatable() {
        XCTAssertEqual(Hyperplane(point: .unitZ, normal: .unitY),
                       Hyperplane(point: .unitZ, normal: .unitY))
        XCTAssertNotEqual(Hyperplane(point: .unitZ, normal: .unitY),
                          Hyperplane(point: .unitX, normal: .unitY))
        XCTAssertNotEqual(Hyperplane(point: .unitZ, normal: .unitY),
                          Hyperplane(point: .unitX, normal: .unitX))
    }
    
    func testHashable() {
        XCTAssertEqual(Hyperplane(point: .unitZ, normal: .unitY).hashValue,
                       Hyperplane(point: .unitZ, normal: .unitY).hashValue)
        XCTAssertNotEqual(Hyperplane(point: .unitZ, normal: .unitY).hashValue,
                          Hyperplane(point: .unitX, normal: .unitY).hashValue)
        XCTAssertNotEqual(Hyperplane(point: .unitZ, normal: .unitY).hashValue,
                          Hyperplane(point: .unitX, normal: .unitX).hashValue)
    }
    
    func testDescription() {
        let sut = Hyperplane(point: .init(x: 1, y: 2, z: 3),
                        normal: .init(x: 0, y: 0, z: 1))
        
        XCTAssertEqual(
            sut.description,
            "Hyperplane(point: Vector3<Double>(x: 1.0, y: 2.0, z: 3.0), normal: Vector3<Double>(x: 0.0, y: 0.0, z: 1.0))"
        )
    }
    
    func testNormal_normalizesAssignedValues_onInit() {
        let sut = Hyperplane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 1, y: 1, z: 1))
        
        XCTAssertEqual(sut.normal, Vector3(x: 0.5773502691896258, y: 0.5773502691896258, z: 0.5773502691896258))
    }
    
    func testNormal_normalizesAssignedValues_onAssign() {
        var sut = Hyperplane(point: .init(x: 0, y: 0, z: 0),
                        normal: .init(x: 1, y: 0, z: 0))
        
        sut.normal = .init(x: 1, y: 1, z: 1)
        
        XCTAssertEqual(sut.normal, Vector3(x: 0.5773502691896258, y: 0.5773502691896258, z: 0.5773502691896258))
    }
    
    func testAsPointNormal() {
        let sut = Hyperplane(point: .init(x: 1, y: 2, z: 3),
                        normal: .init(x: 4, y: 5, z: 7))
        
        let result = sut.asPointNormal
        
        XCTAssertEqual(result.point, .init(x: 1, y: 2, z: 3))
        XCTAssertEqual(result.normal, .init(x: 0.4216370213557839, y: 0.5270462766947299, z: 0.7378647873726218))
    }
    
    func testInitWithPlane() {
        let plane = PointNormal<Vector3D>(point: .init(x: 1, y: 2, z: 3),
                                          normal: .init(x: 4, y: 5, z: 6))
        
        let result = PointNormalPlane(plane)
        
        XCTAssertEqual(result.point, .init(x: 1, y: 2, z: 3))
        XCTAssertEqual(
            result.normal,
            .init(x: 0.4558423058385518,
                  y: 0.5698028822981898,
                  z: 0.6837634587578276)
        )
    }

    // MARK: - intersectionInterval(with:)

    func testIntersectionInterval_lineSegment_ingoing() throws {
        let sut = Hyperplane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .init(x: -1, y: 0, z: 0)
        )
        let line = LineSegment3D(
            x1: -10, y1: 0, z1: 0,
            x2: 10, y2: 5, z2: 10
        )

        let result = try XCTUnwrap(sut.intersectionInterval(with: line))

        assertEqual(
            result.a,
            .init(x: 1, y: 2.75, z: 5.5),
            accuracy: 1e-16
        )
        assertEqual(
            result.b,
            line.end,
            accuracy: 1e-16
        )
    }

    func testIntersectionInterval_lineSegment_outgoing() throws {
        let sut = Hyperplane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .init(x: 1, y: 0, z: 0)
        )
        let line = LineSegment3D(
            x1: -10, y1: 0, z1: 0,
            x2: 10, y2: 5, z2: 10
        )

        let result = try XCTUnwrap(sut.intersectionInterval(with: line))

        assertEqual(
            result.a,
            line.start,
            accuracy: 1e-16
        )
        assertEqual(
            result.b,
            .init(x: 1, y: 2.75, z: 5.5),
            accuracy: 1e-16
        )
    }

    func testIntersectionInterval_lineSegment_fullyContained() throws {
        let sut = Hyperplane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .init(x: 1, y: 0, z: 0)
        )
        let line = LineSegment3D(
            x1: -2, y1: 0, z1: 0,
            x2: -1, y2: 5, z2: 10
        )

        let result = try XCTUnwrap(sut.intersectionInterval(with: line))

        assertEqual(
            result.a,
            line.start,
            accuracy: 1e-16
        )
        assertEqual(
            result.b,
            line.end,
            accuracy: 1e-16
        )
    }

    func testIntersectionInterval_lineSegment_fullyOutside() throws {
        let sut = Hyperplane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .init(x: 1, y: 0, z: 0)
        )
        let line = LineSegment3D(
            x1: 2, y1: 0, z1: 0,
            x2: 3, y2: 5, z2: 10
        )

        XCTAssertNil(sut.intersectionInterval(with: line))
    }

    func testIntersectionInterval_lineSegment_parallel_inside() throws {
        let sut = Hyperplane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .init(x: 1, y: 0, z: 0)
        )
        let line = LineSegment3D(
            x1: -1, y1: 0, z1: 0,
            x2: -1, y2: 5, z2: 0
        )

        let result = try XCTUnwrap(sut.intersectionInterval(with: line))

        assertEqual(
            result.a,
            line.start,
            accuracy: 1e-16
        )
        assertEqual(
            result.b,
            line.end,
            accuracy: 1e-16
        )
    }

    func testIntersectionInterval_lineSegment_parallel_outside() throws {
        let sut = Hyperplane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .init(x: 1, y: 0, z: 0)
        )
        let line = LineSegment3D(
            x1: 2, y1: 0, z1: 0,
            x2: 2, y2: 5, z2: 0
        )

        XCTAssertNil(sut.intersectionInterval(with: line))
    }

    // MARK: - intersection(with:)

    func testIntersectionWithLine_lineSegment_exit() {
        let sut = Hyperplane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .init(x: 1, y: 0, z: 0)
        )
        let line = LineSegment3D(
            x1: 0, y1: 0, z1: 3,
            x2: 2, y2: 0, z2: 3
        )

        let result = sut.intersection(with: line)

        XCTAssertEqual(
            result,
            .exit(.init(
                point: .init(x: 1, y: 0, z: 3),
                normal: .init(x: -1, y: 0, z: 0)
            ))
        )
    }

    func testIntersectionWithLine_lineSegment_enter() {
        let sut = Hyperplane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .init(x: 1, y: 0, z: 0)
        )
        let line = LineSegment3D(
            x1: 2, y1: 0, z1: 3,
            x2: 0, y2: 0, z2: 3
        )

        let result = sut.intersection(with: line)

        XCTAssertEqual(
            result,
            .enter(.init(
                point: .init(x: 1, y: 0, z: 3),
                normal: .init(x: 1, y: 0, z: 0)
            ))
        )
    }

    func testIntersectionWithLine_lineSegment_noIntersection_contained() {
        let sut = Hyperplane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .init(x: 1, y: 0, z: 0)
        )
        let line = LineSegment3D(
            x1: -1, y1: 0, z1: 3,
            x2: 0, y2: 0, z2: 3
        )

        let result = sut.intersection(with: line)

        XCTAssertEqual(result, .contained)
    }

    func testIntersectionWithLine_lineSegment_noIntersection_notContained() {
        let sut = Hyperplane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .init(x: 1, y: 0, z: 0)
        )
        let line = LineSegment3D(
            x1: 2, y1: 0, z1: 3,
            x2: 3, y2: 0, z2: 3
        )

        let result = sut.intersection(with: line)

        XCTAssertEqual(result, .noIntersection)
    }
    
    func testIntersectionWithLine_ray_noIntersection_contained() {
        let sut = Hyperplane(
            point: .init(x: 2, y: 3, z: 5),
            normal: .init(x: 1, y: 0, z: 0)
        )
        let line = Ray3D(
            x1: 1, y1: 0, z1: 3,
            x2: 0, y2: 1, z2: 3
        )

        let result = sut.intersection(with: line)

        XCTAssertEqual(result, .contained)
    }

    // MARK: -

    func testContains() {
        let sut = Hyperplane(
            point: .init(x: 1, y: 2, z: 3),
            normal: .init(x: 1, y: 0, z: 0)
        )

        XCTAssertTrue(sut.contains(x: 0, y: 2, z: 3))
        XCTAssertTrue(sut.contains(x: 1, y: 2, z: 3))
        XCTAssertFalse(sut.contains(x: 2, y: 2, z: 3))
    }
}
