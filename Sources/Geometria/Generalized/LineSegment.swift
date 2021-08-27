import RealModule

/// Represents a line segment as a pair of start and end N-dimensional vectors
/// which describe a closed interval.
public struct LineSegment<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    /// The bounded start of this line segment, inclusive.
    public var start: Vector
    
    /// The bounded end of this line segment, inclusive.
    public var end: Vector
    
    @_transparent
    public init(start: Vector, end: Vector) {
        self.start = start
        self.end = end
    }
}

extension LineSegment: Equatable where Vector: Equatable, Scalar: Equatable { }
extension LineSegment: Hashable where Vector: Hashable, Scalar: Hashable { }
extension LineSegment: Encodable where Vector: Encodable, Scalar: Encodable { }
extension LineSegment: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension LineSegment {
    /// Returns a `Line` representation of this line segment, where `line.a`
    /// matches `self.start` and `line.b` matches `self.end`.
    @_transparent
    var asLine: Line<Vector> {
        return Line(a: start, b: end)
    }
    
    /// Returns a `Ray` representation of this line segment, where `ray.start`
    /// matches `self.start` and `ray.b` matches `self.end`.
    @_transparent
    var asRay: Ray<Vector> {
        return Ray(start: start, b: end)
    }
}

extension LineSegment: LineType {
    @_transparent
    public var a: Vector { return start }
    
    @_transparent
    public var b: Vector { return end }
}

extension LineSegment: BoundedVolumeType where Vector: VectorComparable {
    @_transparent
    public var bounds: AABB<Vector> {
        return AABB(minimum: Vector.pointwiseMin(a, b),
                    maximum: Vector.pointwiseMax(a, b))
    }
}

public extension LineSegment where Vector: VectorMultiplicative {
    /// Returns the squared length of this line
    @_transparent
    var lengthSquared: Scalar {
        return (end - start).lengthSquared
    }
}

extension LineSegment: LineFloatingPoint where Vector: VectorFloatingPoint {
    /// Returns the distance squared between this line and a given vector.
    ///
    /// The projected point on which the distance is taken is capped between
    /// the start and end points.
    @inlinable
    public func distanceSquared(to vector: Vector) -> Scalar {
        let proj = min(1, max(0, projectScalar(vector)))
        
        let point = start.addingProduct(end - start, proj)
        
        return vector.distanceSquared(to: point)
    }
}

extension LineSegment: LineReal where Vector: VectorReal {
    /// Returns the length of this line
    @_transparent
    public var length: Scalar {
        return (end - start).length
    }
}

public extension LineSegment where Vector: VectorNormalizable {
    /// Returns a `DirectionalRay` representation of this ray, where `ray.start`
    /// matches `self.start` and `ray.direction` matches
    /// `(self.end - self.start).normalized()`.
    ///
    /// - precondition: `(self.end - self.start).length > 0`
    @_transparent
    var asDirectionalRay: DirectionalRay<Vector> {
        return DirectionalRay(start: start, direction: end - start)
    }
}
