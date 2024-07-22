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

    private mutating func ensureUnique() {
        if !isKnownUniquelyReferenced(&root) {
            root = root.deepCopy()
        }
    }

    private mutating func ensuringUnique() -> Subdivision {
        ensureUnique()
        return root
    }

    // MARK: - Querying

    /// Returns all elements contained within this spatial tree.
    public func elements() -> [Element] {
        var result: [Element] = []
        root.collectElements(to: &result)
        return result
    }

    public func queryPoint(_ point: Vector) -> [Element] {
        var result: [Element] = []
        root.queryPoint(point, to: &result)
        return result
    }

    public func queryLine<Line: LineFloatingPoint>(
        _ line: Line
    ) -> [Element] where Line.Vector == Vector {
        var result: [Element] = []
        root.queryLine(line, to: &result)
        return result
    }

    public func query<Bounds: BoundableType>(
        _ area: Bounds
    ) -> [Element] where Bounds.Vector == Vector {
        var result: [Element] = []
        root.query(area, to: &result)
        return result
    }

    // MARK: - Mutation

    /// Inserts a new element into this spatial tree.
    ///
    /// If the given element is outside the boundaries of this spatial tree, it
    /// is reconstructed to fit all current elements, plus the incoming element.
    public mutating func insert(_ element: Element) {
        ensureUnique()

        if root.bounds.contains(element.bounds) {
            root.insert(
                element: element,
                .init(
                    maxSubdivisions: maxSubdivisions,
                    maxElementsPerLevelBeforeSplit: maxElementsPerLevelBeforeSplit
                )
            )
        } else {
            // Reconstruction is required
            let newBounds: Bounds
            if root.isEmpty() {
                newBounds = element.bounds
            } else {
                newBounds = root.bounds.union(element.bounds)
            }

            let existing = elements()
            root = .init(
                bounds: newBounds,
                elements: [element],
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
    }

    /// Removes an element at a given index in this spatial tree.
    ///
    /// In case removal results in an empty set of subdivisions for a subdivision,
    /// the subdivisions are collapsed and removed.
    public mutating func remove(at index: Index) {
        ensureUnique()
        if !root.remove(at: index.path) {
            fatalError("Index \(index) is not part of this spatial tree.")
        }
    }

    /// Removes all elements contained within this spatial tree, resetting its
    /// root element back to an empty state.
    ///
    /// The bounds of the root element are kept as-is.
    public mutating func removeAll() {
        ensureUnique()
        root = .init(
            bounds: root.bounds,
            elements: [],
            subdivisions: nil,
            depth: 0
        )
    }

    /// A subdivision of a spatial tree.
    internal class Subdivision {
        /// The bounds that this subdivision represents.
        var bounds: Bounds

        /// Elements contained within this subdivision.
        var elements: [Element]

        /// If non-nil, indicates child sub-divisions within this subdivision.
        var subdivisions: [Subdivision]?

        /// The depth of this subdivision structure.
        var depth: Int

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

        func queryPoint(_ point: Vector, to result: inout [Element]) {
            for element in elements {
                if element.bounds.contains(point) {
                    result.append(element)
                }
            }

            forEachSubdivision { subdivision in
                guard subdivision.bounds.contains(point) else {
                    return
                }

                subdivision.queryPoint(point, to: &result)
            }
        }

        func queryLine<Line: LineFloatingPoint>(
            _ line: Line, to result: inout [Element]
        ) where Line.Vector == Vector {
            for element in elements {
                if element.bounds.intersects(line: line) {
                    result.append(element)
                }
            }

            forEachSubdivision { subdivision in
                guard subdivision.bounds.intersects(line: line) else {
                    return
                }

                subdivision.queryLine(line, to: &result)
            }
        }

        func query<Bounds: BoundableType>(
            _ area: Bounds, to result: inout [Element]
        ) where Bounds.Vector == Vector {
            for element in elements {
                if element.bounds.intersects(area.bounds) {
                    result.append(element)
                }
            }

            forEachSubdivision { subdivision in
                guard subdivision.bounds.intersects(area.bounds) else {
                    return
                }

                subdivision.query(area, to: &result)
            }
        }

        /// Returns `true` if no elements are contained within this subdivision,
        /// or any of its inner subdivisions.
        func isEmpty() -> Bool {
            guard elements.isEmpty else {
                return false
            }

            return areSubdivisionsEmpty()
        }

        /// Returns `true` if no subdivisions are available, or if they are all
        /// empty.
        func areSubdivisionsEmpty() -> Bool {
            guard let subdivisions else {
                return true
            }

            return subdivisions.allSatisfy({ $0.isEmpty() })
        }

        /// Recursively traverses this subdivision, collecting all elements into
        /// a given array.
        func collectElements(to result: inout [Element]) {
            result.append(contentsOf: elements)

            forEachSubdivision { subdivision in
                subdivision.collectElements(to: &result)
            }
        }

        /// Inserts the given element within this subdivision.
        ///
        /// If the number of items in this subdivision exceeds
        /// `maxElementsPerLevelBeforeSplit`, and `maxSubdivisions` has not been
        /// reached yet, this subdivision is split, and all elements contained
        /// within are distributed along the subdivisions.
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
        func forEachSubdivision(_ block: (Subdivision) -> Void) {
            if let subdivisions {
                subdivisions.forEach(block)
            }
        }

        /// Returns all indexable element paths within this subdivision tree.
        ///
        /// If no elements are available in any subdivision within this tree, the
        /// result is an empty array.
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
        func remove(at path: ElementPath) -> Bool {
            switch path {
            case .element(let index):
                elements.remove(at: index)
                return true

            case .subdivision(let index, let inner):
                guard let subdivisions else {
                    return false
                }

                guard subdivisions[index].remove(at: inner) else {
                    return false
                }

                // Collapse subdivision
                if areSubdivisionsEmpty() {
                    self.subdivisions = nil
                }

                return true
            }
        }

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

        struct InsertionContext {
            let maxSubdivisions: Int
            let maxElementsPerLevelBeforeSplit: Int
        }
    }
}

extension SpatialTree {
    enum ElementPath: Comparable, CustomStringConvertible {
        case element(Int)
        indirect case subdivision(Int, Self)

        var description: String {
            switch self {
            case .element(let index):
                return ".element(\(index))"

            case .subdivision(let index, let inner):
                return ".subdivision(\(index), \(inner))"
            }
        }

        var elementIndex: Int {
            switch self {
            case .element(let index):
                return index

            case .subdivision(_, let inner):
                return inner.elementIndex
            }
        }

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
        var path: ElementPath

        fileprivate func withPath(_ path: ElementPath) -> Self {
            var copy = self
            copy.path = path
            return copy
        }

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
