import RealModule

/// Defines a line type that can represent either a [line], [ray] or [line segment],
/// depending on whether the ends of the line are open or closed.
///
/// 
/// [line]: https://en.wikipedia.org/wiki/Line_(geometry)
/// [ray]: https://en.wikipedia.org/wiki/Line_(geometry)#Ray
/// [line segment]: https://en.wikipedia.org/wiki/Line_segment
public struct IntervalLine<Vector: VectorFloatingPoint> {
    public typealias Scalar = Vector.Scalar

    /// A point on this line.
    public var pointOnLine: Vector
    
    /// A unit vector relative to `pointOnLine` which indicates the direction of
    /// this line.
    ///
    /// Must have `length > 0`.
    @UnitVector
    public var direction: Vector

    /// The minimum magnitude of this line, relative to `pointOnLine -> direction`.
    ///
    /// If `-Scalar.infinity`, represents an interval line with an open start.
    ///
    /// If equal to or greater than ``maximumMagnitude``, the line is considered
    /// degenerate.
    public var minimumMagnitude: Scalar
    
    /// The maximum magnitude of this line, relative to `pointOnLine -> direction`.
    ///
    /// If `Scalar.infinity`, represents an interval line with an open end.
    ///
    /// If equal to or less than ``minimumMagnitude``, the line is considered
    /// degenerate.
    public var maximumMagnitude: Scalar

    public var category: LineCategory {
        var rawValue = 0
        if minimumMagnitude.isInfinite {
            rawValue |= LineCategory.startOpenBit
        }
        if maximumMagnitude.isInfinite {
            rawValue |= LineCategory.endOpenBit
        }

        return .init(rawValue: rawValue)
    }
    
    /// Creates a line segment interval with minimum and maximum magnitudes.
    /// 
    /// - note: If `start == end`, the resulting interval line will be considered
    /// [degenerate].
    ///
    /// [degenerate]: https://en.wikipedia.org/wiki/Degeneracy_(mathematics)
    @_transparent
    public init(start: Vector, end: Vector) {
        self.pointOnLine = start
        self.direction = (end - start)

        self.minimumMagnitude = 0
        self.maximumMagnitude = start.distance(to: end)
    }

    /// Creates an interval line with the given properties.
    @_transparent
    public init(
        pointOnLine: Vector,
        direction: Vector,
        minimumMagnitude: Scalar,
        maximumMagnitude: Scalar
    ) {
        self.pointOnLine = pointOnLine
        self.direction = direction

        self.minimumMagnitude = minimumMagnitude
        self.maximumMagnitude = maximumMagnitude
    }
}

extension IntervalLine: Equatable where Vector: Equatable, Scalar: Equatable { }
extension IntervalLine: Hashable where Vector: Hashable, Scalar: Hashable { }
extension IntervalLine: Encodable where Vector: Encodable, Scalar: Encodable { }
extension IntervalLine: Decodable where Vector: Decodable, Scalar: Decodable { }

public extension IntervalLine {
    /// Returns a ``Line`` representation of this interval line, where the
    /// result's ``Line/a`` matches ``a`` and ``Line/b``
    /// matches ``b``.
    @_transparent
    var asLine: Line<Vector> {
        Line(
            a: a,
            b: b
        )
    }
}

extension IntervalLine: LineType {
    @inlinable
    public var a: Vector {
        if minimumMagnitude.isFinite {
            return pointOnLine + direction * minimumMagnitude
        }
        if maximumMagnitude.isFinite && maximumMagnitude <= .zero {
            return pointOnLine - direction * (maximumMagnitude + 1)
        }

        return pointOnLine
    }

    @inlinable
    public var b: Vector {
        if maximumMagnitude.isFinite {
            return pointOnLine + direction * maximumMagnitude
        }
        if minimumMagnitude.isFinite && minimumMagnitude >= 1 {
            return pointOnLine + direction * (minimumMagnitude + 1)
        }

        return pointOnLine + direction
    }
}

extension IntervalLine: LineAdditive where Vector: VectorAdditive {
    @_transparent
    public func offsetBy(_ vector: Vector) -> Self {
        var copy = self
        copy.pointOnLine += vector
        return copy
    }
}

extension IntervalLine: LineMultiplicative where Vector: VectorMultiplicative {
    /// Returns the squared length of this interval line.
    ///
    /// If ``minimumMagnitude.isInfinite`` or ``maximumMagnitude.isInfinite`` are
    /// either true, the result will also be an infinite value.
    ///
    /// - seealso: ``length``
    @_transparent
    public var lengthSquared: Scalar {
        length * length
    }

    @inlinable
    public func withPointsScaledBy(_ factor: Vector) -> Self {
        withPointsScaledBy(factor, around: .zero)
    }
    
    @inlinable
    public func withPointsScaledBy(_ factor: Vector, around center: Vector) -> Self {
        if minimumMagnitude.isInfinite && maximumMagnitude.isInfinite {
            return Self(
                pointOnLine: (pointOnLine - center) * factor + center,
                direction: direction * factor,
                minimumMagnitude: minimumMagnitude,
                maximumMagnitude: maximumMagnitude
            )
        }

        var copy = Self(
            start: (a - center) * factor + center,
            end: (b - center) * factor + center
        )

        if minimumMagnitude.isInfinite {
            copy.minimumMagnitude = minimumMagnitude
        }
        if maximumMagnitude.isInfinite {
            copy.minimumMagnitude = maximumMagnitude
        }
        
        return copy
    }
}

extension IntervalLine: LineDivisible where Vector: VectorDivisible {

}

extension IntervalLine: LineFloatingPoint & PointProjectableType & SignedDistanceMeasurableType where Vector: VectorFloatingPoint {
    /// Returns the length of this interval line.
    ///
    /// If ``minimumMagnitude.isInfinite`` or ``maximumMagnitude.isInfinite`` are
    /// either true, the result will also be an infinite value.
    ///
    /// - seealso: ``lengthSquared``
    @_transparent
    public var length: Scalar {
        (maximumMagnitude - minimumMagnitude)
    }
    
    @inlinable
    public func projectedMagnitude(_ scalar: Magnitude) -> Vector {
        a.addingProduct(direction, scalar)
    }
    
    @inlinable
    public func projectedNormalizedMagnitude(_ scalar: Magnitude) -> Vector {
        return a.addingProduct(lineSlope, scalar)
    }

    /// Returns `true` if this interval line contains a given normalized magnitude
    /// from `a -> b`.
    @inlinable
    public func containsProjectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Bool {
        if minimumMagnitude.isFinite && scalar < 0 {
            return false
        }
        if maximumMagnitude.isFinite && scalar > 1 {
            return false
        }

        return !scalar.isNaN
    }
    
    /// Returns a projected normalized magnitude that is guaranteed to be
    /// contained in this line.
    @inlinable
    public func clampProjectedNormalizedMagnitude(_ scalar: Vector.Scalar) -> Vector.Scalar {
        var scalar = scalar
        if minimumMagnitude.isFinite {
            scalar = max(0, scalar)
        }
        if maximumMagnitude.isFinite {
            scalar = min(1, scalar)
        }

        return scalar
    }
}

extension IntervalLine: LineReal where Vector: VectorReal {
    
}
