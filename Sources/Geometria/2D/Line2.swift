import RealModule

/// Describes a line as a pair of double-precision floating-point start and end
/// vectors
public typealias Line2D = Line2<Double>

/// Describes a line as a pair of single-precision floating-point start and end
/// vectors
public typealias Line2F = Line2<Float>

/// Describes a line as a pair of start and end positions
public struct Line2<Scalar: VectorScalar> {
    public var start: Vector2<Scalar>
    public var end: Vector2<Scalar>
    
    @inlinable
    public init(start: Vector2<Scalar>, end: Vector2<Scalar>) {
        self.start = start
        self.end = end
    }
    
    @inlinable
    public init(x1: Scalar, y1: Scalar, x2: Scalar, y2: Scalar) {
        start = Vector2(x: x1, y: y1)
        end = Vector2(x: x2, y: y2)
    }
}

extension Line2: Equatable where Scalar: Equatable { }
extension Line2: Hashable where Scalar: Hashable { }
extension Line2: Encodable where Scalar: Encodable { }
extension Line2: Decodable where Scalar: Decodable { }

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
