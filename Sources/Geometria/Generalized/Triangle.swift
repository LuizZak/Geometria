/// Represents a [triangle] as a trio of N-dimensional vectors which describe an
/// enclosed surface on an euclidean space.
///
/// [line segment]: https://en.wikipedia.org/wiki/Triangle
public struct Triangle<Vector: VectorType>: GeometricType {
    /// Convenience for `Vector.Scalar`
    public typealias Scalar = Vector.Scalar
    
    /// The first point of this triangle.
    public var a: Vector
    
    /// The second point of this triangle.
    public var b: Vector
    
    /// The third point of this triangle.
    public var c: Vector
    
    @_transparent
    public init(a: Vector, b: Vector, c: Vector) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public extension Triangle {
    /// Returns a line segment between the points ``a`` and ``b``.
    var lineAB: LineSegment<Vector> {
        .init(start: a, end: b)
    }
    
    /// Returns a line segment between the points ``a`` and ``c``.
    var lineAC: LineSegment<Vector> {
        .init(start: a, end: c)
    }
    
    /// Returns a line segment between the points ``b`` and ``c``.
    var lineBC: LineSegment<Vector> {
        .init(start: b, end: c)
    }
}

extension Triangle: BoundableType where Vector: VectorComparable {
    public var bounds: AABB<Vector> {
        let min = Vector.pointwiseMin(a, Vector.pointwiseMin(b, c))
        let max = Vector.pointwiseMax(a, Vector.pointwiseMax(b, c))
        
        return AABB(minimum: min, maximum: max)
    }
}

public extension Triangle where Vector: VectorFloatingPoint {
    /// Returns the area of this triangle.
    ///
    /// Performs the following formula:
    ///
    ///     1÷2 √(|AB|² |AC|² - (AB • AC)²)
    ///
    /// Triangles with internal angles of 0° or 180° have an area zero.
    @inlinable
    var area: Scalar {
        let ab = lineAB
        let ac = lineAC
        
        let abL = ab.lengthSquared
        let acL = ac.lengthSquared
        let abacD = ab.lineSlope.dot(ac.lineSlope)
        
        let res: Scalar = abL * acL - (abacD * abacD)
        
        return res.squareRoot() / 2
    }
}
