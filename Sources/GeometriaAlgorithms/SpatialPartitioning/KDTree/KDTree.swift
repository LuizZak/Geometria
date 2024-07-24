import Geometria

/// A [k-d tree] implementation for point-clouds.
///
/// [k-d tree](https://en.wikipedia.org/wiki/K-d_tree)
public struct KDTree<Element: KDTreeLocatable> where Element.Vector: VectorComparable & VectorMultiplicative {
    public typealias Vector = Element.Vector
    internal var root: Subdivision?

    /// Returns the total number of items within this k-d tree.
    public var count: Int {
        return root?.totalItemCount ?? 0
    }

    /// Initializes a new k-d tree from a given set of points.
    public init<C: Collection<Element>>(elements: C) where Vector: VectorAdditive {
        self.init(
            dimensionCount: Vector.zero.scalarCount,
            elements: elements
        )
    }

    /// Initializes a new k-d tree from a given set of points.
    public init<C: Collection<Element>>(dimensionCount: Int, elements: C) {
        self.root = .create(
            elements,
            absolutePath: .root,
            dimensionCount: dimensionCount,
            depth: 0
        )
    }

    fileprivate mutating func ensureUnique() {
        if !isKnownUniquelyReferenced(&root) {
            root = root?.deepCopy()
        }
    }

    /// Returns the list of all elements within this k-d tree.
    public func elements() -> [Element] {
        var result: [Element] = []
        root?.collectElements(to: &result)
        return result
    }

    /// Returns the nearest neighbor in this k-d tree to a given point vector.
    /// Result is `nil`, if this k-d tree is empty.
    public func nearestNeighbor(to point: Vector) -> Element? {
        root?.nearestSubdivision(to: point).0.element
    }

    /// Returns the nearest neighbors in this k-d tree to a given point vector
    /// that are under `distanceSquared` away from the input point.
    public func nearestNeighbors(
        to point: Vector,
        distanceSquared: Vector.Scalar
    ) -> [Element] {
        var results: [Element] = []
        root?.nearestSubdivisions(to: point, distanceSquared: distanceSquared) {
            results.append($0.element)
        }
        return results
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
    public func subdivisionPath(forInserting element: Element) -> SubdivisionPath {
        guard let root else { return .root }

        var current = root

        let point = element.location

        while true {
            let isLeft = current.isOnLeft(point)

            if isLeft {
                if let left = current.left {
                    current = left
                } else {
                    return current.absolutePath.left
                }
            } else {
                if let right = current.right {
                    current = right
                } else {
                    return current.absolutePath.right
                }
            }
        }

        return current.absolutePath
    }

    /// Inserts a given element on this k-d tree.
    public mutating func insert(_ element: Element) {
        ensureUnique()

        guard let root else {
            root = Subdivision(
                state: .empty(
                    element: element,
                    dimension: 0,
                    totalItemCount: 1,
                    absolutePath: .root
                ),
                left: nil,
                right: nil
            )

            return
        }

        let path = subdivisionPath(forInserting: element)
        let reversed = path.reversed

        root.inserting(element, path: reversed.asPath)
    }

    /// If `element` is contained within this k-d tree, it is removed in-place.
    public mutating func remove(_ element: Element) where Element: Equatable {
        ensureUnique()

        guard let root else {
            return
        }

        var allNearest: [Subdivision] = []
        root.nearestSubdivisions(
            to: element.location,
            distanceSquared: .zero,
            onMatch: { if $0.element == element { allNearest.append($0) } }
        )

        for nearest in allNearest {
            guard let path = root.findPath(to: nearest) else {
                return
            }

            remove(at: .init(path: path))
        }
    }

    /// Removes an element at a given index in this k-d tree.
    public mutating func remove(at index: Index) {
        ensureUnique()

        guard let root, root.pathExists(index.path) else {
            fatalError("Index \(index) is not part of this k-d tree.")
        }

        self.root = root.removing(at: index.path)
    }

    /// Removes all elements contained within this k-d tree.
    public mutating func removeAll() {
        ensureUnique()
        root = nil
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

        fileprivate var asPath: Path {
            switch self {
            case .self:
                return .self

            case .left(let inner):
                return .left(inner.asPath)

            case .right(let inner):
                return .right(inner.asPath)
            }
        }
    }

    /// Shared state for all k-d tree subdivision levels.
    internal struct SubdivisionState {
        /// Initializes an empty subdivision state.
        static func empty(
            element: Element,
            dimension: Int,
            totalItemCount: Int,
            absolutePath: SubdivisionPath
        ) -> Self {
            .init(
                element: element,
                dimension: dimension,
                totalItemCount: totalItemCount,
                absolutePath: absolutePath
            )
        }

        /// The element associated with this subdivision state.
        var element: Element

        /// The numerical dimension that this subdivision splits between.
        var dimension: Int

        /// Returns the total number of items within this particular subdivision
        /// tree, including all nested subdivisions.
        var totalItemCount: Int

        /// The absolute path from the root subdivision path this subdivision
        /// node.
        var absolutePath: SubdivisionPath
    }

    /// A subdivision of a k-d tree.
    internal class Subdivision {
        var state: SubdivisionState

        var left: Subdivision?
        var right: Subdivision?

        internal init(
            state: SubdivisionState,
            left: Subdivision? = nil,
            right: Subdivision? = nil
        ) {
            self.state = state
            self.left = left
            self.right = right
        }

        func deepCopy() -> Subdivision {
            return .init(
                state: state,
                left: left?.deepCopy(),
                right: right?.deepCopy()
            )
        }

        /// Recursively traverses this subdivision, collecting all elements into
        /// a given array.
        func collectElements(to result: inout [Element]) {
            result.append(element)

            forEachSubdivision { subdivision in
                subdivision.collectElements(to: &result)
            }
        }

        /// Applies a given closure to each subdivision within this k-d tree,
        /// if there are any.
        func forEachSubdivision(_ block: (Subdivision) -> Void) {
            if let left {
                block(left)
            }
            if let right {
                block(right)
            }
        }

        func pathExists(_ path: Path) -> Bool {
            switch path {
            case .self:
                return true

            case .left(let inner):
                if let left {
                    return left.pathExists(inner)
                }

                return false

            case .right(let inner):
                if let right {
                    return right.pathExists(inner)
                }

                return false
            }
        }

        /// Returns all indexable element paths within this subdivision tree.
        func availableElementPaths() -> [Path] {
            var result: [Path] = []
            result.append(.self)

            if let left {
                for inner in left.availableElementPaths() {
                    result.append(.left(inner))
                }
            }
            if let right {
                for inner in right.availableElementPaths() {
                    result.append(.right(inner))
                }
            }

            return result
        }

        func path(after path: Path) -> Path? {
            switch path {
            case .self:
                if let left {
                    return .left(left.firstPath())
                }

                if let right {
                    return .right(right.firstPath())
                }

                return nil

            case .left(let inner):
                guard let left else {
                    return nil
                }

                if let next = left.path(after: inner) {
                    return .left(next)
                }

                if let right {
                    return .right(right.firstPath())
                }

                return nil

            case .right(let inner):
                guard let right else {
                    return nil
                }

                if let next = right.path(after: inner) {
                    return .right(next)
                }

                return nil
            }
        }

        func firstPath() -> Path {
            return .self
        }

        func lastPath() -> Path {
            if let right {
                return .right(right.lastPath())
            }
            if let left {
                return .left(left.lastPath())
            }

            return .left(.self)
        }
    }

    /// Represents a path from the root of a k-d tree down to an element.
    internal enum Path: Comparable, CustomStringConvertible {
        case `self`
        indirect case left(Self)
        indirect case right(Self)

        var description: String {
            switch self {
            case .self:
                return ".self"

            case .left(let inner):
                return ".left(\(inner))"

            case .right(let inner):
                return ".right(\(inner))"
            }
        }

        /// Resolves this subdivision path into a given tree.
        ///
        /// Returns `nil` if this path is not a valid path into `Subdivision`.
        fileprivate func resolve(in tree: Subdivision) -> Subdivision? {
            switch self {
            case .self:
                return tree

            case .left(let child):
                guard let left = tree.left else {
                    return nil
                }

                return child.resolve(in: left)

            case .right(let child):
                guard let right = tree.right else {
                    return nil
                }

                return child.resolve(in: right)
            }
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.left, .right):
                return true

            case (.right, .left):
                return false

            case (.self, _):
                return true

            case (_, .self):
                return false

            case (.left(let lhs), .left(let rhs)):
                return lhs < rhs

            case (.right(let lhs), .right(let rhs)):
                return lhs < rhs
            }
        }
    }
}

extension KDTree: Collection {
    public struct Index: Comparable {
        internal var path: Path

        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.path < rhs.path
        }
    }

    public var startIndex: Index {
        if let first = root?.firstPath() {
            return .init(path: first)
        }

        return .init(path: .`self`)
    }

    public var endIndex: Index {
        if let last = root?.lastPath() {
            return .init(path: last)
        }

        return .init(path: .`self`)
    }

    public subscript(position: Index) -> Element {
        guard let root, let result = position.path.resolve(in: root) else {
            fatalError("Index \(position) is not part of this spatial tree.")
        }

        return result.element
    }

    public func index(after i: Index) -> Index {
        guard let root else {
            return endIndex
        }
        guard let path = root.path(after: i.path) else {
            return endIndex
        }

        return .init(path: path)
    }
}

extension KDTree.Subdivision {
    typealias Vector = Element.Vector

    /// The element associated with this subdivision.
    var element: Element {
        state.element
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

    /// The numerical dimension that this subdivision splits between.
    var dimension: Int {
        state.dimension
    }

    /// Returns the nearest subdivision in this subdivision to a given point vector.
    func nearestSubdivision(to point: Vector) -> (KDTree.Subdivision, distanceSquared: Vector.Scalar) {
        switch (left, right) {
        case (nil, nil):
            return (
                self,
                distanceSquared: point.distanceSquared(to: state.element.location)
            )

        case (let left?, nil):
            var current: (KDTree.Subdivision, distanceSquared: Vector.Scalar)

            current = left.nearestSubdivision(to: point)

            let distanceSquared = point.distanceSquared(to: state.element.location)
            if distanceSquared < current.distanceSquared {
                current = (
                    self,
                    distanceSquared: distanceSquared
                )
            }

            return current

        case (nil, let right?):
            var current: (KDTree.Subdivision, distanceSquared: Vector.Scalar)

            current = right.nearestSubdivision(to: point)

            let distanceSquared = point.distanceSquared(to: state.element.location)
            if distanceSquared < current.distanceSquared {
                current = (
                    self,
                    distanceSquared: distanceSquared
                )
            }

            return current

        case (let left?, let right?):
            var current: (KDTree.Subdivision, distanceSquared: Vector.Scalar)

            let (first, second) = isOnLeft(point) ? (left, right) : (right, left)

            current = first.nearestSubdivision(to: point)

            guard distanceSquared(to: point) < current.distanceSquared else {
                return current
            }

            let childNearest = second.nearestSubdivision(to: point)
            if childNearest.distanceSquared < current.distanceSquared {
                current = childNearest
            }

            // Check this subdivision's point now.
            let distanceSquared = point.distanceSquared(to: state.element.location)
            if distanceSquared < current.distanceSquared {
                current = (
                    self,
                    distanceSquared: distanceSquared
                )
            }

            return current
        }
    }

    /// Collects all nearest subdivisions that have a distance of `distanceSquared`
    /// or less to `point` into `results`.
    func nearestSubdivisions(
        to point: Vector,
        distanceSquared: Vector.Scalar,
        onMatch: (KDTree.Subdivision) -> Void
    ) {
        func makeResult(
            _ subdivision: KDTree.Subdivision
        ) -> (KDTree.Subdivision, distanceSquared: Vector.Scalar) {
            return (
                subdivision,
                distanceSquared: point.distanceSquared(to: subdivision.element.location)
            )
        }

        func checkState(
            _ subdivision: KDTree.Subdivision
        ) {
            let result = makeResult(subdivision)
            if result.distanceSquared <= distanceSquared {
                onMatch(result.0)
            }
        }

        switch (left, right) {
        case (nil, nil):
            checkState(self)

        case (let left?, nil):
            checkState(self)

            left.nearestSubdivisions(
                to: point,
                distanceSquared: distanceSquared,
                onMatch: onMatch
            )

        case (nil, let right?):
            checkState(self)

            right.nearestSubdivisions(
                to: point,
                distanceSquared: distanceSquared,
                onMatch: onMatch
            )

        case (let left?, let right?):
            let (first, second) = isOnLeft(point) ? (left, right) : (right, left)

            first.nearestSubdivisions(
                to: point,
                distanceSquared: distanceSquared,
                onMatch: onMatch
            )

            checkState(self)

            guard self.distanceSquared(to: point) <= distanceSquared else {
                return
            }

            second.nearestSubdivisions(
                to: point,
                distanceSquared: distanceSquared,
                onMatch: onMatch
            )
        }
    }

    /// Returns `true` if the current subdivision level point's scalar at
    /// the current subdivision dimension is less than or equal to the
    /// same scalar of the given point.
    func isOnLeft(_ point: Vector) -> Bool {
        point[state.dimension] < state.element.location[state.dimension]
    }

    /// Returns the distance squared from a given point to the subdivision
    /// line of this subdivision.
    func distanceSquared(to point: Vector) -> Vector.Scalar {
        let dist = point[state.dimension] - state.element.location[state.dimension]

        return dist * dist
    }

    static func create<C: Collection<Element>>(
        _ elements: C,
        absolutePath: KDTree.SubdivisionPath,
        dimensionCount: Int,
        depth: Int
    ) -> KDTree.Subdivision? {

        guard !elements.isEmpty else {
            return nil
        }

        let dim = depth % dimensionCount

        let sorted = elements.sorted(by: { $0.location[dim] < $1.location[dim] })
        let median = sorted.count / 2

        let pivot = sorted[median]

        let left = sorted.prefix(upTo: median)
        let right = sorted.suffix(from: median + 1)

        assert(left.count + right.count == elements.count - 1)

        return KDTree.Subdivision(
            state: .init(
                element: pivot,
                dimension: dim,
                totalItemCount: elements.count,
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

    /// Returns a copy of this subdivision, with a new point inserted at a
    /// given subdivision path.
    func inserting(_ element: Element, path: KDTree.Path) {
        let point = element.location

        switch path {
        case .self:
            break

        case .left(let child):
            self.state.totalItemCount += 1

            if child == .self {
                self.left = .init(
                    state: .init(
                        element: element,
                        dimension: (state.dimension + 1) % point.scalarCount,
                        totalItemCount: 1,
                        absolutePath: absolutePath.left
                    ),
                    left: nil,
                    right: nil
                )
            } else {
                left?.inserting(element, path: child)
            }

        case .right(let child):
            self.state.totalItemCount += 1

            if child == .self {
                self.right = .init(
                    state: .init(
                        element: element,
                        dimension: (state.dimension + 1) % point.scalarCount,
                        totalItemCount: 1,
                        absolutePath: absolutePath.right
                    ),
                    left: nil,
                    right: nil
                )
            } else {
                right?.inserting(element, path: child)
            }
        }
    }

    /// Removes a k-d tree element at a given path, returning the new subdivision
    /// to replace in case a removal has taken place.
    func removing(at path: KDTree.Path) -> KDTree.Subdivision? {
        self.state.totalItemCount -= 1

        switch path {
        case .`self`:
            switch (left, right) {
            case (nil, nil):
                return nil

            case (_, let right?):
                let min = right.min { sub in
                    sub.element.location[dimension]
                }
                guard let path = self.findPath(to: min) else {
                    return self
                }
                self.state.element = min.element
                self.right = right.removing(at: path)

            case (let left?, _):
                let min = left.min { sub in
                    sub.element.location[dimension]
                }
                guard let path = self.findPath(to: min) else {
                    return self
                }
                self.state.element = min.element
                self.left = left.removing(at: path)
            }

            return self

        case .left(let inner):
            guard let left else {
                return nil
            }

            self.left = left.removing(at: inner)
            return self

        case .right(let inner):
            guard let right else {
                return nil
            }

            self.right = right.removing(at: inner)
            return self
        }
    }

    /// Returns the relative path between `self` and `target`, in case `target`
    /// is a subdivision of `self`, otherwise returns `nil`
    func findPath(to target: KDTree.Subdivision) -> KDTree.Path? {
        if self === target { return .self }

        if let result = left?.findPath(to: target) {
            return .left(result)
        }
        if let result = right?.findPath(to: target) {
            return .right(result)
        }

        return nil
    }

    /// Returns the minimal element within the subtree represented by `self`
    /// that minimizes the given function.
    func min<T: Comparable>(by production: (KDTree.Subdivision) -> T) -> KDTree.Subdivision {
        var result: (KDTree.Subdivision, T) = (
            self, production(self)
        )
        applyToTreeBreadthFirst { subdivision in
            let next = production(subdivision)
            if next < result.1 {
                result = (subdivision, next)
            }
        }

        return result.0
    }

    /// Returns the minimal element within the subtree represented by `self`
    /// that maximizes the given function.
    func max<T: Comparable>(by production: (KDTree.Subdivision) -> T) -> KDTree.Subdivision {
        var result: (KDTree.Subdivision, T) = (
            self, production(self)
        )
        applyToTreeBreadthFirst { subdivision in
            let next = production(subdivision)
            if next > result.1 {
                result = (subdivision, next)
            }
        }

        return result.0
    }

    /// Applies a given closure to all subdivisions in depth-first order,
    /// including this instance.
    func applyToTreeDepthFirst(_ closure: (KDTree.Subdivision) -> Void) {
        var stack: [KDTree.Subdivision] = [self]

        while let next = stack.popLast() {
            closure(next)

            if let right = next.right { stack.append(right) }
            if let left = next.left { stack.append(left) }
        }
    }

    /// Applies a given closure to all subdivisions in breadth-first order,
    /// including this instance.
    func applyToTreeBreadthFirst(_ closure: (KDTree.Subdivision) -> Void) {
        var queue: [KDTree.Subdivision] = [self]

        while !queue.isEmpty {
            let next = queue.removeFirst()

            closure(next)

            if let left = next.left { queue.append(left) }
            if let right = next.right { queue.append(right) }
        }
    }

    /// Applies a given closure to the first depth of subdivisions within
    /// this subdivision object, non-recursively.
    ///
    /// In case this object is a `.leaf`, nothing is done.
    func applyToSubdivisions(_ closure: (KDTree.Subdivision) -> Void) {
        left.map(closure)
        right.map(closure)
    }
}

/// Protocol for KD-tree elements that are space-locatable by a vector.
public protocol KDTreeLocatable {
    associatedtype Vector: VectorType

    /// Gets the location of this locatable object in space.
    var location: Vector { get }
}

extension Vector2: KDTreeLocatable {
    /// Returns `self`.
    ///
    /// Default implementation for `KDTreeLocatable`.
    public var location: Self {
        self
    }
}

extension Vector3: KDTreeLocatable {
    /// Returns `self`.
    ///
    /// Default implementation for `KDTreeLocatable`.
    public var location: Self {
        self
    }
}

extension Vector4: KDTreeLocatable {
    /// Returns `self`.
    ///
    /// Default implementation for `KDTreeLocatable`.
    public var location: Self {
        self
    }
}
