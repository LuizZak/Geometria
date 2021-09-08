#if canImport(simd)

import simd

public extension Vector2D {
    /// Creates a matrix that when multiplied with a Vector object applies the
    /// given set of transformations.
    ///
    /// If all default values are set, an identity matrix is created, which does
    /// not alter a Vector's coordinates once applied.
    ///
    /// The order of operations are: scaling -> rotation -> translation.
    @inlinable
    static func simdMatrix(scale: Self = .one,
                           rotate angle: Scalar = 0,
                           translate: Self = .zero) -> double3x3 {
        
        var matrix = double3x3(1)
        
        // Prepare matrices
        
        // Scaling:
        //
        // | sx 0  0 |
        // | 0  sy 0 |
        // | 0  0  1 |
        //
        
        let cScale =
        double3x3(
            .init(scale.x, 0, 0),
            .init(0, scale.y, 0),
            .init(0, 0, 1)
        )
        
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
            double3x3(
                .init(c, s, 0),
                .init(-s, c, 0),
                .init(0, 0, 1)
            )
            
            matrix *= cRotation
        }
        
        // Translation:w
        //
        // | 0  0  dx |
        // | 0  0  dy |
        // | 0  0  1  |
        //
        
        let cTranslation =
        double3x3(
            .init(1, 0, translate.x),
            .init(0, 1, translate.y),
            .init(0, 0, 1)
        )
        
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
}

#endif
