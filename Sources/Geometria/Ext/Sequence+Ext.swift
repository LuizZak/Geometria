extension Sequence where Element: VectorMultiplicative, Element.Scalar: Comparable {
    /// Returns the vector within this sequence that is the closest to a given
    /// input vector.
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
    /// print(vectors.closestPointIndex(to: Vector2D(x: 0, y: 0))) // Prints "(x: -2.0, y: 2.3)"
    /// ```
    @inlinable
    func closestPoint(to vector: Element) -> Element? {
        var closest: (point: Element, distanceSquared: Element.Scalar)?
        for p in self {
            let distSquare = p.distanceSquared(to: vector)

            guard let c = closest else {
                closest = (p, distSquare)
                continue
            }
            if c.distanceSquared > distSquare {
                closest = (p, distSquare)
            }
        }

        return closest?.point
    }
}
