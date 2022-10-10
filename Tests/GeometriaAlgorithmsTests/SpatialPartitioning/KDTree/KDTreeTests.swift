import XCTest
import Geometria

@testable import GeometriaAlgorithms

class KDTreeTests: XCTestCase {
    func testInit_empty_2D() {
        let points: [Vector2D] = []
        
        let sut = KDTree(points: points)

        XCTAssertEqual(sut.count, 0)
        SequenceAsserter
            .forSet(
                actual: sut.points()
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
        
        let sut = KDTree(points: points)

        XCTAssertEqual(sut.count, 4)
        SequenceAsserter
            .forSet(
                actual: sut.points()
            ).assert(
                equals: points
            )
    }

    func testSubdivisionPaths_pointCloudPartition_2D() {
        let points = makePointCloud(count: 10)
        let sut = KDTree(points: points)

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
        let sut = KDTree(points: points)

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
        var sut = KDTree<Vector2D>(points: [])

        for point in points {
            sut.insert(point)
        }

        XCTAssertEqual(sut.count, points.count)
        SequenceAsserter
            .forSet(
                actual: sut.points()
            ).assert(
                equals: points
            )
    }

    func testNearestNeighbor_pointCloudPartition_2D_identitySearch() {
        let points = makePointCloud(count: 50)
        let sut = KDTree<Vector2D>(points: points)

        for point in points {
            XCTAssertEqual(sut.nearestNeighbor(to: point), point)
        }
    }

    func testNearestNeighbor_pointCloudPartition_2D_randomSampling() {
        let totalPoints = makePointCloud(count: 200)
        let points = totalPoints[..<(totalPoints.count / 2)]
        let searchPoints = points[(totalPoints.count / 2)...]
        let sut = KDTree<Vector2D>(points: points)

        for searchPoint in searchPoints {
            XCTAssertEqual(
                sut.nearestNeighbor(to: searchPoint),
                closestPointBruteForce(to: searchPoint, in: searchPoints)
            )
        }
    }
}

private func closestPointBruteForce<C: Collection<Vector2D>>(to point: Vector2D, in list: C) -> Vector2D {
    guard let first = list.first else {
        return point
    }

    var current: (point: Vector2D, distanceSquared: Double) = (first, first.distanceSquared(to: point))

    for p in list {
        let distance = p.distanceSquared(to: point)
        if distance < current.distanceSquared {
            current = (p, distance)
        }
    }

    return current.point
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
