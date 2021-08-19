import simd

public extension Vector2D {
    /// Returns the distance between this `Vector2` and another `Vector2`
    @inlinable
    func distance(to vec: Self) -> Scalar {
        return simd.distance(self, vec)
    }
    
    /// Returns the distance squared between this `Vector2` and another `Vector2`
    @inlinable
    func distanceSquared(to vec: Self) -> Scalar {
        return distance_squared(self, vec)
    }
    
    /// Calculates the dot product between this `Vector2` and another provided
    /// `Vector2`
    @inlinable
    func dot(_ other: Self) -> Scalar {
        return simd.dot(self, other)
    }
    
    /// Creates a matrix that when multiplied with a Vector object applies the
    /// given set of transformations.
    ///
    /// If all default values are set, an identity matrix is created, which does
    /// not alter a Vector's coordinates once applied.
    ///
    /// The order of operations are: scaling -> rotation -> translation
    @inlinable
    static func matrix(scalingBy scale: Self = .one,
                       rotatingBy angle: Scalar = 0,
                       translatingBy translate: Self = .zero) -> double3x3 {
        
        typealias MatrixType = double3x3
        typealias Vector3Type = SIMD3<Scalar>
        
        var matrix = MatrixType(1)
        
        // Prepare matrices
        
        // Scaling:
        //
        // | sx 0  0 |
        // | 0  sy 0 |
        // | 0  0  1 |
        //
        
        let cScale =
            MatrixType(columns:
                (Vector3Type(scale.x, 0, 0),
                 Vector3Type(0, scale.y, 0),
                 Vector3Type(0, 0, 1)))
        
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
                MatrixType(columns:
                    (Vector3Type(c, s, 0),
                     Vector3Type(-s, c, 0),
                     Vector3Type(0, 0, 1)))
            
            matrix *= cRotation
        }
        
        // Translation:
        //
        // | 0  0  dx |
        // | 0  0  dy |
        // | 0  0  1  |
        //
        
        let cTranslation =
            MatrixType(columns:
                (Vector3Type(1, 0, translate.x),
                 Vector3Type(0, 1, translate.y),
                 Vector3Type(0, 0, 1)))
        
        matrix *= cTranslation
        
        return matrix
    }
    
    // Matrix multiplication
    @inlinable
    static func * (lhs: Self, rhs: double3x3) -> Self {
        let homog = SIMD3<Scalar>(lhs.x, lhs.y, 1)
        
        let transformed = homog * rhs
        
        return Self(x: transformed.x, y: transformed.y)
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Matrix2D) -> Self {
        return Matrix2D.transformPoint(matrix: rhs, point: lhs)
    }
    
    @inlinable
    static func * (lhs: Matrix2D, rhs: Self) -> Self {
        return Matrix2D.transformPoint(matrix: lhs, point: rhs)
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Matrix2D) {
        lhs = Matrix2D.transformPoint(matrix: rhs, point: lhs)
    }
}
