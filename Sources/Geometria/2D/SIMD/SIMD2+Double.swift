import simd

extension SIMD2: VectorType where Scalar == Double {
    
}

extension SIMD2: VectorAdditive where Scalar == Double {
    
}

extension SIMD2: VectorMultiplicative where Scalar == Double {
    
}

extension SIMD2: VectorDivisible where Scalar == Double {
    
}

extension SIMD2: Vector2Type, VectorComparable, VectorReal, VectorFloatingPoint where Scalar == Double {
    public var length: Scalar {
        return simd.length(self)
    }
    
    public static var unit: SIMD2<Scalar> {
        return .one
    }
    
    public var lengthSquared: Scalar {
        return length_squared(self)
    }
    
    public func distance(to vec: SIMD2<Scalar>) -> Scalar {
        return simd.distance(self, vec)
    }
    
    public func rounded() -> SIMD2<Scalar> {
        return self.rounded(.toNearestOrAwayFromZero)
    }
    
    public func ceil() -> SIMD2<Scalar> {
        return self.rounded(.up)
    }
    
    public func floor() -> SIMD2<Scalar> {
        return self.rounded(.down)
    }
    
    public func distanceSquared(to vec: SIMD2<Scalar>) -> Scalar {
        return distance_squared(self, vec)
    }
    
    public func dot(_ other: SIMD2<Scalar>) -> Scalar {
        return simd.dot(self, other)
    }
    
    public func ratio(_ ratio: Scalar, to other: SIMD2<Scalar>) -> SIMD2<Scalar> {
        return (1 - ratio) * self + ratio * other
    }
    
    public static func lerp(start: SIMD2<Scalar>, end: SIMD2<Scalar>, amount: Scalar) -> SIMD2<Scalar> {
        start.ratio(amount, to: end)
    }
    
    /// Returns the pointwise minimal Vector where each component is the minimal
    /// scalar value at each index for both vectors.
    public static func pointwiseMin(_ lhs: Self, _ rhs: Self) -> Self {
        return simd.min(lhs, rhs)
    }
    
    /// Returns the pointwise maximal Vector where each component is the maximal
    /// scalar value at each index for both vectors.
    public static func pointwiseMax(_ lhs: Self, _ rhs: Self) -> Self {
        return simd.max(lhs, rhs)
    }
    
    @inlinable
    public static func % (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x.truncatingRemainder(dividingBy: rhs.x),
                    y: lhs.y.truncatingRemainder(dividingBy: rhs.y))
    }
    
    @inlinable
    public static func % (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x.truncatingRemainder(dividingBy: rhs),
                    y: lhs.y.truncatingRemainder(dividingBy: rhs))
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than `rhs`.
    ///
    /// Performs `lhs.x > rhs.x && lhs.y > rhs.y`
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.x > rhs.x && lhs.y > rhs.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than or equal to `rhs`.
    ///
    /// Performs `lhs.x >= rhs.x && lhs.y >= rhs.y`
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.x >= rhs.x && lhs.y >= rhs.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than `rhs`.
    ///
    /// Performs `lhs.x < rhs.x && lhs.y < rhs.y`
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than or equal to `rhs`.
    ///
    /// Performs `lhs.x <= rhs.x && lhs.y <= rhs.y`
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.x <= rhs.x && lhs.y <= rhs.y
    }
}
