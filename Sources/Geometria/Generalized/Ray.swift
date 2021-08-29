/// Represents an N-dimensional ray line which has a starting point and crosses
/// a secondary point before being projecting to infinity.
public struct Ray<Vector: VectorType>: GeometricType {
    public typealias Scalar = Vector.Scalar
    
    /// The starting position of this ray
    public var start: Vector
    
    /// A secondary point a line tracing from `start` passes through before
    /// being projected to infinity in a straight line.
    public var b: Vector
    
    @_transparent
    public init(start: Vector, b: Vector) {
        self.start = start
        self.b = b
    }
}

extension Ray: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Ray: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Ray: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Ray: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension Ray {
    /// Returns a `Line` representation of this ray, where `line.a` matches
    /// `self.start` and `line.b` matches `self.b`.
    @_transparent
    var asLine: Line<Vector> {
        Line(a: start, b: b)
    }
}

extension Ray: LineType {
    @_transparent
    public var a: Vector {
        start
    }
}

extension Ray: LineFloatingPoint where Vector: VectorFloatingPoint {
    /// Returns a `DirectionalRay` representation of this ray, where `ray.start`
    /// matches `self.start` and `ray.direction` matches
    /// `(self.b - self.start).normalized()`.
    ///
    /// - precondition: `(self.b - self.start).length > 0`
    @_transparent
    public var asDirectionalRay: DirectionalRay<Vector> {
        DirectionalRay(start: start, direction: b - start)
    }
    
    /// Returns `true` for all positive projected scalars (ray)
    @inlinable
    public func containsProjectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Bool {
        scalar >= 0
    }
    
    /// Returns the distance squared between this line and a given vector.
    @inlinable
    public func distanceSquared(to vector: Vector) -> Scalar {
        let proj = max(0, projectAsScalar(vector))
        
        let point = start.addingProduct(b - start, proj)
        
        return vector.distanceSquared(to: point)
    }
}

extension Ray: LineReal where Vector: VectorReal {
    
}
