import simd
import RealModule

/// Represents a 2D point with two double-precision, floating-point components
public typealias Vector2D = Vector2<Double>

/// Represents a 2D point with two floating-point components
public typealias Vector2F = Vector2<Float>

/// Represents a 2D point with two `Int` components
public typealias Vector2i = Vector2<Int>

/// Alias for `Vector2D`
public typealias Size = Vector2D

/// A typealias for a scalar that can specialize a `VectorT` instance
public typealias VectorScalar = Comparable & Numeric & SIMDScalar

/// Represents a 2D vector
public struct Vector2<Scalar: VectorScalar>: Hashable, Codable, CustomStringConvertible {
    /// Used to match `Scalar`'s native type
    public typealias NativeVectorType = SIMD2<Scalar>
    
    /// This is used during affine transformation
    public typealias HomogenousVectorType = SIMD3<Scalar>
    
    /// A zeroed-value Vector
    public static var zero: Vector2 { Vector2(NativeVectorType()) }
    
    /// An unit-valued Vector
    public static var unit: Vector2 { Vector2(x: 1, y: 1) }
    
    /// An unit-valued Vector.
    /// Aliast for 'unit'.
    public static var one: Vector2 { unit }
    
    /// The underlying SIMD vector type
    @usableFromInline
    var theVector: NativeVectorType
    
    @inlinable
    public var x: Scalar {
        get {
            return theVector.x
        }
        set {
            theVector.x = newValue
        }
    }
    
    @inlinable
    public var y: Scalar {
        get {
            return theVector.y
        }
        set {
            theVector.y = newValue
        }
    }
    
    /// Textual representation of this vector's coordinates
    public var description: String {
        return "\(type(of: self))(x: \(self.x), y: \(self.y))"
    }
    
    @inlinable
    public init(_ vector: NativeVectorType) {
        theVector = vector
    }
    
    /// Inits a Vector
    @inlinable
    public init(x: Scalar, y: Scalar) {
        theVector = NativeVectorType(x, y)
    }
    
    /// Inits a Vector where both components have the same given value
    @inlinable
    public init(_ xy: Scalar) {
        theVector = NativeVectorType(xy, xy)
    }
    
    /// Inits a 0-valued Vector
    @inlinable
    public init() {
        theVector = NativeVectorType(repeating: Scalar.zero)
    }
}

// MARK: Operators
public extension Vector2 {
    @inlinable
    static func == (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.theVector == rhs.theVector
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than `rhs`.
    ///
    /// Performs `lhs.x > rhs.x && lhs.y > rhs.y`
    @inlinable
    static func > (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.theVector.x > rhs.theVector.x && lhs.theVector.y > rhs.theVector.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than or equal to `rhs`.
    ///
    /// Performs `lhs.x >= rhs.x && lhs.y >= rhs.y`
    @inlinable
    static func >= (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.theVector.x >= rhs.theVector.x && lhs.theVector.y >= rhs.theVector.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than `rhs`.
    ///
    /// Performs `lhs.x < rhs.x && lhs.y < rhs.y`
    @inlinable
    static func < (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.theVector.x < rhs.theVector.x && lhs.theVector.y < rhs.theVector.y
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than or equal to `rhs`.
    ///
    /// Performs `lhs.x <= rhs.x && lhs.y <= rhs.y`
    @inlinable
    static func <= (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.theVector.x <= rhs.theVector.x && lhs.theVector.y <= rhs.theVector.y
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

public extension Vector2 where Scalar: Numeric {
    /// Returns the distance squared between this Vector and another Vector
    @inlinable
    func distanceSquared(to vec: Vector2) -> Scalar {
        let d = self - vec
        
        return d.x * d.x + d.y * d.y
    }
    
    /// Calculates the dot product between this and another provided Vector
    @inlinable
    func dot(_ other: Vector2) -> Scalar {
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
    static func smoothStep(start: Vector2, end: Vector2, amount: Scalar) -> Vector2 {
        let amount = smoothStep(amount)
        
        return lerp(start: start, end: end, amount: amount)
    }
    
    /// Performs smooth (cubic Hermite) interpolation between 0 and 1.
    /// - Remarks:
    /// See https://en.wikipedia.org/wiki/Smoothstep
    /// - Parameter amount: Value between 0 and 1 indicating interpolation amount.
    private static func smoothStep(_ amount: Scalar) -> Scalar {
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
    static func *= (lhs: inout Vector2, rhs: Scalar) {
        lhs = lhs * rhs
    }
}

public extension Vector2 where Scalar: SignedNumeric {
    /// Makes this Vector perpendicular to its current position relative to the
    /// origin.
    /// This alters the vector instance
    @inlinable
    mutating func formPerpendicular() -> Vector2 {
        self = perpendicular()
        return self
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
    
    /// Returns a vector that represents this vector's point, rotated 90º clockwise
    /// clockwise relative to the origin.
    @inlinable
    func rightRotated() -> Vector2 {
        return Vector2(x: y, y: -x)
    }
    
    /// Negates this Vector
    @inlinable
    static prefix func - (lhs: Vector2) -> Vector2 {
        return Vector2(x: -lhs.x, y: -lhs.y)
    }
}

public extension Vector2 where Scalar: FloatingPoint {
    /// Creates a new Vector, with each coordinate rounded to the closest
    /// possible representation.
    ///
    /// If two representable values are equally close, the result is the value
    /// with more trailing zeros in its significand bit pattern.
    ///
    /// - parameter vector: The integer vector to convert to a floating-point vector.
    @inlinable
    init<U>(_ vector: Vector2<U>) where U: BinaryInteger {
        self.init(x: Scalar.init(vector.x), y: Scalar.init(vector.y))
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
    static func / (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }
    
    @inlinable
    static func / (lhs: Scalar, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs / rhs.x, y: lhs / rhs.y)
    }
    
    @inlinable
    static func / (lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(x: lhs.x / rhs, y: lhs.y / rhs)
    }
}

/// BinaryInteger - FloatingPoint operations
public extension Vector2 where Scalar: FloatingPoint {
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

// MARK: - Rotation and angle
public extension Vector2 where Scalar: Real {
    /// Returns the angle in radians of this Vector relative to the origin (0, 0).
    @inlinable
    var angle: Scalar {
        return Scalar.atan2(y: y, x: x)
    }
    
    /// Returns the squared length of this Vector
    @inlinable
    var lengthSquared: Scalar {
        return x * x + y * y
    }
    
    /// Returns the magnitude (or square root of the squared length) of this
    /// Vector
    @inlinable
    var length: Scalar {
        return Scalar.sqrt(x * x + y * y)
    }
}

public extension Vector2 where Scalar: ElementaryFunctions {
    /// Returns a rotated version of this vector, rotated around by a given
    /// angle in radians
    @inlinable
    func rotated(by angleInRadians: Scalar) -> Vector2 {
        return Vector2.rotate(self, by: angleInRadians)
    }
    
    /// Rotates this vector around by a given angle in radians
    @inlinable
    mutating func rotate(by angleInRadians: Scalar) -> Vector2 {
        self = rotated(by: angleInRadians)
        return self
    }
    
    /// Rotates a given vector by an angle in radians
    @inlinable
    static func rotate(_ vec: Vector2, by angleInRadians: Scalar) -> Vector2 {
        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(angleInRadians)
        
        return Vector2(x: (c * vec.x) - (s * vec.y), y: (c * vec.y) + (s * vec.x))
    }
}

public extension Collection {
    /// Averages this collection of vectors into one Vector point as the mean
    /// location of each vector.
    ///
    /// Returns a zero Vector, if the collection is empty.
    @inlinable
    func averageVector<T: FloatingPoint>() -> Vector2<T> where Element == Vector2<T> {
        if isEmpty {
            return .zero
        }
        
        return reduce(into: .zero) { $0 += $1 } / T(count)
    }
}

/// Returns a Vector that represents the minimum coordinates between two
/// Vector objects
@inlinable
public func min<T>(_ a: Vector2<T>, _ b: Vector2<T>) -> Vector2<T> {
    return Vector2(x: min(a.theVector.x, b.theVector.x), y: min(a.theVector.y, b.theVector.y))
}

/// Returns a Vector that represents the maximum coordinates between two
/// Vector objects
@inlinable
public func max<T>(_ a: Vector2<T>, _ b: Vector2<T>) -> Vector2<T> {
    return Vector2(x: max(a.theVector.x, b.theVector.x), y: max(a.theVector.y, b.theVector.y))
}

////////
//// Define the operations to be performed on the Vector
////////

// This • character is available as 'Option-8' combination on Mac keyboards
infix operator • : MultiplicationPrecedence
infix operator =/ : MultiplicationPrecedence

@inlinable
public func round<T: FloatingPoint>(_ x: Vector2<T>) -> Vector2<T> {
    return Vector2(x.theVector.rounded(.toNearestOrAwayFromZero))
}

@inlinable
public func ceil<T: FloatingPoint>(_ x: Vector2<T>) -> Vector2<T> {
    return Vector2(x.theVector.rounded(.up))
}

@inlinable
public func floor<T: FloatingPoint>(_ x: Vector2<T>) -> Vector2<T> {
    return Vector2(x.theVector.rounded(.down))
}

@inlinable
public func abs<T: SignedNumeric>(_ x: Vector2<T>) -> Vector2<T> {
    return Vector2(x: abs(x.theVector.x), y: abs(x.theVector.y))
}

extension Vector2.NativeMatrixType: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        try self.init([
            container.decode(Vector2.HomogenousVectorType.self),
            container.decode(Vector2.HomogenousVectorType.self),
            container.decode(Vector2.HomogenousVectorType.self)
        ])
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        
        try container.encode(self.columns.0)
        try container.encode(self.columns.1)
        try container.encode(self.columns.2)
    }
}
