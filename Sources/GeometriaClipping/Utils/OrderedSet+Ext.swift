import OrderedCollections
import MiniDigraph

internal extension OrderedSet {
    /// Performs a minimization of the inputs sets contained within this set by
    /// combining sets with common elements, such that all contained sets in the
    /// result are fully disjoint with one another, and contain the same elements
    /// as the sets within `self`.
    @inlinable
    func minimized<T>() -> [OrderedSet<T>] where Element == OrderedSet<T> {
        var graph = DirectedGraph<Int>()

        graph.addNodes(0..<self.count)

        for (current, currentSet) in self.enumerated() {
            for (next, nextSet) in self.enumerated().dropFirst(current + 1) {
                if !currentSet.isDisjoint(with: nextSet) {
                    graph.addEdge(from: current, to: next)
                }
            }
        }

        var minimalSets: [OrderedSet<T>] = []

        for component in graph.connectedComponents() {
            var minimalSet: OrderedSet<T> = []

            for index in component.sorted() {
                minimalSet.formUnion(self[index])
            }

            minimalSets.append(minimalSet)
        }

        return minimalSets
    }
}
