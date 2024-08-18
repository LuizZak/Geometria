import MiniDigraph
import Geometria
import GeometriaAlgorithms
import OrderedCollections

/// A graph that describes a set of geometry vertices + intersection points, with
/// edges that correspond to simplexes of a 2-dimensional geometry.
public struct Simplex2Graph<Vector: Vector2Real & Hashable> {
    public typealias Scalar = Vector.Scalar
    public typealias Period = Scalar
    public typealias Contour = Parametric2Contour<Vector>

    /// Internal cached graph implementation.
    private(set) var graph: CachingDirectedGraph<InternalGraph>

    /// Nodes sorted by `Node.id`.
    @inlinable
    var sortedNodes: [Node] {
        Array(nodes)
    }

    /// Edges sorted by `Edge.id`.
    @usableFromInline
    var sortedEdges: [Edge] {
        Array(edges)
    }

    /// kd-tree of nodes.
    @usableFromInline
    var nodeTree: KDTree<Node> = .init(dimensionCount: 2, elements: [])

    /// Quad-tree of edges.
    @usableFromInline
    var edgeTree: QuadTree<Edge> = .init(maxSubdivisions: 4, maxElementsPerLevelBeforeSplit: 10)

    /// Quad-tree of contours.
    @usableFromInline
    var contourTree: QuadTree<ContourEntry> = .init(maxSubdivisions: 4, maxElementsPerLevelBeforeSplit: 10)

    /// The next available node ID to be used when adding contours.
    var nodeId: Int = 0

    /// The next available edge ID to be used when adding contours.
    var edgeId: Int = 0

    public var contours: [Contour]

    public var nodes: OrderedSet<Node> {
        graph.nodes
    }
    public var edges: OrderedSet<Edge> {
        graph.edges
    }

    public init() {
        self.graph = .init()
        self.contours = []
    }

    @usableFromInline
    mutating func nextNodeId() -> Int {
        defer { nodeId += 1 }
        return nodeId
    }

    @usableFromInline
    mutating func nextEdgeId() -> Int {
        defer { edgeId += 1 }
        return edgeId
    }

    /// Returns `true` if any of the nodes within this simplex graph is an
    /// intersection.
    public func hasIntersections() -> Bool {
        nodes.contains(where: \.isIntersection)
    }

    /// Returns the edge for a given period within a given shape index number.
    @usableFromInline
    func edgeForPeriod(_ period: Period, shapeIndex: Int) -> Edge? {
        edges.first { edge in
            edge.references(shapeIndex: shapeIndex, at: period)
        }
    }

    @usableFromInline
    struct ContourEntry: BoundableType {
        @usableFromInline
        var contour: Contour

        @usableFromInline
        var bounds: AABB<Vector>

        @usableFromInline
        var index: Int

        @usableFromInline
        internal init(contour: Contour, bounds: AABB<Vector>, index: Int) {
            self.contour = contour
            self.bounds = bounds
            self.index = index
        }
    }

    public final class Node: Hashable, CustomStringConvertible {
        public typealias ShapeIndex = Int

        public var id: Int
        public var location: Vector
        public var kind: Kind

        public var geometries: [Kind.SharedGeometryEntry] {
            switch kind {
            case .geometry(let shapeIndex, let period):
                return [.init(shapeIndex: shapeIndex, period: period)]

            case .sharedGeometry(let entries):
                return entries
            }
        }

        public var description: String {
            "Node(id: \(id), location: \(location), kind: \(kind))"
        }

        public var isIntersection: Bool {
            kind.isIntersection
        }

        public var shapeIndex: Int? {
            kind.shapeIndex
        }

        @usableFromInline
        init(
            id: Int,
            location: Vector,
            kind: Kind
        ) {
            self.id = id
            self.location = location
            self.kind = kind
        }

        @inlinable
        func append(shapeIndex: Int, period: Period) {
            let entry = Kind.SharedGeometryEntry(
                shapeIndex: shapeIndex,
                period: period
            )

            kind = .sharedGeometry([entry] + geometries)
        }

        @inlinable
        func references(shapeIndex: Int, period: Period) -> Bool {
            switch kind {
            case .geometry(shapeIndex, period):
                return true

            case .sharedGeometry(let entries):
                return entries.contains(where: { $0.shapeIndex == shapeIndex && $0.period == period })

            default:
                return false
            }
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }

        public static func == (lhs: Node, rhs: Node) -> Bool {
            lhs === rhs
        }

        public enum Kind: Equatable, CustomStringConvertible {
            /// A geometry node.
            case geometry(
                shapeIndex: ShapeIndex,
                period: Period
            )

            /// A geometry node that is shared amongst different geometries,
            /// indicating an intersection.
            case sharedGeometry(
                [SharedGeometryEntry]
            )

            public var description: String {
                switch self {
                case .geometry(let shapeIndex, let period):
                    return ".geometry(shapeIndex: \(shapeIndex), period: \(period))"

                case .sharedGeometry(let entries):
                    return ".sharedGeometry(\(entries))"
                }
            }

            public var isIntersection: Bool {
                switch self {
                case .sharedGeometry:
                    return true

                default:
                    return false
                }
            }

            public var shapeIndex: Int? {
                switch self {
                case .geometry(let shapeIndex, _):
                    return shapeIndex

                default:
                    return nil
                }
            }

            /// Subtracts a given shape index from the list of referenced shapes
            /// within this node kind.
            ///
            /// If this results in the kind having an empty set of referenced
            /// nodes, `nil` is returned, instead.
            ///
            /// This may transform `intersection` and `sharedGeometry` back into
            /// `geometry`, which always maps to `nil` if subtracted from.
            ///
            /// It is a programming error to attempt to subtract a shape index
            /// that this node kind does not reference.
            public func subtracting(shapeIndex: Int) -> Self? {
                switch self {
                case .geometry(shapeIndex, _):
                    return nil

                case .sharedGeometry(let geometries):
                    let newGeometries = geometries.filter { $0.shapeIndex != shapeIndex }
                    if newGeometries.count > 1 {
                        return .sharedGeometry(newGeometries)
                    }
                    if newGeometries.count == 1 {
                        return .geometry(
                            shapeIndex: newGeometries[0].shapeIndex,
                            period: newGeometries[0].period
                        )
                    }
                    return nil

                default:
                    assertionFailure(
                        "\(#function): \(shapeIndex) is not part of the shape indices of \(self)"
                    )
                    return nil
                }
            }

            public struct SharedGeometryEntry: Equatable, CustomStringConvertible {
                public var shapeIndex: ShapeIndex
                public var period: Period

                public var description: String {
                    "\(type(of: self))(shapeIndex: \(shapeIndex), period: \(period))"
                }

                @usableFromInline
                internal init(
                    shapeIndex: ShapeIndex,
                    period: Period
                ) {
                    self.shapeIndex = shapeIndex
                    self.period = period
                }
            }
        }
    }

    public final class Edge: AbstractDirectedGraphEdge, Hashable, CustomStringConvertible {
        /// A unique identifier assigned during graph generation, used to sort
        /// edges by earliest generation.
        public var id: Int

        public var start: Node {
            didSet { cacheProperties() }
        }
        public var end: Node {
            didSet { cacheProperties() }
        }
        public var kind: Kind {
            didSet { cacheProperties() }
        }
        public var geometry: [SharedGeometryEntry]

        @inlinable
        public var shapeIndices: [Int] {
            geometry.map(\.shapeIndex)
        }

        public var totalWinding: Int
        public var winding: Parametric2Contour<Vector>.Winding

        public var description: String {
            return "\(start.id) -(\(kind), \(geometry))-> \(end.id)"
        }

        public internal(set) var bounds: AABB<Vector> = .zero
        public internal(set) var lengthSquared: Vector.Scalar = .zero

        public convenience init(
            id: Int,
            start: Node,
            end: Node,
            kind: Kind,
            shapeIndex: Int,
            startPeriod: Period,
            endPeriod: Period,
            totalWinding: Int = 0,
            winding: Parametric2Contour<Vector>.Winding = .clockwise
        ) {
            self.init(
                id: id,
                start: start,
                end: end,
                kind: kind,
                geometry: [
                    .init(
                        shapeIndex: shapeIndex,
                        startPeriod: startPeriod,
                        endPeriod: endPeriod
                    )
                ],
                totalWinding: totalWinding,
                winding: winding
            )
        }

        public init(
            id: Int,
            start: Node,
            end: Node,
            kind: Kind,
            geometry: [SharedGeometryEntry],
            totalWinding: Int = 0,
            winding: Parametric2Contour<Vector>.Winding = .clockwise
        ) {
            self.id = id
            self.start = start
            self.end = end
            self.kind = kind
            self.geometry = geometry
            self.totalWinding = totalWinding
            self.winding = winding

            cacheProperties()
        }

        internal func cacheProperties() {
            let primitive = materializePrimitive()
            bounds = primitive.bounds
            lengthSquared = primitive.lengthSquared
        }

        @inlinable
        func queryPoint() -> Vector {
            switch kind {
            case .line:
                return (start.location + end.location) / 2

            case .circleArc(let center, let radius, let startAngle, let sweepAngle):
                let arc = CircleArc2(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    sweepAngle: sweepAngle
                )

                return arc.pointOnAngle(
                    startAngle + sweepAngle / 2
                )
            }
        }

        /// Returns `true` if `self` references a given shape index.
        @inlinable
        func references(shapeIndex: Int) -> Bool {
            for geometry in geometry {
                if geometry.shapeIndex == shapeIndex {
                    return true
                }
            }

            return false
        }

        /// Returns `true` if `self` references a given shape index at a given
        /// period.
        @inlinable
        func references(shapeIndex: Int, at period: Period) -> Bool {
            for geometry in geometry {
                if geometry.shapeIndex == shapeIndex && geometry.contains(period: period) {
                    return true
                }
            }

            return false
        }

        /// Subtracts a given shape index from the list of referenced shape indices
        /// of this edge, returning `nil` if the operation results in no shape
        /// indices left referenced by this edge.
        @inlinable
        func subtracting(shapeIndex: Int) -> Edge? {
            geometry.removeAll { $0.shapeIndex == shapeIndex }
            return geometry.isEmpty ? nil : self
        }

        /// Subtracts a given shape index from the list of referenced shape indices
        /// of this edge, returning `nil` if the operation results in no shape
        /// indices left referenced by this edge.
        @inlinable
        func subtractingFirstNonEqual(shapeIndex: Int) -> Bool? {
            if let index = geometry.firstIndex(where: { $0.shapeIndex != shapeIndex }) {
                geometry.remove(at: index)
                return geometry.isEmpty ? nil : true
            }

            return false
        }

        /// Returns `true` if `self` and `other` have an overlapping shape index
        /// reference between them.
        @inlinable
        func referencesSameShape(as other: Edge) -> Bool {
            for shapeIndex in other.geometry.map(\.shapeIndex) {
                if references(shapeIndex: shapeIndex) {
                    return true
                }
            }

            return false
        }

        /// Returns the ratio for a given period within this edge, based on a given
        /// shape index.
        ///
        /// If the period does not exist within this edge, `nil` is returned, instead.
        @inlinable
        func ratio(forPeriod period: Period, shapeIndex: Int) -> Scalar? {
            for geometry in geometry where geometry.shapeIndex == shapeIndex {
                guard geometry.periodRange.contains(period) else {
                    continue
                }

                return (period - geometry.startPeriod) / (geometry.endPeriod - geometry.startPeriod)
            }

            return nil
        }

        /// Returns `true` if `self` is coincident with `other`, i.e. both edges
        /// represent the same underlying stroke, overlapping in space.
        ///
        /// The check ignores other edges that belong to the same shape.
        @usableFromInline
        func isCoincident(with other: Edge, tolerance: Scalar) -> Bool {
            // Edges cannot be collinear with themselves
            if other === self {
                return false
            }
            // TODO: Relax this step to a parameter to allow joining collinear edges later on
            // Edges cannot be collinear with other edges from the same shape
            if referencesSameShape(as: other) {
                return false
            }

            switch (self.kind, other.kind) {
            case (.line, .line):
                let lhsLine = LineSegment2(start: self.start.location, end: self.end.location)
                let rhsLine = LineSegment2(start: other.start.location, end: other.end.location)

                if lhsLine.isCollinear(with: rhsLine, tolerance: tolerance) {
                    func lhsContains(_ scalar: Scalar) -> Bool {
                        return lhsLine.containsProjectedNormalizedMagnitude(scalar)
                    }
                    func rhsContains(_ scalar: Scalar) -> Bool {
                        return rhsLine.containsProjectedNormalizedMagnitude(scalar)
                    }

                    let lhsStart = rhsLine.projectAsScalar(lhsLine.start)
                    if rhsContains(lhsStart) {
                        return true
                    }

                    let lhsEnd = rhsLine.projectAsScalar(lhsLine.end)
                    if rhsContains(lhsEnd) {
                        return true
                    }

                    let rhsStart = lhsLine.projectAsScalar(rhsLine.start)
                    if lhsContains(rhsStart) {
                        return true
                    }

                    let rhsEnd = lhsLine.projectAsScalar(rhsLine.end)
                    if lhsContains(rhsEnd) {
                        return true
                    }
                }

                return false

            case (
                .circleArc(let lhsCenter, let lhsRadius, let lhsStart, let lhsSweep),
                .circleArc(let rhsCenter, let rhsRadius, let rhsStart, let rhsSweep)
                ) where lhsCenter == rhsCenter && lhsRadius.isApproximatelyEqualFast(to: rhsRadius, tolerance: tolerance):
                let lhsSweep = AngleSweep(start: lhsStart, sweep: lhsSweep)
                let rhsSweep = AngleSweep(start: rhsStart, sweep: rhsSweep)

                // Ignore angles that are joined end-to-end
                func withinTolerance(_ v1: Scalar, _ v2: Scalar) -> Bool {
                    (v1 - v2).magnitude <= tolerance
                }
                if
                    withinTolerance(lhsSweep.start.normalized(from: .zero), rhsSweep.stop.normalized(from: .zero)) ||
                    withinTolerance(lhsSweep.stop.normalized(from: .zero), rhsSweep.start.normalized(from: .zero))
                {
                    return false
                }

                return lhsSweep.intersects(rhsSweep)

            default:
                return false
            }
        }

        /// Returns `true` if this edge opposes the direction of another coincident
        /// edge.
        ///
        /// - note: Assumes that `self` and `other` are coincident edges, and
        /// returns `false` if the edges are of different kinds.
        @usableFromInline
        func isOpposingCoincident(_ other: Edge) -> Bool {
            switch (self.kind, other.kind) {
            case (.line, .line):
                let lhsLine = LineSegment2(start: self.start.location, end: self.end.location)
                let lhsSlope = lhsLine.lineSlope
                let rhsLine = LineSegment2(start: other.start.location, end: other.end.location)
                let rhsSlope = rhsLine.lineSlope

                return lhsSlope.sign == -rhsSlope.sign

            case (.circleArc(_, _, _, let lhsSweep), .circleArc(_, _, _, let rhsSweep)):
                return lhsSweep.radians.sign != rhsSweep.radians.sign

            default:
                return false
            }
        }

        /// Performs a coincidence check against another edge.
        @usableFromInline
        func coincidenceRelationship(
            with other: Edge,
            tolerance: Scalar
        ) -> CoincidenceRelationship {
            if other === self {
                // An edge cannot be coincident with itself.
                return .notCoincident
            }
            if referencesSameShape(as: other) {
                // Edges belonging to the same shape are never coincident.
                return .notCoincident
            }

            func areClose(_ v1: Vector, _ v2: Vector) -> Bool {
                let diff = (v1 - v2)

                return diff.absolute.maximalComponent.magnitude < tolerance
            }

            let lhsStartCoincident: Bool
            let lhsEndCoincident: Bool

            var lhsStart: Scalar
            var lhsEnd: Scalar
            var rhsStart: Scalar
            var rhsEnd: Scalar

            let lhsContains: (_ scalar: Scalar) -> Bool
            let rhsContains: (_ scalar: Scalar) -> Bool
            let lhsPeriod: (_ scalar: Scalar) -> [CoincidenceRelationship.PeriodEntry]
            let rhsPeriod: (_ scalar: Scalar) -> [CoincidenceRelationship.PeriodEntry]

            switch (self.kind, other.kind) {
            case (.line, .line):
                let lhsLine = LineSegment2(start: self.start.location, end: self.end.location)
                let rhsLine = LineSegment2(start: other.start.location, end: other.end.location)

                // lhs:  •----•
                // rhs:  •----•
                lhsStartCoincident = areClose(lhsLine.start, rhsLine.start) || areClose(lhsLine.start, rhsLine.end)
                lhsEndCoincident = areClose(lhsLine.end, rhsLine.start) || areClose(lhsLine.end, rhsLine.end)

                if
                    lhsStartCoincident && lhsEndCoincident
                {
                    return .sameSpan
                }

                if lhsLine.isCollinear(with: rhsLine, tolerance: tolerance) {
                    lhsStart = rhsLine.projectAsScalar(lhsLine.start)
                    lhsEnd = rhsLine.projectAsScalar(lhsLine.end)
                    rhsStart = lhsLine.projectAsScalar(rhsLine.start)
                    rhsEnd = lhsLine.projectAsScalar(rhsLine.end)

                    lhsContains = { scalar in
                        lhsLine.containsProjectedNormalizedMagnitude(scalar)
                    }
                    rhsContains = { scalar in
                        rhsLine.containsProjectedNormalizedMagnitude(scalar)
                    }

                    // Ensure start < end so checks are easier to make
                    if lhsStart > lhsEnd {
                        swap(&lhsStart, &lhsEnd)
                    }
                    if rhsStart > rhsEnd {
                        swap(&rhsStart, &rhsEnd)
                    }
                } else {
                    return .notCoincident
                }

                lhsPeriod = { scalar in
                    self.geometry.map { geometry in
                        .init(
                            shapeIndex: geometry.shapeIndex,
                            period: geometry.startPeriod + (geometry.endPeriod - geometry.startPeriod) * scalar
                        )
                    }
                }
                rhsPeriod = { scalar in
                    other.geometry.map { geometry in
                        .init(
                            shapeIndex: geometry.shapeIndex,
                            period: geometry.startPeriod + (geometry.endPeriod - geometry.startPeriod) * scalar
                        )
                    }
                }

            case (
                .circleArc(let lhsCenter, let lhsRadius, let lhsStartAngle, let lhsSweepAngle),
                .circleArc(let rhsCenter, let rhsRadius, let rhsStartAngle, let rhsSweepAngle)
                ) where lhsCenter == rhsCenter && lhsRadius.isApproximatelyEqualFast(to: rhsRadius, tolerance: tolerance):
                let lhsSweep = AngleSweep(start: lhsStartAngle, sweep: lhsSweepAngle)
                let rhsSweep = AngleSweep(start: rhsStartAngle, sweep: rhsSweepAngle)

                guard lhsSweep.intersects(rhsSweep) else {
                    return .notCoincident
                }

                lhsStart = lhsSweep.start.radians
                lhsEnd = lhsSweep.stop.radians
                rhsStart = rhsSweep.start.radians
                rhsEnd = rhsSweep.stop.radians

                lhsContains = { value in
                    lhsSweep.contains(.init(radians: value))
                }
                rhsContains = { value in
                    rhsSweep.contains(.init(radians: value))
                }

                let lhs = CircleArc2(
                    center: lhsCenter,
                    radius: lhsRadius,
                    startAngle: lhsStartAngle,
                    sweepAngle: lhsSweepAngle
                )
                let rhs = CircleArc2(
                    center: rhsCenter,
                    radius: rhsRadius,
                    startAngle: rhsStartAngle,
                    sweepAngle: rhsSweepAngle
                )

                lhsStartCoincident =
                    areClose(lhs.startPoint, rhs.startPoint) ||
                    areClose(lhs.startPoint, rhs.endPoint)

                lhsEndCoincident =
                    areClose(lhs.endPoint, rhs.startPoint) ||
                    areClose(lhs.endPoint, rhs.endPoint)

                if
                    lhsStartCoincident && lhsEndCoincident
                {
                    return .sameSpan
                }

                // Ignore angles that are joined end-to-end
                func withinTolerance(_ v1: Scalar, _ v2: Scalar) -> Bool {
                    (v1 - v2).magnitude <= tolerance
                }

                if
                    withinTolerance(lhsSweep.start.normalized(from: .zero), rhsSweep.stop.normalized(from: .zero)) ||
                    withinTolerance(lhsSweep.stop.normalized(from: .zero), rhsSweep.start.normalized(from: .zero))
                {
                    return .notCoincident
                }

                lhsPeriod = { scalar in
                    self.geometry.map { geometry in
                        return .init(
                            shapeIndex: geometry.shapeIndex,
                            period: geometry.startPeriod + (geometry.endPeriod - geometry.startPeriod) * lhsSweep.ratioOfAngle(.init(radians: scalar))
                        )
                    }
                }
                rhsPeriod = { scalar in
                    other.geometry.map { geometry in
                        return .init(
                            shapeIndex: geometry.shapeIndex,
                            period: geometry.startPeriod + (geometry.endPeriod - geometry.startPeriod) * rhsSweep.ratioOfAngle(.init(radians: scalar))
                        )
                    }
                }

            default:
                return .notCoincident
            }

            // lhs:  •------•
            // rhs:   •----•
            if lhsContains(rhsStart) && lhsContains(rhsEnd) {
                return .lhsContainsRhs(
                    lhsStart: lhsPeriod(rhsStart), lhsEnd: lhsPeriod(rhsEnd)
                )
            }

            // lhs:   •----•
            // rhs:  •------•
            if rhsContains(lhsStart) && rhsContains(lhsEnd) {
                return .rhsContainsLhs(
                    rhsStart: rhsPeriod(lhsStart), rhsEnd: rhsPeriod(lhsEnd)
                )
            }

            // lhs:  •----•
            // rhs:    •----•
            if lhsContains(rhsStart) && rhsContains(lhsEnd) {
                return .rhsContainsLhsEnd(
                    lhsEnd: lhsPeriod(rhsStart), rhsStart: rhsPeriod(lhsEnd)
                )
            }

            // lhs:    •----•
            // rhs:  •----•
            if rhsContains(lhsStart) && lhsContains(rhsEnd) {
                return .rhsContainsLhsStart(
                    rhsStart: rhsPeriod(lhsStart), lhsEnd: lhsPeriod(rhsEnd)
                )
            }

            // lhs:  •------•
            // rhs:  •----•
            if lhsStartCoincident && lhsContains(rhsEnd) {
                return .rhsPrefixesLhs(
                    lhsEnd: lhsPeriod(rhsEnd)
                )
            }

            // lhs:  •----•
            // rhs:  •------•
            if lhsStartCoincident && rhsContains(lhsEnd) {
                return .lhsPrefixesRhs(
                    rhsEnd: rhsPeriod(lhsEnd)
                )
            }

            // lhs:  •------•
            // rhs:    •----•
            if lhsEndCoincident && lhsContains(rhsStart) {
                return .rhsSuffixesLhs(
                    lhsStart: lhsPeriod(rhsStart)
                )
            }

            // lhs:    •----•
            // rhs:  •------•
            if lhsEndCoincident && rhsContains(lhsEnd) {
                return .lhsSuffixesRhs(
                    rhsStart: rhsPeriod(lhsEnd)
                )
            }

            return .notCoincident
        }

        @inlinable
        public func materialize(
            startPeriod: Period,
            endPeriod: Period
        ) -> Parametric2GeometrySimplex<Vector> {
            switch kind {
            case .line:
                return .lineSegment2(
                    .init(
                        lineSegment: .init(
                            start: start.location,
                            end: end.location
                        ),
                        startPeriod: startPeriod,
                        endPeriod: endPeriod
                    )
                )

            case .circleArc(let center, let radius, let startAngle, let sweepAngle):
                let arc = CircleArc2(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    sweepAngle: sweepAngle
                )

                return .circleArc2(
                    .init(
                        circleArc: arc,
                        startPeriod: startPeriod,
                        endPeriod: endPeriod
                    )
                )
            }
        }

        /// Materializes the underlying primitive for this edge that is devoid
        /// of period information.
        @inlinable
        func materializePrimitive() -> Primitive {
            switch kind {
            case .line:
                let lineSegment = LineSegment2(
                    start: start.location,
                    end: end.location
                )

                return .lineSegment2(lineSegment)

            case .circleArc(let center, let radius, let startAngle, let sweepAngle):
                let arc = CircleArc2(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    sweepAngle: sweepAngle
                )

                return .circleArc2(arc)
            }
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }

        public static func == (lhs: Edge, rhs: Edge) -> Bool {
            lhs === rhs
        }

        public enum Kind: Equatable, CustomStringConvertible {
            /// A straight line edge.
            case line

            /// A circular arc edge, with a center point, radius, and start+sweep
            /// angles.
            case circleArc(
                center: Vector,
                radius: Vector.Scalar,
                startAngle: Angle<Vector.Scalar>,
                sweepAngle: Angle<Vector.Scalar>
            )

            public var description: String {
                switch self {
                case .line:
                    return ".line"

                case .circleArc(let center, let radius, let startAngle, let sweepAngle):
                    return ".circleArc(center: \(center), radius: \(radius), startAngle: \(startAngle), sweepAngle: \(sweepAngle))"
                }
            }
        }

        public enum Primitive {
            case lineSegment2(LineSegment2<Vector>)
            case circleArc2(CircleArc2<Vector>)

            @inlinable
            var lengthSquared: Scalar {
                switch self {
                case .lineSegment2(let primitive):
                    return primitive.lengthSquared

                case .circleArc2(let primitive):
                    let arcLength = primitive.arcLength
                    return arcLength * arcLength
                }
            }

            @inlinable
            var bounds: AABB<Vector> {
                switch self {
                case .lineSegment2(let primitive):
                    return primitive.bounds

                case .circleArc2(let primitive):
                    return primitive.bounds()
                }
            }

            @inlinable
            var centerPoint: Vector {
                ratioPoint(1 / 2)
            }

            @inlinable
            func ratioPoint(_ ratio: Scalar) -> Vector {
                switch self {
                case .lineSegment2(let primitive):
                    return primitive.projectedNormalizedMagnitude(ratio)

                case .circleArc2(let primitive):
                    return primitive.pointOnAngle(
                        primitive.startAngle + primitive.sweepAngle * ratio
                    )
                }
            }
        }

        public struct SharedGeometryEntry: Equatable, CustomStringConvertible {
            public var shapeIndex: Int
            public var startPeriod: Period
            public var endPeriod: Period

            @inlinable
            public var periodRange: Range<Period> {
                startPeriod..<endPeriod
            }

            public var description: String {
                "\(type(of: self))(shapeIndex: \(shapeIndex), startPeriod: \(startPeriod), endPeriod: \(endPeriod))"
            }

            @usableFromInline
            internal init(
                shapeIndex: Int,
                startPeriod: Period,
                endPeriod: Period
            ) {
                self.shapeIndex = shapeIndex
                self.startPeriod = startPeriod
                self.endPeriod = endPeriod
            }

            @inlinable
            func contains(period: Period) -> Bool {
                periodRange.contains(period)
            }
        }

        /// A coincidence relationship between two edges that are coincident.
        ///
        /// The relationship between start/end nodes is relative to the receiver
        /// of the coincidence check call, e.g. 'lhs prefixing rhs' means that
        /// the incoming edge coincides with the receiver's start point, and its
        /// other point is contained within the receiver's span in space.
        public enum CoincidenceRelationship: Hashable {
            /// Edges are not coincident.
            case notCoincident

            /// Both edges span the same points in space.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:   •----•
            /// rhs:   •----•
            /// ```
            case sameSpan

            /// The receiver of the coincidence call contains the incoming edge
            /// parameter within its two points.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:  •------•
            /// rhs:   •----•
            /// ```
            case lhsContainsRhs(lhsStart: [PeriodEntry], lhsEnd: [PeriodEntry])

            /// The incoming edge parameter contains the receiver of the coincidence
            /// call within its two points.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:   •----•
            /// rhs:  •------•
            /// ```
            case rhsContainsLhs(rhsStart: [PeriodEntry], rhsEnd: [PeriodEntry])

            /// The receiver of the coincidence call overlaps the incoming edge
            /// parameter, prefixing it exactly at one point in space.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:  •----•
            /// rhs:  •------•
            /// ```
            case lhsPrefixesRhs(rhsEnd: [PeriodEntry])

            /// The incoming edge parameter overlaps the receiver of the coincidence
            /// call, prefixing it exactly at one point in space.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:  •------•
            /// rhs:  •----•
            /// ```
            case rhsPrefixesLhs(lhsEnd: [PeriodEntry])

            /// The receiver of the coincidence call overlaps the incoming edge
            /// parameter, suffixing it exactly at one point in space.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:    •----•
            /// rhs:  •------•
            /// ```
            case lhsSuffixesRhs(rhsStart: [PeriodEntry])

            /// The incoming edge parameter overlaps the receiver of the coincidence
            /// call, suffixing it exactly at one point in space.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:  •------•
            /// rhs:    •----•
            /// ```
            case rhsSuffixesLhs(lhsStart: [PeriodEntry])

            /// The incoming edge parameter overlaps the start point of the receiver
            /// of the coincidence call.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:    •----•
            /// rhs:  •----•
            /// ```
            case rhsContainsLhsStart(rhsStart: [PeriodEntry], lhsEnd: [PeriodEntry])

            /// The incoming edge parameter overlaps the end point of the receiver
            /// of the coincidence call.
            ///
            /// Represented by the visualization:
            /// ```
            /// lhs:  •----•
            /// rhs:    •----•
            /// ```
            case rhsContainsLhsEnd(lhsEnd: [PeriodEntry], rhsStart: [PeriodEntry])

            public struct PeriodEntry: Hashable {
                public let shapeIndex: Int
                public let period: Period
            }
        }
    }

    struct InternalGraph: MutableDirectedGraphType {
        var nodes: OrderedSet<Node>
        var edges: OrderedSet<Edge>

        init() {
            nodes = []
            edges = []
        }

        mutating func addNode(_ node: Node) {
            nodes.append(node)
        }

        mutating func removeNode(_ node: Node) {
            nodes.remove(node)
        }

        mutating func addEdge(_ edge: Edge) -> Edge {
            edges.append(edge)
            return edge
        }

        mutating func removeEdge(_ edge: Edge) {
            edges.remove(edge)
        }
    }
}

extension Simplex2Graph: DirectedGraphType {
    public func startNode(for edge: Edge) -> Node {
        edge.start
    }

    public func endNode(for edge: Edge) -> Node {
        edge.end
    }

    public func edges(from node: Node) -> [Edge] {
        graph.edges(from: node)
    }

    public func edges(towards node: Node) -> [Edge] {
        graph.edges(towards: node)
    }

    public func edges(from start: Node, to end: Node) -> [Edge] {
        graph.edges(from: start, to: end)
    }

    public func indegree(of node: Node) -> Int {
        graph.indegree(of: node)
    }

    public func outdegree(of node: Node) -> Int {
        graph.outdegree(of: node)
    }
}

extension Simplex2Graph: MutableDirectedGraphType {
    public mutating func addNode(_ node: Node) {
        guard !graph.containsNode(node) else {
            return
        }

        nodeTree.insert(node)

        graph.addNode(node)
    }

    public mutating func removeNode(_ node: Node) {
        let relatedEdges = allEdges(for: node)

        for edge in relatedEdges {
            edgeTree.remove(edge)
        }

        nodeTree.remove(node)

        graph.removeNode(node)
    }

    @discardableResult
    public mutating func addEdge(_ edge: Edge) -> Edge {
        guard !graph.containsEdge(edge) else {
            return edge
        }

        edgeTree.insert(edge)

        return graph.addEdge(edge)
    }

    public mutating func removeEdge(_ edge: Edge) {
        edgeTree.remove(edge)

        graph.removeEdge(edge)
    }

    public mutating func removeNodes(_ nodes: some Sequence<Node>) {
        let relatedEdges = nodes.flatMap({ allEdges(for: $0) })

        for edge in relatedEdges {
            edgeTree.remove(edge)
        }
        for node in nodes {
            nodeTree.remove(node)
        }

        graph.removeNodes(nodes)
    }

    public mutating func removeEdges(_ edgesToRemove: some Sequence<Edge>) {
        let edgesToRemove = Array(edgesToRemove)

        for edge in edgesToRemove {
            edgeTree.remove(edge)
        }

        graph.removeEdges(edgesToRemove)
    }
}

extension Simplex2Graph.Node: KDTreeLocatable { }
extension Simplex2Graph.Edge: BoundableType { }
