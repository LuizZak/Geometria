/// Protocol for vector types where the components are floating-point numbers
public protocol Vector2FloatingPoint: Vector2Type, VectorFloatingPoint {
    /// Initializes this `Vector2FloatingPoint` with a given binary Vector2
    init<V: Vector2Type>(_ other: V) where V.Scalar: BinaryInteger
    
    static func + <V: Vector2Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger

    static func - <V: Vector2Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger

    static func * <V: Vector2Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger

    static func + <V: Vector2Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger

    static func - <V: Vector2Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger

    static func * <V: Vector2Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger

    static func += <V: Vector2Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger

    static func -= <V: Vector2Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger

    static func *= <V: Vector2Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger

    static func / <V: Vector2Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger

    static func / <V: Vector2Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger

    static func /= <V: Vector2Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger
}

extension Vector2FloatingPoint {
    @inlinable
    public static func + <V: Vector2Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        return lhs + Self(rhs)
    }
    
    @inlinable
    public static func - <V: Vector2Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        return lhs - Self(rhs)
    }
    
    @inlinable
    public static func * <V: Vector2Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        return lhs * Self(rhs)
    }
    
    @inlinable
    public static func + <V: Vector2Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        return Self(lhs) + rhs
    }
    
    @inlinable
    public static func - <V: Vector2Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        return Self(lhs) - rhs
    }
    
    @inlinable
    public static func * <V: Vector2Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        return Self(lhs) * rhs
    }
    
    @inlinable
    public static func += <V: Vector2Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs + Self(rhs)
    }
    
    @inlinable
    public static func -= <V: Vector2Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs - Self(rhs)
    }
    
    @inlinable
    public static func *= <V: Vector2Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs * Self(rhs)
    }
    
    @inlinable
    public static func / <V: Vector2Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        return lhs / Self(rhs)
    }
    
    @inlinable
    public static func / <V: Vector2Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        return Self(lhs) / rhs
    }
    
    @inlinable
    public static func /= <V: Vector2Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs / Self(rhs)
    }
}