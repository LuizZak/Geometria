/// Prints output to the current standard output
public class StandardOutputConsolePrintTarget: ConsolePrintTarget {
    public let supportsTerminalColors = true

    public func print(_ values: [Any], separator: String, terminator: String) {
        let total = values.map { String(describing: $0) }.joined(separator: separator)

        Swift.print(total, terminator: terminator)
    }
}
