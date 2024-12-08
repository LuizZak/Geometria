import MiniDigraph

internal extension Set {
    /// Performs a minimization of the inputs sets contained within this set by
    /// combining sets with common elements, such that all contained sets in the
    /// result are fully disjoint with one another, and contain the same elements
    /// as the sets within `self`.
    @inlinable
    func minimized<T>() -> [Set<T>] where Element == Set<T> {
        var graph = DirectedGraph<Int>()

        graph.addNodes(0..<self.count)

        let ordered = Array(self)
        for (current, currentSet) in ordered.enumerated() {
            for (next, nextSet) in ordered.enumerated().dropFirst(current + 1) {
                if !currentSet.isDisjoint(with: nextSet) {
                    graph.addEdge(from: current, to: next)
                }
            }
        }

        var minimalSets: [Set<T>] = []

        for component in graph.connectedComponents() {
            var minimalSet: Set<T> = []

            for index in component {
                minimalSet.formUnion(ordered[index])
            }

            minimalSets.append(minimalSet)
        }

        return minimalSets
    }
}
