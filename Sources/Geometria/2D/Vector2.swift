import RealModule
import simd

/// A typealias for a scalar that can specialize a `Vector2` instance
public typealias VectorScalar = SIMDScalar & Numeric

/// A two-component vector type
public typealias Vector2<T: VectorScalar> = SIMD2<T>

/// Represents a 2D point with two double-precision, floating-point components
public typealias Vector2D = Vector2<Double>

/// Represents a 2D point with two floating-point components
public typealias Vector2F = Vector2<Float>

/// Represents a 2D point with two `Int` components
public typealias Vector2i = Vector2<Int>

public extension Vector2 {
    /// A zero-value `Vector2` value where each component corresponds to its
    /// representation of `0`.
    static var zero: Vector2 {
        return Vector2(x: .zero, y: .zero)
    }
    
    /// A unit-value `Vector2` value where each component corresponds to its
    /// representation of `1`.
    static var unit: Vector2 {
        return Vector2(x: 1, y: 1)
    }
}

public extension Vector2 where Scalar: Comparable {
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than `rhs`.
    ///
    /// Performs `lhs.x > rhs.x && lhs.y > rhs.y`
    @inlinable
    static func > (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x > rhs.x && lhs.y > rhs.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than or equal to `rhs`.
    ///
    /// Performs `lhs.x >= rhs.x && lhs.y >= rhs.y`
    @inlinable
    static func >= (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x >= rhs.x && lhs.y >= rhs.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than `rhs`.
    ///
    /// Performs `lhs.x < rhs.x && lhs.y < rhs.y`
    @inlinable
    static func < (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than or equal to `rhs`.
    ///
    /// Performs `lhs.x <= rhs.x && lhs.y <= rhs.y`
    @inlinable
    static func <= (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x <= rhs.x && lhs.y <= rhs.y
    }
}

public extension Vector2 where Scalar: AdditiveArithmetic {
    @inlinable
    static func + (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    @inlinable
    static func - (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    @inlinable
    static func + (lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(x: lhs.x + rhs, y: lhs.y + rhs)
    }
    
    @inlinable
    static func - (lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(x: lhs.x - rhs, y: lhs.y - rhs)
    }
    
    @inlinable
    static func += (lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func -= (lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func += (lhs: inout Vector2, rhs: Scalar) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func -= (lhs: inout Vector2, rhs: Scalar) {
        lhs = lhs - rhs
    }
}

public extension Vector2 where Scalar: Numeric {
    /// Returns the length squared of this `Vector2`
    @inlinable
    var lengthSquared: Scalar {
        return x * x + y * y
    }
    
    /// Returns the distance squared between this `Vector2` and another `Vector2`
    @inlinable
    func distanceSquared(to vec: Vector2) -> Scalar {
        let d = self - vec
        
        return d.lengthSquared
    }
    
    /// Calculates the dot product between this and another provided `Vector2`
    @inlinable
    func dot(_ other: Vector2) -> Scalar {
        return x * other.x + y * other.y
    }
    
    /// Calculates the cross product between this and another provided Vector.
    /// The resulting scalar would match the 'z' axis of the cross product
    /// between 3d vectors matching the x and y coordinates of the operands, with
    /// the 'z' coordinate being 0.
    @inlinable
    func cross(_ other: Vector2) -> Scalar {
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
    func ratio(_ ratio: Scalar, to other: Vector2) -> Vector2 {
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
    static func lerp(start: Vector2, end: Vector2, amount: Scalar) -> Vector2 {
        return start.ratio(amount, to: end)
    }
    
    /// Performs a cubic interpolation between two points.
    ///
    /// - Parameter start: Start point.
    /// - Parameter end: End point.
    /// - Parameter amount: Value between 0 and 1 indicating the weight of `end`.
    static func smoothStep(start: Vector2, end: Vector2, amount: Scalar) -> Vector2 where Scalar: Comparable {
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
    static func * (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    @inlinable
    static func * (lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    
    @inlinable
    static func *= (lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func *= (lhs: inout Vector2, rhs: Scalar) {
        lhs = lhs * rhs
    }
}

public extension Vector2 where Scalar: SignedNumeric {
    /// Makes this Vector perpendicular to its current position relative to the
    /// origin.
    /// This alters the vector instance.
    @inlinable
    mutating func formPerpendicular() {
        self = perpendicular()
    }
    
    /// Returns a Vector perpendicular to this Vector relative to the origin
    @inlinable
    func perpendicular() -> Vector2 {
        return Vector2(x: -y, y: x)
    }
    
    /// Returns a vector that represents this vector's point, rotated 90º counter
    /// clockwise relative to the origin.
    @inlinable
    func leftRotated() -> Vector2 {
        return Vector2(x: -y, y: x)
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
    func rightRotated() -> Vector2 {
        return Vector2(x: y, y: -x)
    }
    
    /// Rotates this vector 90º clockwise relative to the origin.
    /// This alters the vector instance.
    @inlinable
    mutating func formRightRotated() {
        self = rightRotated()
    }
    
    /// Negates this Vector
    @inlinable
    static prefix func - (lhs: Vector2) -> Vector2 {
        return Vector2(x: -lhs.x, y: -lhs.y)
    }
}

public extension Vector2 where Scalar: DivisibleArithmetic {
    @inlinable
    static func / (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }

    @inlinable
    static func / (lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(x: lhs.x / rhs, y: lhs.y / rhs)
    }
}

public extension Vector2 where Scalar: FloatingPoint {
    init<B: BinaryInteger>(_ vec: Vector2<B>) {
        self.init(Scalar(vec.x), Scalar(vec.y))
    }
    
    @inlinable
    static func % (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x.truncatingRemainder(dividingBy: rhs.x),
                       y: lhs.y.truncatingRemainder(dividingBy: rhs.y))
    }
    
    @inlinable
    static func % (lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(x: lhs.x.truncatingRemainder(dividingBy: rhs),
                       y: lhs.y.truncatingRemainder(dividingBy: rhs))
    }
    
    @inlinable
    static func + <B: BinaryInteger>(lhs: Vector2, rhs: Vector2<B>) -> Vector2 {
        return lhs + Vector2(rhs)
    }
        
    @inlinable
    static func - <B: BinaryInteger>(lhs: Vector2, rhs: Vector2<B>) -> Vector2 {
        return lhs - Vector2(rhs)
    }
        
    @inlinable
    static func * <B: BinaryInteger>(lhs: Vector2, rhs: Vector2<B>) -> Vector2 {
        return lhs * Vector2(rhs)
    }
        
    @inlinable
    static func / <B: BinaryInteger>(lhs: Vector2, rhs: Vector2<B>) -> Vector2 {
        return lhs / Vector2(rhs)
    }
        
    @inlinable
    static func + <B: BinaryInteger>(lhs: Vector2<B>, rhs: Vector2) -> Vector2 {
        return Vector2(lhs) + rhs
    }
        
    @inlinable
    static func - <B: BinaryInteger>(lhs: Vector2<B>, rhs: Vector2) -> Vector2 {
        return Vector2(lhs) - rhs
    }
        
    @inlinable
    static func * <B: BinaryInteger>(lhs: Vector2<B>, rhs: Vector2) -> Vector2 {
        return Vector2(lhs) * rhs
    }
        
    @inlinable
    static func / <B: BinaryInteger>(lhs: Vector2<B>, rhs: Vector2) -> Vector2 {
        return Vector2(lhs) / rhs
    }
        
    @inlinable
    static func += <B: BinaryInteger>(lhs: inout Vector2, rhs: Vector2<B>) {
        lhs = lhs + Vector2(rhs)
    }
    @inlinable
    static func -= <B: BinaryInteger>(lhs: inout Vector2, rhs: Vector2<B>) {
        lhs = lhs - Vector2(rhs)
    }
    @inlinable
    static func *= <B: BinaryInteger>(lhs: inout Vector2, rhs: Vector2<B>) {
        lhs = lhs * Vector2(rhs)
    }
    @inlinable
    static func /= <B: BinaryInteger>(lhs: inout Vector2, rhs: Vector2<B>) {
        lhs = lhs / Vector2(rhs)
    }
}

public extension Vector2 where Scalar: ElementaryFunctions {
    /// Returns the Euclidean norm (square root of the squared length) of this
    /// `Vector2`
    @inlinable
    var length: Scalar {
        return Scalar.sqrt(lengthSquared)
    }
    
    /// Returns a rotated version of this vector, rotated around the origin by a
    /// given angle in radians
    @inlinable
    func rotated(by angleInRadians: Scalar) -> Vector2 {
        return Vector2.rotate(self, by: angleInRadians)
    }
    
    /// Rotates this vector around the origin by a given angle in radians
    @inlinable
    mutating func rotate(by angleInRadians: Scalar) {
        self = rotated(by: angleInRadians)
    }
    
    /// Rotates this vector around a given pivot by a given angle in radians
    @inlinable
    func rotated(by angleInRadians: Scalar, around pivot: Vector2) -> Vector2 {
        return (self - pivot).rotated(by: angleInRadians) + pivot
    }
    
    /// Rotates a given vector around the origin by an angle in radians
    @inlinable
    static func rotate(_ vec: Vector2, by angleInRadians: Scalar) -> Vector2 {
        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(angleInRadians)
        
        return Vector2(x: (c * vec.x) - (s * vec.y), y: (c * vec.y) + (s * vec.x))
    }
}

public extension Vector2 where Scalar: Comparable & ElementaryFunctions & DivisibleArithmetic {
    /// Normalizes this Vector instance.
    ///
    /// Returns `Vector2.zero` if the vector has `length == 0`.
    @inlinable
    mutating func normalized() {
        self = normalized()
    }
    
    /// Returns a normalized version of this vector.
    ///
    /// Returns `Vector2.zero` if the vector has `length == 0`.
    func normalized() -> Vector2 {
        let l = length
        if l <= 0 {
            return .zero
        }
        
        return self / l
    }
}

public extension Vector2 where Scalar: FloatingPoint & ElementaryFunctions {
    @inlinable
    static func * (lhs: Self, rhs: Matrix2<Scalar>) -> Self {
        return Matrix2<Scalar>.transformPoint(matrix: rhs, point: lhs)
    }
    
    @inlinable
    static func * (lhs: Matrix2<Scalar>, rhs: Self) -> Self {
        return Matrix2<Scalar>.transformPoint(matrix: lhs, point: rhs)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix2<Scalar>) {
        lhs = Matrix2<Scalar>.transformPoint(matrix: rhs, point: lhs)
    }
}

public extension Vector2 where Scalar: Real {
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
    func averageVector<Scalar: FloatingPoint>() -> Vector2<Scalar> where Element == Vector2<Scalar> {
        if isEmpty {
            return .zero
        }
        
        return reduce(into: .zero) { $0 += $1 } / Scalar(count)
    }
}

public func min<T: Comparable>(_ vec1: Vector2<T>, _ vec2: Vector2<T>) -> Vector2<T> {
    return Vector2(min(vec1.x, vec2.x), min(vec1.y, vec2.y))
}

public func max<T: Comparable>(_ vec1: Vector2<T>, _ vec2: Vector2<T>) -> Vector2<T> {
    return Vector2(max(vec1.x, vec2.x), max(vec1.y, vec2.y))
}

/// Returns a `Vector2` with each component as the absolute value of the components
/// of a given `Vector2`.
///
/// Equivalent to calling C's abs() function on each component.
@inlinable
public func abs<T: Comparable & SignedNumeric>(_ x: Vector2<T>) -> Vector2<T> {
    return Vector2(x: abs(x.x), y: abs(x.y))
}

/// Rounds the components of a given `Vector2` using
/// `FloatingPointRoundingRule.toNearestOrAwayFromZero`.
///
/// Equivalent to calling C's round() function on each component.
@inlinable
public func round<T: FloatingPoint>(_ x: Vector2<T>) -> Vector2<T> {
    return x.rounded(.toNearestOrAwayFromZero)
}

/// Rounds up the components of a given `Vector2` using
/// `FloatingPointRoundingRule.up`.
///
/// Equivalent to calling C's ceil() function on each component.
@inlinable
public func ceil<T: FloatingPoint>(_ x: Vector2<T>) -> Vector2<T> {
    return x.rounded(.up)
}

/// Rounds down the components of a given `Vector2` using
/// `FloatingPointRoundingRule.down`.
///
/// Equivalent to calling C's floor() function on each component.
@inlinable
public func floor<T: FloatingPoint>(_ x: Vector2<T>) -> Vector2<T> {
    return x.rounded(.down)
}
