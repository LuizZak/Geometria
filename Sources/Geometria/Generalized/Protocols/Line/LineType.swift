/// Protocol for objects that form geometric lines with at least two distinct
/// points the line is guaranteed to cross.
public protocol LineType: GeometricType {
    /// The vector type associated with this `LineType`.
    associatedtype Vector: VectorType
    
    /// Gets the first point that defines the line of this `LineType`.
    ///
    /// This point is always guaranteed to be colinear and part of the line limits.
    /// For lines with a closed start (`!self.category.category.isOpenStart`),
    /// `a` is the limit of the start of this line, i.e. for any other point `c`
    /// within this line, `self.a < c`.
    ///
    /// If `self.a == self.b`, the line is considered to be [degenerate].
    ///
    /// [degenerate]: https://en.wikipedia.org/wiki/Degeneracy_(mathematics)
    var a: Vector { get }
    
    /// Gets the second point that defines the line of this `LineType`.
    ///
    /// This point is always guaranteed to be colinear and part of the line limits.
    /// For lines with a closed end (`!self.category.category.isOpenEnd`),
    /// `b` is the limit of the end of this line, i.e. for any other point `c`
    /// within this line, `self.b > c`.
    ///
    /// If `self.a == self.b`, the line is considered to be [degenerate].
    ///
    /// [degenerate]: https://en.wikipedia.org/wiki/Degeneracy_(mathematics)
    var b: Vector { get }

    /// Gets the category for this `LineType`, specifying whether the end points
    /// of the line are open or closed.
    var category: LineCategory { get }
}
