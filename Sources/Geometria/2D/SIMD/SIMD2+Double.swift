#if canImport(simd)

import RealModule
import simd

extension SIMD2: VectorType {
    
}

extension SIMD2: Vector2Type where Scalar == Double {
    
}

extension SIMD2: VectorComparable where Scalar == Double {
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
    /// Performs `lhs.x > rhs.x && lhs.y > rhs.y`
    @_transparent
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.x > rhs.x && lhs.y > rhs.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than or equal to `rhs`.
    ///
    /// Performs `lhs.x >= rhs.x && lhs.y >= rhs.y`
    @_transparent
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.x >= rhs.x && lhs.y >= rhs.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than `rhs`.
    ///
    /// Performs `lhs.x < rhs.x && lhs.y < rhs.y`
    @_transparent
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than or equal to `rhs`.
    ///
    /// Performs `lhs.x <= rhs.x && lhs.y <= rhs.y`
    @_transparent
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.x <= rhs.x && lhs.y <= rhs.y
    }
}

extension SIMD2: AdditiveArithmetic where Scalar: FloatingPoint {
    
}

extension SIMD2: VectorAdditive where Scalar: FloatingPoint {
    
}

extension SIMD2: Vector2Additive where Scalar == Double {
    
}

extension SIMD2: VectorMultiplicative where Scalar == Double {
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

extension SIMD2: Vector2Multiplicative where Scalar == Double {
    @_transparent
    public func cross(_ other: Self) -> Scalar {
        simd.cross(self, other).z
    }
}

extension SIMD2: VectorSigned where Scalar == Double {
    @_transparent
    public var absolute: Self {
        simd.abs(self)
    }
    
    @_transparent
    public var sign: Self {
        simd.sign(self)
    }
}

extension SIMD2: Vector2Signed where Scalar == Double {
    /// Makes this Vector perpendicular to its current position relative to the
    /// origin.
    /// This alters the vector instance.
    @_transparent
    public mutating func formPerpendicular() {
        self = perpendicular()
    }
    
    /// Returns a Vector perpendicular to this Vector relative to the origin
    @_transparent
    public func perpendicular() -> Self {
        Self(x: -y, y: x)
    }
    
    /// Returns a vector that represents this vector's point, rotated 90º counter
    /// clockwise relative to the origin.
    @_transparent
    public func leftRotated() -> Self {
        Self(x: -y, y: x)
    }
    
    /// Rotates this vector 90º counter clockwise relative to the origin.
    /// This alters the vector instance.
    @_transparent
    public mutating func formLeftRotated() {
        self = leftRotated()
    }
    
    /// Returns a vector that represents this vector's point, rotated 90º clockwise
    /// clockwise relative to the origin.
    @_transparent
    public func rightRotated() -> Self {
        Self(x: y, y: -x)
    }
    
    /// Rotates this vector 90º clockwise relative to the origin.
    /// This alters the vector instance.
    @_transparent
    public mutating func formRightRotated() {
        self = rightRotated()
    }
}

extension SIMD2: VectorDivisible where Scalar == Double {
    
}

extension SIMD2: VectorFloatingPoint where Scalar == Double {
    /// Returns the Euclidean norm (square root of the squared length) of this
    /// `Vector2Type`
    @_transparent
    public var length: Scalar {
        simd.length(self)
    }
    
    @_transparent
    public mutating func normalize() {
        self = normalized()
    }
    
    @_transparent
    public func normalized() -> Self {
        if lengthSquared == 0 {
            return .zero
        }
        
        return simd.normalize(self)
    }
    
    /// Returns the distance between this `Vector2Type` and another `Vector2Type`
    @_transparent
    public func distance(to vec: Self) -> Scalar {
        simd.distance(self, vec)
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
             y: lhs.y.truncatingRemainder(dividingBy: rhs.y))
    }
    
    @_transparent
    public static func % (lhs: Self, rhs: Scalar) -> Self {
        Self(x: lhs.x.truncatingRemainder(dividingBy: rhs),
             y: lhs.y.truncatingRemainder(dividingBy: rhs))
    }
}

extension SIMD2: Vector2FloatingPoint where Scalar == Double {
    @_transparent
    public init<V>(_ other: V) where V: Vector2Type, V.Scalar: BinaryInteger {
        self.init(x: Scalar(other.x), y: Scalar(other.y))
    }
}

extension SIMD2: VectorReal where Scalar == Double {
    @_transparent
    public static func pow(_ vec: Self, _ exponent: Int) -> Self {
        Self(x: Scalar.pow(vec.x, exponent),
             y: Scalar.pow(vec.y, exponent))
    }
    
    @_transparent
    public static func pow(_ vec: Self, _ exponent: Self) -> Self {
        Self(x: Scalar.pow(vec.x, exponent.x),
             y: Scalar.pow(vec.y, exponent.y))
    }
}

extension SIMD2: Vector2Real where Scalar == Double {
    /// Returns the angle in radians of the line formed by tracing from the
    /// origin (0, 0) to this `Vector2Type`.
    @_transparent
    public var angle: Scalar {
        Scalar.atan2(y: y, x: x)
    }
    
    /// Returns a rotated version of this vector, rotated around the origin by a
    /// given angle in radians
    @inlinable
    public func rotated(by angleInRadians: Scalar) -> Self {
        Self.rotate(self, by: angleInRadians)
    }
    
    /// Rotates this vector around the origin by a given angle in radians
    @inlinable
    public mutating func rotate(by angleInRadians: Scalar) {
        self = rotated(by: angleInRadians)
    }
    
    /// Rotates this vector around a given pivot by a given angle in radians
    @inlinable
    public func rotated(by angleInRadians: Scalar, around pivot: Self) -> Self {
        (self - pivot).rotated(by: angleInRadians) + pivot
    }
    
    /// Rotates a given vector around the origin by an angle in radians
    @inlinable
    public static func rotate(_ vec: Self, by angleInRadians: Scalar) -> Self {
        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(angleInRadians)
        
        return Self(x: (c * vec.x) - (s * vec.y), y: (c * vec.y) + (s * vec.x))
    }
    
    /// Creates a matrix that when multiplied with a Vector object applies the
    /// given set of transformations.
    ///
    /// If all default values are set, an identity matrix is created, which does
    /// not alter a Vector's coordinates once applied.
    ///
    /// The order of operations are: scaling -> rotation -> translation
    @inlinable
    public static func matrix(scale: Self = .one,
                              rotate angle: Scalar = 0,
                              translate: Self = Self(x: 0, y: 0)) -> Matrix2<Scalar> {
        
        Matrix2<Scalar>.transformation(xScale: scale.x,
                                       yScale: scale.y,
                                       angle: angle,
                                       xOffset: translate.x,
                                       yOffset: translate.y)
    }
    
    @inlinable
    public static func * (lhs: Self, rhs: Matrix2<Scalar>) -> Self {
        Matrix2<Scalar>.transformPoint(matrix: rhs, point: lhs)
    }
    
    @inlinable
    public static func *= (lhs: inout Self, rhs: Matrix2<Scalar>) {
        lhs = Matrix2<Scalar>.transformPoint(matrix: rhs, point: lhs)
    }
}

#endif
