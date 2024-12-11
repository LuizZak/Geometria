import Geometria
import GeometriaClipping
import MiniGraphviz

extension GraphViz {
    static func printGraph<Vector>(_ graph: Simplex2Graph<Vector>) where Vector.Scalar: CustomStringConvertible {
        let nodes = graph.nodes
        let edges = graph.edges

        let graph = GraphViz()

        for node in nodes {
            graph.createNode(label: "\(node.id)")
        }

        for edge in edges {
            let label: String
            switch edge.kind {
            case .line:
                label = "line"
            case .circleArc(_, _, _, let sweepAngle):
                label = "arc (\(sweepAngle.degrees)°)"
            }
            graph.addConnection(fromLabel: "\(edge.start.id)", toLabel: "\(edge.end.id)", label: label)
        }

        print(graph.generateFile())
    }
}
