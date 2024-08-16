extension FloatingPoint {
    @inlinable
    func isApproximatelyEqualFast(to other: Self, tolerance: Self) -> Bool {
        (self - other).magnitude <= tolerance
    }
}
