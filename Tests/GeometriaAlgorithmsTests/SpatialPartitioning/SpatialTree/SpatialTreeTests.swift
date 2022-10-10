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
        SequenceAsserter
            .forSet(
                actual: points.flatMap(sut.queryPoint)
            ).assert(
                equals: points
            )
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
        SequenceAsserter
            .forSet(
                actual: aabbs.flatMap { sut.queryPoint($0.center) }
            ).assert(
                equals: aabbs
            )
    }

    func testInit_pointCloudPartition_2D() {
        let points = makePointCloud()

        let sut = SpatialTree(
            points,
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 1
        )

        XCTAssertEqual(sut.geometryList.count, 50)
        let paths = sut.subdivisionPaths()
        let allIndices = paths.flatMap(sut.indicesAt)
        SequenceAsserter
            .forSet(
                actual: allIndices
            ).assert(
                equals: Set(0..<points.count)
            )
    }

    func testMaxDepth() {
        let points = makePointCloud()

        let sut = SpatialTree(
            points,
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 4
        )

        XCTAssertEqual(sut.maxDepth(), 3)
    }

    func testMaxDepth_emptyTree() {
        let sut = SpatialTree<Vector2D>(
            [],
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 4
        )

        XCTAssertEqual(sut.maxDepth(), 0)
    }

    func test_subdivisionPaths_pointCloudPartition_2D() {
        let points = makePointCloud()
        let sut = SpatialTree(
            points,
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 12
        )

        let result = sut.subdivisionPaths()
        SequenceAsserter
            .forSet(
                actual: result
            ).assert(
                equals: [
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
                ]
            )
    }

    func testIndicesAt() {
        let points = makePointCloud()
        let sut = SpatialTree(
            points,
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 12
        )

        let result = sut.indicesAt(path: .child(index: 1, parent: .child(index: 0, parent: .root)))

        SequenceAsserter
            .forSet(
                actual: result
            ).assert(
                equals: [2, 6, 7, 8, 32, 37, 48]
            )
    }

    func testIndicesAt_pastMaxDepth_returnsEmptyArray() {
        let sut = SpatialTree<Vector2D>(
            [],
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 12
        )

        let result = sut.indicesAt(path: .root.childAt(0).childAt(0))

        XCTAssertEqual(result, [])
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

        XCTAssertEqual(result, [])
    }

    func testDeepestSubdivisionContaining() {
        let sut = SpatialTree<Vector2D>(
            makePointCloud(),
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 8
        )

        let result = sut.deepestSubdivisionContaining(.init(x: 15, y: 20))
        
        XCTAssertEqual(
            result,
            .root.childAt(3).childAt(0)
        )
    }

    func testDeepestSubdivisionContaining_outOfBounds_returnsNil() {
        let sut = SpatialTree<Vector2D>(
            [],
            maxSubdivisions: 8,
            maxElementsPerLevelBeforeSplit: 8
        )

        let result = sut.deepestSubdivisionContaining(.init(x: 15, y: 20))
        
        XCTAssertNil(result)
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
