import RealModule

/// Represents a 2D line as a pair of double-precision floating-point start and
/// end vectors.
public typealias Line2D = Line<Vector2D>

/// Represents a 2D line as a pair of single-precision floating-point start and
/// end vectors.
public typealias Line2F = Line<Vector2F>

/// Represents a 2D line as a pair of integer start and end vectors.
public typealias Line2i = Line<Vector2i>

/// Represents a line as a pair of start and end N-dimensional vectors.
public struct Line<Vector: VectorType> {
    public typealias Scalar = Vector.Scalar
    
    public var start: Vector
    public var end: Vector
    
    @inlinable
    public init(start: Vector, end: Vector) {
        self.start = start
        self.end = end
    }
}

extension Line: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Line: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Line: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Line: Decodable where Vector: Decodable, Scalar: Decodable { }

extension Line where Vector: VectorMultiplicative {
    /// Returns the squared length of this line
    @inlinable
    public var lengthSquared: Scalar {
        return (end - start).lengthSquared
    }
}

extension Line where Vector: VectorReal {
    /// Returns the length of this line
    @inlinable
    public var length: Scalar {
        return (end - start).length
    }
}
