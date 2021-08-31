import RealModule

/// Protocol for 3D vector types where the components are Real numbers
public protocol Vector3Real: VectorReal {
    /// The XY-plane angle of this vector
    var azimuth: Scalar { get }
    
    /// The elevation angle of this vector, or the angle between the XY plane
    /// and the vector.
    ///
    /// Returns zero, if the vector's length is zero.
    var elevation: Scalar { get }
}
