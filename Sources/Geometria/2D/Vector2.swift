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
    @inlinable
    public var description: String {
        "\(type(of: self))(x: \(x), y: \(y))"
    }
    
    @_transparent
    public init(x: Scalar, y: Scalar) {
        self.x = x
        self.y = y
    }
    
    @_transparent
    public init(repeating scalar: Scalar) {
        self.init(x: scalar, y: scalar)
    }
}

extension Vector2: Equatable where Scalar: Equatable { }
extension Vector2: Hashable where Scalar: Hashable { }
extension Vector2: Encodable where Scalar: Encodable { }
extension Vector2: Decodable where Scalar: Decodable { }

// swiftlint:disable shorthand_operator
extension Vector2: VectorComparable where Scalar: Comparable {
    /// Returns the pointwise minimal Vector where each component is the minimal
    /// scalar value at each index for both vectors.
    @_transparent
    public static func pointwiseMin(_ lhs: Self, _ rhs: Self) -> Self {
        Self(x: min(lhs.x, rhs.x), y: min(lhs.y, rhs.y))
    }
    
    /// Returns the pointwise maximal Vector where each component is the maximal
    /// scalar value at each index for both vectors.
    @_transparent
    public static func pointwiseMax(_ lhs: Self, _ rhs: Self) -> Self {
        Self(x: max(lhs.x, rhs.x), y: max(lhs.y, rhs.y))
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

extension Vector2: AdditiveArithmetic where Scalar: AdditiveArithmetic {
    /// A zero-value `Vector2` value where each component corresponds to its
    /// representation of `0`.
    @_transparent
    public static var zero: Self {
        Self(x: .zero, y: .zero)
    }
}

extension Vector2: VectorAdditive where Scalar: AdditiveArithmetic {
    /// Initializes a zero-valued `Vector2Type`
    @_transparent
    public init() {
        self = .zero
    }
    
    @_transparent
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    @_transparent
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    @_transparent
    public static func + (lhs: Self, rhs: Scalar) -> Self {
        Self(x: lhs.x + rhs, y: lhs.y + rhs)
    }
    
    @_transparent
    public static func - (lhs: Self, rhs: Scalar) -> Self {
        Self(x: lhs.x - rhs, y: lhs.y - rhs)
    }
    
    @_transparent
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @_transparent
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @_transparent
    public static func += (lhs: inout Self, rhs: Scalar) {
        lhs = lhs + rhs
    }
    
    @_transparent
    public static func -= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs - rhs
    }
}

extension Vector2: VectorMultiplicative where Scalar: Numeric {
    /// A unit-value `Vector2Type` value where each component corresponds to its
    /// representation of `1`.
    @_transparent
    public static var one: Self {
        Self(x: 1, y: 1)
    }
    
    /// Calculates the dot product between this and another provided `Vector2Type`
    @_transparent
    public func dot(_ other: Self) -> Scalar {
        // Doing this in separate statements to ease long compilation times in
        // Xcode 12
        let dx = x * other.x
        let dy = y * other.y
        
        return dx + dy
    }
    
    @_transparent
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    @_transparent
    public static func * (lhs: Self, rhs: Scalar) -> Self {
        Self(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    @_transparent
    public static func * (lhs: Scalar, rhs: Self) -> Self {
        Self(x: lhs * rhs.x, y: lhs * rhs.y)
    }
    
    @_transparent
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @_transparent
    public static func *= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs * rhs
    }
}

extension Vector2: Vector2Multiplicative where Scalar: Numeric {
    @_transparent
    public func cross(_ other: Self) -> Scalar {
        // Doing this in separate statements to ease long compilation times in
        // Xcode 12
        let d1 = (x * other.y)
        let d2 = (y * other.x)
        
        return d1 - d2
    }
}

extension Vector2: VectorSigned where Scalar: SignedNumeric & Comparable {
    /// Returns a `Vector2` where each component is the absolute value of the
    /// components of this `Vector2`.
    @_transparent
    public var absolute: Self {
        Self(x: abs(x), y: abs(y))
    }
    
    @_transparent
    public var sign: Self {
        Self(x: x < 0 ? -1 : (x > 0 ? 1 : 0),
             y: y < 0 ? -1 : (y > 0 ? 1 : 0))
    }
    
    /// Negates this Vector
    @_transparent
    public static prefix func - (lhs: Self) -> Self {
        Self(x: -lhs.x, y: -lhs.y)
    }
}

extension Vector2: Vector2Signed where Scalar: SignedNumeric & Comparable {
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

extension Vector2: VectorDivisible where Scalar: DivisibleArithmetic {
    @_transparent
    public static func / (lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
    @_transparent
    public static func / (lhs: Self, rhs: Scalar) -> Self {
        Self(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
    @_transparent
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @_transparent
    public static func /= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs / rhs
    }
}
// swiftlint:enable shorthand_operator

extension Vector2: VectorFloatingPoint where Scalar: DivisibleArithmetic & FloatingPoint {
    /// Returns the result of adding the product of the two given vectors to this
    /// vector, computed without intermediate rounding.
    ///
    /// This method is equivalent to calling C `fma` function on each component.
    ///
    /// - Parameters:
    ///   - lhs: One of the vectors to multiply before adding to this vector.
    ///   - rhs: The other vector to multiply.
    /// - Returns: The product of `lhs` and `rhs`, added to this vector.
    public func addingProduct(_ a: Self, _ b: Self) -> Self {
        Self(x: x.addingProduct(a.x, b.x), y: y.addingProduct(a.y, b.y))
    }
    
    /// Returns the result of adding the product of the given scalar and vector
    /// to this vector, computed without intermediate rounding.
    ///
    /// This method is equivalent to calling C `fma` function on each component.
    ///
    /// - Parameters:
    ///   - lhs: A scalar to multiply before adding to this vector.
    ///   - rhs: A vector to multiply.
    /// - Returns: The product of `lhs` and `rhs`, added to this vector.
    public func addingProduct(_ a: Scalar, _ b: Self) -> Self {
        Self(x: x.addingProduct(a, b.x), y: y.addingProduct(a, b.y))
    }
    
    /// Returns the result of adding the product of the given vector and scalar
    /// to this vector, computed without intermediate rounding.
    ///
    /// This method is equivalent to calling C `fma` function on each component.
    ///
    /// - Parameters:
    ///   - lhs: A vector to multiply before adding to this vector.
    ///   - rhs: A scalar to multiply.
    /// - Returns: The product of `lhs` and `rhs`, added to this vector.
    public func addingProduct(_ a: Self, _ b: Scalar) -> Self {
        Self(x: x.addingProduct(a.x, b), y: y.addingProduct(a.y, b))
    }
    
    /// Rounds the components of this `Vector2Type` using a given
    /// `FloatingPointRoundingRule`.
    @_transparent
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        Self(x: x.rounded(rule), y: y.rounded(rule))
    }
    
    /// Rounds the components of this `Vector2Type` using a given
    /// `FloatingPointRoundingRule.toNearestOrAwayFromZero`.
    ///
    /// Equivalent to calling C's round() function on each component.
    @_transparent
    public func rounded() -> Self {
        rounded(.toNearestOrAwayFromZero)
    }
    
    /// Rounds the components of this `Vector2Type` using a given
    /// `FloatingPointRoundingRule.up`.
    ///
    /// Equivalent to calling C's ceil() function on each component.
    @_transparent
    public func ceil() -> Self {
        rounded(.up)
    }
    
    /// Rounds the components of this `Vector2Type` using a given
    /// `FloatingPointRoundingRule.down`.
    ///
    /// Equivalent to calling C's floor() function on each component.
    @_transparent
    public func floor() -> Self {
        rounded(.down)
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

extension Vector2: Vector2FloatingPoint where Scalar: DivisibleArithmetic & FloatingPoint {
    @_transparent
    public init<V: Vector2Type>(_ vec: V) where V.Scalar: BinaryInteger {
        self.init(x: Scalar(vec.x), y: Scalar(vec.y))
    }
}

extension Vector2: VectorReal where Scalar: DivisibleArithmetic & Real {
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

extension Vector2: Vector2Real where Scalar: DivisibleArithmetic & Real {
    /// Returns the angle in radians of the line formed by tracing from the
    /// origin (0, 0) to this `Vector2`.
    @_transparent
    public var angle: Scalar {
        Scalar.atan2(y: y, x: x)
    }
    
    /// Returns a rotated version of this vector, rotated around the origin by a
    /// given angle in radians
    @_transparent
    public func rotated(by angleInRadians: Scalar) -> Self {
        Self.rotate(self, by: angleInRadians)
    }
    
    /// Rotates this vector around the origin by a given angle in radians
    @_transparent
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
        
        let x: Scalar = (c * vec.x) as Scalar - (s * vec.y) as Scalar
        let y: Scalar = (c * vec.y) as Scalar + (s * vec.x) as Scalar
        
        return Self(x: x, y: y)
    }
    
    /// Creates a matrix that when multiplied with a Vector object applies the
    /// given set of transformations.
    ///
    /// If all default values are set, an identity matrix is created, which does
    /// not alter a Vector's coordinates once applied.
    ///
    /// The order of operations are: scaling -> rotation -> translation
    @_transparent
    public static func matrix(scale: Self = .one,
                              rotate angle: Scalar = 0,
                              translate: Self = Self(x: 0, y: 0)) -> Matrix2<Scalar> {
        
        Matrix2<Scalar>.transformation(xScale: scale.x,
                                       yScale: scale.y,
                                       angle: angle,
                                       xOffset: translate.x,
                                       yOffset: translate.y)
    }
    
    @_transparent
    public static func * (lhs: Self, rhs: Matrix2<Scalar>) -> Self {
        Matrix2<Scalar>.transformPoint(matrix: rhs, point: lhs)
    }
    
    @_transparent
    public static func *= (lhs: inout Self, rhs: Matrix2<Scalar>) {
        lhs = Matrix2<Scalar>.transformPoint(matrix: rhs, point: lhs)
    }
}
