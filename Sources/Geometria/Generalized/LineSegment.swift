import RealModule

/// Represents a [line segment] as a pair of start and end N-dimensional vectors
/// which describe a closed interval.
///
/// [line segment]: https://en.wikipedia.org/wiki/Line_segment
public struct LineSegment<Vector: VectorType>: LineType, CustomStringConvertible {
    public typealias Scalar = Vector.Scalar

    /// The bounded start of this line segment, inclusive.
    public var start: Vector

    /// The bounded end of this line segment, inclusive.
    public var end: Vector

    /// Alias for ``start``.
    @_transparent
    public var a: Vector {
        start
    }

    /// Alias for ``b``.
    @_transparent
    public var b: Vector {
        end
    }

    @inlinable
    public var category: LineCategory { .lineSegment }

    public var description: String {
        "\(type(of: self))(start: \(start), end: \(end))"
    }

    @_transparent
    public init(start: Vector, end: Vector) {
        self.start = start
        self.end = end
    }
}

extension LineSegment: Equatable where Vector: Equatable, Scalar: Equatable { }
extension LineSegment: Hashable where Vector: Hashable, Scalar: Hashable { }
extension LineSegment: Encodable where Vector: Encodable, Scalar: Encodable { }
extension LineSegment: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension LineSegment {
    /// Returns a ``Line`` representation of this line segment, where the
    /// result's ``Line/a`` matches ``start`` and ``Line/b`` matches ``end``.
    @_transparent
    var asLine: Line<Vector> {
        Line(a: start, b: end)
    }

    /// Returns a ``Ray`` representation of this line segment, where the
    /// result's ``Ray/start`` matches ``start`` and ``Ray/b`` matches ``end``.
    @_transparent
    var asRay: Ray<Vector> {
        Ray(start: start, b: end)
    }

    /// Returns a new line segment that has the `start` and `end` points of this
    /// line, in reverse order.
    @inlinable
    var reversed: Self {
        .init(start: end, end: start)
    }
}

extension LineSegment: BoundableType where Vector: VectorComparable {
    /// Returns the minimal ``AABB`` capable of containing this line segment's
    /// points.
    @_transparent
    public var bounds: AABB<Vector> {
        AABB(minimum: Vector.pointwiseMin(a, b),
             maximum: Vector.pointwiseMax(a, b))
    }
}

extension LineSegment: LineAdditive where Vector: VectorAdditive {
    @_transparent
    public func offsetBy(_ vector: Vector) -> Self {
        Self(start: start + vector, end: end + vector)
    }
}

extension LineSegment: LineMultiplicative where Vector: VectorMultiplicative {
    /// Returns the squared length of this line.
    ///
    /// - seealso: ``length``
    @_transparent
    public var lengthSquared: Scalar {
        (end - start).lengthSquared
    }

    @_transparent
    public func withPointsScaledBy(_ factor: Vector) -> Self {
        Self(start: start * factor, end: end * factor)
    }

    @_transparent
    public func withPointsScaledBy(_ factor: Vector, around center: Vector) -> Self {
        let newStart: Vector = (start - center) * factor + center
        let newEnd: Vector = (end - center) * factor + center

        return Self(start: newStart, end: newEnd)
    }
}

extension LineSegment: LineDivisible where Vector: VectorDivisible {
    /// Gets the center point of this line segment.
    @_transparent
    public var center: Vector {
        (start + end) / 2
    }
}

extension LineSegment: LineFloatingPoint & PointProjectableType & SignedDistanceMeasurableType where Vector: VectorFloatingPoint {
    /// Returns the length of this line.
    ///
    /// - seealso: ``lengthSquared``
    @_transparent
    public var length: Scalar {
        (end - start).length
    }

    /// Returns a ``DirectionalRay`` representation of this ray, where the
    /// result's ``DirectionalRay/start`` matches ``start`` and
    /// ``DirectionalRay/direction`` matches `(end - start).normalized()`.
    ///
    /// - precondition: `(self.end - self.start).length > 0`
    @_transparent
    public var asDirectionalRay: DirectionalRay<Vector> {
        DirectionalRay(start: start, direction: end - start)
    }

    /// Returns `true` for projected scalars (0-1), which describes a
    /// [line segment].
    ///
    /// [line segment]: https://en.wikipedia.org/wiki/Line_segment
    @_transparent
    public func containsProjectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Bool {
        scalar >= 0 && scalar <= 1
    }

    /// Returns a projected normalized magnitude that is guaranteed to be
    /// contained in this line.
    ///
    /// For ``LineSegment``, this is a clamped inclusive (0-1) range.
    @_transparent
    public func clampProjectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Vector.Scalar {
        min(1, max(0, scalar))
    }

    /// Returns the squared distance between this line and a given vector.
    ///
    /// The projected point on which the distance is taken is capped between
    /// the start and end points.
    ///
    /// ```swift
    /// let line = LineSegment2D(x1: 1, y1: 1, x2: 3, y2: 1)
    /// let point1 = Vector2D(x: 0, y: 0)
    /// let point2 = Vector2D(x: 2, y: 0)
    /// let point3 = Vector2D(x: 4, y: 0)
    ///
    /// print(line.distanceSquared(to: point1)) // Prints "2"
    /// print(line.distanceSquared(to: point2)) // Prints "1"
    /// print(line.distanceSquared(to: point3)) // Prints "2"
    /// ```
    @inlinable
    public func distanceSquared(to vector: Vector) -> Scalar {
        let proj = min(1, max(0, projectAsScalar(vector)))

        let point = start.addingProduct(end - start, proj)

        return vector.distanceSquared(to: point)
    }
}

extension LineSegment: LineReal where Vector: VectorReal {

}
