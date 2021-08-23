import RealModule
import simd

extension SIMD3: VectorType {
    
}

extension SIMD3: Vector3Type where Scalar == Double {
    
}

extension SIMD3: VectorNormalizable where Scalar == Double {
    public mutating func normalize() {
        self = normalized()
    }
    
    public func normalized() -> SIMD3<Scalar> {
        if self.lengthSquared == 0 {
            return .zero
        }
        
        return simd.normalize(self)
    }
}

extension SIMD3: VectorComparable where Scalar == Double {
    /// Returns the pointwise minimal Vector where each component is the minimal
    /// scalar value at each index for both vectors.
    @inlinable
    public static func pointwiseMin(_ lhs: Self, _ rhs: Self) -> Self {
        return simd.min(lhs, rhs)
    }
    
    /// Returns the pointwise maximal Vector where each component is the maximal
    /// scalar value at each index for both vectors.
    @inlinable
    public static func pointwiseMax(_ lhs: Self, _ rhs: Self) -> Self {
        return simd.max(lhs, rhs)
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than `rhs`.
    ///
    /// Performs `lhs.x > rhs.x && lhs.y > rhs.y && lhs.z > rhs.z`
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.x > rhs.x && lhs.y > rhs.y && lhs.z > rhs.z
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than or equal to `rhs`.
    ///
    /// Performs `lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z`
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than `rhs`.
    ///
    /// Performs `lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z`
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than or equal to `rhs`.
    ///
    /// Performs `lhs.x <= rhs.x && lhs.y <= rhs.y && lhs.z <= rhs.z`
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.x <= rhs.x && lhs.y <= rhs.y && lhs.z <= rhs.z
    }
}

extension SIMD3: VectorAdditive where Scalar: FloatingPoint {
    
}

extension SIMD3: VectorMultiplicative where Scalar == Double {
    @inlinable
    public func distanceSquared(to vec: SIMD3<Scalar>) -> Scalar {
        return distance_squared(self, vec)
    }
    
    @inlinable
    public func dot(_ other: SIMD3<Scalar>) -> Scalar {
        return simd.dot(self, other)
    }
    
    @inlinable
    public func ratio(_ ratio: Scalar, to other: SIMD3<Scalar>) -> SIMD3<Scalar> {
        return (1 - ratio) * self + ratio * other
    }
    
    @inlinable
    public static func lerp(start: SIMD3<Scalar>, end: SIMD3<Scalar>, amount: Scalar) -> SIMD3<Scalar> {
        start.ratio(amount, to: end)
    }
}

extension SIMD3: VectorSigned where Scalar == Double {
    @inlinable
    public var absolute: SIMD3<Scalar> {
        return simd.abs(self)
    }
}

extension SIMD3: VectorDivisible where Scalar == Double {
    
}

extension SIMD3: VectorFloatingPoint where Scalar == Double {
    @inlinable
    public var lengthSquared: Scalar {
        return length_squared(self)
    }
    
    @inlinable
    public func rounded() -> SIMD3<Scalar> {
        return self.rounded(.toNearestOrAwayFromZero)
    }
    
    @inlinable
    public func ceil() -> SIMD3<Scalar> {
        return self.rounded(.up)
    }
    
    @inlinable
    public func floor() -> SIMD3<Scalar> {
        return self.rounded(.down)
    }
    
    @inlinable
    public static func % (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x.truncatingRemainder(dividingBy: rhs.x),
                    y: lhs.y.truncatingRemainder(dividingBy: rhs.y),
                    z: lhs.z.truncatingRemainder(dividingBy: rhs.z))
    }
    
    @inlinable
    public static func % (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x.truncatingRemainder(dividingBy: rhs),
                    y: lhs.y.truncatingRemainder(dividingBy: rhs),
                    z: lhs.z.truncatingRemainder(dividingBy: rhs))
    }
}

extension SIMD3: Vector3FloatingPoint where Scalar == Double {
    public init<V>(_ other: V) where V : Vector3Type, V.Scalar : BinaryInteger {
        self.init(x: Scalar(other.x), y: Scalar(other.y), z: Scalar(other.z))
    }
}

extension SIMD3: VectorReal where Scalar == Double {
    /// Returns the Euclidean norm (square root of the squared length) of this
    /// `Vector2Type`
    @inlinable
    public var length: Scalar {
        return Scalar.sqrt(lengthSquared)
    }
    
    /// Returns the distance between this `Vector2Type` and another `Vector2Type`
    @inlinable
    public func distance(to vec: Self) -> Scalar {
        return Scalar.sqrt(self.distanceSquared(to: vec))
    }
    
    @inlinable
    public static func pow(_ vec: Self, _ n: Scalar) -> Self {
        return Self.pow(vec, Self(x: n, y: n, z: n))
    }
    
    @inlinable
    public static func pow(_ vec: Self, _ n: Int) -> Self {
        return Self(x: Scalar.pow(vec.x, n),
                    y: Scalar.pow(vec.y, n),
                    z: Scalar.pow(vec.z, n))
    }
    
    @inlinable
    public static func pow(_ vec: Self, _ n: Self) -> Self {
        return Self(x: Scalar.pow(vec.x, n.x),
                    y: Scalar.pow(vec.y, n.y),
                    z: Scalar.pow(vec.z, n.z))
    }
}
