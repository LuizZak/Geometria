public extension Collection {
    /// Averages this collection of vectors into one `VectorDivisible` point as
    /// the mean location of each vector.
    ///
    /// Returns `VectorDivisible.zero`, if the collection is empty.
    ///
    /// ```swift
    /// let vectors = [
    ///     Vector2D(x: 3.0, y: 4.3),
    ///     Vector2D(x: -2.0, y: 2.3),
    ///     Vector2D(x: 2.0, y: 6.9)
    /// ]
    ///
    /// print(vectors.averageVector()) // Prints "(x: 1.0, y: 4.5)"
    /// ```
    @inlinable
    func averageVector<V: VectorDivisible>() -> V where Element == V, V.Scalar: FloatingPoint {
        if isEmpty {
            return .zero
        }
        
        let accum: V = reduce(into: .zero) { $0 += $1 }
        
        return accum / V.Scalar(count)
    }
}

public extension Collection where Element: VectorMultiplicative, Element.Scalar: Comparable {
    /// Returns the index to the vector within this collection that is the closest
    /// to a given input vector.
    ///
    /// Returns `nil`, if the collection is empty.
    ///
    /// ```swift
    /// let vectors = [
    ///     Vector2D(x: 3.0, y: 4.3),
    ///     Vector2D(x: -2.0, y: 2.3),
    ///     Vector2D(x: 2.0, y: 6.9)
    /// ]
    ///
    /// print(vectors.closestPointIndex(to: Vector2D(x: 0, y: 0))) // Prints "1"
    /// ```
    @inlinable
    func closestPointIndex(to vector: Element) -> Index? {
        if count == 1 {
            return startIndex
        }

        var closest: (index: Index, distanceSquared: Element.Scalar)?
        for p in self.indices {
            let distSquare = self[p].distanceSquared(to: vector)

            guard let c = closest else {
                closest = (p, distSquare)
                continue
            }
            if c.distanceSquared > distSquare {
                closest = (p, distSquare)
            }
        }

        return closest?.index
    }
}
