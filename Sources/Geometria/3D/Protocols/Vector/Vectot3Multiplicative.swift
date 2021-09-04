/// Protocol for 3D vector types with multiplicable scalars.
public protocol Vector3Multiplicative: Vector3Additive, VectorMultiplicative where SubVector2: Vector2Multiplicative {
    /// Gets the (x: 1, y: 0, z: 0) vector of this type.
    static var unitX: Self { get }
    
    /// Gets the (x: 0, y: 1, z: 0) vector of this type.
    static var unitY: Self { get }
    
    /// Gets the (x: 0, y: 0, z: 1) vector of this type.
    static var unitZ: Self { get }
    
    /// Performs a cross product between this vector and another vector.
    func cross(_ other: Self) -> Self
}

public extension Vector3Multiplicative {
    /// Gets the (x: 1, y: 0, z: 0) vector of this type.
    @_transparent
    static var unitX: Self {
        return Self(x: 1, y: 0, z: 0)
    }
    
    /// Gets the (x: 0, y: 1, z: 0) vector of this type.
    @_transparent
    static var unitY: Self {
        return Self(x: 0, y: 1, z: 0)
    }
    
    /// Gets the (x: 0, y: 0, z: 1) vector of this type.
    @_transparent
    static var unitZ: Self {
        return Self(x: 0, y: 0, z: 1)
    }
    
    @inlinable
    func cross(_ other: Self) -> Self {
        let cx: Scalar = y * other.z - z * other.y
        let cy: Scalar = z * other.x - x * other.z
        let cz: Scalar = x * other.y - y * other.x
        
        return Self(x: cx, y: cy, z: cz)
    }
}
