import Geometria

extension Simplex2Graph {
    /// Re-combines all contours within this graph based on their connectivity.
    ///
    /// Recombination mutates the graph as it removes edges and nodes that where
    /// recombined.
    public mutating func recombine() -> [Contour] {
        let resultOverall = ContourManager<Vector>()

        var visitedOverall: Set<Node> = []

        guard let firstEdge = edges.min(by: { $0.id < $1.id }) else {
            return resultOverall.allContours(applyWindingFiltering: false)
        }

        var currentShapeIndex = firstEdge.shapeIndices[0]
        var current = firstEdge.start

        func candidateIsAscending(_ lhs: Edge, _ rhs: Edge) -> Bool {
            switch (lhs.references(shapeIndex: currentShapeIndex), rhs.references(shapeIndex: currentShapeIndex)) {
            case (true, false):
                return true

            case (false, true):
                return false

            default:
                return lhs.id < rhs.id
            }
        }

        // Keep visiting nodes on the graph, removing them after each complete visit
        while visitedOverall.insert(current).inserted {
            let result = resultOverall.beginContour()
            var visited: Set<Node> = []

            // Visit all reachable nodes
            // The existing edges shouldn't matter as long as we pick any
            // suitable edge in a stable fashion for unit testing
            while visited.insert(current).inserted {
                let edges = edges(from: current)
                guard let nextEdge = edges.min(by: candidateIsAscending) else {
                    break
                }

                let simplex = nextEdge.materialize(startPeriod: .zero, endPeriod: .zero)
                result.append(simplex)

                current = nextEdge.end

                if nextEdge.subtracting(shapeIndex: nextEdge.shapeIndices[0]) == nil {
                    removeEdge(nextEdge)
                } else {
                    assertionFailure()
                }
            }

            result.endContour(startPeriod: .zero, endPeriod: 1)

            // Prune the graph by removing dead-end nodes and pull a new edge to
            // start traversing on any remaining nodes
            prune()

            guard let next = edges.min(by: { $0.id < $1.id }) else {
                break
            }

            currentShapeIndex = next.shapeIndices[0]
            current = next.start
        }

        return resultOverall.allContours(applyWindingFiltering: false)
    }
}
