import Geometria

/// From a structured set of bounded geometry laid out in space, creates subdivided
/// AABBs to quickly query geometry that is neighboring a point or line.
///
/// Generalizes into a [quad tree] in two dimensions and an [octree] in three.
///
/// [quad tree]: https://en.wikipedia.org/wiki/QuadTree
/// [octree]: https://en.wikipedia.org/wiki/Octree
public class SpatialTree<Element: BoundableType>: SpatialTreeType where Element.Vector: VectorDivisible & VectorComparable {
    public typealias Bounds = AABB<Vector>
    public typealias Vector = Element.Vector

    private(set) var root: Subdivision

    /// The list of geometries that is being bounded.
    private(set) public var geometryList: [Element]

    /// Initializes an empty spatial tree object.
    public convenience init() {
        self.init([], maxSubdivisions: 0, maxElementsPerLevelBeforeSplit: 0)
    }

    /// Initializes an spatial tree that contains the given geometry, with initial
    /// parameters to generate the spatial tree division that can fit the geometry.
    ///
    /// - Parameters:
    ///   - geometry: The list of geometries to pack in the spatial tree.
    ///   - maxSubdivisions: The maximum number of subdivisions allowed in the
    /// spatial tree. Takes precedence over `maxElementsPerLevelBeforeSplit` when
    /// splitting the spatial tree.
    ///   - maxElementsPerLevelBeforeSplit: The maximum number of elements per
    /// spatial tree subdivision before an attempt to subdivide it further is done.
    public init(
        _ geometryList: [Element],
        maxSubdivisions: Int,
        maxElementsPerLevelBeforeSplit: Int
    ) {

        self.geometryList = geometryList

        // Calculate minimum bounds
        let bounds = geometryList.map(\.bounds)
        let totalBounds = Bounds(aabbs: bounds)
        let indices = Set(geometryList.indices)

        self.root =
            .leaf(
                state: .init(
                    bounds: totalBounds,
                    indices: indices,
                    depth: 0,
                    totalIndicesCount: indices.count,
                    isEmpty: indices.isEmpty,
                    absolutePath: .root
                )
            ).pushingGeometryDownRecursive(
                bounds,
                maxSubdivisions: maxSubdivisions,
                maxElementsPerLevelBeforeSplit: maxElementsPerLevelBeforeSplit
            )
    }

    /// Returns all of the geometry that are contained within this spatial tree
    /// whose bounds contain a given point.
    public func queryPoint(_ point: Vector) -> [Element] {
        var result: [Element] = []

        root.queryPointRecursive(point) { index in
            let geometry = geometryList[index]

            if geometry.bounds.contains(point) {
                result.append(geometry)
            }
        }

        return result
    }

    /// Returns the path to the deepest subdivision that contain a given point
    /// within its bounds.
    ///
    /// Returns `nil` if the point is not within the boundaries this `SpatialTree`
    /// spans through.
    ///
    /// Points that lie exactly on the shared boundaries of multiple subdivisions
    /// might result in the non-deepest subdivision being traversed and chosen.
    public func deepestSubdivisionContaining(_ point: Vector) -> SubdivisionPath? {
        guard root.bounds.contains(point) else {
            return nil
        }

        var current: Subdivision = root

        while current.hasSubdivisions {
            for sub in current.subdivisions {
                if sub.bounds.contains(point) {
                    current = sub
                    break
                }
            }
        }

        return current.absolutePath
    }

    /// Returns all of the geometry that are contained within this spatial tree
    /// whose bounds intersect a given line.
    public func queryLine<Line: LineFloatingPoint>(
        _ line: Line
    ) -> [Element] where Line.Vector == Vector {

        var result: [Element] = []

        root.queryLineRecursive(line) { index in
            let geometry = geometryList[index]

            if geometry.bounds.intersects(line: line) {
                result.append(geometry)
            }
        }

        return result
    }

    /// Returns all of the geometry that overlap a given AABB within this spatial
    /// tree.
    public func query(_ aabb: AABB<Vector>) -> [Element] {
        var result: [Element] = []

        root.queryRecursive(aabb) { index in
            let geometry = geometryList[index]

            if geometry.bounds.intersects(aabb) {
                result.append(geometry)
            }
        }

        return result
    }

    /// Returns all possible subdivision paths within this spatial tree.
    public func subdivisionPaths() -> [SubdivisionPath] {
        var results: [SubdivisionPath] = []

        root.applyToTreeBreadthFirst { sub in
            results.append(sub.absolutePath)
        }

        return results
    }

    /// Returns the maximum depth of this spatial tree, starting from 0 at no
    /// subdivisions, and incrementing after each subdivision.
    public func maxDepth() -> Int {
        var maxDepth = 0

        root.applyToTreeBreadthFirst { sub in
            maxDepth = max(sub.depth, maxDepth)
        }

        return maxDepth
    }

    /// Returns the list of indices for a specific path of this spatial tree.
    public func indicesAt(path: SubdivisionPath) -> Set<Int> {
        _resolvePath(path)?.indices ?? []
    }

    private func _resolvePath(_ path: SubdivisionPath) -> Subdivision? {
        let path = path.reversed

        var current: Subdivision = root

        var index = 0
        while index < path.count {
            defer { index += 1 }
            let i = path[index]
            if i < 0 || i >= current.subdivisions.count {
                return nil
            }

            current = current.subdivisions[i]
        }

        if index != path.count {
            return nil
        }

        return current
    }

    /// Encodes a path to a specific subdivision within a spatial tree.
    public enum SubdivisionPath: Hashable, CustomStringConvertible {
        /// Specifies the root path.
        case root

        /// Specifies a nested index into a subdivision.
        indirect case child(index: Int, parent: SubdivisionPath)

        public var description: String {
            switch self {
            case .root:
                return ".root"
            case .child(let index, let parent):
                return "\(parent).childAt(\(index))"
            }
        }

        /// Returns the inverse index path from this path.
        /// The reversed path can be used to navigate, starting from a `root`
        /// subdivision, deeper into a subdivision tree.
        var reversed: [Int] {
            switch self {
            case .root:
                return []
            case .child(let index, let parent):
                return parent.reversed + [index]
            }
        }

        /// Returns the access path for a nested subdivision at a specific index
        /// from this path.
        func childAt(_ index: Int) -> Self {
            .child(index: index, parent: self)
        }
    }

    // MARK: - Internal

    struct SubdivisionState {
        /// Initializes an empty subdivision state.
        static func empty(bounds: Bounds, absolutePath: SubdivisionPath) -> Self {
            .init(
                bounds: bounds,
                indices: [],
                depth: 0,
                totalIndicesCount: 0,
                isEmpty: true,
                absolutePath: absolutePath
            )
        }

        /// Defines the boundaries of a subdivision.
        var bounds: Bounds

        /// Indices in the root geometry array from the owning `SpatialTree` that
        /// represent the geometry that is allocated at this depth.
        ///
        /// The same index is not present in sub-divisions of this tree.
        var indices: Set<Int>

        /// The depth of this particular subdivision tree from the root of the
        /// spatial tree.
        var depth: Int

        /// Returns the total number of indices within this particular subdivision
        /// tree, including all nested subdivisions.
        var totalIndicesCount: Int

        /// Is `true` if the subdivision associated with this state has no indices
        /// contained within any level deeper than that subdivision, including
        /// itself.
        var isEmpty: Bool

        /// The absolute path from the root subdivision path this subdivision
        /// node.
        var absolutePath: SubdivisionPath

        func withMaxDepthIncreased(by depth: Int) -> Self {
            var copy: SpatialTree<Element>.SubdivisionState = self
            copy.depth += depth
            return self
        }

        func createSubdivision(bounds: Bounds, index: Int) -> Self {
            return .init(
                bounds: bounds,
                indices: [],
                depth: depth + 1,
                totalIndicesCount: 0,
                isEmpty: true,
                absolutePath: absolutePath.childAt(index)
            )
        }

        /// Adds an index into this subdivision state and returns whether the
        /// index was already present.
        @discardableResult
        mutating func addIndex(_ index: Int) -> Bool {
            guard indices.insert(index).inserted else {
                return false
            }

            totalIndicesCount += 1
            isEmpty = false

            return true
        }

        func addingIndex(_ index: Int) -> Self {
            var copy = self
            copy.addIndex(index)
            return copy
        }

        /// Adds a sequence of indices, returning a set of the indices that where
        /// not in this subdivision state and where added.
        @discardableResult
        mutating func addIndices<S: Sequence>(_ indices: S) -> Set<Int> where S.Element == Int {
            Set(indices.filter { addIndex($0) })
        }

        func addingIndices<S: Sequence>(_ indices: S) -> Self where S.Element == Int {
            var copy = self
            copy.addIndices(indices)
            return copy
        }

        /// Removes the given index from this subdivision state, returning a
        /// value specifying whether the value existed in this state and was
        /// removed.
        @discardableResult
        mutating func removeIndex(_ index: Int) -> Bool {
            guard indices.remove(index) != nil else {
                return false
            }

            totalIndicesCount -= 1
            isEmpty = indices.isEmpty

            return true
        }

        func removingIndex(_ index: Int) -> Self {
            var copy = self
            copy.removeIndex(index)
            return copy
        }

        /// Removes indices from a given sequence of indices from this subdivision
        /// state, returning a set of indices that existed in this state and were
        /// removed.
        @discardableResult
        mutating func removeIndices<S: Sequence>(_ indices: S) -> Set<Int> where S.Element == Int {
            Set(indices.filter { removeIndex($0) })
        }

        func removingIndices<S: Sequence>(_ indices: S) -> Self where S.Element == Int {
            var copy = self
            copy.removeIndices(indices)
            return copy
        }
    }

    enum Subdivision {
        /// Creates and returns an empty leaf subdivision with the given boundaries.
        static func empty(bounds: Bounds, absolutePath: SubdivisionPath) -> Self {
            .leaf(
                state: .empty(
                    bounds: bounds,
                    absolutePath: absolutePath
                )
            )
        }

        case leaf(
            state: SubdivisionState
        )

        indirect case subdivision(
            state: SubdivisionState,
            subdivisions: [Self]
        )

        /// Gets the depth of this subdivision object.
        ///
        /// Is 0 for the root of the tree cases, and + 1 for each subdivision
        /// into the tree.
        var depth: Int {
            state.depth
        }

        /// Gets the bounds that this subdivision occupies in space.
        var bounds: Bounds {
            state.bounds
        }

        /// Gets the indices on this subdivision, not including the deeper
        /// subdivisions.
        var indices: Set<Int> {
            state.indices
        }

        /// The absolute path from the root subdivision path this subdivision
        /// node.
        var absolutePath: SubdivisionPath {
            state.absolutePath
        }

        /// Gets the common state for this subdivision object.
        var state: SubdivisionState {
            switch self {
            case .leaf(let state),
                .subdivision(let state, _):

                return state
            }
        }

        /// Returns `true` if this subdivision object contains nested subdivisions.
        var hasSubdivisions: Bool {
            switch self {
            case .leaf:
                return false

            case .subdivision:
                return true
            }
        }

        /// Returns an array of subdivisions from this tree subdivision.
        ///
        /// Returns an empty array, in case this subdivision is a `.leaf` case.
        var subdivisions: [Self] {
            switch self {
            case .leaf:
                return []
            case .subdivision(_, let subdivisions):
                return subdivisions
            }
        }

        /// Returns all the indices that are contained within this subdivision
        /// tree, and all subsequent depths on this tree recursively whose bounds
        /// contain the point.
        func queryPointRecursive(_ point: Vector, _ out: inout Set<Int>) {
            if !bounds.contains(point) {
                return
            }

            out.formUnion(indices)

            applyToSubdivisions { sub in
                sub.queryPointRecursive(point, &out)
            }
        }

        /// Executes a closure for each index that is contained within this
        /// subdivision tree, and all subsequent depths on this tree recursively
        /// whose bounds contain the point.
        func queryPointRecursive(_ point: Vector, closure: (Int) -> Void) {
            if !bounds.contains(point) {
                return
            }

            indices.forEach(closure)

            applyToSubdivisions { sub in
                sub.queryPointRecursive(point, closure: closure)
            }
        }

        /// Returns all the indices that are contained within this subdivision
        /// tree, and all subsequent depths on this tree recursively whose bounds
        /// intersect the given line.
        func queryLineRecursive<Line: LineFloatingPoint>(
            _ line: Line,
            _ out: inout [Int]
        ) where Line.Vector == Vector {

            if !bounds.intersects(line: line) {
                return
            }

            out.append(contentsOf: indices)

            applyToSubdivisions { sub in
                sub.queryLineRecursive(line, &out)
            }
        }

        /// Executes a closure for each index that is contained within this
        /// subdivision tree, and all subsequent depths on this tree recursively
        /// whose bounds intersect the given line.
        func queryLineRecursive<Line: LineFloatingPoint>(
            _ line: Line,
            closure: (Int) -> Void
        ) where Line.Vector == Vector {

            if !bounds.intersects(line: line) {
                return
            }

            indices.forEach(closure)

            applyToSubdivisions { sub in
                sub.queryLineRecursive(line, closure: closure)
            }
        }

        /// Executes a closure for each index that is contained within this
        /// subdivision tree, and all subsequent depths on this tree recursively
        /// whose bounds intersect the given boundable area.
        func queryRecursive<Bounds: BoundableType>(
            _ area: Bounds,
            closure: (Int) -> Void
        ) where Bounds.Vector == Vector {

            if !bounds.intersects(area.bounds) {
                return
            }

            indices.forEach(closure)

            applyToSubdivisions { sub in
                sub.queryRecursive(area, closure: closure)
            }
        }

        /// Recursively checks that geometry indices referenced by this subdivision
        /// object, whose bounds are contained in the passed `geometryBounds`
        /// array, can be fitted into a deeper subdivision level, and performs
        /// subdivisions according to the subdivision limits specified, if
        /// necessary.
        ///
        /// The array of bounds should be the computed bounds of every object
        /// contained within the parent `SpatialTree`.
        ///
        /// The resulting subdivision object contains the same indices and the
        /// same depth, but objects are contained within the deepest level that
        /// can fully contain their bounds.
        ///
        /// - Parameters:
        ///   - maxSubdivisions: The maximum number of subdivisions allowed in the
        /// spatial tree. Takes precedence over `maxElementsPerLevelBeforeSplit`
        /// when splitting the spatial tree.
        ///   - maxElementsPerLevelBeforeSplit: The maximum number of elements
        /// per spatial tree subdivision before an attempt to subdivide it further
        /// is done.
        func pushingGeometryDownRecursive(
            _ geometryBounds: [Bounds],
            maxSubdivisions: Int,
            maxElementsPerLevelBeforeSplit: Int
        ) -> Self {

            var copy = self

            _ = copy._pushGeometryDownRecursive(
                geometryBounds,
                newIndices: Set(indices),
                maxSubdivisions: maxSubdivisions,
                maxElementsPerLevelBeforeSplit: maxElementsPerLevelBeforeSplit
            )

            return copy
        }

        /// Performs the recursive pushing of indices down a spatial tree.
        ///
        /// Returns a set of indices subtracted from `newIndices` that where accepted
        /// by deeper subdivision levels.
        private mutating func _pushGeometryDownRecursive(
            _ geometryBounds: [Bounds],
            newIndices: Set<Int>,
            maxSubdivisions: Int,
            maxElementsPerLevelBeforeSplit: Int
        ) -> Set<Int> {

            let fittingIndices = newIndices.filter {
                bounds.contains(geometryBounds[$0])
            }

            // Accept all geometries that can be contained within this subdivision
            // first
            let accepted = mutateState { state in
                state.addIndices(fittingIndices)
            }

            // Subdivide before continuing, if possible, otherwise exit as-is.
            if !hasSubdivisions {
                if self.indices.count > maxElementsPerLevelBeforeSplit && maxSubdivisions > 0 {
                    self = subdivided()
                } else {
                    return accepted
                }
            }

            let indices = Set(indices)

            // Push down the indices contained within this tree subdivision deeper
            // down
            var acceptedSubdivisions: Set<Int> = []
            mutateSubdivisions { sub in
                acceptedSubdivisions.formUnion(
                    sub._pushGeometryDownRecursive(
                        geometryBounds,
                        newIndices: indices,
                        maxSubdivisions: maxSubdivisions - 1,
                        maxElementsPerLevelBeforeSplit: maxElementsPerLevelBeforeSplit
                    )
                )
            }

            // Remove all the indices that where accepted by deeper subdivisions.
            mutateState { state in
                state.removeIndices(
                    acceptedSubdivisions
                )
            }

            return acceptedSubdivisions
        }

        /// Appends the indices of this subdivision depth, and all subsequent
        /// depths on this tree recursively.
        func totalIndicesInTree(_ out: inout [Int]) {
            out.append(contentsOf: indices)

            applyToSubdivisions { sub in
                sub.totalIndicesInTree(&out)
            }
        }

        /// Requests that this subdivision object be subdivided, in case it is
        /// not already.
        ///
        /// The bounds of the subdivisions will be computed as an even split
        /// of the bounds of this subdivision object along each axis.
        ///
        /// Indices within this state are not changed.
        ///
        /// Returns `self`, if this object is already subdivided.
        func subdivided() -> Self {
            switch self {
            case .leaf(let state):
                let subdivisions = state.bounds.subdivided()

                return .subdivision(
                    state: state,
                    subdivisions: subdivisions.enumerated().map {
                        Self.leaf(
                            state: state.createSubdivision(
                                bounds: $1,
                                index: $0
                            )
                        )
                    }
                )

            case .subdivision:
                return self
            }
        }

        /// Requests that this subdivision object be subdivided in-place, in case
        /// it is not already.
        ///
        /// The bounds of the subdivisions will be computed as an even split
        /// of the bounds of this subdivision object along each axis.
        ///
        /// Indices within this state are not changed.
        mutating func subdivide() {
            self = subdivided()
        }

        /// Applies a given closure to the first depth of subdivisions within
        /// this subdivision object, non-recursively.
        ///
        /// In case this object is a `.leaf`, nothing is done.
        func applyToSubdivisions(_ closure: (Self) -> Void) {
            switch self {
            case .leaf:
                break
            case .subdivision(
                _,
                let subdivisions
            ):

                subdivisions.forEach(closure)
            }
        }

        /// Applies a given closure to all subdivisions in depth-first order,
        /// including this instance.
        func applyToTreeDepthFirst(_ closure: (Self) -> Void) {
            var stack: [Self] = [self]

            while let next = stack.popLast() {
                closure(next)

                stack.append(contentsOf: next.subdivisions.reversed())
            }
        }

        /// Applies a given closure to all subdivisions in breadth-first order,
        /// including this instance.
        func applyToTreeBreadthFirst(_ closure: (Self) -> Void) {
            var queue: [Self] = [self]

            while !queue.isEmpty {
                let next = queue.removeFirst()

                closure(next)

                queue.append(contentsOf: next.subdivisions)
            }
        }

        /// Applies a given closure to the first depth of subdivisions within
        /// this subdivision object, non-recursively, returning the result of
        /// mutating each individual subdivision with a given closure.
        ///
        /// In case this object is a `.leaf`, nothing is done.
        private mutating func mutateSubdivisions(_ closure: (inout Self) -> Void) {
            switch self {
            case .leaf:
                break
            case .subdivision(
                let state,
                let subdivisions
            ):

                let subdivisions = subdivisions.map { sub in
                    var sub = sub
                    closure(&sub)
                    return sub
                }

                self = .subdivision(
                    state: state,
                    subdivisions: subdivisions
                )
            }
        }

        /// Performs an in-place mutation of this subdivision object, with the
        /// state modified by a given closure.
        @discardableResult
        mutating func mutateState<T>(_ mutator: (inout SubdivisionState) throws -> T) rethrows -> T {
            switch self {
            case .leaf(var state):
                defer { self = .leaf(state: state) }

                return try mutator(&state)

            case .subdivision(
                var state,
                let subdivisions
            ):
                defer {
                    self = .subdivision(
                        state: state,
                        subdivisions: subdivisions
                    )
                }

                return try mutator(&state)
            }
        }

        /// Returns a copy of this subdivision object, with the state modified
        /// by a given closure.
        func mutatingState(_ mutator: (inout SubdivisionState) throws -> Void) rethrows -> Self {
            var copy = self
            try copy.mutateState(mutator)
            return copy
        }
    }
}
