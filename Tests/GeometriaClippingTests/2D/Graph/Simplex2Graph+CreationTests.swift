import Geometria
import TestCommons
import XCTest

@testable import GeometriaClipping

class Simplex2Graph_CreationTests: XCTestCase {
    // TODO: Fix instability of test and assertNodesUnordered
    func xtestFromParametricIntersections() {
        let lhs = LinePolygon2Parametric.makeHexagon()
        let rhs = Circle2Parametric.makeTestCircle(radius: 95.0)

        let result = Simplex2Graph.fromParametricIntersections(lhs, rhs, tolerance: 1e-14)

        result.assertNodesUnordered(accuracy: 1e-14,
            [
            ]
        )
    }
}

// MARK: - Test internals

extension Simplex2Graph {
    func assertNodesUnordered(
        accuracy: Vector.Scalar,
        _ expected: [Node],
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
        guard Simplex2Graph.Node.weakEquality(accuracy: accuracy, lhs.start, rhs.start) else {
            return false
        }
        guard Simplex2Graph.Node.weakEquality(accuracy: accuracy, lhs.end, rhs.end) else {
            return false
        }
        guard
            lhs.geometry.elementsEqual(rhs.geometry, by: { (lhs, rhs) in
                Simplex2Graph.Edge.SharedGeometryEntry.weakEquality(
                    accuracy: accuracy,
                    lhs,
                    rhs
                )
            })
        else {
            return false
        }

        switch (lhs.kind, rhs.kind) {
        case (.line, .line):
            return true

        case (.circleArc(let lhsCenter, let lhsRadius, let lhsStartAngle, let lhsSweep), .circleArc(let rhsCenter, let rhsRadius, let rhsStartAngle, let rhsSweep)):
            return areEqual(lhsCenter, rhsCenter, accuracy: accuracy)
                && areEqual(lhsRadius, rhsRadius, accuracy: accuracy)
                && areEqual(lhsStartAngle, rhsStartAngle, accuracy: accuracy)
                && areEqual(lhsSweep, rhsSweep, accuracy: accuracy)

        default:
            return false
        }
    }
}

extension Simplex2Graph.Edge.SharedGeometryEntry {
    static func weakEquality(
        accuracy: Vector.Scalar,
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        guard lhs.shapeIndex == rhs.shapeIndex else {
            return false
        }
        guard areEqual(lhs.startPeriod, rhs.startPeriod, accuracy: accuracy) else {
            return false
        }
        guard areEqual(lhs.endPeriod, rhs.endPeriod, accuracy: accuracy) else {
            return false
        }

        return true
    }
}
