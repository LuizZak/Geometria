/// Represents an N-dimensional square with an origin point and a scalar value
/// for the side length of each edge.
public struct NSquare<Vector: VectorType>: GeometricType {
    /// Convenience for `Vector.Scalar`
    public typealias Scalar = Vector.Scalar
    
    /// The location of this box, corresponding to the minimal coordinate of the
    /// box's bounds.
    public var location: Vector
    
    /// The length of the side edges of this square.
    public var sideLength: Scalar
    
    /// Returns a rectangle with the same boundaries as this square.
    @_transparent
    public var asRectangle: NRectangle<Vector> {
        NRectangle(location: location, size: Vector(repeating: sideLength))
    }
    
    @_transparent
    public init(location: Vector, sideLength: Scalar) {
        self.location = location
        self.sideLength = sideLength
    }
}

extension NSquare: Equatable where Vector: Equatable, Scalar: Equatable { }
extension NSquare: Hashable where Vector: Hashable, Scalar: Hashable { }

extension NSquare: RectangleType & BoundableType where Vector: VectorAdditive {
    /// Returns the span of this ``NSquare``.
    @_transparent
    public var size: Vector {
        Vector(repeating: sideLength)
    }
    
    /// Returns the minimal ``AABB`` capable of containing this ``NSquare``.
    @_transparent
    public var bounds: AABB<Vector> {
        AABB(minimum: location, maximum: location + Vector(repeating: sideLength))
    }
}

extension NSquare: VolumetricType where Vector: VectorAdditive & VectorComparable {
    /// Returns `true` if the given vector is contained within the bounds of this
    /// square.
    @inlinable
    public func contains(_ vector: Vector) -> Bool {
        return vector >= location && vector <= location + sideLength
    }
}

public extension NSquare where Vector: VectorMultiplicative {
    /// Returns an ``NSquare`` with position `.zero` and side length `1`.
    @_transparent
    static var unit: Self {
        Self(location: .zero, sideLength: 1)
    }
}

public extension NSquare where Vector: VectorDivisible {
    @_transparent
    var center: Vector {
        location + sideLength / 2
    }
}

extension NSquare: ConvexType where Vector: VectorFloatingPoint {
    /// Returns whether a given line intersects with this square.
    public func intersects<Line>(line: Line) -> Bool where Line: LineFloatingPoint, Line.Vector == Vector {
        bounds.intersects(line: line)
    }
    
    public func intersection<Line>(with line: Line) -> ConvexLineIntersection<Vector> where Line : LineFloatingPoint, Vector == Line.Vector {
        bounds.intersection(with: line)
    }
}

extension NSquare: SignedDistanceMeasurableType where Vector: VectorFloatingPoint {
    public func signedDistance(to point: Vector) -> Vector.Scalar {
        bounds.signedDistance(to: point)
    }
}
