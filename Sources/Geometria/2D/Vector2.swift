import RealModule

/// Represents a 2D point with two double-precision floating-point components
public typealias Vector2D = Vector2<Double>

/// Represents a 2D point with two single-precision floating-point components
public typealias Vector2F = Vector2<Float>

/// Represents a 2D point with two `Int` components
public typealias Vector2i = Vector2<Int>

/// A two-component vector type
public struct Vector2<Scalar>: Vector2Type {
    /// X coordinate of this vector
    public var x: Scalar
    
    /// Y coordinate of this vector
    public var y: Scalar
    
    /// Textual representation of this `Vector2`
    public var description: String {
        return "\(type(of: self))(x: \(self.x), y: \(self.y))"
    }
    
    /// Creates a new `Vector2` with the given coordinates
    public init(x: Scalar, y: Scalar) {
        self.x = x
        self.y = y
    }
    
    /// Creates a new `Vector2` with the given scalar on all coordinates
    @inlinable
    public init(repeating scalar: Scalar) {
        self.init(x: scalar, y: scalar)
    }
}

extension Vector2: Equatable where Scalar: Equatable { }
extension Vector2: Hashable where Scalar: Hashable { }
extension Vector2: Encodable where Scalar: Encodable { }
extension Vector2: Decodable where Scalar: Decodable { }

extension Vector2: VectorComparable where Scalar: Comparable {
    /// Returns the pointwise minimal Vector where each component is the minimal
    /// scalar value at each index for both vectors.
    public static func pointwiseMin(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(x: min(lhs.x, rhs.x), y: min(lhs.y, rhs.y))
    }
    
    /// Returns the pointwise maximal Vector where each component is the maximal
    /// scalar value at each index for both vectors.
    public static func pointwiseMax(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(x: max(lhs.x, rhs.x), y: max(lhs.y, rhs.y))
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

extension Vector2: AdditiveArithmetic where Scalar: AdditiveArithmetic {
    
}

extension Vector2: VectorAdditive where Scalar: AdditiveArithmetic {
    /// A zero-value `Vector2` value where each component corresponds to its
    /// representation of `0`.
    @inlinable
    public static var zero: Self {
        return Self(x: .zero, y: .zero)
    }
    
    /// Initializes a zero-valued `Vector2Type`
    @inlinable
    public init() {
        self = .zero
    }
    
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    @inlinable
    public static func + (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x + rhs, y: lhs.y + rhs)
    }
    
    @inlinable
    public static func - (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x - rhs, y: lhs.y - rhs)
    }
    
    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    public static func += (lhs: inout Self, rhs: Scalar) {
        lhs = lhs + rhs
    }
    
    @inlinable
    public static func -= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs - rhs
    }
}

extension Vector2: VectorMultiplicative where Scalar: Numeric {
    /// A unit-value `Vector2Type` value where each component corresponds to its
    /// representation of `1`.
    public static var one: Self {
        return Self(x: 1, y: 1)
    }
    
    /// Returns the length squared of this `Vector2Type`
    @inlinable
    public var lengthSquared: Scalar {
        return x * x + y * y
    }
    
    /// Returns the distance squared between this `Vector2Type` and another `Vector2Type`
    @inlinable
    public func distanceSquared(to vec: Self) -> Scalar {
        let d = self - vec
        
        return d.lengthSquared
    }
    
    /// Calculates the dot product between this and another provided `Vector2Type`
    @inlinable
    public func dot(_ other: Self) -> Scalar {
        return x * other.x + y * other.y
    }
    
    /// Returns the vector that lies within this and another vector's ratio line
    /// projected at a specified ratio along the line created by the vectors.
    ///
    /// A vector on ratio of 0 is the same as this vector's position, and 1 is the
    /// same as the other vector's position.
    ///
    /// Values beyond 0 - 1 range project the point across the limits of the line.
    ///
    /// - Parameters:
    ///   - ratio: A ratio (usually 0 through 1) between this and the second vector.
    ///   - other: The second vector to form the line that will have the point
    /// projected onto.
    /// - Returns: A vector that lies within the line created by the two vectors.
    @inlinable
    public func ratio(_ ratio: Scalar, to other: Self) -> Self {
        return self * (1 - ratio) + other * ratio
    }
    
    /// Performs a linear interpolation between two points.
    ///
    /// Passing `amount` a value of 0 will cause `start` to be returned; a value
    /// of 1 will cause `end` to be returned.
    ///
    /// - Parameter start: Start point.
    /// - Parameter end: End point.
    /// - Parameter amount: Value between 0 and 1 indicating the weight of `end`.
    public static func lerp(start: Self, end: Self, amount: Scalar) -> Self {
        return start.ratio(amount, to: end)
    }
    
    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    @inlinable
    public static func * (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    public static func *= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs * rhs
    }
}

extension Vector2: Vector2Multiplicative where Scalar: Numeric {
    /// Calculates the cross product between this and another provided Vector.
    /// The resulting scalar would match the 'z' axis of the cross product
    /// between 3d vectors matching the x and y coordinates of the operands, with
    /// the 'z' coordinate being 0.
    @inlinable
    public func cross(_ other: Self) -> Scalar {
        return (x * other.y) - (y * other.x)
    }
}

extension Vector2: VectorSigned where Scalar: SignedNumeric & Comparable {
    /// Returns a `Vector2` where each component is the absolute value of the
    /// components of this `Vector2`.
    public var absolute: Self {
        return Self(x: abs(x), y: abs(y))
    }
    
    /// Negates this Vector
    @inlinable
    public static prefix func - (lhs: Self) -> Self {
        return Self(x: -lhs.x, y: -lhs.y)
    }
}

extension Vector2: Vector2Signed where Scalar: SignedNumeric & Comparable {
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

extension Vector2: VectorDivisible where Scalar: DivisibleArithmetic {
    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
    @inlinable
    public static func / (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
    @inlinable
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    public static func /= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs / rhs
    }
}

extension Vector2: VectorNormalizable where Scalar: Comparable & Real & DivisibleArithmetic {
    /// Normalizes this Vector instance.
    ///
    /// Returns `Vector2.zero` if the vector has `length == 0`.
    @inlinable
    public mutating func normalize() {
        self = normalized()
    }
    
    /// Returns a normalized version of this vector.
    ///
    /// Returns `Vector2.zero` if the vector has `length == 0`.
    @inlinable
    public func normalized() -> Self {
        let l = length
        if l <= 0 {
            return .zero
        }
        
        return self / l
    }
}

extension Vector2: VectorFloatingPoint where Scalar: DivisibleArithmetic & FloatingPoint {
    /// Rounds the components of this `Vector2Type` using a given
    /// `FloatingPointRoundingRule`.
    @inlinable
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        return Self(x: x.rounded(rule), y: y.rounded(rule))
    }
    
    /// Rounds the components of this `Vector2Type` using a given
    /// `FloatingPointRoundingRule.toNearestOrAwayFromZero`.
    ///
    /// Equivalent to calling C's round() function on each component.
    @inlinable
    public func rounded() -> Self {
        return rounded(.toNearestOrAwayFromZero)
    }
    
    /// Rounds the components of this `Vector2Type` using a given
    /// `FloatingPointRoundingRule.up`.
    ///
    /// Equivalent to calling C's ceil() function on each component.
    @inlinable
    public func ceil() -> Self {
        return rounded(.up)
    }
    
    /// Rounds the components of this `Vector2Type` using a given
    /// `FloatingPointRoundingRule.down`.
    ///
    /// Equivalent to calling C's floor() function on each component.
    @inlinable
    public func floor() -> Self {
        return rounded(.down)
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

extension Vector2: Vector2FloatingPoint where Scalar: DivisibleArithmetic & FloatingPoint {
    public init<V: Vector2Type>(_ vec: V) where V.Scalar: BinaryInteger {
        self.init(x: Scalar(vec.x), y: Scalar(vec.y))
    }
}

extension Vector2: VectorReal where Scalar: DivisibleArithmetic & Real {
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
        return Self.pow(vec, Self(x: n, y: n))
    }
    
    @inlinable
    public static func pow(_ vec: Self, _ n: Int) -> Self {
        return Self(x: Scalar.pow(vec.x, n),
                    y: Scalar.pow(vec.y, n))
    }
    
    @inlinable
    public static func pow(_ vec: Self, _ n: Self) -> Self {
        return Self(x: Scalar.pow(vec.x, n.x),
                    y: Scalar.pow(vec.y, n.y))
    }
}

extension Vector2: Vector2Real where Scalar: DivisibleArithmetic & Real {
    /// Returns the angle in radians of the line formed by tracing from the
    /// origin (0, 0) to this `Vector2`.
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
