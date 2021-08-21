import RealModule
import simd

extension SIMD2: VectorType {
    
}

extension SIMD2: VectorNormalizable where Scalar == Double {
    public mutating func normalize() {
        self = normalized()
    }
    
    public func normalized() -> SIMD2<Scalar> {
        if self.lengthSquared == 0 {
            return .zero
        }
        
        return simd.normalize(self)
    }
}

extension SIMD2: VectorComparable where Scalar == Double {
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

extension SIMD2: VectorAdditive where Scalar: FloatingPoint {
    
}

extension SIMD2: VectorMultiplicative where Scalar == Double {
    @inlinable
    public func distanceSquared(to vec: SIMD2<Scalar>) -> Scalar {
        return distance_squared(self, vec)
    }
    
    @inlinable
    public func dot(_ other: SIMD2<Scalar>) -> Scalar {
        return simd.dot(self, other)
    }
    
    @inlinable
    public func ratio(_ ratio: Scalar, to other: SIMD2<Scalar>) -> SIMD2<Scalar> {
        return (1 - ratio) * self + ratio * other
    }
    
    @inlinable
    public static func lerp(start: SIMD2<Scalar>, end: SIMD2<Scalar>, amount: Scalar) -> SIMD2<Scalar> {
        start.ratio(amount, to: end)
    }
}

extension SIMD2: Vector2Multiplicative where Scalar == Double {
    @inlinable
    public func cross(_ other: SIMD2<Scalar>) -> Scalar {
        return simd.cross(self, other).z
    }
}

extension SIMD2: VectorSigned where Scalar == Double {
    @inlinable
    public var absolute: SIMD2<Scalar> {
        return simd.abs(self)
    }
}

extension SIMD2: Vector2Signed where Scalar == Double {
    /// Makes this Vector perpendicular to its current position relative to the
    /// origin.
    /// This alters the vector instance.
    @inlinable
    public mutating func formPerpendicular() {
        self = perpendicular()
    }
    
    /// Returns a Vector perpendicular to this Vector relative to the origin
    @inlinable
    public func perpendicular() -> Self {
        return Self(x: -y, y: x)
    }
    
    /// Returns a vector that represents this vector's point, rotated 90º counter
    /// clockwise relative to the origin.
    @inlinable
    public func leftRotated() -> Self {
        return Self(x: -y, y: x)
    }
    
    /// Rotates this vector 90º counter clockwise relative to the origin.
    /// This alters the vector instance.
    @inlinable
    public mutating func formLeftRotated() {
        self = leftRotated()
    }
    
    /// Returns a vector that represents this vector's point, rotated 90º clockwise
    /// clockwise relative to the origin.
    @inlinable
    public func rightRotated() -> Self {
        return Self(x: y, y: -x)
    }
    
    /// Rotates this vector 90º clockwise relative to the origin.
    /// This alters the vector instance.
    @inlinable
    public mutating func formRightRotated() {
        self = rightRotated()
    }
}

extension SIMD2: VectorDivisible where Scalar == Double {
    
}

extension SIMD2: VectorReal where Scalar == Double {
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
}

extension SIMD2: Vector2Real where Scalar == Double {
    /// Returns the angle in radians of the line formed by tracing from the
    /// origin (0, 0) to this `Vector2Type`.
    @inlinable
    public var angle: Scalar {
        return Scalar.atan2(y: y, x: x)
    }
    
    /// Returns a rotated version of this vector, rotated around the origin by a
    /// given angle in radians
    @inlinable
    public func rotated(by angleInRadians: Scalar) -> Self {
        return Self.rotate(self, by: angleInRadians)
    }
    
    /// Rotates this vector around the origin by a given angle in radians
    @inlinable
    public mutating func rotate(by angleInRadians: Scalar) {
        self = rotated(by: angleInRadians)
    }
    
    /// Rotates this vector around a given pivot by a given angle in radians
    @inlinable
    public func rotated(by angleInRadians: Scalar, around pivot: Self) -> Self {
        return (self - pivot).rotated(by: angleInRadians) + pivot
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
        
        return Matrix2<Scalar>.transformation(xScale: scale.x,
                                              yScale: scale.y,
                                              angle: angle,
                                              xOffset: translate.x,
                                              yOffset: translate.y)
    }
    
    @inlinable
    public static func * (lhs: Self, rhs: Matrix2<Scalar>) -> Self {
        return Matrix2<Scalar>.transformPoint(matrix: rhs, point: lhs)
    }
    
    @inlinable
    public static func *= (lhs: inout Self, rhs: Matrix2<Scalar>) {
        lhs = Matrix2<Scalar>.transformPoint(matrix: rhs, point: lhs)
    }
}

extension SIMD2: Vector2Type, VectorFloatingPoint where Scalar == Double {
    @inlinable
    public var lengthSquared: Scalar {
        return length_squared(self)
    }
    
    @inlinable
    public func rounded() -> SIMD2<Scalar> {
        return self.rounded(.toNearestOrAwayFromZero)
    }
    
    @inlinable
    public func ceil() -> SIMD2<Scalar> {
        return self.rounded(.up)
    }
    
    @inlinable
    public func floor() -> SIMD2<Scalar> {
        return self.rounded(.down)
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
}
