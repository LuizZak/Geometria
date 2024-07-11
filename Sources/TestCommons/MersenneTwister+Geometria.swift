import Geometria

public extension MersenneTwister {
    /// Generates a random scalar within a given range.
    func randomScalar<Scalar: FixedWidthInteger>(range: ClosedRange<Scalar>) -> Scalar {
        var s = self
        return Scalar.random(in: range, using: &s)
    }

    /// Generates a random scalar within a given range.
    func randomScalar<Scalar: BinaryFloatingPoint>(range: ClosedRange<Scalar>) -> Scalar where Scalar.RawSignificand: FixedWidthInteger {
        var s = self
        return Scalar.random(in: range, using: &s)
    }

    /// Generates a random vector using the given random scalar sampler.
    func randomVector<Vector: VectorAdditive>(
        _ randomScalar: (MersenneTwister) -> Vector.Scalar
    ) -> Vector {
        var base = Vector.zero
        for i in 0..<base.scalarCount {
            base[i] = randomScalar(self)
        }
        return base
    }

    /// Generates a sample of random vectors using the given random scalar sampler.
    func randomVectors<Vector: VectorAdditive>(
        count: Int,
        _ randomScalar: (MersenneTwister) -> Vector.Scalar
    ) -> [Vector] {
        (0..<count).map { _ in
            self.randomVector(randomScalar)
        }
    }
}
