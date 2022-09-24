import XCTest

import Geometria
@testable import GeometriaAlgorithms

class SpatialTreeTests: XCTestCase {
    func testInit_fourPointPartition_2D() {
        let points: [Vector2D] = [
            .init(x: -50, y: -50),
            .init(x: -50, y: 50),
            .init(x: 50, y: -50),
            .init(x: 50, y: 50),
        ]
        
        let sut = SpatialTree(
            points,
            maxSubdivisions: 3,
            maxElementsPerLevelBeforeSplit: 1
        )

        XCTAssertEqual(sut.geometryList.count, 4)
        XCTAssertEqual(sut.queryPoint(points[0]), [points[0]])
        XCTAssertEqual(sut.queryPoint(points[1]), [points[1]])
        XCTAssertEqual(sut.queryPoint(points[2]), [points[2]])
        XCTAssertEqual(sut.queryPoint(points[3]), [points[3]])
    }

    func testInit_centerAABBOnSplit_2D() {
        let aabbs: [AABB2D] = [
            .init(center: .init(x: 0, y: 0), size: .init(x: 5, y: 5)),
            .init(center: .init(x: -10, y: -10), size: .init(x: 5, y: 5)),
            .init(center: .init(x: 10, y: -10), size: .init(x: 5, y: 5)),
            .init(center: .init(x: -10, y: 10), size: .init(x: 5, y: 5)),
            .init(center: .init(x: 10, y: 10), size: .init(x: 5, y: 5)),
        ]
        
        let sut = SpatialTree(
            aabbs,
            maxSubdivisions: 3,
            maxElementsPerLevelBeforeSplit: 1
        )

        XCTAssertEqual(sut.geometryList.count, 5)
        XCTAssertEqual(sut.queryPoint(aabbs[0].center), [aabbs[0]])
        XCTAssertEqual(sut.queryPoint(aabbs[1].center), [aabbs[1]])
        XCTAssertEqual(sut.queryPoint(aabbs[2].center), [aabbs[2]])
        XCTAssertEqual(sut.queryPoint(aabbs[3].center), [aabbs[3]])
        XCTAssertEqual(sut.queryPoint(aabbs[4].center), [aabbs[4]])
    }

    func testInit_pointCloudPartition_2D() {
        let points = makePointCloud()

        let sut = SpatialTree(
            points,
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 12
        )

        XCTAssertEqual(sut.geometryList.count, 50)
    }

    func test_subdivisionPaths_pointCloudPartition_2D() {
        let points = makePointCloud()
        let sut = SpatialTree(
            points,
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 12
        )

        let result = sut.subdivisionPaths()

        XCTAssertEqual(result, [
            .root,
            .root.childAt(0),
            .root.childAt(1),
            .root.childAt(2),
            .root.childAt(3),
            .root.childAt(0).childAt(0),
            .root.childAt(0).childAt(1),
            .root.childAt(0).childAt(2),
            .root.childAt(0).childAt(3),
            .root.childAt(1).childAt(0),
            .root.childAt(1).childAt(1),
            .root.childAt(1).childAt(2),
            .root.childAt(1).childAt(3),
        ])
    }

    func testIndicesAt() {
        let points = makePointCloud()
        let sut = SpatialTree(
            points,
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 12
        )

        let result = sut.indicesAt(path: .child(index: 1, parent: .child(index: 0, parent: .root)))

        XCTAssertEqual(result.sorted(), [
            2, 6, 7, 8, 32, 37, 48,
        ])
    }

    func testIndicesAt_pastMaxDepth_returnsEmptyArray() {
        let sut = SpatialTree<Vector2D>(
            [],
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 12
        )

        let result = sut.indicesAt(path: .root.childAt(0).childAt(0))

        XCTAssertEqual(result.sorted(), [])
    }

    func testIndicesAt_outOfBoundsSubdivision_returnsEmptyArray() {
        let sut = SpatialTree<Vector2D>(
            [
                .init(x: 0, y: 0),
                .init(x: 10, y: 0),
                .init(x: 0, y: 10),
                .init(x: 10, y: 10),
            ],
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 12
        )

        let result = sut.indicesAt(path: .root.childAt(0))

        XCTAssertEqual(result.sorted(), [])
    }
}

private func makePointCloud() -> [Vector2D] {
    var rng = MersenneTwister(seed: 0x123)

    func randomPoint() -> Vector2D {
        let recenter = Vector2D(
            x: 12,
            y: 20
        )
        let scaling = Vector2D(
            x: 1.1,
            y: 0.9
        )

        let vec = Vector2D(
            x: .random(in: (-100..<100), using: &rng),
            y: .random(in: (-100..<100), using: &rng)
        )

        return (vec - recenter) * scaling + recenter
    }

    return (0..<50).map { _ in
        randomPoint()
    }
}

extension Vector2D: BoundableType {
    public var bounds: AABB<Self> {
        .init(of: self, self)
    }
}
