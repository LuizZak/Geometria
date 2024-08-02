import OrderedCollections
import Geometria
import GeometriaAlgorithms

extension Simplex2Graph {
    /// Re-combines all contours within this graph based on their connectivity.
    @inlinable
    public func recombine(
        edgeFilter: (Edge) -> Bool
    ) -> [Contour] {

        var edgesComputed: Set<Edge> = []
        func computeWindingAndFilter(_ edge: Edge) -> Bool {
            guard let geometry = edge.geometry.first else {
                return false
            }

            if edgesComputed.insert(edge).inserted {
                let contour = contours[geometry.shapeIndex]
                edge.winding = contour.winding
                let center = edge.queryPoint()

                edge.totalWinding =
                    contourTree
                    .queryPoint(center)
                    .filter({ $0.index != geometry.shapeIndex && $0.contour.contains(center) })
                    .reduce(edge.winding.value, { $0 + $1.contour.winding.value })
            }

            return edgeFilter(edge)
        }

        let resultOverall = ContourManager<Vector>()

        var visitedOverall: Set<Node> = []
        var sortedEdges = OrderedSet(edges.sorted(by: { $0.id < $1.id }))

        guard let firstEdge = sortedEdges.first(where: computeWindingAndFilter) else {
            return resultOverall.allContours(applyWindingFiltering: false)
        }

        var currentShapeIndex = firstEdge.shapeIndices[0]
        var current = firstEdge.start

        func candidateIsAscending(_ lhs: Edge, _ rhs: Edge) -> Bool {
            if !computeWindingAndFilter(lhs) {
                return false
            }
            if !computeWindingAndFilter(rhs) {
                return true
            }

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
                let edges = sortedEdges.intersection(edges(from: current))
                guard let nextEdge = edges.min(by: candidateIsAscending) else {
                    break
                }

                let simplex = nextEdge.materialize(startPeriod: .zero, endPeriod: .zero)
                result.append(simplex)

                current = nextEdge.end

                if nextEdge.subtracting(shapeIndex: nextEdge.shapeIndices[0]) == nil {
                    sortedEdges.remove(nextEdge)
                }
            }

            result.endContour(startPeriod: .zero, endPeriod: 1)

            guard let next = sortedEdges.first(where: computeWindingAndFilter) else {
                break
            }

            currentShapeIndex = next.shapeIndices[0]
            current = next.start
        }

        return resultOverall.allContours(applyWindingFiltering: false)
    }
}
