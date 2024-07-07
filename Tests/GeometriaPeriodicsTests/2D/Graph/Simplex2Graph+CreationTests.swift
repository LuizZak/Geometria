import Geometria
import TestCommons
import XCTest

@testable import GeometriaPeriodics

class Simplex2Graph_CreationTests: XCTestCase {
    func testCreateFromIntersections() {
        let lhs = LinePolygon2Periodic.makeHexagon()
        let rhs = Circle2Periodic.makeTestCircle(radius: 95.0)
        let intersections = lhs.allIntersectionPeriods(rhs)

        let sut = Simplex2Graph.fromPeriodicIntersections(lhs, rhs, intersections: intersections)

        XCTAssertEqual(
            sut.nodes,
            [
                .init(
                    id: 3,
                    kind: .geometry(.init(x: -100.0, y: 1.2246467991473532e-14), onLhs: true)
                ),
                .init(
                    id: 5,
                    kind: .geometry(
                        .init(x: 50.000000000000014, y: -86.60254037844386),
                        onLhs: true
                    )
                ),
                .init(
                    id: 9,
                    kind: .intersection(.init(x: 94.52562418976665, y: 9.481897043050221))
                ),
                .init(
                    id: 12,
                    kind: .intersection(.init(x: -39.05124837953324, y: 86.60254037844388))
                ),
                .init(
                    id: 13,
                    kind: .intersection(.init(x: -55.47437581023333, y: 77.12064333539367))
                ),
                .init(
                    id: 19,
                    kind: .intersection(.init(x: 55.47437581023337, y: -77.12064333539365))
                ),
                .init(
                    id: 7,
                    kind: .geometry(.init(x: -95.0, y: 1.1634144591899855e-14), onLhs: false)
                ), .init(id: 0, kind: .geometry(.init(x: 100.0, y: 0.0), onLhs: true)),
                .init(
                    id: 11,
                    kind: .intersection(.init(x: 39.051248379533256, y: 86.60254037844386))
                ),
                .init(
                    id: 20,
                    kind: .intersection(.init(x: 94.52562418976665, y: -9.48189704305021))
                ),
                .init(
                    id: 18,
                    kind: .intersection(.init(x: 39.051248379533305, y: -86.60254037844386))
                ),
                .init(
                    id: 15,
                    kind: .intersection(.init(x: -94.52562418976665, y: -9.481897043050205))
                ),
                .init(
                    id: 17,
                    kind: .intersection(.init(x: -39.051248379533334, y: -86.60254037844383))
                ),
                .init(
                    id: 4,
                    kind: .geometry(
                        .init(x: -50.00000000000004, y: -86.60254037844383),
                        onLhs: true
                    )
                ),
                .init(
                    id: 2,
                    kind: .geometry(.init(x: -49.99999999999998, y: 86.60254037844388), onLhs: true)
                ), .init(id: 6, kind: .geometry(.init(x: 95.0, y: 0.0), onLhs: false)),
                .init(
                    id: 10,
                    kind: .intersection(.init(x: 55.47437581023338, y: 77.12064333539362))
                ),
                .init(
                    id: 16,
                    kind: .intersection(.init(x: -55.4743758102334, y: -77.12064333539362))
                ),
                .init(
                    id: 8,
                    kind: .geometry(.init(x: 95.0, y: -2.326828918379971e-14), onLhs: false)
                ),
                .init(
                    id: 1,
                    kind: .geometry(.init(x: 50.000000000000014, y: 86.60254037844386), onLhs: true)
                ),
                .init(
                    id: 14,
                    kind: .intersection(.init(x: -94.52562418976665, y: 9.481897043050225))
                ),
            ]
        )
        XCTAssertEqual(
            sut.edges,
            [
                .init(
                    start: 20,
                    end: 8,
                    lengthSquared: 90.20651479102702,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 0.09997590556877503)
                    )
                ),
                .init(
                    start: 7,
                    end: 19,
                    lengthSquared: 43457.758688270944,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 2.1943710079619714)
                    )
                ),
                .init(
                    start: 6,
                    end: 7,
                    lengthSquared: 89073.17971983146,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 3.141592653589793)
                    )
                ),
                .init(
                    start: 18,
                    end: 8,
                    lengthSquared: 11876.962632660801,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 1.1471734567653724)
                    )
                ),
                .init(start: 13, end: 3, lengthSquared: 7930.124837953332, kind: .line),
                .init(
                    start: 6,
                    end: 9,
                    lengthSquared: 90.20651479102789,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 0.09997590556877552)
                    )
                ),
                .init(start: 12, end: 2, lengthSquared: 119.87516204667315, kind: .line),
                .init(
                    start: 6,
                    end: 11,
                    lengthSquared: 11876.962632660823,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 1.1471734567653735)
                    )
                ),
                .init(start: 1, end: 11, lengthSquared: 119.87516204667347, kind: .line),
                .init(
                    start: 7,
                    end: 8,
                    lengthSquared: 89073.17971983146,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 3.141592653589793)
                    )
                ),
                .init(start: 18, end: 5, lengthSquared: 119.87516204667239, kind: .line),
                .init(start: 0, end: 9, lengthSquared: 119.87516204667261, kind: .line),
                .init(start: 3, end: 15, lengthSquared: 119.87516204667256, kind: .line),
                .init(start: 4, end: 17, lengthSquared: 119.87516204667239, kind: .line),
                .init(start: 1, end: 12, lengthSquared: 7930.124837953325, kind: .line),
                .init(start: 0, end: 10, lengthSquared: 7930.124837953324, kind: .line),
                .init(
                    start: 13,
                    end: 7,
                    lengthSquared: 8097.490334661561,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 0.9472216456278221)
                    )
                ),
                .init(start: 16, end: 4, lengthSquared: 119.87516204667241, kind: .line),
                .init(start: 17, end: 5, lengthSquared: 7930.124837953341, kind: .line),
                .init(
                    start: 7,
                    end: 20,
                    lengthSquared: 83494.17778762362,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 3.041616748021018)
                    )
                ),
                .init(
                    start: 11,
                    end: 7,
                    lengthSquared: 35898.81409227241,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 1.9944191968244196)
                    )
                ),
                .init(start: 3, end: 4, lengthSquared: 9999.999999999993, kind: .line),
                .init(
                    start: 6,
                    end: 13,
                    lengthSquared: 43457.75868827093,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 2.194371007961971)
                    )
                ),
                .init(start: 2, end: 13, lengthSquared: 119.87516204667241, kind: .line),
                .init(start: 14, end: 3, lengthSquared: 119.87516204667241, kind: .line),
                .init(
                    start: 7,
                    end: 15,
                    lengthSquared: 90.20651479102825,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 0.09997590556877572)
                    )
                ),
                .init(start: 15, end: 4, lengthSquared: 7930.124837953323, kind: .line),
                .init(start: 4, end: 18, lengthSquared: 7930.124837953341, kind: .line),
                .init(
                    start: 6,
                    end: 12,
                    lengthSquared: 35898.81409227241,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 1.9944191968244196)
                    )
                ),
                .init(start: 19, end: 0, lengthSquared: 7930.124837953328, kind: .line),
                .init(
                    start: 7,
                    end: 18,
                    lengthSquared: 35898.81409227245,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 1.9944191968244207)
                    )
                ),
                .init(
                    start: 19,
                    end: 8,
                    lengthSquared: 8097.490334661556,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 0.9472216456278217)
                    )
                ),
                .init(start: 20, end: 0, lengthSquared: 119.87516204667241, kind: .line),
                .init(
                    start: 6,
                    end: 14,
                    lengthSquared: 83494.17778762359,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 3.0416167480210174)
                    )
                ),
                .init(
                    start: 7,
                    end: 17,
                    lengthSquared: 11876.962632660801,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 1.1471734567653724)
                    )
                ),
                .init(
                    start: 17,
                    end: 8,
                    lengthSquared: 35898.81409227245,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 1.9944191968244207)
                    )
                ),
                .init(start: 3, end: 16, lengthSquared: 7930.1248379533245, kind: .line),
                .init(start: 2, end: 3, lengthSquared: 10000.000000000002, kind: .line),
                .init(start: 0, end: 1, lengthSquared: 9999.999999999998, kind: .line),
                .init(
                    start: 10,
                    end: 7,
                    lengthSquared: 43457.758688270944,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 2.1943710079619714)
                    )
                ),
                .init(start: 5, end: 0, lengthSquared: 9999.999999999998, kind: .line),
                .init(start: 11, end: 2, lengthSquared: 7930.124837953321, kind: .line),
                .init(start: 5, end: 20, lengthSquared: 7930.124837953328, kind: .line),
                .init(start: 9, end: 1, lengthSquared: 7930.124837953326, kind: .line),
                .init(start: 10, end: 1, lengthSquared: 119.87516204667311, kind: .line),
                .init(
                    start: 9,
                    end: 7,
                    lengthSquared: 83494.17778762362,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 3.041616748021018)
                    )
                ),
                .init(start: 4, end: 5, lengthSquared: 10000.000000000011, kind: .line),
                .init(
                    start: 16,
                    end: 8,
                    lengthSquared: 43457.75868827098,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 2.1943710079619723)
                    )
                ),
                .init(
                    start: 15,
                    end: 8,
                    lengthSquared: 83494.17778762359,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 3.0416167480210174)
                    )
                ),
                .init(
                    start: 6,
                    end: 10,
                    lengthSquared: 8097.490334661558,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 0.947221645627822)
                    )
                ),
                .init(start: 1, end: 2, lengthSquared: 10000.0, kind: .line),
                .init(start: 2, end: 14, lengthSquared: 7930.124837953332, kind: .line),
                .init(
                    start: 7,
                    end: 16,
                    lengthSquared: 8097.490334661543,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 0.9472216456278211)
                    )
                ),
                .init(
                    start: 12,
                    end: 7,
                    lengthSquared: 11876.962632660823,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 1.1471734567653735)
                    )
                ),
                .init(
                    start: 14,
                    end: 7,
                    lengthSquared: 90.20651479102825,
                    kind: .circleArc(
                        center: .init(x: 0.0, y: 0.0),
                        sweep: Angle(radians: 0.09997590556877572)
                    )
                ),
                .init(start: 5, end: 19, lengthSquared: 119.87516204667241, kind: .line),
            ]
        )
    }
}
