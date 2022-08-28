/// Represents a 2D polygon as a series of connected double-precision
/// floating-point 2D vertices.
public typealias LinePolygon2D = LinePolygon2<Vector2D>

/// Represents a 2D polygon as a series of connected single-precision
/// floating-point 2D vertices.
public typealias LinePolygon2F = LinePolygon2<Vector2F>

/// Represents a 2D polygon as a series of connected integer 2D vertices.
public typealias LinePolygon2i = LinePolygon2<Vector2i>

/// Typealias for `LinePolygon<V>`, where `V` is constrained to ``Vector2Type``.
public typealias LinePolygon2<V: Vector2Type> = LinePolygon<V>

public extension LinePolygon2 {
    /// Adds a new 2D vertex at the end of this polygon's vertices list
    @_transparent
    mutating func addVertex(x: Scalar, y: Scalar) {
        vertices.append(Vector(x: x, y: y))
    }
}

extension LinePolygon2 where Vector: Vector2Multiplicative {
    /// Returns the winding number for this polygon.
    ///
    /// The winding number is the sum of the cross products of each adjacent
    /// edge's slope.
    ///
    /// Positive values indicate clockwise orientation in an (X-Right, Y-Up)
    /// space, while negative indicate counter-clockwise.
    ///
    /// If this polygon has less than 3 points, `.zero` is returned instead.
    public func winding() -> Vector.Scalar {
        guard var v2 = vertices.last else {
            return 0
        }
        
        var winding: Vector.Scalar = 0
        
        for p in vertices {
            winding += v2.cross(p)
            v2 = p
        }
        
        return winding
    }
}

extension LinePolygon2 where Vector: Vector2Multiplicative, Vector.Scalar: DivisibleArithmetic {
    /// Returns the signed area of this 2D polygon.
    ///
    /// Positive values indicate clockwise orientation in an (X-Right, Y-Up)
    /// space, while negative indicate counter-clockwise.
    public func area() -> Vector.Scalar {
        return winding() / 2
    }
}

extension LinePolygon2 where Vector: Vector2Multiplicative & VectorComparable {
    /// Returns `true` if this polygon is convex.
    ///
    /// A polygon must have at least 3 points to be considered convex.
    ///
    /// If the polygon self-intersects, `false` is returned.
    public func isConvex() -> Bool {
        // Implementation based on:
        // https://math.stackexchange.com/a/1745427
        
        if vertices.count < 3 {
            return false
        }
        
        var xSign = SignFlipHandler()
        var ySign = SignFlipHandler()
        
        let secondToLast: Vector = vertices[vertices.count - 2]
        let last: Vector = vertices[vertices.count - 1]
        
        let diffLast = last - secondToLast
        let diffFirst = vertices[0] - last
        let wSign: Scalar = diffLast.cross(diffFirst)
        
        var current: Vector = secondToLast
        var next: Vector = last
        
        for v in vertices {
            let prev = current
            current = next
            next = v
            
            let b: Vector = current - prev
            let a: Vector = next - current
            
            // Calculate sign flips using the next edge vector, recording the
            // first sign
            if xSign.recordValue(a.x) || ySign.recordValue(a.y) {
                return false
            }
            
            // Find out the orientation of this pair of edges, and ensure it
            // does not differ from previous ones
            let w = b.cross(a)
            if w * wSign < Scalar.zero {
                return false
            }
        }
        
        // Final/wraparound sign flips:
        xSign.finish()
        ySign.finish()
        
        // Convex polygons have exactly two sign flips along each axis
        if xSign.flips != 2 || ySign.flips != 2 {
            return false
        }
        
        // This is a convex polygon
        return true
    }
    
    // Auxiliary struct for LinePolygon2.isConvex used to track value sign changes
    struct SignFlipHandler {
        private var sign: Sign = .indeterminate
        private var firstSign: Sign = .indeterminate
        var flips: Int = 0

        /// Records a signed value to derive the sign flips from.
        ///
        /// Also returns whether the sign has been flipped two or more times.
        mutating func recordValue(_ value: Scalar) -> Bool {
            if value > Scalar.zero {
                if sign == .indeterminate {
                    firstSign = .positive
                } else if sign == .negative {
                    flips += 1
                }

                sign = .positive
            } else if value < Scalar.zero {
                if sign == .indeterminate {
                    firstSign = .negative
                } else if sign == .positive {
                    flips += 1
                }

                sign = .negative
            }

            return hasFlippedTwice()
        }
        
        /// Returns `true` when the sign of a scalar value has flipped at least
        /// two times.
        func hasFlippedTwice() -> Bool {
            if flips > 2 {
                return true
            }
            
            return false
        }
        
        mutating func finish() {
            if sign != .indeterminate && firstSign != .indeterminate && sign != firstSign {
                flips += 1
            }
        }

        enum Sign {
            case positive
            case negative
            case indeterminate
        }
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
            
            if ((edgeSt.y <= vector.y) && (edgeEnd.y > vector.y)) || ((edgeEnd.y <= vector.y) && (edgeSt.y > vector.y)) {
                let edge: Vector = edgeEnd - edgeSt
                let slope: Scalar = edge.x / edge.y
                let vecDiff: Scalar = vector.y - edgeSt.y
                let hitX: Scalar = edgeSt.x + vecDiff * slope
                
                if hitX >= vector.x && hitX <= endPtX {
                    inside = !inside
                }
            }
            
            edgeSt = edgeEnd
        }
        
        return inside
    }
}
