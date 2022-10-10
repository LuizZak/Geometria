#if ENABLE_SIMD

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
    static func simdMatrix(
        scale: Self = .one,
        rotate angle: Scalar = 0,
        translate: Self = .zero
    ) -> double3x3 {
        
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
                SIMD3<Double>(scale.x, 0, 0),
                SIMD3<Double>(0, scale.y, 0),
                SIMD3<Double>(0, 0, 1)
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
                    SIMD3<Double>(c, s, 0),
                    SIMD3<Double>(-s, c, 0),
                    SIMD3<Double>(0, 0, 1)
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
                SIMD3<Double>(1, 0, translate.x),
                SIMD3<Double>(0, 1, translate.y),
                SIMD3<Double>(0, 0, 1)
            )
        
        matrix *= cTranslation
        
        return matrix
    }
    
    // Matrix multiplication
    @inlinable
    static func * (lhs: Self, rhs: double3x3) -> Self {
        let homogenous: SIMD3<Scalar> = .init(lhs.x, lhs.y, 1)
        let transformed: SIMD3<Scalar> = homogenous * rhs
        
        return Self(x: transformed.x, y: transformed.y)
    }
}

#endif // #if canImport(simd)

#endif // #if ENABLE_SIMD
