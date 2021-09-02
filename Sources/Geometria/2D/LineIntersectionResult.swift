/// Describes the result of a line-line intersection query on two
/// ``Line2FloatingPoint``.
///
/// - seealso: ``Line2FloatingPoint/intersection(with:)-75fo7``
public struct LineIntersectionResult<Vector: VectorFloatingPoint> {
    /// Convenience for `Vector.Scalar`.
    public typealias Scalar = Vector.Scalar
    
    /// The interseciton point in global space.
    public var point: Vector
    
    /// A scalar value between (0-1) that describe the normalized magnitude of
    /// the intersection point ``point`` on the first line.
    public var line1NormalizedMagnitude: Vector.Scalar
    
    /// A scalar value between (0-1) that describe the normalized magnitude of
    /// the intersection point ``point`` on the second line.
    public var line2NormalizedMagnitude: Vector.Scalar
    
    @_transparent
    public init(point: Vector,
                line1NormalizedMagnitude: Vector.Scalar,
                line2NormalizedMagnitude: Vector.Scalar) {
        
        self.point = point
        self.line1NormalizedMagnitude = line1NormalizedMagnitude
        self.line2NormalizedMagnitude = line2NormalizedMagnitude
    }
}

extension LineIntersectionResult: Equatable where Vector: Equatable { }
extension LineIntersectionResult: Hashable where Vector: Hashable { }
