/// Protocol that vector types conform to to indicate that different combinations
/// of their dimensions can be extracted into other known N-dimensional vector
/// types.
public protocol VectorTakeable: VectorType {
    /// The 2-dimensional vector type for selections of 2-components on this
    /// vector.
    associatedtype SubVector2: Vector2Type = Vector2<Scalar> where SubVector2.Scalar == Scalar

    /// The 3-dimensional vector type for selections of 3-components on this
    /// vector.
    associatedtype SubVector3: Vector3Type = Vector3<Scalar> where SubVector3.Scalar == Scalar

    /// The 4-dimensional vector type for selections of 4-components on this
    /// vector.
    associatedtype SubVector4: Vector4Type = Vector4<Scalar> where SubVector4.Scalar == Scalar

    /// A named indexer into the dimensions of this vector.
    associatedtype TakeDimensions: RawRepresentable where TakeDimensions.RawValue == Int

    // MARK: - Getters

    /// Takes a new 2D vector from a combination of two of the provided dimensions
    /// of this vector.
    ///
    /// ```swift
    /// let vector = Vector3D(x: 3.5, y: 2.1, z: 1.0)
    ///
    /// print(vector[.x, .z]) // Prints "(x: 3.5, y: 1.0)"
    /// print(vector[.z, .y]) // Prints "(x: 1.0, y: 2.1)"
    /// ```
    subscript(x: TakeDimensions, y: TakeDimensions) -> SubVector2 { get }
    
    /// Takes a new 3D vector from a combination of two of the provided dimensions
    /// of this vector.
    ///
    /// ```swift
    /// let vector = Vector3D(x: 3.5, y: 2.1, z: 1.0)
    ///
    /// print(vector[.x, .z, .y]) // Prints "(x: 3.5, y: 1.0, z: 2.1)"
    /// print(vector[.z, .y, .x]) // Prints "(x: 1.0, y: 2.1, x: 3.5)"
    /// ```
    subscript(x: TakeDimensions, y: TakeDimensions, z: TakeDimensions) -> SubVector3 { get }

    /// Takes a new 4D vector from a combination of two of the provided dimensions
    /// of this vector.
    ///
    /// ```swift
    /// let vector = Vector3D(x: 3.5, y: 2.1, z: 1.0)
    ///
    /// print(vector[.x, .z, .y, .z]) // Prints "(x: 3.5, y: 1.0, z: 2.1, w: 2.1)"
    /// print(vector[.z, .y, .x, .z]) // Prints "(x: 1.0, y: 2.1, x: 3.5, w: 1.0)"
    /// ```
    subscript(x: TakeDimensions, y: TakeDimensions, z: TakeDimensions, w: TakeDimensions) -> SubVector4 { get }
}

public extension VectorTakeable {
    subscript(x: TakeDimensions, y: TakeDimensions) -> SubVector2 {
        return SubVector2(x: self[x.rawValue], y: self[y.rawValue])
    }

    subscript(x: TakeDimensions, y: TakeDimensions, z: TakeDimensions) -> SubVector3 {
        return SubVector3(x: self[x.rawValue], y: self[y.rawValue], z: self[z.rawValue])
    }

    subscript(x: TakeDimensions, y: TakeDimensions, z: TakeDimensions, w: TakeDimensions) -> SubVector4 {
        return SubVector4(x: self[x.rawValue], y: self[y.rawValue], z: self[z.rawValue], w: self[w.rawValue])
    }
}
