import XCTest
import Geometria

class ConvexLineIntersectionTests: XCTestCase {
    typealias Vector = Vector2D
    typealias Sut = ConvexLineIntersection<Vector>
    typealias PointNormal = Geometria.PointNormal<Vector>
    typealias Mapper = (PointNormal, Sut.PointNormalKind) -> PointNormal
    //
    typealias Vector3 = Vector3D
    typealias OtherPointNormal = Geometria.PointNormal<Vector3>
    typealias Transformer = (PointNormal, Sut.PointNormalKind) -> OtherPointNormal
    
    // MARK: mappingPointNormals
    
    func testMappingPointNormals_noIntersection() {
        let sut = Sut.noIntersection
        var kinds: [Sut.PointNormalKind] = []
        let mapper: Mapper = { (pn, k) in kinds.append(k); return pn }
        
        XCTAssertEqual(sut.mappingPointNormals(mapper), .noIntersection)
        XCTAssertEqual(kinds, [])
    }
    
    func testMappingPointNormals_contained() {
        let sut = Sut.contained
        var kinds: [Sut.PointNormalKind] = []
        let mapper: Mapper = { (pn, k) in kinds.append(k); return pn }
        
        XCTAssertEqual(sut.mappingPointNormals(mapper), .contained)
        XCTAssertEqual(kinds, [])
    }
    
    func testMappingPointNormals_singlePoint() {
        let sut = Sut.singlePoint(.init(point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        var kinds: [Sut.PointNormalKind] = []
        let mapper: Mapper = { (pn, k) in
            kinds.append(k)
            return .init(point: pn.point * 2, normal: pn.normal * 2)
        }
        
        assertEqual(
            sut.mappingPointNormals(mapper),
            .singlePoint(
                .init(
                    point: .init(x: 2, y: 4),
                    normal: .init(x: 6, y: 8)
                )
            )
        )
        XCTAssertEqual(kinds, [.singlePoint])
    }
    
    func testMappingPointNormals_enter() {
        let sut = Sut.enter(.init(point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        var kinds: [Sut.PointNormalKind] = []
        let mapper: Mapper = { (pn, k) in
            kinds.append(k)
            return .init(point: pn.point * 2, normal: pn.normal * 2)
        }
        
        assertEqual(
            sut.mappingPointNormals(mapper),
            .enter(
                .init(
                    point: .init(x: 2, y: 4),
                    normal: .init(x: 6, y: 8)
                )
            )
        )
        XCTAssertEqual(kinds, [.enter])
    }
    
    func testMappingPointNormals_exit() {
        let sut = Sut.exit(.init(point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        var kinds: [Sut.PointNormalKind] = []
        let mapper: Mapper = { (pn, k) in
            kinds.append(k)
            return .init(point: pn.point * 2, normal: pn.normal * 2)
        }
        
        assertEqual(
            sut.mappingPointNormals(mapper),
            .exit(
                .init(
                    point: .init(x: 2, y: 4),
                    normal: .init(x: 6, y: 8)
                )
            )
        )
        XCTAssertEqual(kinds, [.exit])
    }
    
    func testMappingPointNormals_enterExit() {
        let sut = Sut.enterExit(
            .init(point: .init(x: 1, y: 2),
                  normal: .init(x: 3, y: 4)),
            .init(point: .init(x: 5, y: 6),
                  normal: .init(x: 7, y: 8))
        )
        var kinds: [Sut.PointNormalKind] = []
        let mapper: Mapper = { (pn, k) in
            kinds.append(k)
            return .init(point: pn.point * 2, normal: pn.normal * 2)
        }
        
        assertEqual(
            sut.mappingPointNormals(mapper),
            .enterExit(
                .init(
                    point: .init(x: 2, y: 4),
                    normal: .init(x: 6, y: 8)
                ),
                .init(
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
        var kinds: [Sut.PointNormalKind] = []
        let mapper: Transformer = { (pn, k) in kinds.append(k); return transform(pn) }
        
        XCTAssertEqual(sut.replacingPointNormals(mapper), .noIntersection)
        XCTAssertEqual(kinds, [])
    }
    
    func testReplacingPointNormals_contained() {
        let sut = Sut.contained
        var kinds: [Sut.PointNormalKind] = []
        let mapper: Transformer = { (pn, k) in kinds.append(k); return transform(pn) }
        
        XCTAssertEqual(sut.replacingPointNormals(mapper), .contained)
        XCTAssertEqual(kinds, [])
    }
    
    func testReplacingPointNormals_singlePoint() {
        let sut = Sut.singlePoint(.init(point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        var kinds: [Sut.PointNormalKind] = []
        let mapper: Transformer = { (pn, k) in
            kinds.append(k)
            return transform(.init(point: pn.point * 2, normal: pn.normal * 2))
        }
        
        assertEqual(
            sut.replacingPointNormals(mapper),
            .singlePoint(
                .init(
                    point: .init(x: 2, y: 4, z: 0),
                    normal: .init(x: 6, y: 8, z: 0)
                )
            )
        )
        XCTAssertEqual(kinds, [.singlePoint])
    }
    
    func testReplacingPointNormals_enter() {
        let sut = Sut.enter(.init(point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        var kinds: [Sut.PointNormalKind] = []
        let mapper: Transformer = { (pn, k) in
            kinds.append(k)
            return transform(.init(point: pn.point * 2, normal: pn.normal * 2))
        }
        
        assertEqual(
            sut.replacingPointNormals(mapper),
            .enter(
                .init(
                    point: .init(x: 2, y: 4, z: 0),
                    normal: .init(x: 6, y: 8, z: 0)
                )
            )
        )
        XCTAssertEqual(kinds, [.enter])
    }
    
    func testReplacingPointNormals_exit() {
        let sut = Sut.exit(.init(point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        var kinds: [Sut.PointNormalKind] = []
        let mapper: Transformer = { (pn, k) in
            kinds.append(k)
            return transform(.init(point: pn.point * 2, normal: pn.normal * 2))
        }
        
        assertEqual(
            sut.replacingPointNormals(mapper),
            .exit(
                .init(
                    point: .init(x: 2, y: 4, z: 0),
                    normal: .init(x: 6, y: 8, z: 0)
                )
            )
        )
        XCTAssertEqual(kinds, [.exit])
    }
    
    func testReplacingPointNormals_enterExit() {
        let sut = Sut.enterExit(
            .init(point: .init(x: 1, y: 2),
                  normal: .init(x: 3, y: 4)),
            .init(point: .init(x: 5, y: 6),
                  normal: .init(x: 7, y: 8))
        )
        var kinds: [Sut.PointNormalKind] = []
        let mapper: Transformer = { (pn, k) in
            kinds.append(k)
            return transform(.init(point: pn.point * 2, normal: pn.normal * 2))
        }
        
        assertEqual(
            sut.replacingPointNormals(mapper),
            .enterExit(
                .init(
                    point: .init(x: 2, y: 4, z: 0),
                    normal: .init(x: 6, y: 8, z: 0)
                ),
                .init(
                    point: .init(x: 10, y: 12, z: 0),
                    normal: .init(x: 14, y: 16, z: 0)
                )
            )
        )
        XCTAssertEqual(kinds, [.enter, .exit])
    }
}

private func transform(_ pn: ConvexLineIntersectionTests.PointNormal) -> ConvexLineIntersectionTests.OtherPointNormal {
    .init(point: .init(pn.point),
          normal: .init(pn.normal))
}
