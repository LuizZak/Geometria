internal extension Set {
    /// Performs a minimization of the inputs sets contained within this set by
    /// combining sets with common elements, such that all contained sets in the
    /// result are fully disjoint with one another, and contain the same elements
    /// as the sets within `self`.
    @inlinable
    func minimized<T>() -> [Set<T>] where Element == Set<T> {
        var result: [Set<T>] = []

        var queue: [Set<T>] = Array(self)

        outer:
        while !queue.isEmpty {
            let next = queue.removeFirst()

            for (i, current) in result.enumerated() {
                if !current.isDisjoint(with: next) {
                    result.remove(at: i)
                    queue.append(current.union(next))
                    continue outer
                }
            }

            result.append(next)
        }

        return result
    }
}
