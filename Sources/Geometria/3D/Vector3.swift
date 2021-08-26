import RealModule

/// Represents a 3D point with three double-precision floating-point components
public typealias Vector3D = Vector3<Double>

/// Represents a 3D point with three single-precision floating-point components
public typealias Vector3F = Vector3<Float>

/// Represents a 3D point with three `Int` components
public typealias Vector3i = Vector3<Int>

/// A three-component vector type
public struct Vector3<Scalar>: Vector3Type {
    /// X coordinate of this vector
    public var x: Scalar
    
    /// Y coordinate of this vector
    public var y: Scalar
    
    /// Z coordinate of this vector
    public var z: Scalar
    
    /// Textual representation of this `Vector3`
    public var description: String {
        return "\(type(of: self))(x: \(x), y: \(y), z: \(z))"
    }
    
    /// Creates a new `Vector3` with the given coordinates
    @_transparent
    public init(x: Scalar, y: Scalar, z: Scalar) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    /// Creates a new `Vector3` with the given scalar on all coordinates
    @_transparent
    public init(repeating scalar: Scalar) {
        self.init(x: scalar, y: scalar, z: scalar)
    }
}

extension Vector3: Equatable where Scalar: Equatable { }
extension Vector3: Hashable where Scalar: Hashable { }
extension Vector3: Encodable where Scalar: Encodable { }
extension Vector3: Decodable where Scalar: Decodable { }

extension Vector3: VectorComparable where Scalar: Comparable {
    /// Returns the pointwise minimal Vector where each component is the minimal
    /// scalar value at each index for both vectors.
    @_transparent
    public static func pointwiseMin(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(x: min(lhs.x, rhs.x), y: min(lhs.y, rhs.y), z: min(lhs.z, rhs.z))
    }
    
    /// Returns the pointwise maximal Vector where each component is the maximal
    /// scalar value at each index for both vectors.
    @_transparent
    public static func pointwiseMax(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(x: max(lhs.x, rhs.x), y: max(lhs.y, rhs.y), z: max(lhs.z, rhs.z))
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than `rhs`.
    ///
    /// Performs `lhs.x > rhs.x && lhs.y > rhs.y && lhs.z > rhs.z`
    @_transparent
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.x > rhs.x && lhs.y > rhs.y && lhs.z > rhs.z
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than or equal to `rhs`.
    ///
    /// Performs `lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z`
    @_transparent
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than `rhs`.
    ///
    /// Performs `lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z`
    @_transparent
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than or equal to `rhs`.
    ///
    /// Performs `lhs.x <= rhs.x && lhs.y <= rhs.y && lhs.z <= rhs.z`
    @_transparent
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.x <= rhs.x && lhs.y <= rhs.y && lhs.z <= rhs.z
    }
}

extension Vector3: AdditiveArithmetic where Scalar: AdditiveArithmetic {
    /// A zero-value `Vector3` value where each component corresponds to its
    /// representation of `0`.
    @_transparent
    public static var zero: Self {
        return Self(x: .zero, y: .zero, z: .zero)
    }
}

extension Vector3: VectorAdditive where Scalar: AdditiveArithmetic {
    /// Initializes a zero-valued `Vector3Type`
    @_transparent
    public init() {
        self = .zero
    }
    
    @_transparent
    public static func + (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    @_transparent
    public static func - (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    
    @_transparent
    public static func + (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x + rhs, y: lhs.y + rhs, z: lhs.z + rhs)
    }
    
    @_transparent
    public static func - (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x - rhs, y: lhs.y - rhs, z: lhs.z - rhs)
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

extension Vector3: VectorMultiplicative where Scalar: Numeric {
    /// A unit-value `Vector3Type` value where each component corresponds to its
    /// representation of `1`.
    @_transparent
    public static var one: Self {
        return Self(x: 1, y: 1, z: 1)
    }
    
    /// Returns the length squared of this `Vector3Type`
    @_transparent
    public var lengthSquared: Scalar {
        return x * x + y * y + z * z
    }
    
    /// Returns the distance squared between this `Vector3Type` and another `Vector3Type`
    @_transparent
    public func distanceSquared(to vec: Self) -> Scalar {
        let d = self - vec
        
        return d.lengthSquared
    }
    
    /// Calculates the dot product between this and another provided `Vector3Type`
    @_transparent
    public func dot(_ other: Self) -> Scalar {
        return x * other.x + y * other.y + z * other.z
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
    @_transparent
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
    @_transparent
    public static func lerp(start: Self, end: Self, amount: Scalar) -> Self {
        return start.ratio(amount, to: end)
    }
    
    @_transparent
    public static func * (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }
    
    @_transparent
    public static func * (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
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

extension Vector3: VectorSigned where Scalar: SignedNumeric & Comparable {
    /// Returns a `Vector3` where each component is the absolute value of the
    /// components of this `Vector3`.
    @_transparent
    public var absolute: Self {
        return Self(x: abs(x), y: abs(y), z: abs(z))
    }
    
    /// Negates this Vector
    @_transparent
    public static prefix func - (lhs: Self) -> Self {
        return Self(x: -lhs.x, y: -lhs.y, z: -lhs.z)
    }
}

extension Vector3: VectorDivisible where Scalar: DivisibleArithmetic {
    @_transparent
    public static func / (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
    }
    
    @_transparent
    public static func / (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
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

extension Vector3: VectorNormalizable where Scalar: Comparable & Real & DivisibleArithmetic {
    /// Normalizes this Vector instance.
    ///
    /// Returns `Vector3.zero` if the vector has `length == 0`.
    @_transparent
    public mutating func normalize() {
        self = normalized()
    }
    
    /// Returns a normalized version of this vector.
    ///
    /// Returns `Vector3.zero` if the vector has `length == 0`.
    @inlinable
    public func normalized() -> Self {
        let l = length
        if l <= 0 {
            return .zero
        }
        
        return self / l
    }
}

extension Vector3: VectorFloatingPoint where Scalar: DivisibleArithmetic & FloatingPoint {
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
        return Self(x: x.addingProduct(a.x, b.x), y: y.addingProduct(a.y, b.y), z: z.addingProduct(a.z, b.z))
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
        return Self(x: x.addingProduct(a, b.x), y: y.addingProduct(a, b.y), z: z.addingProduct(a, b.z))
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
        return Self(x: x.addingProduct(a.x, b), y: y.addingProduct(a.y, b), z: z.addingProduct(a.z, b))
    }
    
    /// Rounds the components of this `Vector3Type` using a given
    /// `FloatingPointRoundingRule`.
    @_transparent
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        return Self(x: x.rounded(rule), y: y.rounded(rule), z: z.rounded(rule))
    }
    
    /// Rounds the components of this `Vector3Type` using a given
    /// `FloatingPointRoundingRule.toNearestOrAwayFromZero`.
    ///
    /// Equivalent to calling C's round() function on each component.
    @_transparent
    public func rounded() -> Self {
        return rounded(.toNearestOrAwayFromZero)
    }
    
    /// Rounds the components of this `Vector3Type` using a given
    /// `FloatingPointRoundingRule.up`.
    ///
    /// Equivalent to calling C's ceil() function on each component.
    @_transparent
    public func ceil() -> Self {
        return rounded(.up)
    }
    
    /// Rounds the components of this `Vector3Type` using a given
    /// `FloatingPointRoundingRule.down`.
    ///
    /// Equivalent to calling C's floor() function on each component.
    @_transparent
    public func floor() -> Self {
        return rounded(.down)
    }
    
    @_transparent
    public static func % (lhs: Self, rhs: Self) -> Self {
        return Self(x: lhs.x.truncatingRemainder(dividingBy: rhs.x),
                    y: lhs.y.truncatingRemainder(dividingBy: rhs.y),
                    z: lhs.z.truncatingRemainder(dividingBy: rhs.z))
    }
    
    @_transparent
    public static func % (lhs: Self, rhs: Scalar) -> Self {
        return Self(x: lhs.x.truncatingRemainder(dividingBy: rhs),
                    y: lhs.y.truncatingRemainder(dividingBy: rhs),
                    z: lhs.z.truncatingRemainder(dividingBy: rhs))
    }
}

extension Vector3: Vector3FloatingPoint where Scalar: DivisibleArithmetic & FloatingPoint {
    @_transparent
    public init<V: Vector3Type>(_ vec: V) where V.Scalar: BinaryInteger {
        self.init(x: Scalar(vec.x), y: Scalar(vec.y), z: Scalar(vec.z))
    }
}

extension Vector3: VectorReal where Scalar: DivisibleArithmetic & Real {
    /// Returns the Euclidean norm (square root of the squared length) of this
    /// `Vector3Type`
    @_transparent
    public var length: Scalar {
        return Scalar.sqrt(lengthSquared)
    }
    
    /// Returns the distance between this `Vector3Type` and another `Vector3Type`
    @_transparent
    public func distance(to vec: Self) -> Scalar {
        return Scalar.sqrt(self.distanceSquared(to: vec))
    }
    
    @_transparent
    public static func pow(_ vec: Self, _ n: Scalar) -> Self {
        return Self.pow(vec, Self(x: n, y: n, z: n))
    }
    
    @_transparent
    public static func pow(_ vec: Self, _ n: Int) -> Self {
        return Self(x: Scalar.pow(vec.x, n),
                    y: Scalar.pow(vec.y, n),
                    z: Scalar.pow(vec.z, n))
    }
    
    @_transparent
    public static func pow(_ vec: Self, _ n: Self) -> Self {
        return Self(x: Scalar.pow(vec.x, n.x),
                    y: Scalar.pow(vec.y, n.y),
                    z: Scalar.pow(vec.z, n.z))
    }
}
