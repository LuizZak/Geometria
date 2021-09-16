// TODO: Add ConvexType support once we figure out how to do N-dimensional
// TODO: capsule intersection tests, or split into Stadium/Capsule for 2D/3D and
// TODO: specialize eaach individually.

/// Represents an N-dimensional capsule (A
/// [Stadium](https://en.wikipedia.org/wiki/Stadium_(geometry) ) in 2D, and a
/// [Capsule](https://en.wikipedia.org/wiki/Capsule_(geometry) ) in 3D),
/// where all points that are less than ``radius`` distance away from a line
/// are considered within the geometry.
public struct NCapsule<Vector: VectorType>: GeometricType {
    /// Convenience for `Vector.Scalar`.
    public typealias Scalar = Vector.Scalar
    
    /// Gets the starting point of this stadium's geometry.
    public var start: Vector
    
    /// Gets the end point of this stadium's geometry.
    public var end: Vector
    
    /// The radius of this stadium.
    public var radius: Scalar
    
    @_transparent
    public init(start: Vector, end: Vector, radius: Scalar) {
        self.start = start
        self.end = end
        self.radius = radius
    }
}

extension NCapsule: Equatable where Vector: Equatable, Scalar: Equatable { }
extension NCapsule: Hashable where Vector: Hashable, Scalar: Hashable { }

public extension NCapsule {
    /// Returns a line segment with the same ``LineSegment/start`` and
    /// ``LineSegment/end`` points of this N-capsule.
    @_transparent
    var asLineSegment: LineSegment<Vector> {
        LineSegment(start: start, end: end)
    }
    
    /// Returns the ``NSphere`` that represents the top- or start, section of
    /// this N-capsule, centered around ``start`` with a radius of ``radius``.
    @_transparent
    var startAsSphere: NSphere<Vector> {
        .init(center: start, radius: radius)
    }
    
    /// Returns the ``NSphere`` that represents the bottom- or end, section of
    /// this N-capsule, centered around ``start`` with a radius of ``radius``.
    @_transparent
    var endAsSphere: NSphere<Vector> {
        .init(center: end, radius: radius)
    }
}

public extension NCapsule where Scalar: Comparable & AdditiveArithmetic {
    /// Returns whether this N-capsule's parameters produce a valid, non-empty
    /// stadium.
    ///
    /// An N-capsule is valid when ``radius`` is greater than zero.
    @_transparent
    var isValid: Bool {
        radius > .zero
    }
}

extension NCapsule: BoundableType where Vector: VectorAdditive & VectorComparable {
    /// Returns the minimal bounds capable of fully containing this N-capsule's
    /// area.
    ///
    /// Is equivalent to a union of the start and end N-spheres of this N-capsule.
    @_transparent
    public var bounds: AABB<Vector> {
        startAsSphere.bounds.union(endAsSphere.bounds)
    }
}

extension NCapsule: VolumetricType where Vector: VectorFloatingPoint {
    /// Returns `true` if a given vector is fully contained within this
    /// N-capsule.
    ///
    /// Points at the perimeter of the N-capsule (distance to line == radius)
    /// are considered as contained within the N-capsule.
    @inlinable
    public func contains(_ vector: Vector) -> Bool {
        // TODO: Doing this in separate statements to ease long compilation times in Xcode 12
        let radSquare: Scalar = radius * radius
        
        return asLineSegment.distanceSquared(to: vector) <= radSquare
    }
}
