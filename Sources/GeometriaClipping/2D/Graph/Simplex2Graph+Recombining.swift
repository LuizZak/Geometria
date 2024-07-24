import Geometria

extension Simplex2Graph {
    /// Re-combines all contours within this graph based on their connectivity.
    ///
    /// Recombination mutates the graph as it removes edges and nodes that where
    /// recombined.
    public mutating func recombine() -> [Contour] {
        let resultOverall = ContourManager<Vector>()

        var currentShapeIndex: Int?

        func candidateIsAscending(_ lhs: Edge, _ rhs: Edge) -> Bool {
            if let currentShapeIndex {
                switch (lhs.shapeIndex == currentShapeIndex, rhs.shapeIndex == currentShapeIndex) {
                case (true, false):
                    return true
                case (false, true):
                    return false

                default: break
                }
            }

            return lhs.id < rhs.id
        }

        var visitedOverall: Set<Node> = []

        guard let firstEdge = edges.min(by: candidateIsAscending) else {
            return resultOverall.allContours(applyWindingFiltering: false)
        }

        currentShapeIndex = firstEdge.shapeIndex
        var current = firstEdge.start

        // Keep visiting nodes on the graph, removing them after each complete visit
        while visitedOverall.insert(current).inserted {
            let result = resultOverall.beginContour()
            var visited: Set<Node> = []

            // Visit all reachable nodes
            // The existing edges shouldn't matter as long as we pick any
            // suitable edge in a stable fashion for unit testing
            while visited.insert(current).inserted {
                guard let nextEdge = edges(from: current).min(by: candidateIsAscending) else {
                    break
                }

                removeEdge(nextEdge)

                result.append(nextEdge.materialize())
                current = nextEdge.end
            }

            result.endContour(startPeriod: .zero, endPeriod: 1)

            // Prune the graph by removing dead-end nodes and pull a new edge to
            // start traversing on any remaining nodes
            prune()

            guard let next = edges.min(by: candidateIsAscending) else {
                break
            }

            currentShapeIndex = next.shapeIndex
            current = next.start
        }

        return resultOverall.allContours(applyWindingFiltering: false)
    }
}
