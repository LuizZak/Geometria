/// Represents a regular 2-dimensional [Stadium](https://en.wikipedia.org/wiki/Stadium_(geometry) )
/// as a pair of end points and a radius with double-precision floating-point
/// numbers.
public typealias Stadium2D = Stadium2<Vector2D>

/// Represents a regular 2-dimensional [Stadium](https://en.wikipedia.org/wiki/Stadium_(geometry) )
/// as a pair of end points and a radius with stadium-precision floating-point
/// numbers.
public typealias Stadium2F = Stadium2<Vector2F>

/// Represents a regular 2-dimensional [Stadium](https://en.wikipedia.org/wiki/Stadium_(geometry) )
/// as a pair of end points and a radius with integers.
public typealias Stadium2i = Stadium2<Vector2i>

/// Represents a regular 2-dimensional [Stadium](https://en.wikipedia.org/wiki/Stadium_(geometry) )
/// as a pair of end points and a radius with integers.
public struct Stadium2<Vector: Vector2Type>: GeometricType {
    /// Convenience for `Vector.Scalar`.
    public typealias Scalar = Vector.Scalar
    
    /// The starting point of this stadium.
    public var start: Vector
    
    /// The ending point of this stadium.
    public var end: Vector
    
    /// The radius of this stadium.
    public var radius: Scalar
    
    public init(start: Vector, end: Vector, radius: Scalar) {
        self.start = start
        self.end = end
        self.radius = radius
    }
}

extension Stadium2: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Stadium2: Hashable where Vector: Hashable, Scalar: Hashable { }

public extension Stadium2 {
    /// Returns a line segment with the same ``LineSegment/start`` and
    /// ``LineSegment/end`` points of this stadium.
    @_transparent
    var asLineSegment: LineSegment<Vector> {
        LineSegment(start: start, end: end)
    }
    
    /// Returns the circle that represents the top- or start, section of this
    /// stadium, centered around ``start`` with a radius of ``radius``.
    @inlinable
    var startAsCircle: Circle2<Vector> {
        Circle2<Vector>(center: start,
                        radius: radius)
    }
    
    /// Returns the circle that represents the bottom- or end, section of this
    /// stadium, centered around ``start`` with a radius of ``radius``.
    @inlinable
    var endAsCircle: Circle2<Vector> {
        Circle2<Vector>(center: end,
                        radius: radius)
    }
}

public extension Stadium2 where Scalar: Comparable & AdditiveArithmetic {
    /// Returns whether this stadium's parameters produce a valid, non-empty
    /// stadium.
    ///
    /// A stadium is valid when ``radius`` is greater than zero.
    @_transparent
    var isValid: Bool {
        radius > .zero
    }
}

extension Stadium2: BoundableType where Vector: VectorAdditive & VectorComparable {
    @inlinable
    public var bounds: AABB<Vector> {
        startAsCircle.bounds.union(endAsCircle.bounds)
    }
}

// TODO: See if we can solve this point-containment check without line.project
// TODO: to drop Vector2FloatingPoint requirement to a base protocol.
extension Stadium2: VolumetricType where Vector: Vector2FloatingPoint {
    /// Returns `true` if a given vector is fully contained within this
    /// stadium.
    ///
    /// Points at the perimeter of the stadium are considered as contained
    /// within the stadium (inclusive).
    @inlinable
    public func contains(_ vector: Vector) -> Bool {
        var projected: Vector
        
        // For start == end, Stadium2 is a circle.
        if start == end {
            projected = start
        } else {
            let line = asLineSegment
            projected = line.project(vector)
        }
        
        return projected.distanceSquared(to: vector) < radius * radius
    }
}
