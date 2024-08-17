import Geometria

extension MersenneTwister {
    func randomScalar(range: ClosedRange<Double>) -> Double {
        var random = self

        return Double.random(in: range, using: &random)
    }

    func randomVectors(count: Int, _ scalarGen: (MersenneTwister) -> Double) -> [Vector2D] {
        return (0..<count).map { _ in
            return .init(x: scalarGen(self), y: scalarGen(self))
        }
    }
}
