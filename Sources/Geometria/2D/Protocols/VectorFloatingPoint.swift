/// Protocol for vector types where the components are floating-point numbers
public protocol VectorFloatingPoint: VectorDivisible where Scalar: FloatingPoint {
    /// Rounds the components of this `VectorType` using a given
    /// `FloatingPointRoundingRule`.
    @inlinable
    func rounded(_ rule: FloatingPointRoundingRule) -> Self
    
    /// Rounds the components of this `VectorType` using a given
    /// `FloatingPointRoundingRule.toNearestOrAwayFromZero`.
    ///
    /// Equivalent to calling C's round() function on each component.
    @inlinable
    func rounded() -> Self
    
    /// Rounds the components of this `VectorType` using a given
    /// `FloatingPointRoundingRule.up`.
    ///
    /// Equivalent to calling C's ceil() function on each component.
    @inlinable
    func ceil() -> Self
    
    /// Rounds the components of this `VectorType` using a given
    /// `FloatingPointRoundingRule.down`.
    ///
    /// Equivalent to calling C's floor() function on each component.
    @inlinable
    func floor() -> Self
    
    @inlinable
    static func % (lhs: Self, rhs: Self) -> Self
    
    @inlinable
    static func % (lhs: Self, rhs: Scalar) -> Self
}

/// Protocol for vector types where the components are floating-point numbers
public protocol Vector2FloatingPoint: Vector2Type, VectorFloatingPoint {
    /// Initializes this Vector2FloatingPoint with a given binary Vector2
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
