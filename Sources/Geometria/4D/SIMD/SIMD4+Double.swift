#if canImport(simd)

import simd

extension SIMD4: GeometricType, VectorType, Vector4Type where Scalar == Double {
    public typealias SubVector2 = SIMD2<Scalar>
    public typealias SubVector4 = SIMD4<Scalar>

    /// Defines the dimension of an indexed takeable getter.
    public enum TakeDimensions: Int {
        case x
        case y
        case z
        case w
    }
}

extension SIMD4: AdditiveArithmetic, VectorAdditive where Scalar == Double {
    
}

extension SIMD4: Vector4Additive where Scalar == Double {
    
}

extension SIMD4: VectorMultiplicative where Scalar == Double {
    public func dot(_ other: Self) -> Double {
        simd.dot(self, other)
    }
}

extension SIMD4: VectorComparable where Scalar == Double {
    
}

extension SIMD4: VectorSigned where Scalar == Double {
    
}

extension SIMD4: VectorDivisible where Scalar == Double {
    
}

extension SIMD4: VectorFloatingPoint where Scalar == Double {
    public var absolute: Self {
        simd.abs(self)
    }
    
    public var sign: Self {
        simd.sign(self)
    }
    
    public static func % (lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x.truncatingRemainder(dividingBy: rhs.x),
             y: lhs.y.truncatingRemainder(dividingBy: rhs.y),
             z: lhs.z.truncatingRemainder(dividingBy: rhs.z),
             w: lhs.w.truncatingRemainder(dividingBy: rhs.w))
    }
    
    public static func % (lhs: Self, rhs: Double) -> Self {
        Self(x: lhs.x.truncatingRemainder(dividingBy: rhs),
             y: lhs.y.truncatingRemainder(dividingBy: rhs),
             z: lhs.z.truncatingRemainder(dividingBy: rhs),
             w: lhs.w.truncatingRemainder(dividingBy: rhs))
    }
    
    public static func pointwiseMin(_ lhs: Self, _ rhs: Self) -> Self {
        simd.min(lhs, rhs)
    }
    
    public static func pointwiseMax(_ lhs: Self, _ rhs: Self) -> Self {
        simd.max(lhs, rhs)
    }
}

extension SIMD4: Vector4FloatingPoint where Scalar == Double {
    public init<V>(_ other: V) where V : Vector4Type, V.Scalar : BinaryInteger {
        self.init(x: Scalar(other.x), y: Scalar(other.y), z: Scalar(other.z), w: Scalar(other.w))
    }
}

extension SIMD4: SignedDistanceMeasurableType where Scalar == Double {
    public func signedDistance(to point: Self) -> Double {
        simd.distance(self, point)
    }
}

extension SIMD4: VectorReal where Scalar == Double {
    @_transparent
    public static func pow(_ vec: Self, _ exponent: Int) -> Self {
        Self(x: Scalar.pow(vec.x, exponent),
             y: Scalar.pow(vec.y, exponent),
             z: Scalar.pow(vec.z, exponent),
             w: Scalar.pow(vec.w, exponent))
    }
    
    @_transparent
    public static func pow(_ vec: Self, _ exponent: Self) -> Self {
        Self(x: Scalar.pow(vec.x, exponent.x),
             y: Scalar.pow(vec.y, exponent.y),
             z: Scalar.pow(vec.z, exponent.z),
             w: Scalar.pow(vec.w, exponent.w))
    }
}

#endif
