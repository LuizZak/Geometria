import Geometria

/// A [k-d tree] implementation for point-clouds.
///
/// [k-d tree](https://en.wikipedia.org/wiki/K-d_tree)
public struct KDTree<Vector: VectorType> where Vector: VectorComparable & VectorMultiplicative {
    private var root: Subdivision?

    /// Returns the total number of items within this k-d tree.
    public var count: Int {
        return root?.totalItemCount ?? 0
    }

    /// Initializes a new k-d tree from a given set of points.
    public init<C: Collection<Vector>>(points: C) where Vector: VectorAdditive {
        self.init(
            dimensionCount: Vector.zero.scalarCount,
            points: points
        )
    }

    /// Initializes a new k-d tree from a given set of points.
    public init<C: Collection<Vector>>(dimensionCount: Int, points: C) {
        self.root = .create(
            points,
            absolutePath: .root,
            dimensionCount: dimensionCount,
            depth: 0
        )
    }

    /// Returns the list of all points within this k-d tree.
    public func points() -> [Vector] {
        guard let root else { return [] }

        return .init(unsafeUninitializedCapacity: count) { (buffer, count) in
            var index = 0

            root.applyToTreeBreadthFirst { sub in
                buffer[index] = sub.point

                index += 1
            }

            count = index
        }
    }

    /// Returns the nearest neighbor in this k-d tree to a given point vector.
    /// Result is `nil`, if this k-d tree is empty.
    public func nearestNeighbor(to point: Vector) -> Vector? {
        root?.nearestNeighbor(to: point).point
    }

    /// Returns all possible subdivision paths within this k-d tree that contain
    /// a point.
    public func subdivisionPaths() -> [SubdivisionPath] {
        guard let root else { return [] }

        var results: [SubdivisionPath] = []

        root.applyToTreeBreadthFirst { sub in
            results.append(sub.absolutePath)
        }

        return results
    }

    /// Returns the deepest subdivision path that contains the given point in
    /// either its left or right subdivision, plus the subpath that is either
    /// left or right, depending on which side the point lies on that subdivision
    /// level.
    public func subdivisionPath(forInserting point: Vector) -> SubdivisionPath {
        guard let root else { return .root }

        var current = root

        while case .subdivision(_, let left, let right) = current {
            let isLeft = current.isOnLeft(point)

            if isLeft {
                if let left {
                    current = left
                } else {
                    return current.absolutePath.left
                }
            } else {
                if let right {
                    current = right
                } else {
                    return current.absolutePath.right
                }
            }
        }

        return current.absolutePath
    }

    /// Inserts a given point on this k-d tree.
    public mutating func insert(_ point: Vector) {
        guard let root else {
            root = .subdivision(
                .empty(
                    point: point,
                    dimension: 0,
                    totalItemCount: 1,
                    absolutePath: .root
                ),
                left: nil,
                right: nil
            )

            return
        }

        let path = subdivisionPath(forInserting: point)
        let reversed = path.reversed

        self.root = root.inserting(point, reversePath: reversed)
    }

    /// Encodes a path to a specific subdivision within a k-d tree.
    public enum SubdivisionPath: Hashable, CustomStringConvertible {
        /// Specifies the root element.
        case root

        /// Specifies a left child into a k-d tree split.
        indirect case left(parent: Self)

        /// Specifies a right child into a k-d tree split.
        indirect case right(parent: Self)

        public var description: String {
            switch self {
            case .root:
                return ".root"
            case .left(let parent):
                return "\(parent).left"
            case .right(let parent):
                return "\(parent).right"
            }
        }

        /// Returns the access path for a nested subdivision that branches from
        /// the left path of this subdivision path.
        var left: Self {
            .left(parent: self)
        }

        /// Returns the access path for a nested subdivision that branches from
        /// the right path of this subdivision path.
        var right: Self {
            .right(parent: self)
        }

        /// Returns the inverse subdivision path from this path.
        /// The reversed path can be used to navigate, starting from a `root`
        /// subdivision, deeper into a subdivision tree.
        var reversed: InvertedSubdivisionPath {
            _reversed({ .self })
        }

        private func _reversed(_ child: () -> InvertedSubdivisionPath) -> InvertedSubdivisionPath {
            switch self {
            case .root:
                return child()

            case .left(let parent):
                return parent._reversed({ .left(child()) })

            case .right(let parent):
                return parent._reversed({ .right(child()) })
            }
        }

        /// Resolves this subdivision path into a given tree.
        /// 
        /// - precondition: The depth of this subdivision path is less than or
        /// equal to the maximum depth of `tree`.
        fileprivate func resolve(in tree: Subdivision) -> Subdivision {
            switch self {
            case .root:
                return tree

            case .left(let parent):
                guard let left = parent.resolve(in: tree).left else {
                    preconditionFailure("Depth of input tree path is shallower than subdivision path \(self)")
                }

                return left

            case .right(let parent):
                guard let right = parent.resolve(in: tree).right else {
                    preconditionFailure("Depth of input tree path is shallower than subdivision path \(self)")
                }

                return right
            }
        }
    }

    /// An inverted subdivision path better fit for top-to-bottom accesses of
    /// a k-d tree.
    enum InvertedSubdivisionPath: Hashable, CustomStringConvertible {
        /// Path ends at the current node.
        case `self`

        /// Path branches to the left, traveling with the remaining path.
        indirect case left(InvertedSubdivisionPath)
        
        /// Path branches to the right, traveling with the remaining path.
        indirect case right(InvertedSubdivisionPath)

        var description: String {
            switch self {
            case .self:
                return "leaf"
            case .left(let child):
                return "left.\(child)"
            case .right(let child):
                return "right.\(child)"
            }
        }

        /// Resolves this subdivision path into a given tree.
        /// 
        /// - precondition: The depth of this subdivision path is less than or
        /// equal to the maximum depth of `tree`.
        fileprivate func resolve(in tree: Subdivision) -> Subdivision {
            switch self {
            case .self:
                return tree

            case .left(let child):
                guard let left = tree.left else {
                    preconditionFailure("Depth of input tree path is shallower than subdivision path \(self)")
                }

                return child.resolve(in: left)

            case .right(let child):
                guard let right = tree.right else {
                    preconditionFailure("Depth of input tree path is shallower than subdivision path \(self)")
                }

                return child.resolve(in: right)
            }
        }
    }

    /// Shared state for all k-d tree subdivision levels.
    fileprivate struct SubdivisionState {
        /// Initializes an empty subdivision state.
        static func empty(
            point: Vector,
            dimension: Int,
            totalItemCount: Int,
            absolutePath: SubdivisionPath
        ) -> Self {
            .init(
                point: point,
                dimension: dimension,
                totalItemCount: totalItemCount,
                absolutePath: absolutePath
            )
        }

        /// The point associated with this subdivision state.
        var point: Vector

        /// The numerical dimension that this subdivision splits between.
        var dimension: Int

        /// Returns the total number of items within this particular subdivision
        /// tree, including all nested subdivisions.
        var totalItemCount: Int

        /// The absolute path from the root subdivision path this subdivision
        /// node.
        var absolutePath: SubdivisionPath
    }

    fileprivate enum Subdivision {
        /// A subdivision of a k-d tree 
        indirect case subdivision(SubdivisionState, left: Self?, right: Self?)
    }
}

extension KDTree.Subdivision {
    /// The point associated with this subdivision.
    var point: Vector {
        state.point
    }

    /// The absolute path from the root subdivision path this subdivision
    /// node.
    var absolutePath: KDTree.SubdivisionPath {
        state.absolutePath
    }

    /// Returns the total number of items within this particular subdivision
    /// tree, including all nested subdivisions.
    var totalItemCount: Int {
        state.totalItemCount
    }

    /// Gets the common state for this subdivision object.
    var state: KDTree.SubdivisionState {
        get {
            switch self {
            case .subdivision(let state, _, _):
                return state
            }
        }
        set {
            switch self {
            case .subdivision(
                _,
                let left,
                let right
            ):
                self = .subdivision(
                    newValue,
                    left: left,
                    right: right
                )
            }
        }
    }

    /// If this subdivision level contains a split, returns the left side
    /// of that split.
    var left: Self? {
        get {
            switch self {
            case .subdivision(_, let left, _):
                return left
            }
        }
        set {
            switch self {
            case .subdivision(let state, _, let right):
                self = .subdivision(
                    state,
                    left: newValue,
                    right: right
                )
            }
        }
    }

    /// If this subdivision level contains a split, returns the right side
    /// of that split.
    var right: Self? {
        get {
            switch self {
            case .subdivision(_, _, let right):
                return right
            }
        }
        set {
            switch self {
            case .subdivision(let state, let left, _):
                self = .subdivision(
                    state,
                    left: left,
                    right: newValue
                )
            }
        }
    }

    /// Returns an array of subdivisions from this tree subdivision.
    ///
    /// Returns an empty array, in case this subdivision is a `.leaf` case.
    var subdivisions: [Self] {
        switch self {
        case .subdivision(_, nil, nil):
            return []
            
        case .subdivision(_, let left?, nil):
            return [left]

        case .subdivision(_, nil, let right?):
            return [right]

        case .subdivision(_, let left?, let right?):
            return [left, right]
        }
    }

    /// Subscripts into this subdivision with an inverted path, allowing
    /// mutation of a particular tree node.
    subscript(path: KDTree.InvertedSubdivisionPath) -> Self? {
        get {
            switch path {
            case .self:
                return self

            case .left(let child):
                return left?[child]

            case .right(let child):
                return right?[child]
            }
        }
        set {
            switch path {
            case .self:
                break

            case .left(let child):
                if child == .self {
                    left = newValue
                } else {
                    left?[child] = newValue
                }

            case .right(let child):
                if child == .self {
                    right = newValue
                } else {
                    right?[child] = newValue
                }
            }
        }
    }

    /// Returns the nearest neighbor in this subdivision to a given point vector.
    func nearestNeighbor(to point: Vector) -> (point: Vector, distanceSquared: Vector.Scalar) {
        switch self {
        case .subdivision(let state, nil, nil):
            return (
                state.point,
                distanceSquared: point.distanceSquared(to: state.point)
            )
        
        case .subdivision(let state, let left?, nil):
            var current: (point: Vector, distanceSquared: Vector.Scalar)

            current = left.nearestNeighbor(to: point)

            if point.distanceSquared(to: state.point) < current.distanceSquared {
                current = (
                    state.point,
                    distanceSquared: point.distanceSquared(to: state.point)
                )
            }

            return current

        case .subdivision(let state, nil, let right?):
            var current: (point: Vector, distanceSquared: Vector.Scalar)

            current = right.nearestNeighbor(to: point)

            if point.distanceSquared(to: state.point) < current.distanceSquared {
                current = (
                    state.point,
                    distanceSquared: point.distanceSquared(to: state.point)
                )
            }

            return current

        case .subdivision(let state, let left?, let right?):
            var current: (point: Vector, distanceSquared: Vector.Scalar)

            let (first, second) = isOnLeft(point) ? (left, right) : (right, left)

            current = first.nearestNeighbor(to: point)

            guard distanceSquared(to: point) < current.distanceSquared else {
                return current
            }

            let childNearest = second.nearestNeighbor(to: point)
            if childNearest.distanceSquared < current.distanceSquared {
                current = childNearest
            }
            
            // Check this subdivision's point now.
            if point.distanceSquared(to: state.point) < current.distanceSquared {
                current = (
                    state.point,
                    distanceSquared: point.distanceSquared(to: state.point)
                )
            }

            return current
        }
    }

    /// Returns `true` if the current subdivision level point's scalar at
    /// the current subdivision dimension is less than or equal to the
    /// same scalar of the given point.
    func isOnLeft(_ point: Vector) -> Bool {
        point[state.dimension] < state.point[state.dimension]
    }

    /// Returns the distance squared from a given point to the subdivision
    /// line of this subdivision.
    func distanceSquared(to point: Vector) -> Vector.Scalar {
        let dist = point[state.dimension] - state.point[state.dimension]

        return dist * dist
    }

    /// Returns a copy of this subdivision, with a new point inserted at a
    /// given subdivision path.
    func inserting(_ point: Vector, reversePath: KDTree.InvertedSubdivisionPath) -> Self {
        var copy = self

        switch reversePath {
        case .self:
            break

        case .left(let child):
            copy.state.totalItemCount += 1

            if child == .self {
                copy.left = .subdivision(
                    .init(
                        point: point,
                        dimension: (state.dimension + 1) % point.scalarCount,
                        totalItemCount: 1,
                        absolutePath: absolutePath.left
                    ),
                    left: nil,
                    right: nil
                )
            } else {
                copy.left = copy.left?.inserting(point, reversePath: child)
            }

        case .right(let child):
            copy.state.totalItemCount += 1

            if child == .self {
                copy.right = .subdivision(
                    .init(
                        point: point,
                        dimension: (state.dimension + 1) % point.scalarCount,
                        totalItemCount: 1,
                        absolutePath: absolutePath.right
                    ),
                    left: nil,
                    right: nil
                )
            } else {
                copy.right = copy.right?.inserting(point, reversePath: child)
            }
        }

        return copy
    }

    /// Applies a given closure to all subdivisions in depth-first order,
    /// including this instance.
    func applyToTreeDepthFirst(_ closure: (Self) -> Void) {
        var stack: [Self] = [self]

        while let next = stack.popLast() {
            closure(next)

            switch next {
            case .subdivision(_, let left, let right):
                if let right { stack.append(right) }
                if let left { stack.append(left) }
            }
        }
    }

    /// Applies a given closure to all subdivisions in breadth-first order,
    /// including this instance.
    func applyToTreeBreadthFirst(_ closure: (Self) -> Void) {
        var queue: [Self] = [self]

        while !queue.isEmpty {
            let next = queue.removeFirst()

            closure(next)

            switch next {
            case .subdivision(_, let left, let right):
                if let left { queue.append(left) }
                if let right { queue.append(right) }
            }
        }
    }

    /// Applies a given closure to the first depth of subdivisions within
    /// this subdivision object, non-recursively.
    ///
    /// In case this object is a `.leaf`, nothing is done.
    func applyToSubdivisions(_ closure: (Self) -> Void) {
        switch self {
        case .subdivision(_, let left, let right):
            left.map(closure)
            right.map(closure)
        }
    }

    static func create<C: Collection<Vector>>(
        _ points: C,
        absolutePath: KDTree.SubdivisionPath,
        dimensionCount: Int,
        depth: Int
    ) -> Self? {

        guard !points.isEmpty else {
            return nil
        }

        let dim = depth % dimensionCount

        let sorted = points.sorted(by: { $0[dim] < $1[dim] })
        let median = sorted.count / 2

        let pivot = sorted[median]

        let left = sorted.prefix(upTo: median)
        let right = sorted.suffix(from: median + 1)

        assert(left.count + right.count == points.count - 1)

        return .subdivision(
            .init(
                point: pivot,
                dimension: dim,
                totalItemCount: points.count,
                absolutePath: absolutePath
            ),
            left: .create(
                left,
                absolutePath: absolutePath.left,
                dimensionCount: dimensionCount,
                depth: depth + 1
            ),
            right: .create(
                right,
                absolutePath: absolutePath.right,
                dimensionCount: dimensionCount,
                depth: depth + 1
            )
        )
    }
}
