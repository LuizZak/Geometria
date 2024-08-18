import Geometria

extension Vector2FloatingPoint {
    @inlinable
    func isApproximatelyEqualFast(to other: Self, tolerance: Scalar) -> Bool {
        return x.isApproximatelyEqualFast(to: other.x, tolerance: tolerance)
            && y.isApproximatelyEqualFast(to: other.y, tolerance: tolerance)
    }
}
