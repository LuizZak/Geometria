/// Protocol for objects representing lines with real vectors
public protocol LineReal: LineFloatingPoint where Vector: VectorReal {
    /// Returns the distance between this line and a given vector.
    func distance(to vector: Vector) -> Vector.Scalar
}

public extension LineReal {
    /// Returns the distance between this line and a given vector.
    @inlinable
    func distance(to vector: Vector) -> Vector.Scalar {
        return distanceSquared(to: vector).squareRoot()
    }
}
