import RealModule

/// Protocol for types that can represent 2D vectors.
public protocol Vector2Type {
    associatedtype Scalar
    
    /// The X coordinate of this 2D vector.
    var x: Scalar { get set }
    
    /// The Y coordinate of this 2D vector.
    var y: Scalar { get set }
    
    /// Initializes this vector type with the given coordinates.
    init(x: Scalar, y: Scalar)
}

public extension Vector2Type {
    /// Creates a new `Vector2Type` with the given scalar on all coordinates
    @inlinable
    init(repeating scalar: Scalar) {
        self.init(x: scalar, y: scalar)
    }
}

public extension Vector2Type where Scalar: Comparable {
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than `rhs`.
    ///
    /// Performs `lhs.x > rhs.x && lhs.y > rhs.y`
    @inlinable
    static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.x > rhs.x && lhs.y > rhs.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than or equal to `rhs`.
    ///
    /// Performs `lhs.x >= rhs.x && lhs.y >= rhs.y`
    @inlinable
    static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.x >= rhs.x && lhs.y >= rhs.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than `rhs`.
    ///
    /// Performs `lhs.x < rhs.x && lhs.y < rhs.y`
    @inlinable
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than or equal to `rhs`.
    ///
    /// Performs `lhs.x <= rhs.x && lhs.y <= rhs.y`
    @inlinable
    static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.x <= rhs.x && lhs.y <= rhs.y
    }
}

public extension Vector2Type where Scalar: AdditiveArithmetic {
    /// A zero-value `Vector2` value where each component corresponds to its
    /// representation of `0`.
    static var zero: Self {
        return Self(x: .zero, y: .zero)
    }
    
    /// Initializes a zero-valued `Vector2Type`
    init() {
        self = .zero
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x + rhs, y: lhs.y + rhs)
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x - rhs, y: lhs.y - rhs)
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Scalar) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs - rhs
    }
}

public extension Vector2Type where Scalar: Numeric {
    /// A unit-value `Vector2` value where each component corresponds to its
    /// representation of `1`.
    static var unit: Self {
        return Self(x: 1, y: 1)
    }
    
    /// Returns the length squared of this `Vector2`
    @inlinable
    var lengthSquared: Scalar {
        return x * x + y * y
    }
    
    /// Returns the distance squared between this `Vector2` and another `Vector2`
    @inlinable
    func distanceSquared(to vec: Self) -> Scalar {
        let d = self - vec
        
        return d.lengthSquared
    }
    
    /// Calculates the dot product between this and another provided `Vector2`
    @inlinable
    func dot(_ other: Self) -> Scalar {
        return x * other.x + y * other.y
    }
    
    /// Calculates the cross product between this and another provided Vector.
    /// The resulting scalar would match the 'z' axis of the cross product
    /// between 3d vectors matching the x and y coordinates of the operands, with
    /// the 'z' coordinate being 0.
    @inlinable
    func cross(_ other: Self) -> Scalar {
        return (x * other.y) - (y * other.x)
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
    func ratio(_ ratio: Scalar, to other: Self) -> Self {
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
    static func lerp(start: Self, end: Self, amount: Scalar) -> Self {
        return start.ratio(amount, to: end)
    }
    
    /// Performs a cubic interpolation between two points.
    ///
    /// - Parameter start: Start point.
    /// - Parameter end: End point.
    /// - Parameter amount: Value between 0 and 1 indicating the weight of `end`.
    static func smoothStep(start: Self, end: Self, amount: Scalar) -> Self where Scalar: Comparable {
        let amount = smoothStep(amount)
        
        return lerp(start: start, end: end, amount: amount)
    }
    
    /// Performs smooth (cubic Hermite) interpolation between 0 and 1.
    /// - Remarks:
    /// See https://en.wikipedia.org/wiki/Smoothstep
    /// - Parameter amount: Value between 0 and 1 indicating interpolation amount.
    private static func smoothStep(_ amount: Scalar) -> Scalar where Scalar: Comparable {
        return amount <= 0 ? 0
        : amount >= 1 ? 1
        : amount * amount * (3 - 2 * amount)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Scalar) {
        lhs = lhs * rhs
    }
}

public extension Vector2Type where Scalar: SignedNumeric {
    /// Makes this Vector perpendicular to its current position relative to the
    /// origin.
    /// This alters the vector instance.
    @inlinable
    mutating func formPerpendicular() {
        self = perpendicular()
    }
    
    /// Returns a Vector perpendicular to this Vector relative to the origin
    @inlinable
    func perpendicular() -> Self {
        return Self(x: -y, y: x)
    }
    
    /// Returns a vector that represents this vector's point, rotated 90º counter
    /// clockwise relative to the origin.
    @inlinable
    func leftRotated() -> Self {
        return Self(x: -y, y: x)
    }
    
    /// Rotates this vector 90º counter clockwise relative to the origin.
    /// This alters the vector instance.
    @inlinable
    mutating func formLeftRotated() {
        self = leftRotated()
    }
    
    /// Returns a vector that represents this vector's point, rotated 90º clockwise
    /// clockwise relative to the origin.
    @inlinable
    func rightRotated() -> Self {
        return Self(x: y, y: -x)
    }
    
    /// Rotates this vector 90º clockwise relative to the origin.
    /// This alters the vector instance.
    @inlinable
    mutating func formRightRotated() {
        self = rightRotated()
    }
    
    /// Negates this Vector
    @inlinable
    static prefix func - (lhs: Self) -> Self {
        return Self(x: -lhs.x, y: -lhs.y)
    }
}

public extension Vector2Type where Scalar: DivisibleArithmetic {
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x / rhs, y: lhs.y / rhs)
    }
}

public extension Vector2Type where Scalar: Comparable & SignedNumeric {
    /// Returns a `Vector2` where each component is the absolute value of the
    /// components of this `Vector2`.
    var absolute: Self {
        return Self(x: abs(x), y: abs(y))
    }
}

public extension Vector2Type where Scalar: FloatingPoint {
    /// Rounds the components of this `Vector2` using a given
    /// `FloatingPointRoundingRule`.
    @inlinable
    func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        return Self(x: x.rounded(rule), y: y.rounded(rule))
    }
    
    /// Rounds the components of this `Vector2` using a given
    /// `FloatingPointRoundingRule.toNearestOrAwayFromZero`.
    ///
    /// Equivalent to calling C's round() function on each component.
    @inlinable
    func rounded() -> Self {
        return rounded(.toNearestOrAwayFromZero)
    }
    
    /// Rounds the components of this `Vector2` using a given
    /// `FloatingPointRoundingRule.up`.
    ///
    /// Equivalent to calling C's ceil() function on each component.
    @inlinable
    func ceil() -> Self {
        return rounded(.up)
    }
    
    /// Rounds the components of this `Vector2` using a given
    /// `FloatingPointRoundingRule.down`.
    ///
    /// Equivalent to calling C's floor() function on each component.
    @inlinable
    func floor() -> Self {
        return rounded(.down)
    }
}

public extension Vector2Type where Scalar: FloatingPoint {
    init<V: Vector2Type>(_ vec: V) where V.Scalar: BinaryInteger {
        self.init(x: Scalar(vec.x), y: Scalar(vec.y))
    }
    
    @inlinable
    static func % (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x.truncatingRemainder(dividingBy: rhs.x),
                    y: lhs.y.truncatingRemainder(dividingBy: rhs.y))
    }
    
    @inlinable
    static func % (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x.truncatingRemainder(dividingBy: rhs),
                    y: lhs.y.truncatingRemainder(dividingBy: rhs))
    }
    
    @inlinable
    static func + <V: Vector2Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        return lhs + Self(rhs)
    }
    
    @inlinable
    static func - <V: Vector2Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        return lhs - Self(rhs)
    }
    
    @inlinable
    static func * <V: Vector2Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        return lhs * Self(rhs)
    }
    
    @inlinable
    static func + <V: Vector2Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        return Self(lhs) + rhs
    }
    
    @inlinable
    static func - <V: Vector2Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        return Self(lhs) - rhs
    }
    
    @inlinable
    static func * <V: Vector2Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        return Self(lhs) * rhs
    }
    
    @inlinable
    static func += <V: Vector2Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs + Self(rhs)
    }
    @inlinable
    static func -= <V: Vector2Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs - Self(rhs)
    }
    @inlinable
    static func *= <V: Vector2Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs * Self(rhs)
    }
}

public extension Vector2Type where Scalar: FloatingPoint & DivisibleArithmetic {
    @inlinable
    static func / <V: Vector2Type>(lhs: Self, rhs: V) -> Self where V.Scalar: BinaryInteger {
        return lhs / Self(rhs)
    }
    
    @inlinable
    static func / <V: Vector2Type>(lhs: V, rhs: Self) -> Self where V.Scalar: BinaryInteger {
        return Self(lhs) / rhs
    }
    
    @inlinable
    static func /= <V: Vector2Type>(lhs: inout Self, rhs: V) where V.Scalar: BinaryInteger {
        lhs = lhs / Self(rhs)
    }
}

public extension Vector2Type where Scalar: Numeric & ElementaryFunctions {
    /// Returns the Euclidean norm (square root of the squared length) of this
    /// `Vector2`
    @inlinable
    var length: Scalar {
        return Scalar.sqrt(lengthSquared)
    }
    
    /// Returns the distance between this `Vector2` and another `Vector2`
    @inlinable
    func distance(to vec: Self) -> Scalar {
        return Scalar.sqrt(self.distanceSquared(to: vec))
    }
    
    /// Returns a rotated version of this vector, rotated around the origin by a
    /// given angle in radians
    @inlinable
    func rotated(by angleInRadians: Scalar) -> Self {
        return Self.rotate(self, by: angleInRadians)
    }
    
    /// Rotates this vector around the origin by a given angle in radians
    @inlinable
    mutating func rotate(by angleInRadians: Scalar) {
        self = rotated(by: angleInRadians)
    }
    
    /// Rotates this vector around a given pivot by a given angle in radians
    @inlinable
    func rotated(by angleInRadians: Scalar, around pivot: Self) -> Self {
        return (self - pivot).rotated(by: angleInRadians) + pivot
    }
    
    /// Rotates a given vector around the origin by an angle in radians
    @inlinable
    static func rotate(_ vec: Self, by angleInRadians: Scalar) -> Self {
        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(angleInRadians)
        
        return Self(x: (c * vec.x) - (s * vec.y), y: (c * vec.y) + (s * vec.x))
    }
}

public extension Vector2Type where Scalar: Comparable & ElementaryFunctions & DivisibleArithmetic {
    /// Normalizes this Vector instance.
    ///
    /// Returns `Vector2.zero` if the vector has `length == 0`.
    @inlinable
    mutating func normalize() {
        self = normalized()
    }
    
    /// Returns a normalized version of this vector.
    ///
    /// Returns `Vector2.zero` if the vector has `length == 0`.
    @inlinable
    func normalized() -> Self {
        let l = length
        if l <= 0 {
            return .zero
        }
        
        return self / l
    }
}

public extension Vector2Type where Scalar: FloatingPoint & ElementaryFunctions {
    /// Creates a matrix that when multiplied with a Vector object applies the
    /// given set of transformations.
    ///
    /// If all default values are set, an identity matrix is created, which does
    /// not alter a Vector's coordinates once applied.
    ///
    /// The order of operations are: scaling -> rotation -> translation
    @inlinable
    static func matrix(scale: Self = .unit,
                       rotate angle: Scalar = 0,
                       translate: Self = .zero) -> Matrix2<Scalar> {
        
        return Matrix2<Scalar>.transformation(xScale: scale.x,
                                              yScale: scale.y,
                                              angle: angle,
                                              xOffset: translate.x,
                                              yOffset: translate.y)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix2<Scalar>) -> Self {
        return Matrix2<Scalar>.transformPoint(matrix: rhs, point: lhs)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix2<Scalar>) {
        lhs = Matrix2<Scalar>.transformPoint(matrix: rhs, point: lhs)
    }
}

public extension Vector2Type where Scalar: Real {
    /// Returns the angle in radians of the line formed by tracing from the
    /// origin (0, 0) to this `Vector2`.
    @inlinable
    var angle: Scalar {
        return Scalar.atan2(y: y, x: x)
    }
}

public extension Collection {
    /// Averages this collection of vectors into one `Vector2` point as the mean
    /// location of each vector.
    ///
    /// Returns `Vector2.zero`, if the collection is empty.
    @inlinable
    func averageVector<V: Vector2Type>() -> V where Element == V, V.Scalar: FloatingPoint & DivisibleArithmetic {
        if isEmpty {
            return .zero
        }
        
        return reduce(into: .zero) { $0 += $1 } / V.Scalar(count)
    }
}

public func min<V: Vector2Type>(_ vec1: V, _ vec2: V) -> V where V.Scalar: Comparable {
    return V(x: min(vec1.x, vec2.x), y: min(vec1.y, vec2.y))
}

public func max<V: Vector2Type>(_ vec1: V, _ vec2: V) -> V where V.Scalar: Comparable {
    return V(x: max(vec1.x, vec2.x), y: max(vec1.y, vec2.y))
}

/// Returns a `Vector2` with each component as the absolute value of the components
/// of a given `Vector2`.
///
/// Equivalent to calling C's abs() function on each component.
@inlinable
public func abs<V: Vector2Type>(_ x: V) -> V where V.Scalar: Comparable & SignedNumeric {
    return V(x: abs(x.x), y: abs(x.y))
}

/// Rounds the components of a given `Vector2` using
/// `FloatingPointRoundingRule.toNearestOrAwayFromZero`.
///
/// Equivalent to calling C's round() function on each component.
@inlinable
public func round<V: Vector2Type>(_ x: V) -> V where V.Scalar: FloatingPoint {
    return x.rounded(.toNearestOrAwayFromZero)
}

/// Rounds up the components of a given `Vector2` using
/// `FloatingPointRoundingRule.up`.
///
/// Equivalent to calling C's ceil() function on each component.
@inlinable
public func ceil<V: Vector2Type>(_ x: V) -> V where V.Scalar: FloatingPoint {
    return x.rounded(.up)
}

/// Rounds down the components of a given `Vector2` using
/// `FloatingPointRoundingRule.down`.
///
/// Equivalent to calling C's floor() function on each component.
@inlinable
public func floor<V: Vector2Type>(_ x: V) -> V where V.Scalar: FloatingPoint {
    return x.rounded(.down)
}
