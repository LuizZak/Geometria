public extension LinePolygon where Vector: Vector2Type {
    /// Adds a new 2D vertex at the end of this polygon's vertices list
    mutating func addVertex(x: Scalar, y: Scalar) {
        vertices.append(Vector(x: x, y: y))
    }
}
