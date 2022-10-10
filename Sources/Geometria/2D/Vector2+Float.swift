#if ENABLE_SIMD

#if canImport(simd)

import simd

public extension Vector2F {
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
    ) -> float3x3 {
        
        var matrix = float3x3(1)
        
        // Prepare matrices
        
        // Scaling:
        //
        // | sx 0  0 |
        // | 0  sy 0 |
        // | 0  0  1 |
        //
        
        let cScale =
            float3x3(
                SIMD3<Float>(scale.x, 0, 0),
                SIMD3<Float>(0, scale.y, 0),
                SIMD3<Float>(0, 0, 1)
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
                float3x3(
                    SIMD3<Float>(c, s, 0),
                    SIMD3<Float>(-s, c, 0),
                    SIMD3<Float>(0, 0, 1)
                )
            
            matrix *= cRotation
        }
        
        // Translation:
        //
        // | 0  0  dx |
        // | 0  0  dy |
        // | 0  0  1  |
        //
        
        let cTranslation =
            float3x3(
                SIMD3<Float>(1, 0, translate.x),
                SIMD3<Float>(0, 1, translate.y),
                SIMD3<Float>(0, 0, 1)
            )
        
        matrix *= cTranslation
        
        return matrix
    }
    
    // Matrix multiplication
    @inlinable
    static func * (lhs: Self, rhs: float3x3) -> Self {
        let homogenous: SIMD3<Scalar> = SIMD3<Scalar>(lhs.x, lhs.y, 1)
        let transformed: SIMD3<Scalar> = homogenous * rhs
        
        return Self(x: transformed.x, y: transformed.y)
    }
}

#endif // #if canImport(simd)

#endif // #if ENABLE_SIMD
