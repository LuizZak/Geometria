import XCTest
import Geometria
import TestCommons

class ConvexLineIntersectionTests: XCTestCase {
    typealias Vector = Vector2D
    typealias Sut = ConvexLineIntersection<Vector>
    typealias PointNormal = Geometria.LineIntersectionPointNormal<Vector>
    typealias Mapper = (LineIntersectionPointNormal<Vector>, Sut.LineIntersectionPointNormalKind) -> LineIntersectionPointNormal<Vector>
    //
    typealias Vector3 = Vector3D
    typealias OtherPointNormal = Geometria.LineIntersectionPointNormal<Vector3>
    typealias Transformer = (LineIntersectionPointNormal<Vector>, Sut.LineIntersectionPointNormalKind) -> OtherPointNormal

    // MARK: mappingPointNormals

    func testMappingPointNormals_noIntersection() {
        let sut = Sut.noIntersection
        var kinds: [Sut.LineIntersectionPointNormalKind] = []
        let mapper: Mapper = { (pn, k) in kinds.append(k); return pn }

        XCTAssertEqual(sut.mappingPointNormals(mapper), .noIntersection)
        XCTAssertEqual(kinds, [])
    }

    func testMappingPointNormals_contained() {
        let sut = Sut.contained
        var kinds: [Sut.LineIntersectionPointNormalKind] = []
        let mapper: Mapper = { (pn, k) in kinds.append(k); return pn }

        XCTAssertEqual(sut.mappingPointNormals(mapper), .contained)
        XCTAssertEqual(kinds, [])
    }

    func testMappingPointNormals_singlePoint() {
        let sut = Sut.singlePoint(.init(normalizedMagnitude: 0.0, point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        var kinds: [Sut.LineIntersectionPointNormalKind] = []
        let mapper: Mapper = { (pn, k) in
            kinds.append(k)
            return .init(normalizedMagnitude: 0.0, point: pn.point * 2, normal: pn.normal * 2)
        }

        assertEqual(
            sut.mappingPointNormals(mapper),
            .singlePoint(
                .init(
                    normalizedMagnitude: 0.0,
                    point: .init(x: 2, y: 4),
                    normal: .init(x: 6, y: 8)
                )
            )
        )
        XCTAssertEqual(kinds, [.singlePoint])
    }

    func testMappingPointNormals_enter() {
        let sut = Sut.enter(.init(normalizedMagnitude: 0.0, point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        var kinds: [Sut.LineIntersectionPointNormalKind] = []
        let mapper: Mapper = { (pn, k) in
            kinds.append(k)
            return .init(normalizedMagnitude: 0.0, point: pn.point * 2, normal: pn.normal * 2)
        }

        assertEqual(
            sut.mappingPointNormals(mapper),
            .enter(
                .init(
                    normalizedMagnitude: 0.0,
                    point: .init(x: 2, y: 4),
                    normal: .init(x: 6, y: 8)
                )
            )
        )
        XCTAssertEqual(kinds, [.enter])
    }

    func testMappingPointNormals_exit() {
        let sut = Sut.exit(.init(normalizedMagnitude: 0.0, point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        var kinds: [Sut.LineIntersectionPointNormalKind] = []
        let mapper: Mapper = { (pn, k) in
            kinds.append(k)
            return .init(normalizedMagnitude: 0.0, point: pn.point * 2, normal: pn.normal * 2)
        }

        assertEqual(
            sut.mappingPointNormals(mapper),
            .exit(
                .init(
                    normalizedMagnitude: 0.0,
                    point: .init(x: 2, y: 4),
                    normal: .init(x: 6, y: 8)
                )
            )
        )
        XCTAssertEqual(kinds, [.exit])
    }

    func testMappingPointNormals_enterExit() {
        let sut = Sut.enterExit(
            .init(
                normalizedMagnitude: 0.0,
                point: .init(x: 1, y: 2),
                normal: .init(x: 3, y: 4)),
            .init(
                normalizedMagnitude: 0.0,
                point: .init(x: 5, y: 6),
                normal: .init(x: 7, y: 8)
            )
        )
        var kinds: [Sut.LineIntersectionPointNormalKind] = []
        let mapper: Mapper = { (pn, k) in
            kinds.append(k)
            return .init(normalizedMagnitude: 0.0, point: pn.point * 2, normal: pn.normal * 2)
        }

        assertEqual(
            sut.mappingPointNormals(mapper),
            .enterExit(
                .init(
                    normalizedMagnitude: 0.0,
                    point: .init(x: 2, y: 4),
                    normal: .init(x: 6, y: 8)
                ),
                .init(
                    normalizedMagnitude: 0.0,
                    point: .init(x: 10, y: 12),
                    normal: .init(x: 14, y: 16)
                )
            )
        )
        XCTAssertEqual(kinds, [.enter, .exit])
    }

    // MARK: replacingPointNormals

    func testReplacingPointNormals_noIntersection() {
        let sut = Sut.noIntersection
        var kinds: [Sut.LineIntersectionPointNormalKind] = []
        let mapper: Transformer = { (pn, k) in kinds.append(k); return transform(pn) }

        XCTAssertEqual(sut.replacingPointNormals(mapper), .noIntersection)
        XCTAssertEqual(kinds, [])
    }

    func testReplacingPointNormals_contained() {
        let sut = Sut.contained
        var kinds: [Sut.LineIntersectionPointNormalKind] = []
        let mapper: Transformer = { (pn, k) in kinds.append(k); return transform(pn) }

        XCTAssertEqual(sut.replacingPointNormals(mapper), .contained)
        XCTAssertEqual(kinds, [])
    }

    func testReplacingPointNormals_singlePoint() {
        let sut = Sut.singlePoint(.init(normalizedMagnitude: 0.0, point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        var kinds: [Sut.LineIntersectionPointNormalKind] = []
        let mapper: Transformer = { (pn, k) in
            kinds.append(k)
            return transform(.init(normalizedMagnitude: 0.0, point: pn.point * 2, normal: pn.normal * 2))
        }

        assertEqual(
            sut.replacingPointNormals(mapper),
            .singlePoint(
                .init(
                    normalizedMagnitude: 0.0,
                    point: .init(x: 2, y: 4, z: 0),
                    normal: .init(x: 6, y: 8, z: 0)
                )
            )
        )
        XCTAssertEqual(kinds, [.singlePoint])
    }

    func testReplacingPointNormals_enter() {
        let sut = Sut.enter(.init(normalizedMagnitude: 0.0, point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        var kinds: [Sut.LineIntersectionPointNormalKind] = []
        let mapper: Transformer = { (pn, k) in
            kinds.append(k)
            return transform(.init(normalizedMagnitude: 0.0, point: pn.point * 2, normal: pn.normal * 2))
        }

        assertEqual(
            sut.replacingPointNormals(mapper),
            .enter(
                .init(
                    normalizedMagnitude: 0.0,
                    point: .init(x: 2, y: 4, z: 0),
                    normal: .init(x: 6, y: 8, z: 0)
                )
            )
        )
        XCTAssertEqual(kinds, [.enter])
    }

    func testReplacingPointNormals_exit() {
        let sut = Sut.exit(.init(normalizedMagnitude: 0.0, point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        var kinds: [Sut.LineIntersectionPointNormalKind] = []
        let mapper: Transformer = { (pn, k) in
            kinds.append(k)
            return transform(.init(normalizedMagnitude: 0.0, point: pn.point * 2, normal: pn.normal * 2))
        }

        assertEqual(
            sut.replacingPointNormals(mapper),
            .exit(
                .init(
                    normalizedMagnitude: 0.0,
                    point: .init(x: 2, y: 4, z: 0),
                    normal: .init(x: 6, y: 8, z: 0)
                )
            )
        )
        XCTAssertEqual(kinds, [.exit])
    }

    func testReplacingPointNormals_enterExit() {
        let sut = Sut.enterExit(
            .init(
                normalizedMagnitude: 0.0,
                point: .init(x: 1, y: 2),
                normal: .init(x: 3, y: 4)),
            .init(
                normalizedMagnitude: 0.0,
                point: .init(x: 5, y: 6),
                normal: .init(x: 7, y: 8)
            )
        )
        var kinds: [Sut.LineIntersectionPointNormalKind] = []
        let mapper: Transformer = { (pn, k) in
            kinds.append(k)
            return transform(.init(normalizedMagnitude: 0.0, point: pn.point * 2, normal: pn.normal * 2))
        }

        assertEqual(
            sut.replacingPointNormals(mapper),
            .enterExit(
                .init(
                    normalizedMagnitude: 0.0,
                    point: .init(x: 2, y: 4, z: 0),
                    normal: .init(x: 6, y: 8, z: 0)
                ),
                .init(
                    normalizedMagnitude: 0.0,
                    point: .init(x: 10, y: 12, z: 0),
                    normal: .init(x: 14, y: 16, z: 0)
                )
            )
        )
        XCTAssertEqual(kinds, [.enter, .exit])
    }
}

private func transform(_ pn: ConvexLineIntersectionTests.PointNormal) -> ConvexLineIntersectionTests.OtherPointNormal {
    .init(
        normalizedMagnitude: pn.normalizedMagnitude,
        point: .init(pn.point),
        normal: .init(pn.normal)
    )
}
