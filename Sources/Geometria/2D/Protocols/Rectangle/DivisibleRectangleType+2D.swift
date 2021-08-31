public extension DivisibleRectangleType where Self: ConstructableRectangleType, Vector: Vector2Type {
    /// Gets or sets the center X position of this Rectangle.
    @_transparent
    var centerX: Vector.Scalar {
        get {
            center.x
        }
        set {
            center.x = newValue
        }
    }
    
    /// Gets or sets the center Y position of this Rectangle.
    @_transparent
    var centerY: Vector.Scalar {
        get {
            center.y
        }
        set {
            center.y = newValue
        }
    }
    
    /// Returns a Rectangle which is an inflated version of this Rectangle
    /// (i.e. bounds are larger by `size`, but center remains the same).
    @_transparent
    func inflatedBy(x: Vector.Scalar, y: Vector.Scalar) -> Self {
        inflatedBy(Vector(x: x, y: y))
    }
    
    /// Returns a Rectangle which is an inset version of this Rectangle
    /// (i.e. bounds are smaller by `size`, but center remains the same).
    @_transparent
    func insetBy(x: Vector.Scalar, y: Vector.Scalar) -> Self {
        insetBy(Vector(x: x, y: y))
    }
    
    /// Returns a new Rectangle with the same width and height as the current
    /// instance, where the center of the boundaries lay on the coordinates
    /// composed of `[x, y]`.
    @_transparent
    func movingCenter(toX x: Vector.Scalar, y: Vector.Scalar) -> Self {
        movingCenter(to: Vector(x: x, y: y))
    }
}
