import XCTest
import Geometria

class Circle2Tests: XCTestCase {
    typealias Circle = Circle2D
    
    func testContainsXY() {
        let sut = Circle(center: .init(x: 0, y: 1), radius: 2)
        
        XCTAssertTrue(sut.contains(x: 1, y: 1))
        XCTAssertTrue(sut.contains(x: 0, y: 1))
        XCTAssertTrue(sut.contains(x: -1, y: 1))
        XCTAssertTrue(sut.contains(x: -2, y: 1))
        XCTAssertTrue(sut.contains(x: 2, y: 1))
        XCTAssertTrue(sut.contains(x: 0, y: -1))
        XCTAssertTrue(sut.contains(x: 0, y: 0))
        XCTAssertTrue(sut.contains(x: 0, y: 3))
        //
        XCTAssertFalse(sut.contains(x: -3, y: 1))
        XCTAssertFalse(sut.contains(x: 3, y: 1))
        XCTAssertFalse(sut.contains(x: 0, y: 4))
        XCTAssertFalse(sut.contains(x: 0, y: -3))
    }
}

// MARK: ClosestPointQueryGeometry2

extension Circle2Tests {
    func testClosestPointTo_line() {
        typealias Line = Line2<Circle.Vector>

        TestFixture.beginFixture(sceneScale: 8.0, renderScale: 15.0) { fixture in
            let sut = Circle(
                center: .init(x: 2, y: 7),
                radius: 5
            )
            let line = Line(
                a: .init(x: 12, y: 0),
                b: .init(x: 12, y: 15)
            )
            fixture.add(sut)
            fixture.add(line)

            fixture.assertEquals(
                sut.closestPointTo(line: line).vector,
                .init(x: 7.0, y: 7.0)
            )
        }
    }

    func testClosestPointTo_line_intersecting() {
        typealias Line = Line2<Circle.Vector>

        TestFixture.beginFixture(sceneScale: 8.0, renderScale: 15.0) { fixture in
            let sut = Circle(
                center: .init(x: 2, y: 7),
                radius: 5
            )
            let line = Line(
                a: .init(x: 0, y: 15),
                b: .init(x: 12, y: 5)
            )
            fixture.add(sut)
            fixture.add(line)

            fixture.assertEquals(
                sut.closestPointTo(line: line),
                .intersection
            )
        }
    }

    func testClosestPointTo_segment_onPath() {
        typealias LineSegment = LineSegment2<Circle.Vector>

        TestFixture.beginFixture(sceneScale: 8.0, renderScale: 15.0) { fixture in
            let sut = Circle(
                center: .init(x: 2, y: 7),
                radius: 5
            )
            let line = LineSegment(
                start: .init(x: 0, y: 17),
                end: .init(x: 3, y: 14)
            )
            fixture.add(sut)
            fixture.add(line)

            fixture.assertEquals(
                sut.closestPointTo(line: line).vector,
                .init(x: 2.7071067811865475, y: 11.949747468305834)
            )
        }
    }
}
