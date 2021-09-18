/// Protocol for 4D vector types where the components are floating-point numbers
public protocol Vector4FloatingPoint: Vector4Additive, VectorMultiplicative & VectorFloatingPoint where SubVector3: Vector3FloatingPoint {
    /// Initializes this `Vector4FloatingPoint` with a given binary Vector3
    init<V: Vector4Type>(_ other: V) where V.Scalar: BinaryInteger
    
    static func + <V: Vector4Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger

    static func - <V: Vector4Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger

    static func * <V: Vector4Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger

    static func + <V: Vector4Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger

    static func - <V: Vector4Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger

    static func * <V: Vector4Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger

    static func += <V: Vector4Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger

    static func -= <V: Vector4Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger

    static func *= <V: Vector4Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger

    static func / <V: Vector4Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger

    static func / <V: Vector4Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger

    static func /= <V: Vector4Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger
}

// swiftlint:disable shorthand_operator

extension Vector4FloatingPoint {
    @inlinable
    public static func + <V: Vector4Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        lhs + Self(rhs)
    }
    
    @inlinable
    public static func - <V: Vector4Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        lhs - Self(rhs)
    }
    
    @inlinable
    public static func * <V: Vector4Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        lhs * Self(rhs)
    }
    
    @inlinable
    public static func + <V: Vector4Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        Self(lhs) + rhs
    }
    
    @inlinable
    public static func - <V: Vector4Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        Self(lhs) - rhs
    }
    
    @inlinable
    public static func * <V: Vector4Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        Self(lhs) * rhs
    }
    
    @inlinable
    public static func += <V: Vector4Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs + Self(rhs)
    }
    
    @inlinable
    public static func -= <V: Vector4Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs - Self(rhs)
    }
    
    @inlinable
    public static func *= <V: Vector4Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs * Self(rhs)
    }
    
    @inlinable
    public static func / <V: Vector4Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        lhs / Self(rhs)
    }
    
    @inlinable
    public static func / <V: Vector4Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        Self(lhs) / rhs
    }
    
    @inlinable
    public static func /= <V: Vector4Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs / Self(rhs)
    }
}
