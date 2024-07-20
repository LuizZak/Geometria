import Geometria
import TestCommons
import XCTest

@testable import GeometriaClipping

class Simplex2Graph_CreationTests: XCTestCase {
    func testFromParametricIntersections() {
        let lhs = LinePolygon2Parametric.makeHexagon()
        let rhs = Circle2Parametric.makeTestCircle(radius: 95.0)

        let result = Simplex2Graph.fromParametricIntersections(lhs, rhs, tolerance: 1e-14)

        result.assertNodesUnordered(
            [
                .init(
                    location: Vector2<Double>(x: -39.05124837953324, y: 86.60254037844388),
                    kind: .intersection(
                        lhs: 0,
                        lhsPeriod: 0.31508541396588874,
                        rhs: 1,
                        rhsPeriod: 0.3174216737719741
                    )
                ),
                .init(
                    location: Vector2<Double>(x: 50.000000000000014, y: -86.60254037844386),
                    kind: .geometry(shapeIndex: 0, period: 0.8333333333333334)
                ),
                .init(
                    location: Vector2<Double>(x: -94.52562418976665, y: 9.481897043050225),
                    kind: .intersection(
                        lhs: 0,
                        lhsPeriod: 0.4817520806325555,
                        rhs: 1,
                        rhsPeriod: 0.4840883404386408
                    )
                ),
                .init(
                    location: Vector2<Double>(x: 95.0, y: 0.0),
                    kind: .geometry(shapeIndex: 1, period: 0.0)
                ),
                .init(
                    location: Vector2<Double>(x: -55.4743758102334, y: -77.12064333539362),
                    kind: .intersection(
                        lhs: 0,
                        lhsPeriod: 0.648418747299222,
                        rhs: 1,
                        rhsPeriod: 0.6507550071053073
                    )
                ),
                .init(
                    location: Vector2<Double>(x: 100.0, y: 0.0),
                    kind: .geometry(shapeIndex: 0, period: 0.0)
                ),
                .init(
                    location: Vector2<Double>(x: -95.0, y: 1.1634144591899855e-14),
                    kind: .geometry(shapeIndex: 1, period: 0.5)
                ),
                .init(
                    location: Vector2<Double>(x: -100.0, y: 1.2246467991473532e-14),
                    kind: .geometry(shapeIndex: 0, period: 0.5)
                ),
                .init(
                    location: Vector2<Double>(x: -39.051248379533334, y: -86.60254037844383),
                    kind: .intersection(
                        lhs: 0,
                        lhsPeriod: 0.684914586034111,
                        rhs: 1,
                        rhsPeriod: 0.6825783262280257
                    )
                ),
                .init(
                    location: Vector2<Double>(x: 39.051248379533305, y: -86.60254037844386),
                    kind: .intersection(
                        lhs: 0,
                        lhsPeriod: 0.8150854139658888,
                        rhs: 1,
                        rhsPeriod: 0.8174216737719743
                    )
                ),
                .init(
                    location: Vector2<Double>(x: -50.00000000000004, y: -86.60254037844383),
                    kind: .geometry(shapeIndex: 0, period: 0.6666666666666665)
                ),
                .init(
                    location: Vector2<Double>(x: 94.52562418976665, y: 9.481897043050221),
                    kind: .intersection(
                        lhs: 0,
                        lhsPeriod: 0.018247919367444534,
                        rhs: 1,
                        rhsPeriod: 0.01591165956135917
                    )
                ),
                .init(
                    location: Vector2<Double>(x: 50.000000000000014, y: 86.60254037844386),
                    kind: .geometry(shapeIndex: 0, period: 0.16666666666666663)
                ),
                .init(
                    location: Vector2<Double>(x: 39.051248379533256, y: 86.60254037844386),
                    kind: .intersection(
                        lhs: 0,
                        lhsPeriod: 0.18491458603411123,
                        rhs: 1,
                        rhsPeriod: 0.1825783262280259
                    )
                ),
                .init(
                    location: Vector2<Double>(x: 55.47437581023338, y: 77.12064333539362),
                    kind: .intersection(
                        lhs: 0,
                        lhsPeriod: 0.14841874729922205,
                        rhs: 1,
                        rhsPeriod: 0.15075500710530745
                    )
                ),
                .init(
                    location: Vector2<Double>(x: -55.47437581023333, y: 77.12064333539367),
                    kind: .intersection(
                        lhs: 0,
                        lhsPeriod: 0.35158125270077784,
                        rhs: 1,
                        rhsPeriod: 0.3492449928946925
                    )
                ),
                .init(
                    location: Vector2<Double>(x: 94.52562418976665, y: -9.48189704305021),
                    kind: .intersection(
                        lhs: 0,
                        lhsPeriod: 0.9817520806325555,
                        rhs: 1,
                        rhsPeriod: 0.9840883404386409
                    )
                ),
                .init(
                    location: Vector2<Double>(x: -49.99999999999998, y: 86.60254037844388),
                    kind: .geometry(shapeIndex: 0, period: 0.3333333333333333)
                ),
                .init(
                    location: Vector2<Double>(x: -94.52562418976665, y: -9.481897043050205),
                    kind: .intersection(
                        lhs: 0,
                        lhsPeriod: 0.5182479193674445,
                        rhs: 1,
                        rhsPeriod: 0.5159116595613592
                    )
                ),
                .init(
                    location: Vector2<Double>(x: 55.47437581023337, y: -77.12064333539365),
                    kind: .intersection(
                        lhs: 0,
                        lhsPeriod: 0.8515812527007779,
                        rhs: 1,
                        rhsPeriod: 0.8492449928946926
                    )
                ),
            ],
            accuracy: 1e-14
        )
    }
}

// MARK: - Test internals

extension Simplex2Graph {
    func assertNodesUnordered(
        _ expected: [Node],
        accuracy: Vector.Scalar,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assertEqualUnordered(
            nodes,
            expected,
            compare: {
                Node.weakEquality(accuracy: accuracy, $0, $1)
            },
            file: file,
            line: line
        )
    }
}

extension Simplex2Graph.Node {
    static func weakEquality(
        accuracy: Vector.Scalar,
        _ lhs: Simplex2Graph.Node,
        _ rhs: Simplex2Graph.Node
    ) -> Bool {
        if lhs === rhs { return true }

        return areEqual(lhs.location, rhs.location, accuracy: accuracy)
            && lhs.kind == rhs.kind
    }
}

extension Simplex2Graph.Edge {
    static func weakEquality(
        accuracy: Vector.Scalar,
        _ lhs: Simplex2Graph.Edge,
        _ rhs: Simplex2Graph.Edge
    ) -> Bool {
        guard lhs.shapeIndex == rhs.shapeIndex else {
            return false
        }
        guard Simplex2Graph.Node.weakEquality(accuracy: accuracy, lhs.start, rhs.start) else {
            return false
        }
        guard Simplex2Graph.Node.weakEquality(accuracy: accuracy, lhs.end, rhs.end) else {
            return false
        }
        guard areEqual(lhs.startPeriod, rhs.startPeriod, accuracy: accuracy) else {
            return false
        }
        guard areEqual(lhs.endPeriod, rhs.endPeriod, accuracy: accuracy) else {
            return false
        }

        switch (lhs.kind, rhs.kind) {
        case (.line, .line):
            return true

        case (.circleArc(let lhsCenter, let lhsSweep), .circleArc(let rhsCenter, let rhsSweep)):
            return areEqual(lhsCenter, rhsCenter, accuracy: accuracy)
                && areEqual(lhsSweep, rhsSweep, accuracy: accuracy)

        default:
            return false
        }
    }
}
