/// Protocol for geometric types that support vector projection operations.
///
/// Types conforming to this protocol expose a function that can project an
/// arbitrary vector onto their surface.
public protocol PointProjectableType: GeometricType {
    /// The vector type associated with this `PointProjectableType`.
    associatedtype Vector: VectorType
    
    /// Returns a vector on the surface of this geometric type that is the
    /// closest to `vector`.
    func project(_ vector: Vector) -> Vector
    
    /// Returns the squared distance between the closest point in this geometric
    /// type's surface to a given vector.
    ///
    /// - seealso: ``distance(to:)``
    func distanceSquared(to vector: Vector) -> Vector.Scalar
    
    /// Returns the distance between the closest point in this geometric type's
    /// surface to a given vector.
    ///
    /// Equivalent to `self.distanceSquared(to: vector).squareRoot()`.
    ///
    /// - seealso: ``distanceSquared(to:)``
    func distance(to vector: Vector) -> Vector.Scalar
}

public extension PointProjectableType where Vector: VectorMultiplicative {
    /// Returns the squared distance between the closest point in this geometric
    /// type's surface to a given vector.
    ///
    /// - seealso: ``distance(to:)``
    @_transparent
    func distanceSquared(to vector: Vector) -> Vector.Scalar {
        project(vector).distanceSquared(to: vector)
    }
}

public extension PointProjectableType where Vector: VectorFloatingPoint {
    /// Returns the distance between the closest point in this geometric type's
    /// surface to a given vector.
    ///
    /// Equivalent to `self.distanceSquared(to: vector).squareRoot()`.
    ///
    /// - seealso: ``distanceSquared(to:)``
    @_transparent
    func distance(to vector: Vector) -> Vector.Scalar {
        distanceSquared(to: vector).squareRoot()
    }
}
