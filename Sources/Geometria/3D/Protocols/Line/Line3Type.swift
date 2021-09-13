/// A line that is described by two 3-dimensional vectors.
public protocol Line3Type: LineType where Vector: Vector3Type {
    /// The 2D type of this 3D line.
    associatedtype SubLine2: Line2Type where SubLine2.Vector == Vector.SubVector2
    
    /// Creates a 2D line of the same underlying type as this line.
    static func make2DLine(_ a: SubLine2.Vector, _ b: SubLine2.Vector) -> SubLine2
}
