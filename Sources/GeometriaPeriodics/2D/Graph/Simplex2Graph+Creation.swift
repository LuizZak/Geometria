import Geometria

extension Simplex2Graph {
    static func fromPeriodicIntersections<T1: Periodic2Geometry, T2: Periodic2Geometry>(
        _ lhs: T1,
        _ rhs: T2,
        intersections: [(`self`: T1.Period, other: T2.Period)]
    ) -> Self where T1.Vector == Vector, T2.Vector == Vector {
        typealias Period = T1.Period

        var result = Self()

        var nodeLocationLookup: [Vector: Node] = [:]

        var _nodeId = 0
        func nextNodeId() -> Int {
            defer { _nodeId += 1 }
            return _nodeId
        }
        func getOrCreateGeometry(_ location: Vector, onLhs: Bool) -> Node {
            if let existing = nodeLocationLookup[location] {
                return existing
            }

            let node = Node(
                id: nextNodeId(),
                kind: .geometry(location, onLhs: onLhs)
            )
            nodeLocationLookup[location] = node
            result.addNode(node)
            return node
        }
        func addSimplexEdge(
            _ simplex: Periodic2GeometrySimplex<Vector>,
            from start: Simplex2Graph<Vector>.Node,
            to end: Simplex2Graph<Vector>.Node
        ) {
            switch simplex {
            case .lineSegment2(let line):
                result.addEdge(
                    from: start,
                    to: end,
                    lengthSquared: line.lengthSquared,
                    kind: .line
                )

            case .circleArc2(let arc):
                result.addEdge(
                    from: start,
                    to: end,
                    lengthSquared: arc.lengthSquared,
                    kind: .circleArc(
                        center: arc.circleArc.center,
                        sweep: arc.circleArc.sweepAngle
                    )
                )
            }
        }
        func register(_ simplex: Periodic2GeometrySimplex<Vector>, onLhs: Bool) {
            let start = getOrCreateGeometry(simplex.start, onLhs: onLhs)
            let end = getOrCreateGeometry(simplex.end, onLhs: onLhs)

            addSimplexEdge(simplex, from: start, to: end)
        }
        func register<T: Periodic2Geometry>(
            _ intersection: T.Period,
            _ node: Node,
            _ shape: T,
            onLhs: Bool
        ) where T.Vector == T1.Vector {
            let simplex = shape.simplex(on: intersection)
            guard let clampedLow = simplex.clamped(in: simplex.startPeriod..<intersection) else {
                return
            }
            guard let clampedHigh = simplex.clamped(in: intersection..<simplex.endPeriod) else {
                return
            }
            let start = getOrCreateGeometry(simplex.start, onLhs: onLhs)
            let end = getOrCreateGeometry(simplex.end, onLhs: onLhs)

            addSimplexEdge(clampedLow, from: start, to: node)
            addSimplexEdge(clampedHigh, from: node, to: end)
        }
        func register(_ intersection: (`self`: T1.Period, other: T2.Period)) {
            let point = lhs.compute(at: intersection.`self`)
            let node = Node(
                id: nextNodeId(),
                kind: .intersection(point)
            )

            register(intersection.`self`, node, lhs, onLhs: true)
            register(intersection.other, node, rhs, onLhs: false)

            result.addNode(node)
        }

        // Add simplexes
        for simplex in lhs.allSimplexes() {
            register(simplex, onLhs: true)
        }
        for simplex in rhs.allSimplexes() {
            register(simplex, onLhs: false)
        }

        // Add intersections
        for intersection in intersections {
            register(intersection)
        }

        return result
    }

    @discardableResult
    fileprivate mutating func addEdge(
        from start: Node,
        to end: Node,
        lengthSquared: Scalar,
        kind: Edge.Kind
    ) -> Edge {

        let edge = Edge(
            start: start.id,
            end: end.id,
            lengthSquared: lengthSquared,
            kind: kind
        )
        return addEdge(edge)
    }
}
