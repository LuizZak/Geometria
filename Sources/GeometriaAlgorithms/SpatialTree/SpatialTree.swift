import Geometria

/// From a structured set of bounded geometry laid out in space, creates subdivided
/// AABBs to quickly query geometry that is neighboring a point or line.
class SpatialTree<Element: BoundableType>: SpatialTreeType where Element.Vector: VectorDivisible & VectorComparable {
    typealias Bounds = AABB<Vector>
    typealias Vector = Element.Vector

    /// The list of geometry that is being bounded.
    private var geometryList: [Element]

    private var root: Subdivision

    /// Initializes an empty spatial tree object.
    convenience init() {
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
    init(_ geometryList: [Element], maxSubdivisions: Int, maxElementsPerLevelBeforeSplit: Int) {
        self.geometryList = geometryList

        // Calculate minimum bounds
        let bounds = geometryList.map(\.bounds)
        let totalBounds = Bounds(aabbs: bounds)
        let indices = Array(geometryList.indices)

        self.root =
            .leaf(
                state: .init(
                    bounds: totalBounds,
                    indices: indices,
                    maxDepth: 0,
                    totalIndicesCount: indices.count,
                    isEmpty: indices.isEmpty
                )
            ).pushingGeometryDownRecursive(
                bounds,
                maxSubdivisions: maxSubdivisions,
                maxElementsPerLevelBeforeSplit: maxElementsPerLevelBeforeSplit
            )
    }

    /// Returns all of the geometry that are contained within this spatial tree
    /// whose bounds contain a given point.
    func queryPoint(_ point: Vector) -> [Element] {
        var result: [Element] = []

        root.queryPointRecursive(point) { index in
            let geometry = geometryList[index]

            if geometry.bounds.contains(point) {
                result.append(geometry)
            }
        }

        return result
    }

    /// Returns all of the geometry that are contained within this spatial tree
    /// whose bounds intersect a given line.
    func queryLine<Line: LineFloatingPoint>(
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

    private struct SubdivisionState {
        /// Initializes an empty subdivision state.
        static func empty(bounds: Bounds) -> Self {
            .init(
                bounds: .zero,
                indices: [],
                maxDepth: 0,
                totalIndicesCount: 0,
                isEmpty: true
            )
        }

        /// Defines the boundaries of a subdivision.
        var bounds: Bounds

        /// Indices in the root geometry array from the owning `SpatialTree` that 
        /// represent the geometry that is allocated at this depth.
        ///
        /// The same index is not present in sub-divisions of this tree.
        var indices: [Int]
        
        /// The maximal depth of this particular subdivision tree, including all
        /// nested subdivisions.
        var maxDepth: Int

        /// Returns the total number of indices within this particular subdivision
        /// tree, including all nested subdivisions.
        var totalIndicesCount: Int

        /// Is `true` if the subdivision associated with this state has no indices
        /// contained within any level deeper than that subdivision, including
        /// itself.
        var isEmpty: Bool

        func withMaxDepthIncreased(by depth: Int) -> Self {
            var copy = self
            copy.maxDepth += depth
            return self
        }

        func addingIndex(_ index: Int) -> Self {
            var copy = self
            
            if !copy.indices.contains(index) {
                copy.indices.append(index)
                copy.totalIndicesCount += 1
                copy.isEmpty = false
            }

            return copy
        }

        func addingIndices<S: Sequence>(_ indices: S) -> Self where S.Element == Int {
            indices.reduce(self, { $0.addingIndex($1) })
        }

        func removingIndex(_ index: Int) -> Self {
            var copy = self
            
            if copy.indices.contains(index) {
                copy.indices.removeAll { $0 == index }
                copy.totalIndicesCount -= 1
                copy.isEmpty = copy.indices.isEmpty
            }

            return copy
        }

        func removingIndices<S: Sequence>(_ indices: S) -> Self where S.Element == Int {
            indices.reduce(self, { $0.removingIndex($1) })
        }
    }

    private enum Subdivision {
        /// Creates and returns an empty leaf subdivision with the given boundaries.
        static func empty(bounds: Bounds) -> Self {
            .empty(state: .empty(bounds: bounds))
        }
        
        /// Creates and returns an empty leaf subdivision with the given state.
        static func empty(state: SubdivisionState) -> Self {
            .leaf(state: state)
        }

        case leaf(
            state: SubdivisionState
        )

        indirect case subdivision(
            state: SubdivisionState,
            subdivisions: [Self]
        )

        /// Gets the maximum depth within this subdivision object.
        ///
        /// Is 0 for `Self.leaf` cases, and + 1 of the greatest subdivision depth
        /// of nested `Self.subdivision` cases.
        var maxDepth: Int {
            state.maxDepth
        }

        /// Gets the bounds that this subdivision occupies in space.
        var bounds: Bounds {
            state.bounds
        }

        /// Gets the indices on this subdivision, not including the deeper
        /// subdivisions.
        var indices: [Int] {
            state.indices
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

        /// Returns all the indices that are contained within this subdivision
        /// tree, and all subsequent depths on this tree recursively whose bounds
        /// contain the point.
        func queryPointRecursive(_ point: Vector, _ out: inout [Int]) {
            if !bounds.contains(point) {
                return
            }

            out.append(contentsOf: indices)

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
        /// The bounds of this subdivision will be computed as an even split
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
                    state: state.withMaxDepthIncreased(by: 1),
                    subdivisions: subdivisions.map(Self.empty(bounds:))
                )

            case .subdivision:
                return self
            }
        }

        /// Recursively checks that geometry indices referenced by this subdivision
        /// object, whose real values are contained in the passed `array`, can
        /// be fitted into a lower subdivision level, and performs subdivisions
        /// according to the subdivision limits specified, if necessary.
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

            var indices = Set(self.indices)
            
            var copy = self

            copy._pushGeometryDownRecursive(
                geometryBounds,
                indices: &indices,
                maxSubdivisions: maxSubdivisions,
                maxElementsPerLevelBeforeSplit: maxElementsPerLevelBeforeSplit
            )

            // Re-accept any remaining index that was not accepted by deeper
            // subtrees.
            copy.mutateState { state in
                state = state.addingIndices(indices)
            }

            return copy
        }

        private mutating func _pushGeometryDownRecursive(
            _ geometryBounds: [Bounds],
            indices: inout Set<Int>,
            maxSubdivisions: Int,
            maxElementsPerLevelBeforeSplit: Int
        ) {
            
            // Accept all geometries that can be contained within this subdivision
            // first
            mutateState { state in
                for index in indices where state.bounds.contains(geometryBounds[index]) {
                    state = state.addingIndex(index)
                    indices.remove(index)
                }
            }

            if !hasSubdivisions {
                if self.indices.count > maxElementsPerLevelBeforeSplit && maxSubdivisions > 0 {
                    self = subdivided()
                } else {
                    return
                }
            }

            var newIndices = Set(self.indices)

            // Push down the indices contained within this tree subdivision deeper
            // down
            mutateSubdivisions { sub in
                sub._pushGeometryDownRecursive(
                    geometryBounds,
                    indices: &newIndices,
                    maxSubdivisions: maxSubdivisions - 1,
                    maxElementsPerLevelBeforeSplit: maxElementsPerLevelBeforeSplit
                )
            }

            // Remove all the indices that where accepted by deeper subdivisions.
            mutateState { state in
                state = state.removingIndices(
                    Set(state.indices).subtracting(newIndices)
                )
            }
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
        mutating func mutateState(_ mutator: (inout SubdivisionState) -> Void) {
            self = self.mutatingState(mutator)
        }

        /// Returns a copy of this subdivision object, with the state modified
        /// by a given closure.
        func mutatingState(_ mutator: (inout SubdivisionState) -> Void) -> Self {
            switch self {
            case .leaf(var state):
                mutator(&state)
                return .leaf(state: state)
            
            case .subdivision(
                var state,
                let subdivisions
            ):

                mutator(&state)

                return .subdivision(
                    state: state,
                    subdivisions: subdivisions
                )
            }
        }
    }
}
