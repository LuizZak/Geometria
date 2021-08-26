import RealModule

/// Represents a line as a pair of start and end N-dimensional vectors which
/// describe the two points an infinite line crosses.
public struct Line<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    /// An initial point a line tracing from infinity passes through before
    /// being projected through `b` and extending to infinity in a straight line.
    public var a: Vector
    
    /// A secondary point a line tracing from `a` passes through before
    /// being projected to infinity in a straight line.
    public var b: Vector
    
    @_transparent
    public init(a: Vector, b: Vector) {
        self.a = a
        self.b = b
    }
}

extension Line: LineType {
    
}

extension Line: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Line: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Line: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Line: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension Line where Vector: VectorFloatingPoint {
    /// Returns the distance squared between this line and a given vector.
    @inlinable
    func distanceSquared(to vector: Vector) -> Scalar {
        let proj = projectScalar(vector)
        
        let point = a + (b - a) * proj
        
        return vector.distanceSquared(to: point)
    }
}

public extension Line where Vector: VectorReal {
    /// Returns the distance between this line and a given vector.
    @inlinable
    func distance(to vector: Vector) -> Scalar {
        return distanceSquared(to: vector).squareRoot()
    }
}
