import XCTest

@testable import Geometria

class AABB3Tests: XCTestCase {
    typealias AABB3 = AABB3D
    typealias Line3 = Line3D
    typealias LineSegment3 = LineSegment3D

    func testClosestPointTo_frontTopEdge() {
        TestFixture.beginFixture(sceneScale: 0.5, renderScale: 20) { fixture in
            let sut = AABB3(
                minimum: .init(x: 1, y: 2, z: 3),
                maximum: .init(x: 5, y: 7, z: 11)
            )
            let line = Line3(
                a: .init(x: 11, y: 3, z: 0),
                b: .init(x: 9, y: 6, z: 12)
            )

            let result = sut.closestPointTo(line: line)

            fixture.assertEquals(
                result.vector,
                .init(x: 5.0, y: 5.918918918918919, z: 11.0)
            )

            fixture.add(sut)
            fixture.add(line)
            fixture.add(result.vector)
        }
    }

    func testClosestPointTo_vertex() {
        TestFixture.beginFixture(sceneScale: 0.5, renderScale: 20) { fixture in
            let sut = AABB3(
                minimum: .init(x: 1, y: 2, z: 3),
                maximum: .init(x: 5, y: 7, z: 11)
            )
            let line = Line3(
                a: .init(x: 11, y: 3, z: 12),
                b: .init(x: 3, y: 14, z: 12)
            )

            let result = sut.closestPointTo(line: line)

            fixture.assertEquals(
                result.vector,
                .init(x: 5.0, y: 7.0, z: 11.0)
            )

            fixture.add(sut)
            fixture.add(line)
            fixture.add(result.vector)
        }
    }

    func testClosestPointTo_coplanarLine() {
        TestFixture.beginFixture(sceneScale: 0.5, renderScale: 20) { fixture in
            let sut = AABB3(
                minimum: .init(x: 1, y: 2, z: 3),
                maximum: .init(x: 5, y: 7, z: 11)
            )
            let line = Line3(
                a: .init(x: 9, y: 3, z: 0),
                b: .init(x: 9, y: 6, z: 12)
            )

            let result = sut.closestPointTo(line: line)

            fixture.assertEquals(
                result.vector,
                .init(x: 5.0, y: 3.75, z: 3.0)
            )

            fixture.add(sut)
            fixture.add(line)
        }
    }

    func testClosestPointTo_intersectingLine() {
        TestFixture.beginFixture(sceneScale: 0.5, renderScale: 20) { fixture in
            let sut = AABB3(
                minimum: .init(x: 1, y: 2, z: 3),
                maximum: .init(x: 5, y: 7, z: 11)
            )
            let line = Line3(
                a: .init(x: 20, y: 5, z: 7),
                b: .init(x: 10, y: 6, z: 7)
            )

            let result = sut.closestPointTo(line: line)

            fixture.assertEquals(
                result,
                .intersection
            )

            fixture.add(sut)
            fixture.add(line)
        }
    }

    func testClosestPointTo_lineSegment_inPath() {
        TestFixture.beginFixture(sceneScale: 0.5, renderScale: 20) { fixture in
            let sut = AABB3(
                minimum: .init(x: 1, y: 2, z: 3),
                maximum: .init(x: 5, y: 7, z: 11)
            )
            let line = LineSegment3(
                start: .init(x: 20, y: 5, z: 7),
                end: .init(x: 10, y: 6, z: 7)
            )

            let result = sut.closestPointTo(line: line)

            fixture.assertEquals(
                result.vector,
                .init(x: 5.0, y: 6.0, z: 7.0)
            )

            fixture.add(sut)
            fixture.add(line)
        }
    }
}
