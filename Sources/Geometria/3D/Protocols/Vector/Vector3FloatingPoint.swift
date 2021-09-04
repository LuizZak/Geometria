/// Protocol for 3D vector types where the components are floating-point numbers
public protocol Vector3FloatingPoint: Vector3Multiplicative & VectorFloatingPoint where SubVector2: Vector2FloatingPoint {
    /// Initializes this `Vector3FloatingPoint` with a given binary Vector3
    init<V: Vector3Type>(_ other: V) where V.Scalar: BinaryInteger
    
    static func + <V: Vector3Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger

    static func - <V: Vector3Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger

    static func * <V: Vector3Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger

    static func + <V: Vector3Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger

    static func - <V: Vector3Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger

    static func * <V: Vector3Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger

    static func += <V: Vector3Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger

    static func -= <V: Vector3Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger

    static func *= <V: Vector3Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger

    static func / <V: Vector3Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger

    static func / <V: Vector3Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger

    static func /= <V: Vector3Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger
}

// swiftlint:disable shorthand_operator

extension Vector3FloatingPoint {
    @inlinable
    public static func + <V: Vector3Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        lhs + Self(rhs)
    }
    
    @inlinable
    public static func - <V: Vector3Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        lhs - Self(rhs)
    }
    
    @inlinable
    public static func * <V: Vector3Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        lhs * Self(rhs)
    }
    
    @inlinable
    public static func + <V: Vector3Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        Self(lhs) + rhs
    }
    
    @inlinable
    public static func - <V: Vector3Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        Self(lhs) - rhs
    }
    
    @inlinable
    public static func * <V: Vector3Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        Self(lhs) * rhs
    }
    
    @inlinable
    public static func += <V: Vector3Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs + Self(rhs)
    }
    
    @inlinable
    public static func -= <V: Vector3Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs - Self(rhs)
    }
    
    @inlinable
    public static func *= <V: Vector3Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs * Self(rhs)
    }
    
    @inlinable
    public static func / <V: Vector3Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        lhs / Self(rhs)
    }
    
    @inlinable
    public static func / <V: Vector3Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        Self(lhs) / rhs
    }
    
    @inlinable
    public static func /= <V: Vector3Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs / Self(rhs)
    }
}
