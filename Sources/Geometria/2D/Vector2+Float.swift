import simd

public extension Vector2 where Scalar == Float {
    /// Returns the squared length of this Vector
    @inlinable
    var lengthSquared: Float {
        return length_squared(theVector)
    }
    
    /// Returns the magnitude (or square root of the squared length) of this
    /// Vector
    @inlinable
    var length: Float {
        return simd.length(theVector)
    }
    
    /// Inits a Vector with two integer components
    @inlinable
    init(x: Int, y: Int) {
        theVector = NativeVectorType(Float(x), Float(y))
    }
    
    /// Inits a Vector with two double-precision float components
    @inlinable
    init(x: Double, y: Double) {
        theVector = NativeVectorType(Float(x), Float(y))
    }
    
    /// Returns the distance between this Vector and another Vector
    @inlinable
    func distance(to vec: Vector2) -> Float {
        return simd.distance(self.theVector, vec.theVector)
    }
    
    /// Returns the distance squared between this Vector and another Vector
    @inlinable
    func distanceSquared(to vec: Vector2) -> Float {
        return distance_squared(self.theVector, vec.theVector)
    }
    
    // Normalizes this Vector instance.
    // This alters the current vector instance
    @inlinable
    mutating func normalize() -> Vector2 {
        self = normalized()
        return self
    }
    
    /// Returns a normalized version of this Vector
    @inlinable
    func normalized() -> Vector2 {
        return Vector2(simd.normalize(theVector))
    }
    
    /// Calculates the dot product between this and another provided Vector
    @inlinable
    func dot(_ other: Vector2) -> Float {
        return simd.dot(theVector, other.theVector)
    }
    
    /// Calculates the cross product between this and another provided Vector.
    /// The resulting scalar would match the 'z' axis of the cross product
    /// between 3d vectors matching the x and y coordinates of the operands, with
    /// the 'z' coordinate being 0.
    @inlinable
    func cross(_ other: Vector2) -> Float {
        return simd.cross(theVector, other.theVector).z
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
        return Vector2(mix(self.theVector, other.theVector, t: ratio))
    }
}

// MARK: - Operators
public extension Vector2 where Scalar == Float {
    /// Calculates the dot product between two provided coordinates.
    /// See `Vector.dot`
    @inlinable
    static func • (lhs: Vector2, rhs: Vector2) -> Float {
        return lhs.dot(rhs)
    }
    
    /// Calculates the dot product between two provided coordinates
    /// See `Vector.cross`
    @inlinable
    static func =/ (lhs: Vector2, rhs: Vector2) -> Float {
        return lhs.cross(rhs)
    }
    
    @inlinable
    static func + (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.theVector + rhs.theVector)
    }
    
    @inlinable
    static func - (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.theVector - rhs.theVector)
    }
    
    @inlinable
    static func * (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.theVector * rhs.theVector)
    }
    
    @inlinable
    static func / (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.theVector / rhs.theVector)
    }
    
    @inlinable
    static func + (lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(lhs.theVector + rhs)
    }
    
    @inlinable
    static func - (lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(lhs.theVector - rhs)
    }
    
    @inlinable
    static func * (lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(lhs.theVector * rhs)
    }
    
    @inlinable
    static func / (lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(lhs.theVector / rhs)
    }
    
    @inlinable
    static func += (lhs: inout Vector2, rhs: Vector2) {
        lhs.theVector += rhs.theVector
    }
    @inlinable
    static func -= (lhs: inout Vector2, rhs: Vector2) {
        lhs.theVector -= rhs.theVector
    }
    @inlinable
    static func *= (lhs: inout Vector2, rhs: Vector2) {
        lhs.theVector *= rhs.theVector
    }
    @inlinable
    static func /= (lhs: inout Vector2, rhs: Vector2) {
        lhs.theVector /= rhs.theVector
    }
}

/// Returns a Vector that represents the minimum coordinates between two
/// Vector objects
@inlinable
public func min(_ a: Vector2<Float>, _ b: Vector2<Float>) -> Vector2<Float> {
    return Vector2(min(a.theVector, b.theVector))
}

/// Returns a Vector that represents the maximum coordinates between two
/// Vector objects
@inlinable
public func max(_ a: Vector2<Float>, _ b: Vector2<Float>) -> Vector2<Float> {
    return Vector2(max(a.theVector, b.theVector))
}

/// Returns whether rotating from A to B is counter-clockwise
@inlinable
public func vectorsAreCCW(_ A: Vector2<Float>, B: Vector2<Float>) -> Bool {
    return (B • A.perpendicular()) >= 0.0
}
