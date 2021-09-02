/// Represents an N-dimensional [geometric ray] which projects a line from a
/// starting point in a specified direction to infinity.
///
/// [geometric ray]: https://en.wikipedia.org/wiki/Line_(geometry)#Ray
public struct DirectionalRay<Vector: VectorFloatingPoint>: GeometricType {
    public typealias Scalar = Vector.Scalar
    
    /// The starting position of this ray
    public var start: Vector
    
    /// A unit vector relative to `start` which indicates the direction of this
    /// ray.
    ///
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
        self.init(a: line.a, b: line.b)
    }
    
    /// Initializes a directional ray with a line passing through `a` and `b`.
    ///
    /// The ray's ``start`` point matches `a`.
    ///
    /// The direction will be normalized before initializing.
    ///
    /// - precondition: `line.length > 0`
    @_transparent
    public init(a: Vector, b: Vector) {
        self.init(start: a, direction: b - a)
    }
}

extension DirectionalRay: Equatable where Vector: Equatable, Scalar: Equatable { }
extension DirectionalRay: Hashable where Vector: Hashable, Scalar: Hashable { }
extension DirectionalRay: Encodable where Vector: Encodable, Scalar: Encodable { }
extension DirectionalRay: Decodable where Vector: Decodable, Scalar: Decodable { }

extension DirectionalRay: LineType {
    /// Equivalent to ``start``.
    @_transparent
    public var a: Vector {
        start
    }
    
    /// Equivalent to ``start`` + ``direction``.
    @_transparent
    public var b: Vector {
        start + direction
    }
}

public extension DirectionalRay where Vector: VectorAdditive {
    /// Returns a `Line` representation of this directional ray, where `line.a`
    /// matches ``start`` and `line.b` matches ``start`` + ``direction``.
    @_transparent
    var asLine: Line<Vector> {
        Line(a: start, b: b)
    }
    
    /// Returns a `Ray` representation of this directional ray, where `ray.start`
    /// matches ``start`` and `ray.b` matches ``start`` + ``direction``.
    @_transparent
    var asRay: Ray<Vector> {
        Ray(start: start, b: b)
    }
}

extension DirectionalRay: LineFloatingPoint & PointProjectiveType where Vector: VectorFloatingPoint {
    /// Performs a vector projection of a given vector with respect to this
    /// directional ray, returning a scalar value representing the magnitude of
    /// the projected point laying on the infinite line defined by points
    /// `start <-> start + direction`.
    ///
    /// By multiplying the result of this function by ``direction`` and adding
    /// ``start``, the projected point as it lays on this directional ray line
    /// can be obtained. This can also be achieved by using
    /// ``projectedMagnitude(_:)``.
    ///
    /// ```swift
    /// let ray = DirectionalRay2D(x: 1, y: 1, dx: 1, dy: 0)
    ///
    /// print(ray.projectAsScalar(.init(x: 5, y: 0))) // Prints "4"
    /// ```
    ///
    /// - seealso: ``projectedMagnitude(_:)``
    @inlinable
    public func projectAsScalar(_ vector: Vector) -> Vector.Scalar {
        let relVec = vector - start
        
        let proj = relVec.dot(direction)
        
        return proj
    }

    /// Returns the result of creating a projection of this ray's start point
    /// projected in the direction of this ray's direction, with a total
    /// magnitude of `scalar`.
    ///
    /// ```swift
    /// let ray = DirectionalRay2D(x: 1, y: 1, dx: 1, dy: 0)
    ///
    /// print(ray.projectedMagnitude(4)) // Prints "(x: 5, y: 0)"
    /// ```
    ///
    /// - seealso: ``projectAsScalar(_:)``
    @inlinable
    public func projectedMagnitude(_ scalar: Vector.Scalar) -> Vector {
        start.addingProduct(direction, scalar)
    }
    
    /// Returns the result of creating a projection of this ray's start point
    /// projected towards this line's end point, with a normalized magnitude of
    /// `scalar`.
    ///
    /// For `scalar == 0`, returns `self.a`, for `scalar == 1`, returns `self.b`
    ///
    /// - parameter scalar: A normalized magnitude that describes the length
    /// along the slope of this line to generate the point out of. Values
    /// outside the range [0, 1] are allowed and equate to projections past the
    /// endpoints of the line.
    @inlinable
    public func projectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Vector {
        start.addingProduct(direction, scalar)
    }
    
    /// Returns `true` for all positive scalar values, which describes a [ray].
    ///
    /// [ray]: https://en.wikipedia.org/wiki/Line_(geometry)#Ray
    @_transparent
    public func containsProjectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Bool {
        scalar >= 0
    }
    
    /// Returns a projected normalized magnitude that is guaranteed to be
    /// contained in this line.
    ///
    /// For ``DirectionalRay``, this is a clamped inclusive (0-∞ range.
    @_transparent
    public func clampProjectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Vector.Scalar {
        return max(0, scalar)
    }
    
    /// Returns the squared distance between this directional ray and a given
    /// vector.
    ///
    /// ```swift
    /// let ray = DirectionalRay2D(x: 1, y: 1, dx: 1, dy: 0)
    /// let point1 = Vector2D(x: 0, y: 0)
    /// let point2 = Vector2D(x: 5, y: 0)
    ///
    /// print(ray.distanceSquared(to: point1)) // Prints "2"
    /// print(ray.distanceSquared(to: point2)) // Prints "1"
    /// ```
    @inlinable
    public func distanceSquared(to vector: Vector) -> Scalar {
        let proj = max(0, projectAsScalar(vector))
        
        let point = start.addingProduct(direction, proj)
        
        return vector.distanceSquared(to: point)
    }
}
