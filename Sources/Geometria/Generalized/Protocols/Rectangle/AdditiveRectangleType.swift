import Foundation

/// Protocol refining ``RectangleType`` with ``VectorAdditive`` extensions.
public protocol AdditiveRectangleType: RectangleType where Vector: VectorAdditive {
    /// Returns a copy of this rectangle with its location offset by a given
    /// Vector amount.
    func offsetBy(_ vector: Vector) -> Self
    
    /// Returns a copy of this rectangle with its size increased by a given
    /// Vector amount.
    func resizedBy(_ vector: Vector) -> Self

    /// Returns a list of vertices corresponding to the extremes of this rectangle.
    ///
    /// - precondition: Currently limited to vectors with < 64 scalars.
    ///
    /// Order of vertices in the result is not defined.
    var vertices: [Vector] { get }
}

extension AdditiveRectangleType {
    /// Returns a list of vertices corresponding to the extremes of this rectangle.
    ///
    /// Order of vertices in the result is not defined.
    ///
    /// - precondition: Currently limited to vectors with < 64 scalars.
    @inlinable
    public var vertices: [Vector] {
        assert(location.scalarCount == size.scalarCount)

        let count = location.scalarCount

        let min = location
        let max = location + size

        var result: [Vector] = []

        // Bit mask toggle for each scalar in the two vectors.
        var toggle: UInt = 0
        let maxToggle: UInt = UInt(1 << count)

        repeat {
            defer { toggle += 1 }

            var vec = min

            for i in 0..<count {
                let bitIndex = i
                let bit = (toggle >> bitIndex) & 1
                if bit == 1 {
                    vec[i] = max[i]
                }
            }

            result.append(vec)
        } while toggle < maxToggle

        return result
    }
}

public extension AdditiveRectangleType where Self: ConstructableRectangleType {
    /// Returns a copy of this rectangle with its location offset by a given
    /// Vector amount.
    ///
    /// ```swift
    /// let rect = Rectangle2D(x: 20, y: 30, width: 50, height: 50)
    ///
    /// let result = rect.offsetBy(.init(x: 5, y: 10))
    ///
    /// print(result) // Prints "(location: (x: 25, y: 40), size: (width: 50, height: 50))"
    /// ```
    @_transparent
    func offsetBy(_ vector: Vector) -> Self {
        Self(location: location + vector, size: size)
    }
    
    /// Returns a copy of this rectangle with its size increased by a given
    /// Vector amount.
    ///
    /// ```swift
    /// let rect = Rectangle2D(x: 20, y: 30, width: 50, height: 50)
    ///
    /// let result = rect.resizedBy(.init(x: 10, y: 20))
    ///
    /// print(result) // Prints "(location: (x: 20, y: 30), size: (width: 60, height: 70))"
    /// ```
    @_transparent
    func resizedBy(_ vector: Vector) -> Self {
        Self(location: location, size: size + vector)
    }
}
