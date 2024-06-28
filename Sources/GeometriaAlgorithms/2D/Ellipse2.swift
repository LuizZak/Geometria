import Numerics
import Geometria

public extension Ellipse2 where Vector: VectorReal {
    /// Returns the point on a given angle, in radians, on this ellipse.
    @inlinable
    func pointOnAngle(_ angleInRadians: Scalar) -> Vector {
        let c = Scalar.cos(angleInRadians)
        let s = Scalar.sin(angleInRadians)

        return center + .init(x: c, y: s) * radius
    }

    /// Performs an approximation-type search to find the closest point on the
    /// ellipse's outer surface to a given point.
    ///
    /// Each step of the search samples `samples` points on the ellipse, using
    /// the closest point on the samples to perform a deeper search around the
    /// sample, up to a depth of `maxDepth`, or until a mean tolerance of
    /// `tolerance` between samples is achieved.
    ///
    /// - complexity: `O(samples * maxDepth)`, for the worst case of the search.
    func approximateClosestPoint(
        to vector: Vector,
        tolerance: Scalar,
        samples: Int,
        maxDepth: Int
    ) -> Vector where Scalar: Strideable, Scalar.Stride == Scalar {

        precondition(samples > 0, "samples > 0")
        precondition(maxDepth > 0, "maxDepth > 0")

        var closestInRadians: (distanceSquared: Scalar, angle: Scalar) = (.infinity, 0)

        let samplesAsScalar = Scalar(samples)

        var searchStart: Scalar = 0
        var searchEnd: Scalar = .pi * 2
        var searchStep: Scalar = .pi * 2 / samplesAsScalar

        outer:
        for _ in 0..<maxDepth {
            var lastPointDistance: Scalar = .infinity

            for radians in stride(from: searchStart, to: searchEnd, by: searchStep) {
                let point = pointOnAngle(radians)
                let distanceSquared = point.distanceSquared(to: vector)

                if distanceSquared < closestInRadians.distanceSquared {
                    closestInRadians = (distanceSquared, radians)
                }

                // Check if we are increasing in distance, instead of decreasing,
                // and quit early; unless we are in the first depth of search, in
                // which case span the entire sample space, since leaving it out
                // might result in the wrong quadrant being picked
                if lastPointDistance < distanceSquared {
                    break
                }

                lastPointDistance = distanceSquared
            }

            if searchStep < tolerance {
                break
            }

            // Narrow search
            searchStep /= samplesAsScalar
            searchStart = closestInRadians.angle - searchStep * 10
            searchEnd = closestInRadians.angle + searchStep * 10
        }

        return pointOnAngle(closestInRadians.angle)
    }
}
