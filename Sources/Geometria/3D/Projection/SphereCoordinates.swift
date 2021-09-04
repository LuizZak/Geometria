import RealModule

/// Coordinates on a sphere projective space.
public struct SphereCoordinates<Scalar: Real>: Equatable {
    /// The azimuth, or XY-plane angle in 3D space, of this coordinate in radians.
    public var azimuth: Scalar
    
    /// The elevation angle of this coordinate in radians, or the angle between
    /// the XY plane and the point in 3D space.
    ///
    /// Returns zero, if the vector's length is zero.
    public var elevation: Scalar
    
    public init(azimuth: Scalar, elevation: Scalar) {
        self.azimuth = azimuth
        self.elevation = elevation
    }
}
