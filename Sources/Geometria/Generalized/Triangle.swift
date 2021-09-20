/// Represents a [triangle] as a trio of N-dimensional vectors which describe a
/// 2-dimensional enclosed surface on an euclidean space.
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
    /// Returns a line segment for the edge between the points ``a`` `->` ``b``.
    @_transparent
    var lineAB: LineSegment<Vector> {
        .init(start: a, end: b)
    }
    
    /// Returns a line segment for the edge between the points ``a`` `->` ``c``.
    @_transparent
    var lineAC: LineSegment<Vector> {
        .init(start: a, end: c)
    }
    
    /// Returns a line segment for the edge between the points ``b`` `->` ``c``.
    @_transparent
    var lineBC: LineSegment<Vector> {
        .init(start: b, end: c)
    }
    
    /// Returns a line segment for the edge between the points ``b`` `->` ``a``.
    @_transparent
    var lineBA: LineSegment<Vector> {
        .init(start: b, end: a)
    }
    
    /// Returns a line segment for the edge between the points ``c`` `->` ``a``.
    @_transparent
    var lineCA: LineSegment<Vector> {
        .init(start: c, end: a)
    }
    
    /// Returns a line segment for the edge between the points ``c`` `->` ``b``.
    @_transparent
    var lineCB: LineSegment<Vector> {
        .init(start: c, end: b)
    }
}

extension Triangle: BoundableType where Vector: VectorComparable {
    @_transparent
    public var bounds: AABB<Vector> {
        AABB(of: a, b, c)
    }
}

public extension Triangle where Vector: VectorDivisible {
    /// Returns the geometric center of this triangle.
    ///
    /// Equivalent to the arithmetic mean of the three points of this triangle:
    ///
    /// ```swift
    /// (a + b + c) / 3
    /// ```
    @_transparent
    var center: Vector {
        (a + b + c) / 3
    }
}

public extension Triangle where Vector: VectorFloatingPoint {
    /// Returns the positive area of this triangle.
    ///
    /// Performs the following operation:
    ///
    /// ```
    /// 1÷2 √(|AB|² |AC|² - (AB • AC)²)
    /// ```
    ///
    /// Where `AB` is the vector going from ``a`` to ``b``, and `AC` from ``a``
    /// to ``c``:
    ///
    /// ```swift
    /// let AB = a - b
    /// let AC = a - c
    /// ```
    ///
    /// (the area of the triangle is half of the area of the [parallelogram]
    /// formed by the vectors AB / AC on the plane of those vertices).
    ///
    /// Triangles with internal angles of 0° or 180° have an area of zero.
    ///
    /// [parallelogram]: https://en.wikipedia.org/wiki/Parallelogram
    @inlinable
    var area: Scalar {
        let ab = lineAB
        let ac = lineAC
        
        let abL = ab.lengthSquared
        let acL = ac.lengthSquared
        let abacD = ab.lineSlope.dot(ac.lineSlope)
        
        let resL: Scalar = abL * acL
        let resR: Scalar = (abacD * abacD)
        let res: Scalar = resL - resR
        
        return res.squareRoot() / 2
    }
}
