import XCTest
import Geometria

@testable import GeometriaAlgorithms

class KDTreeTests: XCTestCase {
    func testInit_empty_2D() {
        let points: [Vector2D] = []

        let sut = KDTree(elements: points)

        XCTAssertEqual(sut.count, 0)
        SequenceAsserter
            .forSet(
                actual: sut.elements()
            ).assert(
                equals: points
            )
    }

    func testInit_fourPointPartition_2D() {
        let points: [Vector2D] = [
            .init(x: -50, y: -50),
            .init(x: -50, y: 50),
            .init(x: 50, y: -50),
            .init(x: 50, y: 50),
        ]

        let sut = KDTree(elements: points)

        XCTAssertEqual(sut.count, 4)
        SequenceAsserter
            .forSet(
                actual: sut.elements()
            ).assert(
                equals: points
            )
    }

    func testSubdivisionPaths_pointCloudPartition_2D() {
        let points = makePointCloud(count: 10)
        let sut = KDTree(elements: points)

        let paths = sut.subdivisionPaths()

        SequenceAsserter
            .forSet(
                actual: paths
            ).assert(
                equals: [
                    .root,
                    .root.left,
                    .root.right,
                    .root.left.left,
                    .root.left.right,
                    .root.right.left,
                    .root.right.right,
                    .root.left.left.left,
                    .root.left.right.left,
                    .root.right.left.left,
                ]
            )
    }

    func testSubdivisionPathForInserting_pointCloud_2D() {
        let points = makePointCloud(count: 10)
        let sut = KDTree(elements: points)

        let path = sut.subdivisionPath(forInserting: Vector2D(x: 20, y: 15))

        XCTAssertEqual(path, .root.right.left.right)
    }

    func testSubdivisionPath_reversed() {
        let sut = KDTree<Vector2D>
            .SubdivisionPath
            .root.right.left.left

        let result = sut.reversed

        XCTAssertEqual(result, .right(.left(.left(.self))))
    }

    func testInsert_pointCloudPartition_2D() {
        let points = makePointCloud(count: 10)
        var sut = KDTree<Vector2D>(elements: [])

        for point in points {
            sut.insert(point)
        }

        assertIsValid(sut)
        XCTAssertEqual(sut.count, points.count)
        SequenceAsserter
            .forSet(
                actual: sut.elements()
            ).assert(
                equals: points
            )
    }

    func testRemove_pointCloudPartition_2D() {
        let points = makePointCloud(count: 50)
        var sut = KDTree(elements: points)

        for point in points[..<25] {
            sut.remove(point)
        }

        assertIsValid(sut)
        for point in sut.elements() {
            XCTAssertEqual(sut.nearestNeighbor(to: point), point)
        }
    }

    func testRemove_repeatedElement() {
        let points = makePointCloud(count: 50)
        var sut = KDTree(elements: points)
        for point in points {
            sut.insert(point)
        }

        for point in points[..<25] {
            sut.remove(point)
        }

        assertIsValid(sut)
        for point in sut.elements() {
            XCTAssertEqual(sut.nearestNeighbor(to: point), point)
        }
    }

    func testNearestNeighbor_pointCloudPartition_2D_identitySearch() {
        let points = makePointCloud(count: 50)
        let sut = KDTree<Vector2D>(elements: points)

        for point in points {
            XCTAssertEqual(sut.nearestNeighbor(to: point), point)
        }
    }

    func testNearestNeighbor_pointCloudPartition_2D_randomSampling() {
        let totalPoints = makePointCloud(count: 500)
        let points = totalPoints[..<(totalPoints.count / 2)]
        let searchPoints = totalPoints[(totalPoints.count / 2)...]
        let sut = KDTree<Vector2D>(elements: points)

        for (i, searchPoint) in searchPoints.enumerated() {
            let actual = sut.nearestNeighbor(to: searchPoint)
            let expected = closestPointBruteForce(to: searchPoint, in: points)
            XCTAssertEqual(
                actual,
                expected,
                "index: \(i) search point: \(searchPoint) actual distance: \(searchPoint.distance(to: actual!)) expected: \(searchPoint.distance(to: expected))"
            )
        }
    }

    func testNearestNeighbors_pointCloudPartition_2D_randomSampling() {
        let totalPoints = makePointCloud(count: 500)
        let points = totalPoints[..<(totalPoints.count / 2)]
        let searchPoints = totalPoints[(totalPoints.count / 2)...]
        let sut = KDTree<Vector2D>(elements: points)

        for (i, searchPoint) in searchPoints.enumerated() {
            let distanceSquared = 5.0
            let actual = sut.nearestNeighbors(
                to: searchPoint,
                distanceSquared: distanceSquared
            )
            let expected = closestPointsBruteForce(
                to: searchPoint,
                distanceSquared: distanceSquared,
                in: points
            )

            XCTAssertEqual(
                Set(actual),
                Set(expected),
                "index: \(i) search point: \(searchPoint)"
            )
        }
    }

    // MARK: - Collection conformance

    func testCollectionConformance_indices() throws {
        let points = makePointCloud(count: 50)
        let sut = KDTree<Vector2D>(elements: points)
        let expected = try XCTUnwrap(sut.root?.availableElementPaths())

        let result = Array(sut.indices)

        XCTAssertEqual(result.map(\.path), expected)
    }

    func testCollectionConformance_startIndex() {
        let points = makePointCloud(count: 50)
        let sut = KDTree<Vector2D>(elements: points)

        XCTAssertEqual(sut.startIndex, .init(path: .self))
    }

    func testCollectionConformance_endIndex() {
        let points = makePointCloud(count: 50)
        let sut = KDTree<Vector2D>(elements: points)

        XCTAssertEqual(sut.endIndex, .init(path: .right(.right(.right(.right(.left(.left(.self))))))))
    }

    func testCollectionConformance_indexAfter() {
        let points = makePointCloud(count: 50)
        let sut = KDTree<Vector2D>(elements: points)

        XCTAssertEqual(
            sut.index(after: sut.startIndex),
            .init(path: .left(.self))
        )
    }

    func testCollectionConformance_index_offsetBy_25() {
        let points = makePointCloud(count: 50)
        let sut = KDTree<Vector2D>(elements: points)

        XCTAssertEqual(
            sut.index(sut.startIndex, offsetBy: 25),
            .init(path: .left(.right(.right(.right(.left(.self))))))
        )
    }

    func testCollectionConformance_index_offsetBy_50() {
        let points = makePointCloud(count: 50)
        let sut = KDTree<Vector2D>(elements: points)

        XCTAssertEqual(
            sut.index(sut.startIndex, offsetBy: 50),
            .init(path: .right(.right(.right(.right(.left(.left(.self)))))))
        )
    }

    func testCollectionConformance_subscript() {
        let points = makePointCloud(count: 50)
        let sut = KDTree<Vector2D>(elements: points)

        XCTAssertEqual(
            sut[.init(path: .left(.left(.left(.right(.left(.self))))))],
            points[0]
        )
    }

    func testCollectionConformance_sequenceProtocol() {
        let points = makePointCloud(count: 50)
        let sut = KDTree<Vector2D>(elements: points)

        XCTAssertEqual(Set(sut), Set(points))
    }

    // MARK: - Performance tests

    #if GEOMETRIA_PERFORMANCE_TESTS

    func testPerformance_nearestNeighbor_pointCloudPartition_2D_randomSampling() {
        let totalPoints = makePointCloud(count: 10_000)
        let points = totalPoints[..<(totalPoints.count / 2)]
        let searchPoints = totalPoints[(totalPoints.count / 2)...]
        let sut = KDTree<Vector2D>(elements: points)

        measure {
            for searchPoint in searchPoints {
                _=sut.nearestNeighbor(to: searchPoint)
            }
        }
    }

    func testPerformance_init_pointCloudPartition_2D() {
        let points = makePointCloud(count: 2_000)

        measure {
            _=KDTree<Vector2D>(elements: points)
        }
    }

    #endif
}

private func closestPointBruteForce<C: Collection<Vector2D>>(
    to point: Vector2D,
    in list: C
) -> Vector2D {
    list.min(by: {
        $0.distanceSquared(to: point) < $1.distanceSquared(to: point)
    }) ?? point
}

private func closestPointsBruteForce<C: Collection<Vector2D>>(
    to point: Vector2D,
    distanceSquared: Double,
    in list: C
) -> [Vector2D] {
    list.filter({
        $0.distanceSquared(to: point) <= distanceSquared
    })
}

private func makePointCloud(count: Int) -> [Vector2D] {
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

    return (0..<count).map { _ in
        randomPoint()
    }
}

private func assertIsValid(
    _ tree: KDTree<Vector2D>,
    file: StaticString = #file,
    line: UInt = #line
) {
    guard let root = tree.root else {
        return
    }

    var isValid = true
    root.applyToTreeBreadthFirst { subdivision in
        let element = subdivision.element
        let dimension = subdivision.dimension

        if let left = subdivision.left {
            isValid = isValid && left.element[dimension] <= element[dimension]
        }
        if let right = subdivision.right {
            isValid = isValid && right.element[dimension] >= element[dimension]
        }
    }

    XCTAssertTrue(isValid, "KDTree is not valid: Elements are not subdivided by their dimensions", file: file, line: line)
}
