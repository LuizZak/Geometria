import XCTest
import Geometria

@testable import GeometriaAlgorithms

class SpatialTreeTests: XCTestCase {
    func testInitialize_pointCloud() {
        let pointCloud = makePointCloud()

        let sut = makeSut(pointCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)

        XCTAssertEqual(Set(sut.elements()), Set(pointCloud))
    }

    func testInitialize_aabbCloud() {
        let aabbCloud = makeAABBCloud()

        let sut = makeSut(aabbCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)

        XCTAssertEqual(Set(sut.elements()), Set(aabbCloud))
    }

    // MARK: - Querying

    func testQueryPoint_aabbCloud() {
        let aabbCloud = makeAABBCloud()
        let point = Vector2D.zero
        let sut = makeSut(aabbCloud, maxSubdivisions: 4, maxElementsPerLevelBeforeSplit: 8)
        let expected = aabbCloud.filter { $0.contains(point) }
        XCTAssertEqual(expected.count, 12) // Sanity check

        let result = sut.queryPoint(point)

        XCTAssertEqual(Set(result), Set(expected))
    }

    func testQueryLine_aabbCloud() {
        let aabbCloud = makeAABBCloud()
        let line = LineSegment2D(
            start: .zero, end: .init(x: 5, y: 5)
        )
        let sut = makeSut(aabbCloud, maxSubdivisions: 4, maxElementsPerLevelBeforeSplit: 8)
        let expected = aabbCloud.filter { $0.intersects(line: line) }
        XCTAssertEqual(expected.count, 14) // Sanity check

        let result = sut.queryLine(line)

        XCTAssertEqual(Set(result), Set(expected))
    }

    func testQuery_aabbCloud() {
        let aabbCloud = makeAABBCloud()
        let bounds = AABB2D(minimum: .zero, maximum: .init(x: 5, y: 5))
        let sut = makeSut(aabbCloud, maxSubdivisions: 4, maxElementsPerLevelBeforeSplit: 8)
        let expected = aabbCloud.filter { $0.intersects(bounds) }
        XCTAssertEqual(expected.count, 14) // Sanity check

        let result = sut.query(bounds)

        XCTAssertEqual(Set(result), Set(expected))
    }

    func testQuery_symptomaticLines() {
        func line(_ x0: Double, _ y0: Double, _ x1: Double, _ y1: Double) -> LineSegment2D {
            .init(x1: x0, y1: y0, x2: x1, y2: y1)
        }
        let lines: [LineSegment2D] = [
            line(-100.0, -250.0, 100.0, -250.0),
            line(100.0, -99.99999999999997, 100.0, 100.00000000000001),
            line(100.0, 250.0, -100.0, 250.0),
            line(-100.0, 250.0, -100.0, -250.0),
            line(200.0, -200.0, 200.0, -100.0),
            line(100.0, -199.99999999999997, 200.0, -200.0),
            line(100.0, -199.99999999999997, 100.0, -99.99999999999997),
            line(100.0, -250.0, 100.0, -199.99999999999997),
            line(200.0, -100.0, 100.0, -99.99999999999997),
            line(100.0, -99.99999999999997, 100.0, -199.99999999999997),
            line(100.0, 200.00000000000003, 100.0, 250.0),
            line(100.0, 100.00000000000001, 100.0, 200.00000000000003),
            line(100.0, 100.00000000000001, 200.0, 100.0),
            line(200.0, 100.0, 200.0, 200.0),
            line(200.0, 200.0, 100.0, 200.00000000000003),
            line(100.0, 200.00000000000003, 100.0, 100.00000000000001),
        ]
        let sut = makeSut(lines, maxSubdivisions: 2, maxElementsPerLevelBeforeSplit: 4)

        for line in lines {
            let results = sut.query(line)

            XCTAssertTrue(results.contains(line), "Expected \(line) to be in \(results)")
        }
    }

    // MARK: - Mutation

    func testInsert_pointCloud() {
        let pointCloud = makePointCloud()
        var sut = makeSut([] as [Vector2D], maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)

        for point in pointCloud {
            sut.insert(point)
        }

        XCTAssertEqual(Set(sut.elements()), Set(pointCloud))
        let paths = sut.root.availableElementPaths()
        XCTAssertEqual(
            paths,
            [
                .element(0),
                .subdivision(0, .subdivision(0, .element(0))),
                .subdivision(0, .subdivision(0, .element(1))),
                .subdivision(0, .subdivision(1, .element(0))),
                .subdivision(0, .subdivision(1, .element(1))),
                .subdivision(0, .subdivision(1, .element(2))),
                .subdivision(0, .subdivision(1, .element(3))),
                .subdivision(0, .subdivision(1, .element(4))),
                .subdivision(0, .subdivision(1, .element(5))),
                .subdivision(0, .subdivision(1, .element(6))),
                .subdivision(0, .subdivision(2, .element(0))),
                .subdivision(0, .subdivision(2, .element(1))),
                .subdivision(0, .subdivision(3, .element(0))),
                .subdivision(0, .subdivision(3, .element(1))),
                .subdivision(0, .subdivision(3, .element(2))),
                .subdivision(1, .subdivision(0, .element(0))),
                .subdivision(1, .subdivision(0, .element(1))),
                .subdivision(1, .subdivision(0, .element(2))),
                .subdivision(1, .subdivision(0, .element(3))),
                .subdivision(1, .subdivision(0, .element(4))),
                .subdivision(1, .subdivision(0, .element(5))),
                .subdivision(1, .subdivision(0, .element(6))),
                .subdivision(1, .subdivision(1, .element(0))),
                .subdivision(1, .subdivision(1, .element(1))),
                .subdivision(1, .subdivision(1, .element(2))),
                .subdivision(1, .subdivision(1, .element(3))),
                .subdivision(1, .subdivision(1, .element(4))),
                .subdivision(1, .subdivision(1, .element(5))),
                .subdivision(1, .subdivision(2, .element(0))),
                .subdivision(1, .subdivision(2, .element(1))),
                .subdivision(1, .subdivision(3, .element(0))),
                .subdivision(1, .subdivision(3, .element(1))),
                .subdivision(1, .subdivision(3, .element(2))),
                .subdivision(1, .subdivision(3, .element(3))),
                .subdivision(2, .element(0)),
                .subdivision(2, .element(1)),
                .subdivision(2, .element(2)),
                .subdivision(2, .element(3)),
                .subdivision(2, .element(4)),
                .subdivision(2, .element(5)),
                .subdivision(2, .element(6)),
                .subdivision(3, .subdivision(1, .element(0))),
                .subdivision(3, .subdivision(2, .element(0))),
                .subdivision(3, .subdivision(2, .element(1))),
                .subdivision(3, .subdivision(2, .element(2))),
                .subdivision(3, .subdivision(2, .element(3))),
                .subdivision(3, .subdivision(2, .element(4))),
                .subdivision(3, .subdivision(2, .element(5))),
                .subdivision(3, .subdivision(2, .element(6))),
                .subdivision(3, .subdivision(3, .element(0))),
            ]
        )
    }

    func testRemove() throws {
        let pointCloud = makePointCloud()
        var sut = makeSut(pointCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)
        let pathsToRemove: [SpatialTree<Vector2D>.ElementPath] = [
            .subdivision(3, .subdivision(1, .element(0))),
            .subdivision(3, .subdivision(2, .element(0))),
            .subdivision(3, .subdivision(2, .element(1))),
            .subdivision(3, .subdivision(2, .element(2))),
            .subdivision(3, .subdivision(2, .element(3))),
            .subdivision(3, .subdivision(2, .element(4))),
            .subdivision(3, .subdivision(2, .element(5))),
            .subdivision(3, .subdivision(2, .element(6))),
            .subdivision(3, .subdivision(3, .element(0))),
        ]

        for path in pathsToRemove.reversed() {
            sut.remove(at: .init(path: path), collapseEmpty: true)
        }

        XCTAssertEqual(sut.count, 41)
        let subdivision = try XCTUnwrap(sut.root.subdivisions?[3])
        XCTAssertNil(subdivision.subdivisions)
    }

    func testRemoveAll() {
        let pointCloud = makePointCloud()
        var sut = makeSut(pointCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)

        sut.removeAll()

        XCTAssertEqual(sut.elements(), [])
        XCTAssertNil(sut.root.subdivisions)
    }

    // MARK: - Collection conformance

    func testCollectionConformance_indices() {
        let pointCloud = makePointCloud()
        let sut = makeSut(pointCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)
        let expected = sut.root.availableElementPaths()

        let result = Array(sut.indices)

        XCTAssertEqual(result.map(\.path), expected)
    }

    func testCollectionConformance_startIndex() {
        let pointCloud = makePointCloud()
        let sut = makeSut(pointCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)

        XCTAssertEqual(sut.startIndex, .init(path: .element(0)))
    }

    func testCollectionConformance_endIndex() {
        let pointCloud = makePointCloud()
        let sut = makeSut(pointCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)

        XCTAssertEqual(sut.endIndex, .init(path: .subdivision(4, .element(0))))
    }

    func testCollectionConformance_indexAfter() {
        let pointCloud = makePointCloud()
        let sut = makeSut(pointCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)

        XCTAssertEqual(
            sut.index(after: sut.startIndex),
            .init(path: .subdivision(0, .subdivision(0, .element(0))))
        )
    }

    func testCollectionConformance_indexAfter_lastRootSubdivision() {
        let pointCloud = makePointCloud()
        let sut = makeSut(pointCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)

        XCTAssertEqual(
            sut.index(
                after: .init(path: .subdivision(2, .element(6)))
            ),
            .init(path: .subdivision(3, .subdivision(1, .element(0))))
        )
    }

    func testCollectionConformance_indexAfter_withinElementCount() {
        let pointCloud = makePointCloud()
        let sut = makeSut(pointCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)

        XCTAssertEqual(
            sut.index(after: .init(path: .subdivision(0, .subdivision(0, .element(0))))),
            .init(path: .subdivision(0, .subdivision(0, .element(1))))
        )
    }

    func testCollectionConformance_indexAfter_pastEndOfElements() {
        let pointCloud = makePointCloud()
        let sut = makeSut(pointCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)

        XCTAssertEqual(
            sut.index(after: .init(path: .subdivision(0, .subdivision(0, .element(1))))),
            .init(path: .subdivision(0, .subdivision(1, .element(0))))
        )
    }

    func testCollectionConformance_subscript() {
        let pointCloud = makePointCloud()
        let sut = makeSut(pointCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)

        XCTAssertEqual(
            sut[.init(path: .subdivision(0, .subdivision(0, .element(0))))],
            pointCloud[0]
        )
    }

    func testCollectionConformance_sequenceProtocol() {
        let pointCloud = makePointCloud()
        let sut = makeSut(pointCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 8)

        XCTAssertEqual(Set(sut), Set(pointCloud))
    }

    // MARK: - Performance

    #if GEOMETRIA_PERFORMANCE_TESTS

    func testPerformance_initialize_aabbs_100_000_maxSubdivisions_3_maxElementsPerLevelBeforeSplit_10() {
        let aabbCloud = makeAABBCloud(count: 100_000)

        measure {
            _=makeSut(aabbCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 10)
        }
    }

    func testPerformance_queryPoint_aabbs_100_000_maxSubdivisions_3_maxElementsPerLevelBeforeSplit_10() {
        let aabbCloud = makeAABBCloud(count: 100_000)
        let sut = makeSut(aabbCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 10)

        measure {
            _=sut.queryPoint(.zero)
        }
    }

    func testPerformance_queryLine_aabbs_100_000_maxSubdivisions_3_maxElementsPerLevelBeforeSplit_10() {
        let aabbCloud = makeAABBCloud(count: 100_000)
        let line = LineSegment2D(
            start: .zero, end: .init(x: 5, y: 5)
        )
        let sut = makeSut(aabbCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 10)

        measure {
            _=sut.queryLine(line)
        }
    }

    func testPerformance_query_aabbs_100_000_maxSubdivisions_3_maxElementsPerLevelBeforeSplit_10() {
        let aabbCloud = makeAABBCloud(count: 100_000)
        let bounds = AABB2D(minimum: .zero, maximum: .init(x: 5, y: 5))
        let sut = makeSut(aabbCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 10)

        measure {
            _=sut.query(bounds)
        }
    }

    func testPerformance_copyOnWrite_aabbs_100_000_maxSubdivisions_6_maxElementsPerLevelBeforeSplit_10() {
        let aabbCloud = makeAABBCloud(count: 100_000)
        let sut = makeSut(aabbCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 10)

        measure {
            var copy = sut
            copy.insert(aabbCloud[0])
        }
    }

    func testPerformance_remove_aabbs_100_000_maxSubdivisions_6_maxElementsPerLevelBeforeSplit_10() {
        let aabbCloud = makeAABBCloud(count: 100_000)
        let sut = makeSut(aabbCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 10)

        measure {
            var copy = sut
            copy.remove(aabbCloud[0])
        }
    }

    func testPerformance_remove_range_aabbs_100_000_maxSubdivisions_6_maxElementsPerLevelBeforeSplit_10() {
        let aabbCloud = makeAABBCloud(count: 100_000)
        let sut = makeSut(aabbCloud, maxSubdivisions: 3, maxElementsPerLevelBeforeSplit: 10)

        measure {
            var copy = sut
            for aabb in aabbCloud[0..<50] {
                copy.remove(aabb)
            }
        }
    }

    #endif
}

// MARK: - Test internals

private func makeSut<Boundable>(
    _ elements: [Boundable],
    maxSubdivisions: Int,
    maxElementsPerLevelBeforeSplit: Int
) -> SpatialTree<Boundable> {
    return .init(
        elements,
        maxSubdivisions: maxSubdivisions,
        maxElementsPerLevelBeforeSplit: maxElementsPerLevelBeforeSplit
    )
}

/// Creates a point-cloud of points (50 by default) randomly distributed along a
/// central point in space.
private func makePointCloud(count: Int = 50) -> [Vector2D] {
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

/// Creates a random assortment of 50 AABBs randomly distributed along a central
/// point in space.
///
/// Each AABB is created by generating two random points, and making an AABB out
/// of the extremas of the points.
private func makeAABBCloud(count: Int = 50) -> [AABB2D] {
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
        AABB(of: randomPoint(), randomPoint())
    }
}

extension Vector2D: BoundableType {
    public var bounds: AABB<Self> {
        .init(of: self, self)
    }
}
