import Geometria

/// From a structured set of bounded geometry laid out in space, creates subdivided
/// AABBs to quickly query geometry that is neighboring a point, line, or other
/// boundable type of compatible vector type.
///
/// Generalizes into a [quad tree] in two dimensions and an [octree] in three.
///
/// [quad tree]: https://en.wikipedia.org/wiki/QuadTree
/// [octree]: https://en.wikipedia.org/wiki/Octree
public struct SpatialTree<Element: BoundableType>: SpatialTreeType where Element.Vector: VectorDivisible & VectorComparable {
    public typealias Bounds = AABB<Vector>
    public typealias Vector = Element.Vector

    @usableFromInline
    internal var root: Subdivision

    /// The maximal subdivisions allowed currently affecting this spatial tree.
    public var maxSubdivisions: Int

    /// The maximal number of elements before a split currently affecting this
    /// spatial tree.
    public var maxElementsPerLevelBeforeSplit: Int

    /// Initializes an empty spatial tree object.
    public init(
        maxSubdivisions: Int,
        maxElementsPerLevelBeforeSplit: Int
    ) {
        self.init(
            [],
            maxSubdivisions: maxSubdivisions,
            maxElementsPerLevelBeforeSplit: maxElementsPerLevelBeforeSplit
        )
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
        _ geometryList: some Sequence<Element>,
        maxSubdivisions: Int,
        maxElementsPerLevelBeforeSplit: Int
    ) {
        self.maxSubdivisions = maxSubdivisions
        self.maxElementsPerLevelBeforeSplit = maxElementsPerLevelBeforeSplit

        let totalBounds = AABB(aabbs: geometryList.map(\.bounds))

        self.root = .init(
            bounds: totalBounds,
            elements: [],
            subdivisions: nil,
            depth: 0
        )

        for element in geometryList {
            insert(element)
        }
    }

    @usableFromInline
    internal mutating func ensureUnique() {
        if !isKnownUniquelyReferenced(&root) {
            root = root.deepCopy()
        }
    }

    // MARK: - Querying

    /// Returns all elements contained within this spatial tree.
    @inlinable
    public func elements() -> [Element] {
        var result: [Element] = []
        root.collectElements(to: &result)
        return result
    }

    @inlinable
    public func queryPoint(_ point: Vector) -> [Element] {
        var result: [Element] = []
        root.queryPoint(point, results: &result)
        return result
    }

    @inlinable
    public func queryLine<Line: LineFloatingPoint>(
        _ line: Line
    ) -> [Element] where Line.Vector == Vector {
        var result: [Element] = []
        root.queryLine(line) { (_, element) in
            result.append(element)
        }
        return result
    }

    @inlinable
    public func query<Bounds: BoundableType>(
        _ area: Bounds
    ) -> [Element] where Bounds.Vector == Vector {
        var result: [Element] = []
        root.query(area) { (_, element) in
            result.append(element)
        }
        return result
    }

    /// Performs a point query using a closure to be invoked for each element
    /// found to intersect `point`.
    @inlinable
    public func lazyQueryPoint(
        _ point: Vector,
        _ closure: (Element) -> Void
    ) {
        root.queryPoint(point) { (_, element) in
            closure(element)
        }
    }

    /// Performs a line query using a closure to be invoked for each element
    /// found to intersect `line`.
    @inlinable
    public func lazyQueryLine<Line: LineFloatingPoint>(
        _ line: Line,
        _ closure: (Element) -> Void
    ) where Line.Vector == Vector {
        root.queryLine(line) { (_, element) in
            closure(element)
        }
    }

    /// Performs a bound query using a closure to be invoked for each element
    /// found to intersect `area`.
    @inlinable
    public func lazyQuery<Bounds: BoundableType>(
        _ area: Bounds,
        _ closure: (Element) -> Void
    ) where Bounds.Vector == Vector {
        root.query(area) { (_, element) in
            closure(element)
        }
    }

    // MARK: - Mutation

    @inlinable
    mutating func reconstruct(_ newBounds: Bounds) {
        let existing = elements()
        root = .init(
            bounds: newBounds,
            elements: [],
            subdivisions: nil,
            depth: 0
        )

        for element in existing {
            root.insert(
                element: element,
                .init(
                    maxSubdivisions: maxSubdivisions,
                    maxElementsPerLevelBeforeSplit: maxElementsPerLevelBeforeSplit
                )
            )
        }
    }

    /// Compacts this spatial tree such that the root subdivision is the minimal
    /// size capable of containing all elements within the spatial tree.
    ///
    /// If this spatial tree has no elements, the root subdivision is reset back
    /// to `AABB.zero`, instead.
    public mutating func compact() {
        let minimalBounds = AABB(aabbs: elements().map(\.bounds))

        reconstruct(minimalBounds)
    }

    /// Ensures that this spatial tree can contain a given boundary.
    ///
    /// If this spatial tree is smaller than `bounds`, or does not intersect it,
    /// it is re-constructed such that it contains `bounds` and all elements
    /// re-added.
    ///
    /// If this spatial tree is empty, the root subdivision's bounds is set to
    /// `bounds` instead of the union of the two.
    @inlinable
    public mutating func ensureContains(bounds: Bounds) {
        ensureUnique()

        guard !root.bounds.contains(bounds) else {
            return
        }

        let newBounds: Bounds
        if root.isEmpty() {
            newBounds = bounds
        } else {
            newBounds = root.bounds.union(bounds)
        }

        reconstruct(newBounds)
    }

    /// Inserts a new element into this spatial tree.
    ///
    /// If the given element is outside the boundaries of this spatial tree, it
    /// is reconstructed to fit all current elements, plus the incoming element.
    @inlinable
    public mutating func insert(_ element: Element) {
        ensureContains(bounds: root.bounds.union(element.bounds))

        root.insert(
            element: element,
            .init(
                maxSubdivisions: maxSubdivisions,
                maxElementsPerLevelBeforeSplit: maxElementsPerLevelBeforeSplit
            )
        )
    }

    /// Removes an element at a given index in this spatial tree.
    @inlinable
    public mutating func remove(at index: Index, collapseEmpty: Bool = false) {
        ensureUnique()
        if !root.remove(at: index.path, collapseEmpty: collapseEmpty) {
            fatalError("Index \(index) is not part of this spatial tree.")
        }
    }

    /// Removes a given element from this spatial tree.
    public mutating func remove(_ element: Element, collapseEmpty: Bool = false) where Element: Equatable {
        let bounds = element.bounds
        root.visitBounds(bounds) { subdivision in
            for i in (0..<subdivision.elements.count).reversed() {
                if subdivision.elements[i] == element {
                    subdivision.elements.remove(at: i)
                }
            }

            return .visitSubdivisions
        }
        if collapseEmpty {
            root.collapseEmpty()
        }
    }

    /// Removes all elements contained within this spatial tree, resetting its
    /// root element back to an empty state.
    ///
    /// The bounds of the root element are kept as-is.
    @inlinable
    public mutating func removeAll() {
        ensureUnique()
        root = .init(
            bounds: root.bounds,
            elements: [],
            subdivisions: nil,
            depth: 0
        )
    }

    /// Returns a view for all subdivisions of this spatial tree.
    public func viewsForSubdivisions() -> [SubdivisionView] {
        var result: [SubdivisionView] = []

        var queue: [Subdivision] = [root]

        while !queue.isEmpty {
            let next = queue.removeFirst()

            result.append(
                .init(bounds: next.bounds, elements: next.elements)
            )

            if let subdivisions = next.subdivisions {
                queue.append(contentsOf: subdivisions)
            }
        }

        return result
    }

    /// A subdivision of a spatial tree.
    @usableFromInline
    internal class Subdivision {
        /// The bounds that this subdivision represents.
        @usableFromInline
        var bounds: Bounds

        /// Elements contained within this subdivision.
        @usableFromInline
        var elements: [Element]

        /// If non-nil, indicates child sub-divisions within this subdivision.
        @usableFromInline
        var subdivisions: [Subdivision]?

        /// The depth of this subdivision structure.
        @usableFromInline
        var depth: Int

        @usableFromInline
        init(
            bounds: Bounds,
            elements: [Element],
            subdivisions: [Subdivision]?,
            depth: Int
        ) {
            self.bounds = bounds
            self.elements = elements
            self.subdivisions = subdivisions
            self.depth = depth
        }

        /// Performs a deep copy of this subdivision structure.
        @inlinable
        func deepCopy() -> Subdivision {
            return Subdivision(
                bounds: bounds,
                elements: elements,
                subdivisions: subdivisions.map {
                    $0.map({ $0.deepCopy() })
                },
                depth: depth
            )
        }

        /// Recursively collapses empty subdivisions within this spatial tree
        /// subdivision.
        @inlinable
        func collapseEmpty() {
            guard let subdivisions else { return }

            for subdivision in subdivisions {
                subdivision.collapseEmpty()
            }

            if subdivisions.allSatisfy({ $0.elements.isEmpty }) {
                self.subdivisions = nil
            }
        }

        @inlinable
        func queryPoint(
            _ point: Vector,
            results: inout [Element]
        ) {
            for element in elements {
                if element.bounds.contains(point) {
                    results.append(element)
                }
            }

            if let subdivisions {
                for subdivision in subdivisions {
                    guard subdivision.bounds.contains(point) else {
                        continue
                    }

                    subdivision.queryPoint(point, results: &results)
                }
            }
        }

        @inlinable
        func queryPoint(
            _ point: Vector,
            onMatch: (Subdivision, Element) -> Void
        ) {
            for element in elements {
                if element.bounds.contains(point) {
                    onMatch(self, element)
                }
            }

            if let subdivisions {
                for subdivision in subdivisions {
                    guard subdivision.bounds.contains(point) else {
                        continue
                    }

                    subdivision.queryPoint(point, onMatch: onMatch)
                }
            }
        }

        @inlinable
        func queryLine<Line: LineFloatingPoint>(
            _ line: Line,
            onMatch: (Subdivision, Element) -> Void
        ) where Line.Vector == Vector {
            for element in elements {
                if element.bounds.intersects(line: line) {
                    onMatch(self, element)
                }
            }

            if let subdivisions {
                for subdivision in subdivisions {
                    guard subdivision.bounds.intersects(line: line) else {
                        continue
                    }

                    subdivision.queryLine(line, onMatch: onMatch)
                }
            }
        }

        @inlinable
        func query<Bounds: BoundableType>(
            _ area: Bounds,
            onMatch: (Subdivision, Element) -> Void
        ) where Bounds.Vector == Vector {
            for element in elements {
                if element.bounds.intersects(area.bounds) {
                    onMatch(self, element)
                }
            }

            if let subdivisions {
                for subdivision in subdivisions {
                    guard subdivision.bounds.intersects(area.bounds) else {
                        continue
                    }

                    subdivision.query(area, onMatch: onMatch)
                }
            }
        }

        @inlinable
        func visitBounds<Bounds: BoundableType>(
            _ area: Bounds,
            visit: (Subdivision) -> VisitResult
        ) where Bounds.Vector == Vector {
            let bounds = area.bounds
            var queue = [self]

            while !queue.isEmpty {
                let next = queue.removeFirst()

                guard next.bounds.intersects(bounds) else {
                    continue
                }

                switch visit(next) {
                case .skipSubdivisions:
                    continue

                case .stop:
                    return

                case .visitSubdivisions:
                    break
                }

                for subdivision in (next.subdivisions ?? []) {
                    if subdivision.bounds.contains(bounds) {
                        queue.append(subdivision)
                    }
                }
            }
        }

        /// Returns `true` if no elements are contained within this subdivision,
        /// or any of its inner subdivisions.
        @inlinable
        func isEmpty() -> Bool {
            guard elements.isEmpty else {
                return false
            }

            return areSubdivisionsEmpty()
        }

        /// Returns `true` if no subdivisions are available, or if they are all
        /// empty.
        ///
        /// The check is performed recursively across all subdivisions.
        @inlinable
        func areSubdivisionsEmpty() -> Bool {
            guard let subdivisions else {
                return true
            }

            return subdivisions.allSatisfy({ $0.isEmpty() })
        }

        /// Recursively traverses this subdivision, collecting all elements into
        /// a given array.
        @inlinable
        func collectElements(to result: inout [Element]) {
            result.append(contentsOf: elements)

            if let subdivisions {
                for subdivision in subdivisions {
                    subdivision.collectElements(to: &result)
                }
            }
        }

        /// Inserts the given element within this subdivision.
        ///
        /// If the number of items in this subdivision exceeds
        /// `maxElementsPerLevelBeforeSplit`, and `maxSubdivisions` has not been
        /// reached yet, this subdivision is split, and all elements contained
        /// within are distributed along the subdivisions.
        @inlinable
        func insert(
            element: Element,
            _ context: InsertionContext
        ) {
            if let subdivisions {
                for subdivision in subdivisions {
                    guard subdivision.bounds.contains(element.bounds) else {
                        continue
                    }

                    subdivision.insert(element: element, context)
                    return
                }
            }

            elements.append(element)

            if
                subdivisions == nil,
                (elements.count + 1) > context.maxElementsPerLevelBeforeSplit,
                depth < context.maxSubdivisions
            {
                subdivideAndDistribute()
            }
        }

        /// Forces a subdivision on this spatial tree subdivision, if no subdivisions
        /// are present yet, and attempts to move all elements deeper into the
        /// subdivisions.
        @inlinable
        func subdivideAndDistribute() {
            for subdivision in subdivide() {
                for (i, element) in elements.enumerated().reversed() {
                    if subdivision.bounds.contains(element.bounds) {
                        subdivision.elements.append(element)
                        elements.remove(at: i)
                    }
                }
            }
        }

        /// Forces a subdivision on this spatial tree subdivision, if no subdivisions
        /// are present yet.
        ///
        /// New subdivisions are left empty.
        @discardableResult
        @inlinable
        func subdivide() -> [Subdivision] {
            if let subdivisions {
                return subdivisions
            }

            let areas = bounds.subdivided()
            let newSubdivision = areas.map { area in
                Subdivision(
                    bounds: area,
                    elements: [],
                    subdivisions: nil,
                    depth: depth + 1
                )
            }

            subdivisions = newSubdivision
            return newSubdivision
        }

        /// Applies a given closure to each subdivision within this spatial tree,
        /// if there are any.
        @inlinable
        func _forEachSubdivision(_ block: (Subdivision) -> Void) {
            if let subdivisions {
                subdivisions.forEach(block)
            }
        }

        /// Returns all indexable element paths within this subdivision tree.
        ///
        /// If no elements are available in any subdivision within this tree, the
        /// result is an empty array.
        @inlinable
        func availableElementPaths() -> [ElementPath] {
            var result: [ElementPath] = []
            for i in 0..<elements.count {
                result.append(.element(i))
            }

            if let subdivisions {
                for (i, subdivision) in subdivisions.enumerated() {
                    for inner in subdivision.availableElementPaths() {
                        result.append(.subdivision(i, inner))
                    }
                }
            }

            return result
        }

        @inlinable
        func index(after index: Index) -> Index? {
            let nextSubdivision: Int
            switch index.path {
            case .element(let index):
                if elements.indices.contains(index + 1) {
                    return .init(path: .element(index + 1))
                }

                nextSubdivision = 0

            case .subdivision(let index, let inner):
                guard let subdivisions else {
                    return nil
                }

                if let nextIndex = subdivisions[index].index(after: .init(path: inner)) {
                    return .init(
                        path: .subdivision(index, nextIndex.path)
                    )
                }

                nextSubdivision = index + 1
            }

            guard let subdivisions else {
                return nil
            }

            for (i, subdivision) in subdivisions.enumerated().dropFirst(nextSubdivision) {
                guard let firstIndex = subdivision.firstIndex() else {
                    continue
                }

                return .init(
                    path: .subdivision(i, firstIndex.path)
                )
            }

            return nil
        }

        @inlinable
        func subdivision(for path: ElementPath) -> Subdivision? {
            switch path {
            case .element:
                return self

            case .subdivision(let index, let inner):
                guard let subdivisions else {
                    return nil
                }

                return subdivisions[index].subdivision(for: inner)
            }
        }

        /// Returns `true` if the element index existed within this subdivision
        /// tree and was successfully removed.
        @inlinable
        func remove(at path: ElementPath, collapseEmpty: Bool = false) -> Bool {
            switch path {
            case .element(let index):
                elements.remove(at: index)
                return true

            case .subdivision(let index, let inner):
                guard let subdivisions else {
                    return false
                }

                guard subdivisions[index].remove(at: inner, collapseEmpty: collapseEmpty) else {
                    return false
                }

                // Collapse subdivision
                if collapseEmpty {
                    if areSubdivisionsEmpty() {
                        self.subdivisions = nil
                    }
                }

                return true
            }
        }

        @inlinable
        func element(at path: ElementPath) -> Element? {
            switch path {
            case .element(let index):
                return elements[index]

            case .subdivision(let subdivision, let inner):
                guard let subdivisions else {
                    return nil
                }

                return subdivisions[subdivision].element(at: inner)
            }
        }

        @inlinable
        func firstIndex() -> Index? {
            if !elements.isEmpty {
                return Index(path: .element(0))
            }
            guard let subdivisions else {
                return nil
            }

            for (i, subdivision) in subdivisions.enumerated() {
                if let index = subdivision.firstIndex() {
                    return index.withPath(.subdivision(i, index.path))
                }
            }

            return nil
        }

        @inlinable
        func indexExists(_ index: Index) -> Bool {
            switch index.path {
            case .element(let index):
                return elements.indices.contains(index)

            case .subdivision(let subdivision, let path):
                guard let subdivisions, subdivision < subdivisions.count else {
                    return false
                }

                return subdivisions[subdivision].indexExists(
                    index.withPath(path)
                )
            }
        }

        @usableFromInline
        enum VisitResult {
            /// Visits subdivisions of the current subdivision.
            case visitSubdivisions

            /// Skips subdivisions of the current subdivision.
            case skipSubdivisions

            /// Ends visiting of all subdivisions queued up.
            case stop
        }

        @usableFromInline
        struct InsertionContext {
            @usableFromInline
            let maxSubdivisions: Int

            @usableFromInline
            let maxElementsPerLevelBeforeSplit: Int

            @usableFromInline
            internal init(
                maxSubdivisions: Int,
                maxElementsPerLevelBeforeSplit: Int
            ) {
                self.maxSubdivisions = maxSubdivisions
                self.maxElementsPerLevelBeforeSplit = maxElementsPerLevelBeforeSplit
            }
        }
    }

    public struct SubdivisionView {
        public var bounds: Bounds
        public var elements: [Element]

        @usableFromInline
        init(bounds: Bounds, elements: [Element]) {
            self.bounds = bounds
            self.elements = elements
        }
    }
}

extension SpatialTree {
    @usableFromInline
    enum ElementPath: Comparable, CustomStringConvertible {
        case element(Int)
        indirect case subdivision(Int, Self)

        @usableFromInline
        var description: String {
            switch self {
            case .element(let index):
                return ".element(\(index))"

            case .subdivision(let index, let inner):
                return ".subdivision(\(index), \(inner))"
            }
        }

        @usableFromInline
        var elementIndex: Int {
            switch self {
            case .element(let index):
                return index

            case .subdivision(_, let inner):
                return inner.elementIndex
            }
        }

        @usableFromInline
        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.element(let lhs), .element(let rhs)):
                return lhs < rhs

            case (.element, _):
                return true

            case (_, .element):
                return false

            case (.subdivision(let lhsIndex, let lhsPath), .subdivision(let rhsIndex, let rhsPath)):
                if lhsIndex < rhsIndex {
                    return true
                }
                if lhsIndex == rhsIndex {
                    return lhsPath < rhsPath
                }

                return false
            }
        }
    }
}

extension SpatialTree: Collection {
    /// An index into a spatial tree, down to an element within the spatial tree.
    public struct Index: Comparable {
        @usableFromInline
        var path: ElementPath

        @inlinable
        internal init(path: SpatialTree<Element>.ElementPath) {
            self.path = path
        }

        @inlinable
        internal func withPath(_ path: ElementPath) -> Self {
            var copy = self
            copy.path = path
            return copy
        }

        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            return lhs.path < rhs.path
        }
    }

    /// Returns the first index for indexing into this spatial tree.
    public var startIndex: Index {
        root.firstIndex() ?? .init(path: .element(0))
    }

    /// Returns the one-past-end index for this spatial tree. Indexing with this
    /// index is not a valid operation, as it points to the end of any valid
    /// spatial division index.
    public var endIndex: Index {
        .init(path: .subdivision(root.subdivisions?.count ?? 0, .element(0)))
    }

    /// Gets an element at a given index in this spatial tree.
    public subscript(position: Index) -> Element {
        guard let element = root.element(at: position.path) else {
            fatalError("Index \(position) is not part of this spatial tree.")
        }

        return element
    }

    public func index(after i: Index) -> Index {
        root.index(after: i) ?? endIndex
    }
}
