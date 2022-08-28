/// Represents the category for a `LineType`, specifying whether the end points
/// of the line are open or closed.
public struct LineCategory: RawRepresentable, Hashable {
    private static let startOpenBit = 0b0000_0001
    private static let endOpenBit = 0b0000_0010

    public var rawValue: Int

    /// Returns whether the start of this line category is open, i.e. it extends
    /// towards infinity past `b -> a`.
    public var isOpenStart: Bool {
        return rawValue & Self.startOpenBit == Self.startOpenBit
    }

    /// Returns whether the end of this line category is open, i.e. it extends
    /// towards infinity past `a -> b`.
    public var isOpenEnd: Bool {
        return rawValue & Self.endOpenBit == Self.endOpenBit
    }

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension LineCategory {
    /// Category for a [geometric line] that define an infinite line.
    ///
    /// [geometric line]: https://en.wikipedia.org/wiki/Line_(geometry)
    static let line: Self = Self(rawValue: startOpenBit | endOpenBit)

    /// Category for a [geometric ray] line which has a starting
    /// point and crosses a secondary point before projecting to infinity.
    ///
    /// [geometric ray]: https://en.wikipedia.org/wiki/Line_(geometry)#Ray
    static let ray: Self = Self(rawValue: endOpenBit)
    
    /// Category for a [line segment] that define a closed interval with a start
    /// and end point.
    ///
    /// [line segment]: https://en.wikipedia.org/wiki/Line_segment
    static let lineSegment: Self = Self(rawValue: 0b0000_0000)
}
