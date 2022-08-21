#if canImport(simd)

import RealModule
import simd

extension SIMD3: VectorType {
    
}

extension SIMD3: VectorTakeable where Scalar == Double {
    public typealias SubVector2 = SIMD2<Scalar>
    public typealias SubVector4 = SIMD4<Scalar>
}

extension SIMD3: Vector3Type where Scalar == Double {
    
}

extension SIMD3: VectorComparable where Scalar == Double {
    /// Returns the pointwise minimal Vector where each component is the minimal
    /// scalar value at each index for both vectors.
    @_transparent
    public static func pointwiseMin(_ lhs: Self, _ rhs: Self) -> Self {
        simd.min(lhs, rhs)
    }
    
    /// Returns the pointwise maximal Vector where each component is the maximal
    /// scalar value at each index for both vectors.
    @_transparent
    public static func pointwiseMax(_ lhs: Self, _ rhs: Self) -> Self {
        simd.max(lhs, rhs)
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than `rhs`.
    ///
    /// Performs `lhs.x > rhs.x && lhs.y > rhs.y && lhs.z > rhs.z`
    @_transparent
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.x > rhs.x && lhs.y > rhs.y && lhs.z > rhs.z
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than or equal to `rhs`.
    ///
    /// Performs `lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z`
    @_transparent
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than `rhs`.
    ///
    /// Performs `lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z`
    @_transparent
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than or equal to `rhs`.
    ///
    /// Performs `lhs.x <= rhs.x && lhs.y <= rhs.y && lhs.z <= rhs.z`
    @_transparent
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.x <= rhs.x && lhs.y <= rhs.y && lhs.z <= rhs.z
    }
}

extension SIMD3: AdditiveArithmetic where Scalar: FloatingPoint {
    
}

extension SIMD3: VectorAdditive where Scalar: FloatingPoint {
    
}

extension SIMD3: VectorMultiplicative where Scalar == Double {
    @_transparent
    public var lengthSquared: Scalar {
        length_squared(self)
    }
    
    @_transparent
    public func distanceSquared(to vec: Self) -> Scalar {
        distance_squared(self, vec)
    }
    
    @_transparent
    public func dot(_ other: Self) -> Scalar {
        simd.dot(self, other)
    }
}

extension SIMD3: Vector3Additive where Scalar == Double {
    
}

extension SIMD3: Vector3Multiplicative where Scalar == Double {
    
}

extension SIMD3: VectorSigned where Scalar == Double {
    @_transparent
    public var absolute: Self {
        simd.abs(self)
    }
    
    @_transparent
    public var sign: Self {
        simd.sign(self)
    }
}

extension SIMD3: VectorDivisible where Scalar == Double {
    
}

extension SIMD3: VectorFloatingPoint where Scalar == Double {
    /// Returns the Euclidean norm (square root of the squared length) of this
    /// `Vector2Type`
    @_transparent
    public var length: Scalar {
        simd.length(self)
    }
    
    /// Returns the distance between this `Vector2Type` and another `Vector2Type`
    @_transparent
    public func distance(to vec: Self) -> Scalar {
        simd.distance(self, vec)
    }
    
    @_transparent
    public mutating func normalize() {
        self = normalized()
    }
    
    @inlinable
    public func normalized() -> Self {
        if lengthSquared == 0 {
            return .zero
        }
        
        return simd.normalize(self)
    }
    
    @_transparent
    public func rounded() -> Self {
        self.rounded(.toNearestOrAwayFromZero)
    }
    
    @_transparent
    public func ceil() -> Self {
        self.rounded(.up)
    }
    
    @_transparent
    public func floor() -> Self {
        self.rounded(.down)
    }
    
    @_transparent
    public static func % (lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x.truncatingRemainder(dividingBy: rhs.x),
             y: lhs.y.truncatingRemainder(dividingBy: rhs.y),
             z: lhs.z.truncatingRemainder(dividingBy: rhs.z))
    }
    
    @_transparent
    public static func % (lhs: Self, rhs: Scalar) -> Self {
        Self(x: lhs.x.truncatingRemainder(dividingBy: rhs),
             y: lhs.y.truncatingRemainder(dividingBy: rhs),
             z: lhs.z.truncatingRemainder(dividingBy: rhs))
    }
}

extension SIMD3: SignedDistanceMeasurableType where Scalar == Double {
    @_transparent
    public func signedDistance(to other: Self) -> Scalar {
        (self - other).length
    }
}

extension SIMD3: Vector3FloatingPoint where Scalar == Double {
    @_transparent
    public init<V>(_ other: V) where V: Vector3Type, V.Scalar: BinaryInteger {
        self.init(x: Scalar(other.x), y: Scalar(other.y), z: Scalar(other.z))
    }
}

extension SIMD3: VectorReal where Scalar == Double {
    @_transparent
    public static func pow(_ vec: Self, _ exponent: Int) -> Self {
        Self(x: Scalar.pow(vec.x, exponent),
             y: Scalar.pow(vec.y, exponent),
             z: Scalar.pow(vec.z, exponent))
    }
    
    @_transparent
    public static func pow(_ vec: Self, _ exponent: Self) -> Self {
        Self(x: Scalar.pow(vec.x, exponent.x),
             y: Scalar.pow(vec.y, exponent.y),
             z: Scalar.pow(vec.z, exponent.z))
    }
}

extension SIMD3: Vector3Real where Scalar == Double {
    /// The XY-plane angle of this vector
    @_transparent
    public var azimuth: Scalar {
        Scalar.atan2(y: y, x: x)
    }
    
    /// The elevation angle of this vector, or the angle between the XY plane
    /// and the vector.
    ///
    /// Returns zero, if the vector's length is zero.
    @inlinable
    public var elevation: Scalar {
        let l = length
        if l == .zero {
            return .zero
        }
        
        return Scalar.asin(z / l)
    }
}

#endif
