import Geometria

public extension PointCloud2 where Vector: Vector2Real {
    /// Returns a point-cloud representing the convex hull of the points within
    /// this point cloud using [Graham scan].
    ///
    /// [Graham scan]: https://en.wikipedia.org/wiki/Graham_scan
    func grahamScanConvexHull() -> Self {
        guard points.count > 3 else { return Self() }

        guard
            let p0Index = points.indices.min(by: { lhs, rhs in
                if points[lhs].y < points[rhs].y {
                    return true
                }
                if points[lhs].y == points[rhs].y {
                    return points[lhs].x < points[rhs].x
                }

                return false
            })
        else {
            return Self()
        }

        // Sort points, favoring points that wind counter-clockwise earlier in
        // the array
        let p0 = points[p0Index]
        var sortedPoints = points
        sortedPoints.swapAt(0, p0Index)
        sortedPoints[1...].sort(by: { lhs, rhs in
            let winding = Vector.winding(p0, lhs, rhs)
            if winding < 0 {
                return true
            }
            if winding > 0 {
                return false
            }

            return lhs.distanceSquared(to: p0) < rhs.distanceSquared(to: p0)
        })

        // Remove colinear points, the resulting points should be the maximally
        // distant of the colinear points
        var index = 1
        var maxBound = 1
        while index < sortedPoints.count {
            defer { index += 1 }

            while index < sortedPoints.count - 1, Vector.winding(p0, sortedPoints[index], sortedPoints[index + 1]) == .zero {
                index += 1
            }
            sortedPoints.swapAt(index, maxBound)
            maxBound += 1
        }

        // Convex hulls require at least three points
        guard maxBound >= 3 else {
            return Self()
        }

        // Apply winding algorithm on the remaining points
        var stack: [Vector] = []

        for point in sortedPoints[..<maxBound] {
            while stack.count > 1, Vector.winding(stack[stack.count - 2], stack[stack.count - 1], point) >= .zero {
                stack.removeLast()
            }
            stack.append(point)
        }

        return Self(points: stack)
    }
}
