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
    /// Returns `true` if this polygon is convex.
    ///
    /// Assumes that the polygon has no self-intersections.
    public func isConvex() -> Bool {
        // Implementation based on:
        // https://math.stackexchange.com/a/1745427
        if vertices.count < 3 {
            return false
        }
        
        var xSign = 0
        var xFirstSign = 0
        var xFlips = 0
        
        var ySign = 0
        var yFirstSign = 0
        var yFlips = 0
        
        let secondToLast = vertices[vertices.count - 2]
        let last = vertices[vertices.count - 1]
        
        let wSign = (last - secondToLast).cross(vertices[0] - last)
        
        var curr = secondToLast
        var next = last
        
        for v in vertices {
            let prev = curr
            curr = next
            next = v
            
            let b = curr - prev
            let a = next - curr
            
            // Calculate sign flips using the next edge vector, recording the
            // first sign
            if a.x > 0 {
                if xSign == 0 {
                    xFirstSign = 1
                } else if xSign < 0 {
                    xFlips += 1
                }
                xSign = 1
            } else if a.x < 0 {
                if xSign == 0 {
                    xFirstSign = -1
                } else if xSign > 0 {
                    xFlips += 1
                }
                xSign = -1
            }
            
            if xFlips > 2 {
                return false
            }
            
            if a.y > 0 {
                if ySign == 0 {
                    yFirstSign = 1
                } else if ySign < 0 {
                    yFlips += 1
                }
                ySign = 1
            } else if a.y < 0 {
                if ySign == 0 {
                    yFirstSign = -1
                } else if ySign > 0 {
                    yFlips += 1
                }
                ySign = -1
            }
            
            if yFlips > 2 {
                return false
            }
            
            // Find out the orientation of this pair of edges, and ensure it
            // does not differ from previous ones
            let w = b.cross(a)
            if w * wSign < 0 {
                return false
            }
        }
        
        // Final/wraparound sign flips:
        if xSign != 0 && xFirstSign != 0 && xSign != xFirstSign {
            xFlips = xFlips + 1
        }
        if ySign != 0 && yFirstSign != 0 && ySign != yFirstSign {
            yFlips = yFlips + 1
        }
        
        // Concave polygons have two sign flips along each axis
        if xFlips != 2 || yFlips != 2 {
            return false
        }
        
        // This is a convex polygon
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
                let edgeSlope = edgeEnd - edgeSt
                let slopeMag = edgeSlope.x / edgeSlope.y
                let vecDiff = vector.y - edgeSt.y
                let hitX = edgeSt.x + vecDiff * slopeMag
                
                if hitX >= vector.x && hitX <= endPtX {
                    inside = !inside
                }
            }
            
            edgeSt = edgeEnd
        }
        
        return inside
    }
}
