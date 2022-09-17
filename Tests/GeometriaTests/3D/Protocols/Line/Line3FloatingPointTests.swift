import XCTest
import Geometria

class Line3FloatingPointTests: XCTestCase {
    typealias Line = Line3D
    typealias LineSegment = LineSegment3D
    typealias Ray = Ray3D
    typealias DirectionalRay = DirectionalRay3D
    
    // MARK: - unclampedNormalizedMagnitudesForShortestLine(to:)
    
    // MARK: Line - Line
    
    func testUnclampedNormalizedMagnitudesForShortestLine_line_line_zeroLengthLine1() {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 0, y2: 0, z2: 0)
        let line2 = Line(x1: 0, y1: 2, z1: 3, x2: 2, y2: 0, z2: 3)
        
        XCTAssertNil(line1.unclampedNormalizedMagnitudesForShortestLine(to: line2))
    }
    
    func testUnclampedNormalizedMagnitudesForShortestLine_line_line_zeroLengthLine2() {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 2, z2: 0)
        let line2 = Line(x1: 0, y1: 0, z1: 0, x2: 0, y2: 0, z2: 0)
        
        XCTAssertNil(line1.unclampedNormalizedMagnitudesForShortestLine(to: line2))
    }
    
    func testUnclampedNormalizedMagnitudesForShortestLine_line_line_crossOnXYPlane() throws {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 2, z2: 0)
        let line2 = Line(x1: 0, y1: 2, z1: 3, x2: 2, y2: 0, z2: 3)
        
        let result = try XCTUnwrap(line1.unclampedNormalizedMagnitudesForShortestLine(to: line2))
        
        XCTAssertTrue(result == (0.5, 0.5), "\(result)")
    }
    
    func testUnclampedNormalizedMagnitudesForShortestLine_line_line_crossOnXZPlane() throws {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 0, z2: 2)
        let line2 = Line(x1: 0, y1: 3, z1: 2, x2: 2, y2: 3, z2: 0)
        
        let result = try XCTUnwrap(line1.unclampedNormalizedMagnitudesForShortestLine(to: line2))
        
        XCTAssertTrue(result == (0.5, 0.5), "\(result)")
    }
    
    func testUnclampedNormalizedMagnitudesForShortestLine_line_line_parallelOnXPlane() throws {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 1, y2: 0, z2: 0)
        let line2 = Line(x1: 0, y1: 0, z1: 1, x2: 1, y2: 0, z2: 1)
        
        XCTAssertNil(line1.shortestLine(to: line2))
    }

    func testUnclampedNormalizedMagnitudesForShortestLine_segment_segment_coplanar_slanted() throws {
        let line1 = LineSegment(
            x1: 0, y1: 0, z1: 0,
            x2: 2, y2: 2, z2: 0
        )
        let line2 = LineSegment(
            x1: 5, y1: 0, z1:  2,
            x2: 2, y2: 5, z2: -2
        )

        try TestFixture.beginFixture(sceneScale: 0.5, renderScale: 80) { fixture in
            fixture.add(line1)
            fixture.add(line2)
            
            let res1 =
                try XCTUnwrap(line1.unclampedNormalizedMagnitudesForShortestLine(to: line2))
            let res2 =
                try XCTUnwrap(line2.unclampedNormalizedMagnitudesForShortestLine(to: line1))

            fixture.assertEquals(res1.onSelf, 1.5416666666666667)
            fixture.assertEquals(res1.onOther, 0.5833333333333334)
            fixture.assertEquals(res2.onSelf, 0.5833333333333334)
            fixture.assertEquals(res2.onOther, 1.5416666666666667)

            fixture.add(LineSegment(
                start: line1.projectedNormalizedMagnitude(res1.onSelf),
                end: line2.projectedNormalizedMagnitude(res1.onOther))
            )
            fixture.add(LineSegment(
                start: line1.projectedNormalizedMagnitude(res2.onOther),
                end: line2.projectedNormalizedMagnitude(res2.onSelf))
            )
        }
    }
    
    // MARK: Line - Ray
    
    func testUnclampedNormalizedMagnitudesForShortestLine_line_ray_crossPastEndOnXYPlane() throws {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 2, z2: 0)
        let line2 = Ray(x1: 0, y1: 4, z1: 3, x2: 1, y2: 3, z2: 3)
        
        let result = try XCTUnwrap(line1.unclampedNormalizedMagnitudesForShortestLine(to: line2))
        
        XCTAssertTrue(result == (1.0, 2.0), "\(result)")
    }
    
    func testUnclampedNormalizedMagnitudesForShortestLine_line_ray_crossBeforeStartOnXYPlane() throws {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 2, z2: 0)
        let line2 = Ray(x1: 1, y1: 3, z1: 3, x2: 0, y2: 4, z2: 3)
        
        let result = try XCTUnwrap(line1.unclampedNormalizedMagnitudesForShortestLine(to: line2))
        
        XCTAssertTrue(result == (1.0, -1.0), "\(result)")
    }
    
    // MARK: Line - LineSegment
    
    func testUnclampedNormalizedMagnitudesForShortestLine_line_segment_crossPastEndOnXYPlane() throws {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 2, z2: 0)
        let line2 = LineSegment(x1: 0, y1: 4, z1: 3, x2: 1, y2: 3, z2: 3)
        
        let result = try XCTUnwrap(line1.unclampedNormalizedMagnitudesForShortestLine(to: line2))
        
        XCTAssertTrue(result == (1.0, 2.0), "\(result)")
    }
    
    func testUnclampedNormalizedMagnitudesForShortestLine_line_segment_crossBeforeStartOnXYPlane() throws {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 2, z2: 0)
        let line2 = LineSegment(x1: 1, y1: 3, z1: 3, x2: 0, y2: 4, z2: 3)
        
        let result = try XCTUnwrap(line1.unclampedNormalizedMagnitudesForShortestLine(to: line2))
        
        XCTAssertTrue(result == (1.0, -1.0), "\(result)")
    }
    
    // MARK: LineSegment - LineSegment
    
    func testUnclampedNormalizedMagnitudesForShortestLine_segment_segment_crossPastEndOnXYPlane() throws {
        let line1 = LineSegment(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 0)
        let line2 = LineSegment(x1: 0, y1: 4, z1: 3, x2: 1, y2: 3, z2: 3)
        
        let result = try XCTUnwrap(line1.unclampedNormalizedMagnitudesForShortestLine(to: line2))
        
        XCTAssertTrue(result == (2.0, 2.0), "\(result)")
    }
    
    func testUnclampedNormalizedMagnitudesForShortestLine_segment_segment_crossBeforeStartOnXYPlane() throws {
        let line1 = LineSegment(x1: 1, y1: 1, z1: 0, x2: 0, y2: 0, z2: 0)
        let line2 = LineSegment(x1: 1, y1: 3, z1: 3, x2: 0, y2: 4, z2: 3)
        
        let result = try XCTUnwrap(line1.unclampedNormalizedMagnitudesForShortestLine(to: line2))
        
        XCTAssertTrue(result == (-1.0, -1.0), "\(result)")
    }
    
    // MARK: - shortestLine(to:)
    
    // MARK: Line - Line
    
    func testShortestLine_line_line_zeroLengthLine1() {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 0, y2: 0, z2: 0)
        let line2 = Line(x1: 0, y1: 2, z1: 3, x2: 2, y2: 0, z2: 3)
        
        XCTAssertNil(line1.shortestLine(to: line2))
    }
    
    func testShortestLine_line_line_zeroLengthLine2() {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 2, z2: 0)
        let line2 = Line(x1: 0, y1: 0, z1: 0, x2: 0, y2: 0, z2: 0)
        
        XCTAssertNil(line1.shortestLine(to: line2))
    }
    
    func testShortestLine_line_line_crossOnXYPlane() {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 2, z2: 0)
        let line2 = Line(x1: 0, y1: 2, z1: 3, x2: 2, y2: 0, z2: 3)
        
        XCTAssertEqual(
            line1.shortestLine(to: line2),
            LineSegment(x1: 1, y1: 1, z1: 0,
                        x2: 1, y2: 1, z2: 3)
        )
    }
    
    func testShortestLine_line_line_crossOnXZPlane() {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 0, z2: 2)
        let line2 = Line(x1: 0, y1: 3, z1: 2, x2: 2, y2: 3, z2: 0)
        
        XCTAssertEqual(
            line1.shortestLine(to: line2),
            LineSegment(x1: 1.0, y1: 0.0, z1: 1.0,
                        x2: 1.0, y2: 3.0, z2: 1.0)
        )
    }
    
    func testShortestLine_line_line_parallelOnXPlane() {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 1, y2: 0, z2: 0)
        let line2 = Line(x1: 0, y1: 0, z1: 1, x2: 1, y2: 0, z2: 1)
        
        XCTAssertNil(line1.shortestLine(to: line2))
    }
    
    // MARK: Line - Ray
    
    func testShortestLine_line_ray_crossPastEndOnXYPlane() {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 2, z2: 0)
        let line2 = Ray(x1: 0, y1: 4, z1: 3, x2: 1, y2: 3, z2: 3)
        
        XCTAssertEqual(
            line1.shortestLine(to: line2),
            LineSegment(x1: 2, y1: 2, z1: 0,
                        x2: 2, y2: 2, z2: 3)
        )
    }
    
    func testShortestLine_line_ray_crossBeforeStartOnXYPlane() {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 2, z2: 0)
        let line2 = Ray(x1: 1, y1: 3, z1: 3, x2: 0, y2: 4, z2: 3)
        
        XCTAssertEqual(
            line1.shortestLine(to: line2),
            LineSegment(x1: 2, y1: 2, z1: 0,
                        x2: 1, y2: 3, z2: 3)
        )
    }
    
    // MARK: Line - LineSegment
    
    func testShortestLine_line_segment_crossPastEndOnXYPlane() {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 2, z2: 0)
        let line2 = LineSegment(x1: 0, y1: 4, z1: 3, x2: 1, y2: 3, z2: 3)
        
        XCTAssertEqual(
            line1.shortestLine(to: line2),
            LineSegment(x1: 2, y1: 2, z1: 0,
                        x2: 1, y2: 3, z2: 3)
        )
    }
    
    func testShortestLine_line_segment_crossBeforeStartOnXYPlane() {
        let line1 = Line(x1: 0, y1: 0, z1: 0, x2: 2, y2: 2, z2: 0)
        let line2 = LineSegment(x1: 1, y1: 3, z1: 3, x2: 0, y2: 4, z2: 3)
        
        XCTAssertEqual(
            line1.shortestLine(to: line2),
            LineSegment(x1: 2, y1: 2, z1: 0,
                        x2: 1, y2: 3, z2: 3)
        )
    }
    
    // MARK: LineSegment - LineSegment
    
    func testShortestLine_segment_segment_crossPastEndOnXYPlane() {
        let line1 = LineSegment(x1: 0, y1: 0, z1: 0, x2: 1, y2: 1, z2: 0)
        let line2 = LineSegment(x1: 0, y1: 4, z1: 3, x2: 1, y2: 3, z2: 3)
        
        XCTAssertEqual(
            line1.shortestLine(to: line2),
            LineSegment(x1: 1, y1: 1, z1: 0,
                        x2: 1, y2: 3, z2: 3)
        )
    }
    
    func testShortestLine_segment_segment_crossBeforeStartOnXYPlane() {
        let line1 = LineSegment(x1: 1, y1: 1, z1: 0, x2: 0, y2: 0, z2: 0)
        let line2 = LineSegment(x1: 1, y1: 3, z1: 3, x2: 0, y2: 4, z2: 3)
        
        XCTAssertEqual(
            line1.shortestLine(to: line2),
            LineSegment(x1: 1, y1: 1, z1: 0,
                        x2: 1, y2: 3, z2: 3)
        )
    }

    func testShortestLine_segment_segment_coplanar_slanted() {
        let line1 = LineSegment(
            x1: 0, y1: 0, z1: 0,
            x2: 2, y2: 2, z2: 0
        )
        let line2 = LineSegment(
            x1: 5, y1: 0, z1:  2,
            x2: 2, y2: 5, z2: -2
        )

        TestFixture.beginFixture(sceneScale: 0.5, renderScale: 80) { fixture in
            fixture.add(line1)
            fixture.add(line2)

            // Test against a point with a known low distance.
            XCTAssertGreaterThan(
                line2.center.distance(to: line1.end),
                line1.shortestLine(to: line2)!.length
            )

            fixture.assertEquals(
                line1.shortestLine(to: line2),
                LineSegment(
                    x1:    2, y1:   2, z1: 0,
                    x2: 3.38, y2: 2.7, z2: -0.16000000000000014
                )
            )
            fixture.assertEquals(
                line2.shortestLine(to: line1),
                LineSegment(
                    x1: 3.38, y1: 2.7, z1: -0.16000000000000014,
                    x2:    2, y2:   2, z2: 0
                )
            )
        }
    }
}
