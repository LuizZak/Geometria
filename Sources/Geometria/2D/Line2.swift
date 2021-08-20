import RealModule

/// Represents a 2D line as a pair of double-precision floating-point start and
/// end vectors.
public typealias Line2D = Line2<Vector2D>

/// Represents a 2D line as a pair of single-precision floating-point start and
/// end vectors.
public typealias Line2F = Line2<Vector2F>

/// Represents a 2D line as a pair of integer start and end vectors.
public typealias Line2i = Line2<Vector2i>

/// Represents a 2D line as a pair of start and end vectors.
public struct Line2<Vector: Vector2Type> {
    public typealias Scalar = Vector.Scalar
    
    public var start: Vector
    public var end: Vector
    
    @inlinable
    public init(start: Vector, end: Vector) {
        self.start = start
        self.end = end
    }
    
    @inlinable
    public init(x1: Scalar, y1: Scalar, x2: Scalar, y2: Scalar) {
        start = Vector(x: x1, y: y1)
        end = Vector(x: x2, y: y2)
    }
}

extension Line2: Equatable where Vector: Equatable, Scalar: Equatable { }
extension Line2: Hashable where Vector: Hashable, Scalar: Hashable { }
extension Line2: Encodable where Vector: Encodable, Scalar: Encodable { }
extension Line2: Decodable where Vector: Decodable, Scalar: Decodable { }

extension Line2 where Scalar: Numeric {
    /// Returns the squared length of this line
    @inlinable
    public var lengthSquared: Scalar {
        return (end - start).lengthSquared
    }
}

extension Line2 where Scalar: Real {
    /// Returns the angle of this line, in radians
    @inlinable
    public var angle: Scalar {
        return (end - start).angle
    }
    
    /// Returns the length of this line
    @inlinable
    public var length: Scalar {
        return (end - start).length
    }
}
