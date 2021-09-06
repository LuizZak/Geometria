import XCTest
import Geometria

class ConvexLineIntersectionTests: XCTestCase {
    typealias Vector = Vector2D
    typealias Sut = ConvexLineIntersection<Vector>
    typealias PointNormal = Geometria.PointNormal<Vector>
    typealias Mapper = (PointNormal) -> PointNormal
    
    func testMappingPointNormals_noIntersection() {
        let sut = Sut.noIntersection
        let mapper: Mapper = { pn in pn }
        
        XCTAssertEqual(sut.mappingPointNormals(mapper), .noIntersection)
    }
    
    func testMappingPointNormals_contained() {
        let sut = Sut.contained
        let mapper: Mapper = { pn in pn }
        
        XCTAssertEqual(sut.mappingPointNormals(mapper), .contained)
    }
    
    func testMappingPointNormals_singlePoint() {
        let sut = Sut.singlePoint(.init(point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        let mapper: Mapper = { pn in
            .init(point: pn.point * 2, normal: pn.normal * 2)
        }
        
        assertEqual(
            sut.mappingPointNormals(mapper),
            .singlePoint(
                PointNormal(
                    point: .init(x: 2, y: 4),
                    normal: .init(x: 6, y: 8)
                )
            )
        )
    }
    
    func testMappingPointNormals_enter() {
        let sut = Sut.enter(.init(point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        let mapper: Mapper = { pn in
            .init(point: pn.point * 2, normal: pn.normal * 2)
        }
        
        assertEqual(
            sut.mappingPointNormals(mapper),
            .enter(
                PointNormal(
                    point: .init(x: 2, y: 4),
                    normal: .init(x: 6, y: 8)
                )
            )
        )
    }
    
    func testMappingPointNormals_exit() {
        let sut = Sut.exit(.init(point: .init(x: 1, y: 2), normal: .init(x: 3, y: 4)))
        let mapper: Mapper = { pn in
            .init(point: pn.point * 2, normal: pn.normal * 2)
        }
        
        assertEqual(
            sut.mappingPointNormals(mapper),
            .exit(
                PointNormal(
                    point: .init(x: 2, y: 4),
                    normal: .init(x: 6, y: 8)
                )
            )
        )
    }
    
    func testMappingPointNormals_enterExit() {
        let sut = Sut.enterExit(
            .init(point: .init(x: 1, y: 2),
                  normal: .init(x: 3, y: 4)),
            .init(point: .init(x: 5, y: 6),
                  normal: .init(x: 7, y: 8))
        )
        let mapper: Mapper = { pn in
            .init(point: pn.point * 2, normal: pn.normal * 2)
        }
        
        assertEqual(
            sut.mappingPointNormals(mapper),
            .enterExit(
                PointNormal(
                    point: .init(x: 2, y: 4),
                    normal: .init(x: 6, y: 8)
                ),
                PointNormal(
                    point: .init(x: 10, y: 12),
                    normal: .init(x: 14, y: 16)
                )
            )
        )
    }
}
