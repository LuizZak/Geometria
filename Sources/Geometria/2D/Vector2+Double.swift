import simd

public extension Vector2 where Scalar == Double {
    /// Returns the squared length of this Vector
    @inlinable
    var lengthSquared: Double {
        return length_squared(theVector)
    }
    
    /// Returns the length (or square root of the squared length) of this Vector
    @inlinable
    var length: Double {
        return simd.length(theVector)
    }
    
    /// Inits a Vector with two integer components
    @inlinable
    init(x: Int, y: Int) {
        theVector = NativeVectorType(Double(x), Double(y))
    }
    
    /// Inits a Vector with two float components
    @inlinable
    init(x: Float, y: Float) {
        theVector = NativeVectorType(Double(x), Double(y))
    }
    
    /// Returns the distance between this Vector and another Vector
    @inlinable
    func distance(to vec: Vector2) -> Double {
        return simd.distance(self.theVector, vec.theVector)
    }
    
    /// Returns the distance squared between this Vector and another Vector
    @inlinable
    func distanceSquared(to vec: Vector2) -> Double {
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
    func dot(_ other: Vector2) -> Double {
        return simd.dot(theVector, other.theVector)
    }
    
    /// Calculates the cross product between this and another provided Vector.
    /// The resulting scalar would match the 'z' axis of the cross product
    /// between 3d vectors matching the x and y coordinates of the operands, with
    /// the 'z' coordinate being 0.
    @inlinable
    func cross(_ other: Vector2) -> Double {
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

// MARK: Matrix-transformation
extension Vector2 where Scalar == Double {
    /// The 3x3 matrix type that can be used to apply transformations by
    /// multiplying on this Vector
    public typealias NativeMatrixType = double3x3
    
    /// Creates a matrix that when multiplied with a Vector object applies the
    /// given set of transformations.
    ///
    /// If all default values are set, an identity matrix is created, which does
    /// not alter a Vector's coordinates once applied.
    ///
    /// The order of operations are: scaling -> rotation -> translation
    @inlinable
    static public func matrix(scalingBy scale: Vector2 = .unit,
                              rotatingBy angle: Double = 0,
                              translatingBy translate: Vector2 = .zero) -> Vector2.NativeMatrixType {
        
        var matrix = Vector2.NativeMatrixType(1)
        
        // Prepare matrices
        
        // Scaling:
        //
        // | sx 0  0 |
        // | 0  sy 0 |
        // | 0  0  1 |
        //
        
        let cScale =
            Vector2.NativeMatrixType(columns:
                (Vector2.HomogenousVectorType(scale.theVector.x, 0, 0),
                 Vector2.HomogenousVectorType(0, scale.theVector.y, 0),
                 Vector2.HomogenousVectorType(0, 0, 1)))
        
        matrix *= cScale
        
        // Rotation:
        //
        // | cos(a)  sin(a)  0 |
        // | -sin(a) cos(a)  0 |
        // |   0       0     1 |
        
        if angle != 0 {
            let c = cos(-angle)
            let s = sin(-angle)
            
            let cRotation =
                Vector2.NativeMatrixType(columns:
                    (Vector2.HomogenousVectorType(c, s, 0),
                     Vector2.HomogenousVectorType(-s, c, 0),
                     Vector2.HomogenousVectorType(0, 0, 1)))
            
            matrix *= cRotation
        }
        
        // Translation:
        //
        // | 0  0  dx |
        // | 0  0  dy |
        // | 0  0  1  |
        //
        
        let cTranslation =
            Vector2.NativeMatrixType(columns:
                (Vector2.HomogenousVectorType(1, 0, translate.theVector.x),
                 Vector2.HomogenousVectorType(0, 1, translate.theVector.y),
                 Vector2.HomogenousVectorType(0, 0, 1)))
        
        matrix *= cTranslation
        
        return matrix
    }
    
    // Matrix multiplication
    @inlinable
    static public func *(lhs: Vector2, rhs: Vector2.NativeMatrixType) -> Vector2 {
        let homog = Vector2.HomogenousVectorType(lhs.theVector.x, lhs.theVector.y, 1)
        
        let transformed = homog * rhs
        
        return Vector2(x: transformed.x, y: transformed.y)
    }

    @inlinable
    static public func *(lhs: Vector2, rhs: Matrix2D) -> Vector2 {
        return Matrix2D.transformPoint(matrix: rhs, point: lhs)
    }

    @inlinable
    static public func *(lhs: Matrix2D, rhs: Vector2) -> Vector2 {
        return Matrix2D.transformPoint(matrix: lhs, point: rhs)
    }
    
    @inlinable
    static public func *=(lhs: inout Vector2, rhs: Matrix2D) {
        lhs = Matrix2D.transformPoint(matrix: rhs, point: lhs)
    }
}

// MARK: - Operators
public extension Vector2 where Scalar == Double {
    /// Calculates the dot product between two provided coordinates.
    /// See `Vector.dot`
    @inlinable
    static func • (lhs: Vector2, rhs: Vector2) -> Double {
        return lhs.dot(rhs)
    }
    
    /// Calculates the dot product between two provided coordinates
    /// See `Vector.cross`
    @inlinable
    static func =/ (lhs: Vector2, rhs: Vector2) -> Double {
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
public func min(_ a: Vector2<Double>, _ b: Vector2<Double>) -> Vector2<Double> {
    return Vector2(min(a.theVector, b.theVector))
}

/// Returns a Vector that represents the maximum coordinates between two
/// Vector objects
@inlinable
public func max(_ a: Vector2<Double>, _ b: Vector2<Double>) -> Vector2<Double> {
    return Vector2(max(a.theVector, b.theVector))
}

/// Returns whether rotating from A to B is counter-clockwise
@inlinable
public func vectorsAreCCW(_ A: Vector2<Double>, B: Vector2<Double>) -> Bool {
    return (B • A.perpendicular()) >= 0.0
}
