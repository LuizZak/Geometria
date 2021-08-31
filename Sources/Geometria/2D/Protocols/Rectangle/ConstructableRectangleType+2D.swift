public extension ConstructableRectangleType where Vector: Vector2Type {
    /// Gets or sets the X position of this Rectangle.
    @_transparent
    var x: Vector.Scalar {
        get { location.x }
        set { self = self.withLocation(x: newValue, y: y) }
    }
    
    /// Gets or sets the Y position of this Rectangle.
    @_transparent
    var y: Vector.Scalar {
        get { location.y }
        set { self = self.withLocation(x: x, y: newValue) }
    }
    
    /// Gets or sets the width of this Rectangle.
    @_transparent
    var width: Vector.Scalar {
        get { size.x }
        set { self = self.withSize(width: newValue, height: height) }
    }
    
    /// Gets or sets the height of this Rectangle.
    @_transparent
    var height: Vector.Scalar {
        get { size.y }
        set { self = self.withSize(width: width, height: newValue) }
    }
    
    /// Initializes a Rectangle with the coordinates of a 2D rectangle.
    @_transparent
    init(x: Vector.Scalar, y: Vector.Scalar, width: Vector.Scalar, height: Vector.Scalar) {
        self.init(location: Vector(x: x, y: y), size: Vector(x: width, y: height))
    }
    
    /// Returns a Rectangle that matches this rectangle's size with a new
    /// location.
    @_transparent
    func withSize(width: Vector.Scalar, height: Vector.Scalar) -> Self {
        withSize(Vector(x: width, y: height))
    }
    
    /// Returns a rectangle that matches this rectangle's size with a new
    /// location.
    @_transparent
    func withLocation(x: Vector.Scalar, y: Vector.Scalar) -> Self {
        withLocation(Vector(x: x, y: y))
    }
    
    /// Returns a new Rectangle with the same left, right, and height as the current
    /// instance, where the `top` lays on `value`.
    @_transparent
    func movingTop(to value: Vector.Scalar) -> Self {
        Self(x: left, y: value, width: width, height: height)
    }
    
    /// Returns a new Rectangle with the same top, bottom, and width as the current
    /// instance, where the `left` lays on `value`.
    @_transparent
    func movingLeft(to value: Vector.Scalar) -> Self {
        Self(x: value, y: top, width: width, height: height)
    }
}
