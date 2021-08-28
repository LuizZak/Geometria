/// Represents an N-dimensional ray line which projects a line from a starting
/// point in a specified direction to infinity.
public struct DirectionalRay<Vector: VectorFloatingPoint> {
    public typealias Scalar = Vector.Scalar
    
    /// The starting position of this ray
    public var start: Vector
    
    /// A vector relative to `start` which indicates the direction of this ray.
    /// Must have `length > 0`.
    @UnitVector public var direction: Vector
    
    /// Initializes a directional ray with a given start position and direction
    /// vectors.
    ///
    /// The direction will be normalized before initializing.
    ///
    /// - precondition: `direction.length > 0`
    @_transparent
    public init(start: Vector, direction: Vector) {
        self.start = start
        self.direction = direction
    }
    
    /// Initializes a directional ray with a given line's endpoints.
    ///
    /// The direction will be normalized before initializing.
    ///
    /// - precondition: `line.length > 0`
    @_transparent
    public init<Line: LineType>(_ line: Line) where Line.Vector == Vector {
        self.init(start: line.a, direction: line.b - line.a)
    }
}

extension DirectionalRay: Equatable where Vector: Equatable, Scalar: Equatable { }
extension DirectionalRay: Hashable where Vector: Hashable, Scalar: Hashable { }
extension DirectionalRay: Encodable where Vector: Encodable, Scalar: Encodable { }
extension DirectionalRay: Decodable where Vector: Decodable, Scalar: Decodable { }

extension DirectionalRay: LineType {
    public var a: Vector {
        return start
    }
    
    public var b: Vector {
        return start + direction
    }
}

public extension DirectionalRay where Vector: VectorAdditive {
    /// Returns a `Line` representation of this directional ray, where `line.a`
    /// matches `self.start` and `line.b` matches `self.start + self.direction`.
    @_transparent
    var asLine: Line<Vector> {
        return Line(a: start, b: start + direction)
    }
    
    /// Returns a `Ray` representation of this directional ray, where `ray.start`
    /// matches `self.start` and `ray.b` matches `self.start + self.direction`.
    @_transparent
    var asRay: Ray<Vector> {
        return Ray(start: start, b: start + direction)
    }
}

extension DirectionalRay: LineFloatingPoint where Vector: VectorFloatingPoint {
    /// Returns `true` for all positive projected scalars (ray)
    @inlinable
    public func containsProjectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Bool {
        return scalar >= 0
    }
    
    /// Performs a vector projection of a given vector with respect to this
    /// directional ray, returning a scalar value representing the magnitude of
    /// the projected point laying on the line `start <-> start + direction`.
    ///
    /// By multiplying the result of this function by `direction` and adding
    /// `start`, the projected point as it lays on this directional ray line can
    /// be obtained.
    @inlinable
    public func projectAsScalar(_ vector: Vector) -> Vector.Scalar {
        let relVec = vector - start
        
        let proj = relVec.dot(direction)
        
        return proj
    }
    
    /// Returns the result of creating a projection of this ray's start point
    /// projected in the direction of this ray's direction, with a total
    /// magnitude of `scalar`.
    @inlinable
    public func projectedMagnitude(_ scalar: Vector.Scalar) -> Vector {
        return start.addingProduct(direction, scalar)
    }
    
    /// Returns the distance squared between this directional ray and a given
    /// vector.
    @inlinable
    public func distanceSquared(to vector: Vector) -> Scalar {
        let proj = max(0, projectAsScalar(vector))
        
        let point = start.addingProduct(direction, proj)
        
        return vector.distanceSquared(to: point)
    }
}
