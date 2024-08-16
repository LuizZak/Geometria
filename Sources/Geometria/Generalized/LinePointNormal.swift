/// Represents a point along with a normal on the surface of a geometry, and an
/// absolute magnitude associated with a line that intersected with that point.
public struct LineIntersectionPointNormal<Vector: VectorFloatingPoint>: GeometricType, CustomStringConvertible {
    /// Convenience for `Vector.Scalar`
    public typealias Scalar = Vector.Scalar

    public var description: String {
        "\(type(of: self))(normalizedMagnitude: \(normalizedMagnitude), pointNormal: \(pointNormal))"
    }

    public var normalizedMagnitude: Scalar
    public var pointNormal: PointNormal<Vector>

    @_transparent
    public init(normalizedMagnitude: Scalar, pointNormal: PointNormal<Vector>) {
        self.normalizedMagnitude = normalizedMagnitude
        self.pointNormal = pointNormal
    }

    @_transparent
    public init(normalizedMagnitude: Scalar, point: Vector, normal: Vector) {
        self.init(
            normalizedMagnitude: normalizedMagnitude,
            pointNormal: .init(point: point, normal: normal)
        )
    }
}

extension LineIntersectionPointNormal: Equatable where Vector: Equatable { }
extension LineIntersectionPointNormal: Hashable where Vector: Hashable { }

extension LineIntersectionPointNormal: PlaneType where Vector: VectorFloatingPoint {
    public var point: Vector { pointNormal.point }
    public var normal: Vector { pointNormal.normal }

    @_transparent
    public var pointOnPlane: Vector { pointNormal.point }

    /// Returns a ``PointNormalPlane`` value initialized with this point normal's
    /// parameters.
    @_transparent
    public var asPlane: PointNormalPlane<Vector> {
        pointNormal.asPlane
    }
}
