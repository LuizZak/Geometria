/// A [point-cloud](https://en.wikipedia.org/wiki/Point_cloud) container for
/// discrete sets of points in space.
public struct PointCloud<Vector: VectorType> {
    /// The points contained within this point-cloud.
    public var points: [Vector]

    /// Initializes an empty point-cloud.
    public init() {
        self.points = []
    }

    /// Initializes a new point-cloud with a given sequence of points.
    @inlinable
    public init<S: Sequence>(points: S) where S.Element == Vector {
        self.points = Array(points)
    }
}

public extension PointCloud where Vector: VectorAdditive {
    /// Returns a copy of this point cloud, offset in space by `offset`.
    @inlinable
    func translated(by offset: Vector) -> Self {
        .init(points: points.map { $0 + offset })
    }
}

public extension PointCloud where Vector: VectorComparable & VectorAdditive {
    /// Gets the minimal axis-aligned bounding box capable of containing this
    /// point cloud.
    @inlinable
    var bounds: AABB<Vector> {
        AABB(points: points)
    }
}

public extension PointCloud where Vector: VectorMultiplicative {
    /// Returns a copy of this point cloud, scaled in space towards the origin
    /// by `scale`.
    @inlinable
    func scaled(by scale: Vector) -> Self {
        .init(points: points.map { $0 * scale })
    }

    /// Returns a copy of this point cloud, scaled in space towards the given
    /// center point by `scale`.
    @inlinable
    func scaled(by scale: Vector, around center: Vector) -> Self {
        .init(points: points.map { ($0 - center) * scale + center })
    }
}
