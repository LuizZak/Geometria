/// Protocol for 3D vector types with multiplicable scalars.
public protocol Vector3Multiplicative: Vector3Additive, VectorMultiplicative {
    /// Gets the (x: 1, y: 0, z: 0) vector of this type.
    static var unitX: Self { get }
    
    /// Gets the (x: 0, y: 1, z: 0) vector of this type.
    static var unitY: Self { get }
    
    /// Gets the (x: 0, y: 0, z: 1) vector of this type.
    static var unitZ: Self { get }
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
}
