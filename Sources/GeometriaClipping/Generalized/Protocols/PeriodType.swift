import Geometria

/// Type for periods that can be used to refer to sections of simplexes of periodic
/// geometry.
public protocol PeriodType: FloatingPoint {
}

extension Float: PeriodType { }
extension Double: PeriodType { }

#if (arch(i386) || arch(x86_64)) && !os(Windows) && !os(Android)
extension Float80: PeriodType { }
#endif
