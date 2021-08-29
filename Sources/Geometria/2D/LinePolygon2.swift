/// Represents a 2D polygon as a series of connected double-precision
/// floating-point 2D vertices.
public typealias LinePolygon2D = LinePolygon2<Vector2D>

/// Represents a 2D polygon as a series of connected single-precision
/// floating-point 2D vertices.
public typealias LinePolygon2F = LinePolygon2<Vector2F>

/// Represents a 2D polygon as a series of connected integer 2D vertices.
public typealias LinePolygon2i = LinePolygon2<Vector2i>

/// Typealias for `LinePolygon<V>`, where `V` is constrained to `Vector2Type`.
public typealias LinePolygon2<V: Vector2Type> = LinePolygon<V>

public extension LinePolygon2 {
    /// Adds a new 2D vertex at the end of this polygon's vertices list
    @_transparent
    mutating func addVertex(x: Scalar, y: Scalar) {
        vertices.append(Vector(x: x, y: y))
    }
}

extension LinePolygon2 where Vector: Vector2Multiplicative & VectorComparable {
    // Implementation derived from LÖVE's love.math.isConvex at:
    // https://github.com/love2d/love/blob/216d5ca4b2ab04bd765daa4c23c00b81b4aedf08/src/modules/math/MathModule.cpp#L155
    public func isConvex() -> Bool {
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
        
        while k + 1 < vertices.count {
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

extension LinePolygon2: VolumetricType where Vector: VectorDivisible & VectorComparable {
    /// Assuming this `LinePolygon2` represents a clockwise closed polygon,
    /// performs a vector-containment check against the polygon formed by this
    /// polygon's vertices.
    @inlinable
    public func contains(_ vector: Vector) -> Bool {
        if vertices.count < 3 {
            return false
        }
        
        let aabb = AABB(points: vertices)
        if !aabb.contains(vector) {
            return false
        }
        
        // Basic idea: Draw a line from the point to a point known to be outside
        // the body. Count the number of lines in the polygon it intersects.
        // If that number is odd, we are inside. If it's even, we are outside.
        // In this implementation we will always use a line that moves off in
        // the positive X direction from the point to simplify things.
        let endPtX = aabb.maximum.x + 1
        
        var inside = false
        
        var edgeSt = vertices[0]
        
        for i in 0..<vertices.count {
            let next = (i + 1) % vertices.count
            
            let edgeEnd = vertices[next]
            
            if ((edgeSt.y <= vector.y) && (edgeEnd.y > vector.y)) || ((edgeSt.y > vector.y) && (edgeEnd.y <= vector.y)) {
                let slope = (edgeEnd.x - edgeSt.x) / (edgeEnd.y - edgeSt.y)
                let hitX = edgeSt.x + ((vector.y - edgeSt.y) * slope)
                
                if ((hitX >= vector.x) && (hitX <= endPtX)) {
                    inside = !inside
                }
            }
            
            edgeSt = edgeEnd
        }
        
        return inside
    }
}
