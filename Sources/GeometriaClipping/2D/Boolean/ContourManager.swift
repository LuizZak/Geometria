import Geometria
import MiniDigraph

/// Manages inclusions/merging of contour objects.
class ContourManager<Vector: Vector2Real> {
    private typealias ContourContainmentGraph = CachingDirectedGraph<Int, DirectedGraph<Int>.Edge>

    typealias Contour = Parametric2Contour<Vector>
    typealias Simplex = Parametric2GeometrySimplex<Vector>
    typealias Period = Vector.Scalar

    private var inputContours: [ContourInfo]

    init() {
        inputContours = []
    }

    /// Fetches all contours from this contour manager, optionally applying winding
    /// filtering to contours in the process.
    func allContours(applyWindingFiltering: Bool) -> [Contour] {
        if applyWindingFiltering {
            return _finishContours()
        } else {
            return inputContours.filter({ !$0.isReference }).map(\.contour)
        }
    }

    func append(_ contour: Contour, isReference: Bool = false) {
        inputContours.append(
            .init(contour: contour, isReference: isReference)
        )
    }

    func beginContour() -> ContourBuilder {
        return ContourBuilder(manager: self)
    }

    /// Applies winding rules with the current reference and non-reference contours,
    /// removing hole contours, and removing all reference contours in the process.
    func coverHoles() {
        var graph = _contourGraph()
        let initialNodes = graph.nodes

        graph.pruneByWinding(
            windingNumber: windingNumber(of:),
            winding: winding(of:)
        )

        let difference = initialNodes.subtracting(graph.nodes).sorted(by: { $0 > $1 })
        for index in difference {
            inputContours.remove(at: index)
        }

        inputContours.removeAll(where: { $0.isReference })
    }

    /// Creates a graph of the containment dependencies: Contours that contain
    /// others have an edge added such that: outer -> inner
    private func _contourGraph() -> ContourContainmentGraph {
        let range = 0..<inputContours.count

        var graph = ContourContainmentGraph()
        graph.addNodes(0..<inputContours.count)

        for lhsIndex in range {
            let lhs = inputContours[lhsIndex].contour

            for rhsIndex in range.dropFirst(lhsIndex + 1) {
                let rhs = inputContours[rhsIndex].contour

                if _isContained(lhs, within: rhs) {
                    graph.addEdge(from: rhsIndex, to: lhsIndex)
                } else if _isContained(rhs, within: lhs) {
                    graph.addEdge(from: lhsIndex, to: rhsIndex)
                }
            }
        }

        return graph
    }

    private func _finishContours() -> [Contour] {
        var graph = self._contourGraph()

        func isReference(_ node: ContourContainmentGraph.Node) -> Bool {
            inputContours[node].isReference
        }

        graph.pruneByWinding(
            windingNumber: windingNumber(of:),
            winding: winding(of:)
        )

        guard let sorted = graph.topologicalSorted(breakTiesWith: { $0 < $1 }) else {
            fatalError("Found cyclic contour containment dependency?")
        }

        return sorted.filter({ !isReference($0) }).map(contourForNode)
    }

    private func contourForNode(_ node: ContourContainmentGraph.Node) -> Contour {
        inputContours[node].contour
    }

    private func windingNumber(of contour: Contour) -> Int {
        switch contour.winding {
        case .clockwise: return 1
        case .counterClockwise: return -1
        }
    }

    private func winding(of node: ContourContainmentGraph.Node) -> Contour.Winding {
        contourForNode(node).winding
    }

    private func windingNumber(of node: ContourContainmentGraph.Node) -> Int {
        windingNumber(of: contourForNode(node))
    }

    private func _isContained(_ lhs: Contour, within rhs: Contour) -> Bool {
        guard rhs.bounds.contains(lhs.bounds) else {
            return false
        }

        func probe(_ period: Contour.Period) -> Bool {
            rhs.contains(lhs.compute(at: period))
        }

        return probe(lhs.startPeriod)
            || probe((lhs.endPeriod + lhs.startPeriod) / 2)
    }

    struct ContourInfo {
        var contour: Contour
        var isReference: Bool
        var isShell: Bool { contour.winding == .clockwise }
        var isHole: Bool { contour.winding == .counterClockwise }
    }

    class ContourBuilder {
        private var hasEnded: Bool = false
        private let manager: ContourManager
        private var simplexes: [Simplex]

        init(manager: ContourManager) {
            self.manager = manager
            self.simplexes = []
        }

        func append<S: Sequence>(contentsOf simplexes: S) where S.Element == Simplex {
            assert(!hasEnded, "!hasEnded: Attempted to append simplexes to finished contour")

            for simplex in simplexes {
                append(simplex)
            }
        }

        func append(_ simplex: Simplex) {
            assert(!hasEnded, "!hasEnded: Attempted to append simplex to finished contour")

            // Attempt to join adjacent circular arcs
            switch (simplexes.last, simplex) {
            case (.circleArc2(let lhs), .circleArc2(let rhs)):
                guard lhs.center == rhs.center else {
                    break
                }
                guard lhs.radius == rhs.radius else {
                    break
                }
                guard (lhs.sweepAngle.radians >= 0) == (rhs.sweepAngle.radians >= 0) else {
                    break
                }
                guard lhs.stopAngle == rhs.startAngle else {
                    break
                }
                guard (lhs.sweepAngle + rhs.sweepAngle).radians.magnitude < .pi / 2 else {
                    break
                }

                simplexes[simplexes.count - 1] = .circleArc2(
                    .init(
                        circleArc: .init(
                            center: lhs.center,
                            radius: lhs.radius,
                            startAngle: lhs.startAngle,
                            sweepAngle: lhs.sweepAngle + rhs.sweepAngle
                        ),
                        startPeriod: lhs.startPeriod,
                        endPeriod: rhs.endPeriod
                    )
                )

                return

            default:
                break
            }

            simplexes.append(simplex)
        }

        func endContour(startPeriod: Period, endPeriod: Period) {
            assert(!hasEnded, "!hasEnded: Attempted to end already finished contour")

            hasEnded = true

            let contour = self.contour(startPeriod: startPeriod, endPeriod: endPeriod)
            manager.append(contour)
        }

        private func contour(startPeriod: Period, endPeriod: Period) -> Contour {
            Contour(
                normalizing: simplexes,
                startPeriod: startPeriod,
                endPeriod: endPeriod
            )
        }
    }
}

private extension DirectedGraphType {
    func entryNodes() -> Set<Node> {
        nodes.filter { indegree(of: $0) == 0 }
    }
}

private extension CachingDirectedGraph where Node == Int, Edge: SimpleDirectedGraphEdge {
    /// Traverses the graph, ensuring that the nested winding number of each
    /// contour matches the contour's winding.
    mutating func pruneByWinding<Vector>(
        windingNumber: (Node) -> Int,
        winding: (Node) -> Parametric2Contour<Vector>.Winding
    ) {
        func _removeNode(_ node: Node) {
            let nodesFrom = nodesConnected(from: node)
            let nodesTo = nodesConnected(towards: node)

            removeNode(node)

            for nodeFrom in nodesFrom {
                for nodeTo in nodesTo {
                    addEdge(from: nodeTo, to: nodeFrom)
                }
            }
        }

        var nodesToRemove: [Node] = []
        for node in nodes {
            let totalWinding = totalWindingNumber(
                of: node,
                windingNumber: windingNumber
            )
            let shouldRemove: Bool

            switch winding(node) {
            case .clockwise:
                // 'Shell' contours require a winding of exactly 1
                shouldRemove = totalWinding != 1

            case .counterClockwise:
                // 'Hole' contours require a winding of exactly 0
                shouldRemove = totalWinding != 0
            }

            if shouldRemove {
                nodesToRemove.append(node)
            }
        }

        for node in nodesToRemove {
            _removeNode(node)
        }
    }

    func totalWindingNumber(
        of node: Node,
        windingNumber: (Node) -> Int
    ) -> Int {
        var totalWinding = 0

        var queue = [node]
        var visited: Set<Node> = []
        while !queue.isEmpty {
            let next = queue.removeFirst()

            if visited.insert(next).inserted {
                totalWinding += windingNumber(next)
                queue.append(contentsOf: nodesConnected(towards: next))
            }
        }

        return totalWinding
    }
}
