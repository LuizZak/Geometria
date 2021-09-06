import RealModule

/// A projected space laying on the surface of a 3-dimensional sphere, with a
/// 2-dimensional underlying space where vectors represent the azimuth (XY angle
/// of the points) and elevation (the angle between the point and the XY-plane
/// on the sphere).
public protocol SphereProjectiveSpace: ProjectiveSpace where Vector: Vector3Type, Vector.Scalar == Scalar, Coordinates == SphereCoordinates<Scalar> {
    associatedtype Scalar: Real
}
