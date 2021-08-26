/// Represents a 2D polygon as a series of connected double-precision
/// floating-point 2D vertices.
public typealias LinePolygon2D = LinePolygon<Vector2D>

/// Represents a 2D polygon as a series of connected single-precision
/// floating-point 2D vertices.
public typealias LinePolygon2F = LinePolygon<Vector2F>

/// Represents a 2D polygon as a series of connected integer 2D vertices.
public typealias LinePolygon2i = LinePolygon<Vector2i>

public extension LinePolygon where Vector: Vector2Type {
    /// Adds a new 2D vertex at the end of this polygon's vertices list
    @_transparent
    mutating func addVertex(x: Scalar, y: Scalar) {
        vertices.append(Vector(x: x, y: y))
    }
}

public extension LinePolygon where Vector: Vector2Multiplicative & VectorComparable {
    
    // Implementation derived from LÖVE's love.math.isConvex at:
    // https://github.com/love2d/love/blob/216d5ca4b2ab04bd765daa4c23c00b81b4aedf08/src/modules/math/MathModule.cpp#L155
    func isConvex() -> Bool {
        if vertices.count < 3 {
            return false
        }
        
        // A polygon is convex if all corners turn in the same direction.
        //
        // Turning direction can be determined using the cross-product of
        // the forward difference vectors
        var i = vertices.count - 2, j = vertices.count - 1, k = 0
        var p = vertices[j] - vertices[i]
        var q = vertices[k] - vertices[j]
        let winding = p.cross(q)
        
        while k + 1 < vertices.count
        {
            i = j
            j = k
            k += 1
            
            p = vertices[j] - vertices[i]
            q = vertices[k] - vertices[j]
            
            if p.cross(q) * winding < 0 {
                return false
            }
        }
        
        return true
    }
}
