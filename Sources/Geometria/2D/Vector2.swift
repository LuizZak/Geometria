import RealModule
import simd

/// Represents a 2D point with two double-precision, floating-point components
public typealias Vector2D = Vector2<Double>

/// Represents a 2D point with two floating-point components
public typealias Vector2F = Vector2<Float>

/// Represents a 2D point with two `Int` components
public typealias Vector2i = Vector2<Int>

/// A two-component vector type
public struct Vector2<Scalar>: Vector2Type {
    /// X coordinate of this vector
    public var x: Scalar
    
    /// Y coordinate of this vector
    public var y: Scalar
    
    /// Textual representation of this `Vector2`
    public var description: String {
        return "\(type(of: self))(x: \(self.x), y: \(self.y))"
    }
    
    /// Creates a new `Vector2` with the given coordinates
    public init(x: Scalar, y: Scalar) {
        self.x = x
        self.y = y
    }
    
    /// Creates a new `Vector2` with the given scalar on all coordinates
    public init(repeating scalar: Scalar) {
        self.init(x: scalar, y: scalar)
    }
}

extension Vector2: Equatable where Scalar: Equatable { }
extension Vector2: Hashable where Scalar: Hashable { }
extension Vector2: Encodable where Scalar: Encodable { }
extension Vector2: Decodable where Scalar: Decodable { }
