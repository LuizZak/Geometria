import Geometria

/// A Union boolean parametric that joins two shapes into a single shape, if they
/// intersect in space.
public struct Union2Parametric<T1: ParametricClip2Geometry, T2: ParametricClip2Geometry>: Boolean2Parametric
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
        #if false

        typealias Graph = Simplex2Graph<Vector>

        func materialize(
            _ edge: Graph.Edge,
            from start: Graph.Node,
            to end: Graph.Node
        ) -> Parametric2GeometrySimplex<Vector> {
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

            case .circleArc(let center, let sweep):
                var arc: CircleArc2 = .init(
                    startPoint: startPoint,
                    endPoint: endPoint,
                    sweepAngle: sweep
                )
                // Re-adjust center
                arc.center = center

                return .circleArc2(
                    .init(
                        circleArc: arc,
                        startPeriod: .zero,
                        endPeriod: .zero
                    )
                )
            }
        }

        let intersections = lhs
            .allIntersectionPeriods(rhs, tolerance: tolerance)
            .flatMap(\.periods)
        let graph = Graph.fromParametricIntersections(
            lhs,
            rhs,
            intersections: intersections
        )

        if !graph.hasIntersections() {
            let lookup: IntersectionLookup<T1, T2> = .init(
                selfShape: lhs,
                otherShape: rhs,
                intersections: intersections
            )

            if lookup.isOtherWithinSelf() {
                return [lhs.allSimplexes()]
            }
            if lookup.isSelfWithinOther() {
                return [rhs.allSimplexes()]
            }

            return [lhs.allSimplexes(), rhs.allSimplexes()]
        }

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
        var isOnLhs = false

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

        typealias State = GeometriaClipping.State<T1, T2>

        let lookup: IntersectionLookup<T1, T2> = .init(
            intersectionsOfSelfShape: lhs,
            otherShape: rhs,
            tolerance: tolerance
        )

        // If no intersections have been found, check if one of the shapes is
        // contained within the other
        guard !lookup.intersections.isEmpty else {
            if lookup.isOtherWithinSelf() {
                return [lhs.allSimplexes()]
            }
            if lookup.isSelfWithinOther() {
                return [rhs.allSimplexes()]
            }

            return [lhs.allSimplexes(), rhs.allSimplexes()]
        }

        var resultOverall: [[Simplex]] = []
        var simplexVisited: Set<State> = []
        var visitedOverall: Set<State> = []

        var state = State.onLhs(lhs.startPeriod, rhs.startPeriod)
        if lookup.isInsideOther(selfPeriod: state.lhsPeriod) {
            state = lookup.next(state)
        } else {
            state = lookup.previous(state)
        }

        while visitedOverall.insert(state).inserted {
            if !simplexVisited.contains(state) {
                var result: [Simplex] = []
                var visited: Set<State> = []

                while visited.insert(state).inserted {
                    // Find next intersection
                    let next = lookup.next(state)

                    // Append simplex
                    let simplex = lookup.clampedSimplexesRange(state, next)
                    result.append(contentsOf: simplex)

                    // Flip to the next intersection
                    state = next.flipped()
                }

                simplexVisited.formUnion(visited)

                // Re-normalize the simplex periods
                result = result.normalized(startPeriod: .zero, endPeriod: 1)
                resultOverall.append(result)
            }

            // Here we skip twice in order to skip the portion of lhs that is
            // occluded behind rhs, and land on the next intersection that brings
            // lhs inside rhs
            state = lookup.next(lookup.next(state))
        }

        return resultOverall

        #endif
    }
}
