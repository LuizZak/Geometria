/// Protocol refining ``RectangleType`` with ``VectorDivisible`` extensions.
///
/// Divisible rectangle types can be split into smaller rectangles, as well as
/// be inflated/inset.
public protocol DivisibleRectangleType: AdditiveRectangleType where Vector: VectorDivisible {
    /// Gets the center point of this rectangle.
    var center: Vector { get }
    
    /// Returns a new rectangle which is an inflated version of this rectangle
    /// (i.e. bounds are larger by `size`, but center remains the same).
    ///
    /// Equivalent to insetting the rectangle by a negative amount.
    ///
    /// - seealso: ``insetBy(_:)``
    func inflatedBy(_ size: Vector) -> Self
    
    /// Returns a new rectangle which is an inset version of this rectangle
    /// (i.e. bounds are smaller by `size`, but center remains the same).
    ///
    /// Equivalent to inflating the rectangle by a negative amount.
    ///
    /// - seealso: ``inflatedBy(_:)``
    func insetBy(_ size: Vector) -> Self
    
    /// Returns a new rectangle with the same size as the current instance,
    /// where the center of the boundaries lay on `center`.
    func movingCenter(to center: Vector) -> Self

    /// Returns a new rectangle with its bounds scaled around a given center point
    /// by a given factor.
    func scaledBy(_ factor: Vector.Scalar, around center: Vector) -> Self

    /// Returns a new rectangle with the same center point as the current instance,
    /// where the size of the rectangle is multiplied by a given numerical factor.
    func scaledAroundCenterBy(_ factor: Vector.Scalar) -> Self
}

public extension DivisibleRectangleType where Self: ConstructableRectangleType {
    /// Gets or sets the center point of this rectangle.
    ///
    /// When assigning the center of a rectangle, the size remains unchanged
    /// while the coordinates of the vectors change to position the rectangle's
    /// center on the provided coordinates.
    var center: Vector {
        @_transparent
        get {
            let newSize: Vector = size / 2
            return location + newSize
        }
        @_transparent
        set { self = self.movingCenter(to: newValue) }
    }
    
    /// Returns a rectangle which is an inflated version of this rectangle
    /// (i.e. bounds are larger by `size`, but center remains the same).
    ///
    /// Equivalent to insetting the rectangle by a negative amount.
    ///
    /// - seealso: ``insetBy(_:)``
    @_transparent
    func inflatedBy(_ size: Vector) -> Self {
        Self(location: location - size / 2, size: self.size + size)
    }
    
    /// Returns a rectangle which is an inset version of this rectangle
    /// (i.e. bounds are smaller by `size`, but center remains the same).
    ///
    /// Equivalent to inflating the rectangle by a negative amount.
    ///
    /// - seealso: ``inflatedBy(_:)``
    @_transparent
    func insetBy(_ size: Vector) -> Self {
        Self(location: location + size / 2, size: self.size - size)
    }
    
    /// Returns a new rectangle with the same size as the current instance,
    /// where the center of the boundaries lay on `center`.
    @_transparent
    func movingCenter(to center: Vector) -> Self {
        Self(location: center - size / 2, size: size)
    }

    /// Returns a new rectangle with the same center point as the current instance,
    /// where the size of the rectangle is multiplied by a given numerical factor.
    @_transparent
    func scaledBy(_ factor: Vector.Scalar, around center: Vector) -> Self {
        let scaledLocation: Vector = (location - center) * factor + center
        let size = size * factor

        return Self(location: scaledLocation, size: size)
    }

    /// Returns a new rectangle with the same center point as the current instance,
    /// where the size of the rectangle is multiplied by a given numerical factor.
    @_transparent
    func scaledAroundCenterBy(_ factor: Vector.Scalar) -> Self {
        scaledBy(factor, around: center)
    }
}
