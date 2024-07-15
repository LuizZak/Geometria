import Geometria
import MiniDigraph

/// Manages inclusions/merging of contour objects.
class ContourManager<Vector: Vector2Real> {
    private typealias ContourContainmentGraph = CachingDirectedGraph<Int, DirectedGraph<Int>.Edge>

    typealias Contour = Parametric2Contour<Vector>
    typealias Simplex = Parametric2GeometrySimplex<Vector>
    typealias Period = Vector.Scalar

    private var contours: [Contour]

    init() {
        contours = []
    }

    func allContours() -> [Contour] {
        _finishContours()

        return contours
    }

    func append(_ contour: Contour) {
        contours.append(contour)
    }

    func beginContour() -> ContourBuilder {
        return ContourBuilder(manager: self)
    }

    /// Creates a graph of the containment dependencies: Contours that contain
    /// others have an edge added such that: outer -> inner
    private func _contourGraph() -> ContourContainmentGraph {
        let range = 0..<contours.count

        var graph = ContourContainmentGraph()
        graph.addNodes(0..<contours.count)

        for lhsIndex in range {
            let lhs = contours[lhsIndex]

            for rhsIndex in range.dropFirst(lhsIndex + 1) {
                let rhs = contours[rhsIndex]

                if _isContained(lhs, within: rhs) {
                    graph.addEdge(from: rhsIndex, to: lhsIndex)
                } else if _isContained(rhs, within: lhs) {
                    graph.addEdge(from: lhsIndex, to: rhsIndex)
                }
            }
        }

        return graph
    }

    private func _finishContours() {
        var graph = self._contourGraph()

        func contourForNode(_ node: ContourContainmentGraph.Node) -> Contour {
            contours[node]
        }
        func windingNumber(of contour: Contour) -> Int {
            switch contour.winding {
            case .clockwise: return 1
            case .counterClockwise: return -1
            }
        }
        func windingNumber(of node: ContourContainmentGraph.Node) -> Int {
            windingNumber(of: contourForNode(node))
        }
        func totalWindingNumber(of node: ContourContainmentGraph.Node) -> Int {
            var totalWinding = 0

            var queue = [node]
            while !queue.isEmpty {
                let next = queue.removeFirst()
                totalWinding += windingNumber(of: next)

                queue.append(contentsOf: graph.nodesConnected(towards: next))
            }

            return totalWinding
        }
        func removeNode(_ node: ContourContainmentGraph.Node) {
            let nodesFrom = graph.nodesConnected(from: node)
            let nodesTo = graph.nodesConnected(towards: node)

            graph.removeNode(node)

            for nodeFrom in nodesFrom {
                for nodeTo in nodesTo {
                    graph.addEdge(from: nodeTo, to: nodeFrom)
                }
            }
        }

        // If the outermost contour is a counter-clockwise contour, it is actually
        // removing all inner contours of depth 1
        var nodesToRemove: [ContourContainmentGraph.Node] = []
        for node in graph.nodes {
            let contour = contourForNode(node)
            let totalWinding = totalWindingNumber(of: node)
            let shouldRemove: Bool

            switch contour.winding {
            case .clockwise:
                shouldRemove = totalWinding != 1

            case .counterClockwise:
                shouldRemove = totalWinding != 0
            }

            if shouldRemove {
                nodesToRemove.append(node)
            }
        }

        for node in nodesToRemove {
            removeNode(node)
        }

        guard let sorted = graph.topologicalSorted(breakTiesWith: { $0 < $1 }) else {
            fatalError("Found cyclic contour containment dependency?")
        }

        self.contours = sorted.map(contourForNode)
    }

    private func _isContained(_ lhs: Contour, within rhs: Contour) -> Bool {
        func probe(_ period: Contour.Period) -> Bool {
            rhs.contains(lhs.compute(at: period))
        }

        return probe(lhs.startPeriod)
            || probe((lhs.endPeriod - lhs.startPeriod) / 2)
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

            self.simplexes.append(contentsOf: simplexes)
        }

        func append(_ simplex: Simplex) {
            assert(!hasEnded, "!hasEnded: Attempted to append simplex to finished contour")

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
