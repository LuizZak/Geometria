import Geometria

/// A 2-dimensional periodic geometry that produces lines and circular arcs as
/// periodic simplexes.
public protocol Periodic2Geometry: PeriodicGeometry {
    /// The type of period that this periodic geometry uses to refer to its
    /// ordered simplexes.
    associatedtype Period: PeriodType

    /// The inclusive lower bound period within this geometry.
    var startPeriod: Period { get }

    /// The exclusive upper bound period within this geometry.
    ///
    /// This value is not part of the addressable period range.
    var endPeriod: Period { get }
}
