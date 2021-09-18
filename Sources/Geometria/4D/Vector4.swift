/// Represents a 4D point with three double-precision floating-point components
public typealias Vector4D = Vector4<Double>

/// Represents a 4D point with three single-precision floating-point components
public typealias Vector4F = Vector4<Float>

/// Represents a 4D point with three `Int` components
public typealias Vector4i = Vector4<Int>

/// A four-component vector type
public struct Vector4<Scalar>: Vector4Type {
    public typealias SubVector3 = Vector3<Scalar>
    
    /// X coordinate of this vector
    public var x: Scalar
    
    /// Y coordinate of this vector
    public var y: Scalar
    
    /// Z coordinate of this vector
    public var z: Scalar
    
    /// w coordinate of this vector
    public var w: Scalar
    
    /// Textual representation of this `Vector4`
    public var description: String {
        "\(type(of: self))(x: \(x), y: \(y), z: \(z), w: \(w))"
    }
    
    @_transparent
    public init(repeating scalar: Scalar) {
        (x, y, z, w) = (scalar, scalar, scalar, scalar)
    }
    
    @_transparent
    public init(x: Scalar, y: Scalar, z: Scalar, w: Scalar) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
}

extension Vector4: Equatable where Scalar: Equatable { }
extension Vector4: Hashable where Scalar: Hashable { }
extension Vector4: Encodable where Scalar: Encodable { }
extension Vector4: Decodable where Scalar: Decodable { }

// swiftlint:disable shorthand_operator
extension Vector4: VectorComparable where Scalar: Comparable {
    /// Returns the pointwise minimal Vector where each component is the minimal
    /// scalar value at each index for both vectors.
    @_transparent
    public static func pointwiseMin(_ lhs: Self, _ rhs: Self) -> Self {
        Self(x: min(lhs.x, rhs.x), y: min(lhs.y, rhs.y), z: min(lhs.z, rhs.z), w: min(lhs.w, rhs.w))
    }
    
    /// Returns the pointwise maximal Vector where each component is the maximal
    /// scalar value at each index for both vectors.
    @_transparent
    public static func pointwiseMax(_ lhs: Self, _ rhs: Self) -> Self {
        Self(x: max(lhs.x, rhs.x), y: max(lhs.y, rhs.y), z: max(lhs.z, rhs.z), w: max(lhs.w, rhs.w))
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than `rhs`.
    ///
    /// Performs `lhs.x > rhs.x && lhs.y > rhs.y && lhs.z > rhs.z && lhs.w > rhs.w`
    @_transparent
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.x > rhs.x && lhs.y > rhs.y && lhs.z > rhs.z && lhs.w > rhs.w
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// greater than or equal to `rhs`.
    ///
    /// Performs `lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z && lhs.w >= rhs.w`
    @_transparent
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z && lhs.w >= rhs.w
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than `rhs`.
    ///
    /// Performs `lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z && lhs.w < rhs.w`
    @_transparent
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z && lhs.w < rhs.w
    }
    
    /// Compares two vectors and returns `true` if all components of `lhs` are
    /// less than or equal to `rhs`.
    ///
    /// Performs `lhs.x <= rhs.x && lhs.y <= rhs.y && lhs.z <= rhs.z && lhs.w <= rhs.w`
    @_transparent
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.x <= rhs.x && lhs.y <= rhs.y && lhs.z <= rhs.z && lhs.w <= rhs.w
    }
}

extension Vector4: AdditiveArithmetic where Scalar: AdditiveArithmetic {
    /// A zero-value `Vector4` value where each component corresponds to its
    /// representation of `0`.
    @_transparent
    public static var zero: Self {
        Self(repeating: .zero)
    }
}

extension Vector4: VectorAdditive where Scalar: AdditiveArithmetic {
    @_transparent
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z, w: lhs.w + rhs.w)
    }
    
    @_transparent
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z, w: lhs.w - rhs.w)
    }
    
    @_transparent
    public static func + (lhs: Self, rhs: Scalar) -> Self {
        Self(x: lhs.x + rhs, y: lhs.y + rhs, z: lhs.z + rhs, w: lhs.w + rhs)
    }
    
    @_transparent
    public static func - (lhs: Self, rhs: Scalar) -> Self {
        Self(x: lhs.x - rhs, y: lhs.y - rhs, z: lhs.z - rhs, w: lhs.w - rhs)
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
