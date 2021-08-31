public extension ConstructableRectangleType where Vector: Vector2Type {
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
}
