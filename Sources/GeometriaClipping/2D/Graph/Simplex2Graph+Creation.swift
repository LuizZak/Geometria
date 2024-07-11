import Geometria

extension Simplex2Graph {
    static func fromParametricIntersections<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>(
        _ lhs: T1,
        _ rhs: T2,
        intersections: [(`self`: T1.Period, other: T2.Period)]
    ) -> Self where T1.Vector == Vector, T2.Vector == Vector {
        typealias Period = T1.Period

        var result = Self()

        var lhsNodeLookup: [Vector: Node] = [:]
        var rhsNodeLookup: [Vector: Node] = [:]

        var lhsSimplexLookup: [Node.ID] = []
        var rhsSimplexLookup: [Node.ID] = []

        var _nodeId = 0
        func nextNodeId() -> Int {
            defer { _nodeId += 1 }
            return _nodeId
        }
        func makeGeometryNode(_ location: Vector, onLhs: Bool) -> Node {
            return Node(
                id: nextNodeId(),
                kind: .geometry(location, onLhs: onLhs)
            )
        }
        func createGeometry(_ location: Vector, onLhs: Bool) -> Node {
            let node = makeGeometryNode(location, onLhs: onLhs)

            if onLhs {
                lhsNodeLookup[location] = node
            } else {
                rhsNodeLookup[location] = node
            }

            result.addNode(node)
            return node
        }
        func getGeometry(_ index: Int, onLhs: Bool) -> Node.ID {
            if onLhs {
                return lhsSimplexLookup[index]
            } else {
                return rhsSimplexLookup[index]
            }
        }
        func addSimplexEdge(
            _ simplex: Parametric2GeometrySimplex<Vector>,
            from start: Node.ID,
            to end: Node.ID
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
        func register(_ simplexes: [Parametric2GeometrySimplex<Vector>], onLhs: Bool) {
            var simplexNodes: [Node.ID] = []

            for simplex in simplexes {
                let start = createGeometry(simplex.start, onLhs: onLhs)

                if onLhs {
                    lhsSimplexLookup.append(start.id)
                } else {
                    rhsSimplexLookup.append(start.id)
                }

                simplexNodes.append(start.id)
            }

            for index in 0..<simplexes.count {
                let simplex = simplexes[index]
                let prev = simplexNodes[index]
                let next = simplexNodes[(index + 1) % simplexNodes.count]

                addSimplexEdge(simplex, from: prev, to: next)
            }
        }
        func register<T: ParametricClip2Geometry>(
            _ intersection: T.Period,
            _ simplexes: [T.Simplex],
            _ node: Node,
            _ shape: T,
            onLhs: Bool
        ) where T.Vector == T1.Vector {
            let intersection = shape.normalizedPeriod(intersection)

            guard let simplexIndex = simplexes.simplexIndex(containingPeriod: intersection) else {
                return
            }

            let simplex = simplexes[simplexIndex]

            guard let clampedLow = simplex.clamped(in: simplex.startPeriod..<intersection) else {
                return
            }
            guard let clampedHigh = simplex.clamped(in: intersection..<simplex.endPeriod) else {
                return
            }
            let start = getGeometry(simplexIndex, onLhs: onLhs)
            let end = getGeometry((simplexIndex + 1) % simplexes.count, onLhs: onLhs)

            // Remove existing edge
            if let edge = result.edge(from: start, to: end) {
                result.removeEdge(edge)
            }

            addSimplexEdge(clampedLow, from: start, to: node.id)
            addSimplexEdge(clampedHigh, from: node.id, to: end)
        }
        func register(
            _ lhsSimplexes: [T1.Simplex],
            _ rhsSimplexes: [T2.Simplex],
            _ intersection: (`self`: T1.Period, other: T2.Period)
        ) {
            let point = lhs.compute(at: intersection.`self`)
            let node = Node(
                id: nextNodeId(),
                kind: .intersection(point)
            )

            result.addNode(node)

            register(intersection.`self`, lhsSimplexes, node, lhs, onLhs: true)
            register(intersection.other, rhsSimplexes, node, rhs, onLhs: false)
        }

        // Add simplexes
        let lhsSimplexes = lhs.allSimplexes()
        let rhsSimplexes = rhs.allSimplexes()

        register(lhsSimplexes, onLhs: true)
        register(rhsSimplexes, onLhs: false)

        result.assertIsValid()

        // Add intersections
        for intersection in intersections {
            register(lhsSimplexes, rhsSimplexes, intersection)
        }

        result.assertIsValid()

        return result
    }

    fileprivate func edge(from start: Node.ID, to end: Node.ID) -> Edge? {
        edges.first(where: { $0.start == start && $0.end == end })
    }

    @discardableResult
    fileprivate mutating func addEdge(
        from start: Node,
        to end: Node,
        lengthSquared: Scalar,
        kind: Edge.Kind
    ) -> Edge {

        return addEdge(
            from: start.id,
            to: end.id,
            lengthSquared: lengthSquared,
            kind: kind
        )
    }

    @discardableResult
    fileprivate mutating func addEdge(
        from start: Node.ID,
        to end: Node.ID,
        lengthSquared: Scalar,
        kind: Edge.Kind
    ) -> Edge {

        let edge = Edge(
            start: start,
            end: end,
            lengthSquared: lengthSquared,
            kind: kind
        )
        return addEdge(edge)
    }

    @inlinable
    internal func assertIsValid(file: StaticString = #file, line: UInt = #line) {
        #if DEBUG

        for node in self.nodes {
            if node.isIntersection {
                let indegree = self.indegree(of: node)
                let outdegree = self.outdegree(of: node)

                assert(indegree == 2, "intersection.indegree == 2", file: file, line: line)
                assert(outdegree == 2, "intersection.outdegree == 2", file: file, line: line)
            } else {
                let indegree = self.indegree(of: node)
                let outdegree = self.outdegree(of: node)

                assert(indegree > 0, "geometry.indegree > 0", file: file, line: line)
                assert(outdegree > 0, "geometry.outdegree > 0", file: file, line: line)
            }
        }

        #endif
    }
}

fileprivate extension Collection {
    func simplexIndex<V: VectorType>(
        containingPeriod period: V.Scalar
    ) -> Index? where Element == Parametric2GeometrySimplex<V> {
        for index in indices {
            let element = self[index]

            if element.periodRange.contains(period) {
                return index
            }
        }

        return nil
    }
}
