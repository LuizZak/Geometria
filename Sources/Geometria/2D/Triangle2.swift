/// Represents a 2D triangle as a trio of N-dimensional vectors with
/// double-precision floating-point components.
public typealias Triangle2D = Triangle2<Vector2D>

/// Represents a 2D triangle as a trio of N-dimensional vectors with
/// single-precision floating-point components.
public typealias Triangle2F = Triangle2<Vector2F>

/// Represents a 2D triangle as a trio of N-dimensional vectors with integer
/// components.
public typealias Triangle2i = Triangle2<Vector2i>

/// Typealias for `Triangle<V>`, where `V` is constrained to `Vector2Type`.
public typealias Triangle2<V: Vector2Type> = Triangle<V>

public extension Triangle2 where Vector: Vector2Multiplicative, Scalar: Comparable {
    /// Returns `true` if this triangle winds in clockwise order (in Cartesian
    /// space).
    var isClockwise: Bool {
        let ab = a - b
        let bc = b - c
        
        return ab.cross(bc) < .zero
    }
}

extension Triangle2: VolumetricType where Vector: Vector2FloatingPoint {
    /// Returns whether the given vector is contained within this triangle.
    ///
    /// Points at the perimeter of the triangle, as well as the points forming
    /// the corners of the triangle, are not considered as contained within the
    /// triangle (exclusive).
    ///
    /// Triangles where `area == .zero` cannot contain points and return `false`
    /// for any containment check.
    public func contains(_ vector: Vector) -> Bool {
        let area = self.area
        if area == .zero {
            return false
        }
        
        let sign: Scalar = isClockwise ? -1 : 1
        
        let caCross = c.cross(a)
        
        let caMinus = a - c
        let caMinusCross = caMinus.cross(vector)
        
        let s: Scalar = (caCross + caMinusCross) * sign
        if s <= .zero {
            return false
        }
        
        let abCross = a.cross(b)
        let abMinus = a - c
        let abMinusCross = caMinus.cross(vector)
        
        let t: Scalar = (abCross + (a.y - b.y) * vector.x as Scalar + (b.x - a.x) * vector.y as Scalar) * sign
        if t <= .zero {
            return false
        }
        
        return (s + t) < 2 * area
    }
}
