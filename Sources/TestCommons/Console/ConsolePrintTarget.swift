/// Encapsulates a target for `print()` requests to the terminal
public protocol ConsolePrintTarget {
    /// Whether this print target supports printing of colors through ASCII
    /// control characters
    var supportsTerminalColors: Bool { get }

    func print(_ values: [Any], separator: String, terminator: String)
}

extension ConsolePrintTarget {
    public func print(_ values: Any..., separator: String = " ") {
        print(values, separator: separator, terminator: "\n")
    }
}
