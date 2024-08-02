/// Console print target that stores print requests into a string buffer that can
/// later be manipulated in-memory.
public class StringBufferConsolePrintTarget: ConsolePrintTarget {
    public var supportsTerminalColors: Bool

    public var buffer: String = ""

    public init(supportsTerminalColors: Bool = false) {
        self.supportsTerminalColors = supportsTerminalColors
    }

    public func print(_ values: [Any], separator: String, terminator: String) {
        let total = values.map { String(describing: $0) }.joined(separator: separator)

        Swift.print(total, terminator: terminator, to: &buffer)
    }
}
