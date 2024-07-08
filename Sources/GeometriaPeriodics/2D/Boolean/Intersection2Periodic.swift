/// A Union boolean periodic that joins two shapes into a single shape, if they
/// intersect in space.
public struct Intersection2Periodic<T1: Periodic2Geometry, T2: Periodic2Geometry>: Boolean2Periodic
    where T1.Vector == T2.Vector, T1.Vector: Hashable
{
    public let lhs: T1, rhs: T2
    public let tolerance: Scalar

    public init(_ lhs: T1, _ rhs: T2, tolerance: T1.Scalar) where T1.Vector == T2.Vector {
        self.lhs = lhs
        self.rhs = rhs
        self.tolerance = tolerance
    }

    public func allSimplexes() -> [[Simplex]] {
        typealias Graph = Simplex2Graph<Vector>

        #if false

        func materialize(
            _ edge: Graph.Edge,
            from start: Graph.Node,
            to end: Graph.Node
        ) -> Periodic2GeometrySimplex<Vector> {
            let startPoint = start.point
            let endPoint = end.point

            switch edge.kind {
            case .line:
                return .lineSegment2(
                    .init(
                        lineSegment: .init(start: startPoint, end: endPoint),
                        startPeriod: .zero,
                        endPeriod: .zero
                    )
                )

            case .circleArc(_, let sweep):
                return .circleArc2(
                    .init(
                        circleArc: .init(
                            startPoint: startPoint,
                            endPoint: endPoint,
                            sweepAngle: sweep
                        ),
                        startPeriod: .zero,
                        endPeriod: .zero
                    )
                )
            }
        }

        let graph = Graph.fromPeriodicIntersections(
            lhs,
            rhs,
            intersections: lhs.allIntersectionPeriods(rhs, tolerance: tolerance)
        )

        let start = lhs.compute(at: lhs.startPeriod)
        guard let startNode = graph.nodes.first(where: { $0.point == start }) else {
            return []
        }
        var current = startNode
        if rhs.contains(current.point) {
            current = graph.firstIntersection(after: current) ?? current
        } else {
            current = graph.firstIntersection(before: current) ?? current
        }

        var result: [Simplex] = []

        var visited: Set<Graph.Node> = []
        var isOnLhs = true

        while visited.insert(current).inserted {
            let edges = graph.edges(from: current).filter { edge -> Bool in
                let node = graph.endNode(for: edge)
                return node.isIntersection || node.onLhs == isOnLhs
            }

            guard let shortest = edges.min(by: { $0.lengthSquared < $1.lengthSquared }) else {
                // Found non-periodic geometry?
                continue
            }
            let next = graph.endNode(for: shortest)

            let simplex = materialize(shortest, from: current, to: next)

            result.append(simplex)

            if next.isIntersection {
                isOnLhs = !isOnLhs
            }

            current = next
        }

        // Re-normalize the simplex periods
        result = result.normalized(startPeriod: .zero, endPeriod: 1)

        return [result]

        #else

        let lookup: IntersectionLookup<T1, T2> = .init(
            intersectionsOfSelfShape: lhs,
            otherShape: rhs,
            tolerance: tolerance
        )

        // If no intersections have been found, check if one of the shapes is
        // contained within the other
        guard !lookup.intersections.isEmpty else {
            if lookup.isSelfWithinOther() {
                return [rhs.allSimplexes()]
            }
            if lookup.isOtherWithinSelf() {
                return [lhs.allSimplexes()]
            }

            return []
        }

        var state = State.onLhs(lhs.startPeriod, rhs.startPeriod)
        if lookup.isInsideOther(selfPeriod: state.lhsPeriod) {
            state = lookup.next(state).flipped()
        } else {
            state = lookup.previous(state).flipped()
        }

        var result: [Simplex] = []
        var visited: Set<State> = []

        while visited.insert(state).inserted {
            let next = lookup.next(state)

            // Append simplex
            let simplex = lookup.clampedSimplexesRange(state, next)
            result.append(contentsOf: simplex)

            state = next.flipped()
        }

        // Re-normalize the simplex periods
        result = result.normalized(startPeriod: .zero, endPeriod: 1)

        return [result]

        #endif
    }

    enum State: Hashable {
        case onLhs(T1.Period, T2.Period)
        case onRhs(T1.Period, T2.Period)

        var isLhs: Bool {
            switch self {
            case .onLhs: return true
            case .onRhs: return false
            }
        }

        var isRhs: Bool {
            switch self {
            case .onLhs: return false
            case .onRhs: return true
            }
        }

        var activePeriod: Period {
            switch self {
            case .onLhs(let period, _),
                .onRhs(_, let period):
                return period
            }
        }

        var lhsPeriod: T1.Period {
            switch self {
            case .onLhs(let lhs, _), .onRhs(let lhs, _):
                return lhs
            }
        }

        var rhsPeriod: T1.Period {
            switch self {
            case .onLhs(_, let rhs), .onRhs(_, let rhs):
                return rhs
            }
        }

        func flipped() -> Self {
            switch self {
            case .onLhs(let lhs, let rhs):
                return .onRhs(lhs, rhs)

            case .onRhs(let lhs, let rhs):
                return .onLhs(lhs, rhs)
            }
        }

        func hash(into hasher: inout Hasher) {
            switch self {
            case .onLhs(let value, _):
                hasher.combine(0)
                hasher.combine(value)

            case .onRhs(_, let value):
                hasher.combine(1)
                hasher.combine(value)
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs.isLhs, rhs.isLhs) {
            case (true, true):
                return lhs.lhsPeriod == rhs.lhsPeriod

            case (false, false):
                return lhs.rhsPeriod == rhs.rhsPeriod

            default:
                return false
            }
        }
    }
}

fileprivate extension IntersectionLookup where T1.Vector: Hashable {
    typealias State = Intersection2Periodic<T1, T2>.State

    func clampedSimplexesRange(
        _ start: State,
        _ end: State
    ) -> [T1.Simplex] {

        switch start {
        case .onLhs(let lhsPeriod, _):
            // If start > end, clamp as two ranges that cross the origin instead
            if lhsPeriod > end.lhsPeriod {
                return selfShape.clampedSimplexes(in: lhsPeriod..<selfShape.endPeriod)
                    + selfShape.clampedSimplexes(in: selfShape.startPeriod..<end.lhsPeriod)
            }

            return selfShape.clampedSimplexes(in: lhsPeriod..<end.lhsPeriod)

        case .onRhs(_, let rhsPeriod):
            // Ditto here
            if rhsPeriod > end.rhsPeriod {
                return otherShape.clampedSimplexes(in: rhsPeriod..<otherShape.endPeriod)
                    + otherShape.clampedSimplexes(in: otherShape.startPeriod..<end.rhsPeriod)
            }

            return otherShape.clampedSimplexes(in: rhsPeriod..<end.rhsPeriod)
        }
    }

    func periodPrecedes(from start: State, _ lhs: State, _ rhs: State) -> Bool {
        switch (start, lhs, rhs) {
        case (.onLhs(let start, _), .onLhs(let lhs, _), .onLhs(let rhs, _)):
            return selfShape.periodPrecedes(from: start, lhs, rhs)

        case (.onLhs(_, let start), .onRhs(_, let lhs), .onRhs(_, let rhs)):
            return otherShape.periodPrecedes(from: start, lhs, rhs)

        default:
            return false
        }
    }

    /// - note: Calling `flip` with the result of this method may lead to the
    /// incorrect period on the flipped state; calling `next(state)` collapses
    /// the invalid secondary period back to a valid period that can be flipped
    /// to again.
    func nextSimplexEnd(_ state: State) -> State {
        switch state {
        case .onLhs(let lhs, let rhs):
            guard let simplex = nextSimplexEnd(onSelf: lhs) else {
                return state
            }

            return .onLhs(simplex.endPeriod, rhs)

        case .onRhs(let lhs, let rhs):
            guard let simplex = nextSimplexEnd(onOther: rhs) else {
                return state
            }

            return .onRhs(lhs, simplex.endPeriod)
        }
    }

    func next(_ state: State) -> State {
        switch state {
        case .onLhs(let lhs, _):
            guard let intersection = next(onSelf: lhs) else {
                return state
            }

            return .onLhs(intersection.`self`, intersection.other)

        case .onRhs(_, let rhs):
            guard let intersection = next(onOther: rhs) else {
                return state
            }

            return .onRhs(intersection.`self`, intersection.other)
        }
    }

    func previous(_ state: State) -> State {
        switch state {
        case .onLhs(let lhs, _):
            guard let intersection = previous(onSelf: lhs) else {
                return state
            }

            return .onLhs(intersection.`self`, intersection.other)

        case .onRhs(_, let rhs):
            guard let intersection = previous(onOther: rhs) else {
                return state
            }

            return .onRhs(intersection.`self`, intersection.other)
        }
    }
}
