import RealModule

/// Protocol for 3D vector types where the components are Real numbers
public protocol Vector3Real: VectorReal {
    /// The XY-plane angle of this vector
    var azimuth: Scalar { get }
    
    /// The XZ-plane angle of this vector
    var elevation: Scalar { get }
}
