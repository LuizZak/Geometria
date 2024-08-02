import Foundation

/// Helper for printing grids and other 2D shapes made of ASCII characters to the
/// console using ASCII text.
open class ConsolePrintBuffer {
    public var target: ConsolePrintTarget

    private var buffer: [ConsoleCharacter] = []

    /// Used when diffing print
    private var lastPrintBuffer: String?
    private var _storingDiff = false

    /// - note: Counts the line-feed at the end of a line.
    public let bufferWidth: Int
    public let bufferHeight: Int

    /// Whether to highlight colors of changed areas diff-style (red for removed
    /// text, green for added text, and white for unchanged)
    public var diffingPrint = false

    /// Whether to allow colors in the output string.
    public var colorized: Bool = true

    public init(target: ConsolePrintTarget, bufferWidth: Int, bufferHeight: Int) {
        self.target = target
        self.bufferWidth = bufferWidth
        self.bufferHeight = bufferHeight

        // Initialize buffer string
        resetBuffer()
    }

    public init(bufferWidth: Int, bufferHeight: Int) {
        self.target = StandardOutputConsolePrintTarget()
        self.bufferWidth = bufferWidth
        self.bufferHeight = bufferHeight

        // Initialize buffer string
        resetBuffer()
    }

    public func resetBuffer() {
        let line = Array(
            repeating: ConsoleCharacter(character: " " as Character),
            count: bufferWidth - 1
        )

        buffer = Array(
            repeating: line + [ConsoleCharacter(character: "\n")],
            count: bufferHeight
        ).flatMap { $0 }
    }

    /// Removes any prior diff buffer so the next print is clean of diff checks
    public func resetDiffPrint() {
        lastPrintBuffer = nil
    }

    public func put(
        _ scalar: UnicodeScalar,
        color: ConsoleColor? = nil,
        x: Int,
        y: Int
    ) {

        var offset = y * bufferWidth + x

        // Out of buffer's reach
        if offset >= buffer.count - 2 {
            return
        }
        if offset < 0 {
            return
        }

        // Wrap-around (-2 to not eat the line-ending character at bufferWidth - 1)
        if offset % bufferWidth == (bufferWidth - 1) {
            offset += 1

            if offset >= buffer.count - 2 {
                return
            }
        }

        putChar(scalar, color: color, offset: offset)

        offset += 1
    }

    public func putString(_ string: String, color: ConsoleColor? = nil, x: Int, y: Int) {
        var offset = y * bufferWidth + x

        for c in string {
            // Out of buffer's reach
            if offset >= buffer.count - 2 {
                return
            }
            if offset < 0 {
                continue
            }

            // Wrap-around (- 2 to not eat the line-ending character at bufferWidth - 1)
            if offset % bufferWidth == (bufferWidth - 1) {
                offset += 1
                continue
            }

            putChar(c, color: color, offset: offset)

            offset += 1
        }
    }

    public func putChar(_ char: Character, color: ConsoleColor? = nil, x: Int, y: Int) {
        var offset = y * bufferWidth + x

        // Out of buffer's reach
        if offset > buffer.count - 2 {
            return
        }
        if offset < 0 {
            return
        }

        // Wrap-around (- 2 to not eat the line-ending character at bufferWidth - 1)
        if offset % bufferWidth == (bufferWidth - 1) {
            offset += 1

            if offset > buffer.count - 2 {
                return
            }
        }

        putChar(char, color: color, offset: offset)
    }

    private func putChar(_ char: Character, color: ConsoleColor?, offset: Int) {
        let index = buffer.index(buffer.startIndex, offsetBy: offset)

        buffer[index] = ConsoleCharacter(character: char, color: color)
    }

    private func putChar(_ char: UnicodeScalar, color: ConsoleColor?, offset: Int) {
        let index = buffer.index(buffer.startIndex, offsetBy: offset)

        buffer[index] = ConsoleCharacter(character: Character(char), color: color)
    }

    private func coordToOffset(_ x: Int, _ y: Int) -> Int {
        var offset = y * bufferWidth + x

        if offset % bufferWidth == (bufferWidth - 1) {
            offset += 1
        }

        return offset
    }

    private func get(_ x: Int, _ y: Int) -> Character {
        let offset = coordToOffset(x, y)

        if offset >= buffer.count - 2 {
            return " "
        }

        return buffer[offset].character
    }

    private func getColor(_ x: Int, _ y: Int) -> ConsoleColor? {
        let offset = coordToOffset(x, y)

        if offset >= buffer.count - 2 {
            return nil
        }

        return buffer[offset].color
    }

    public func fillRect(
        char: Character,
        color: ConsoleColor? = nil,
        x: Int,
        y: Int,
        w: Int,
        h: Int
    ) {

        for _y in y..<y + h {
            for _x in x..<x + w {
                putChar(char, x: _x, y: _y)
            }
        }
    }

    public func putRect(x: Int, y: Int, w: Int, h: Int, color: ConsoleColor? = nil) {
        putHorizontalLine("-", x: x, y: y, w: w)
        putHorizontalLine("-", x: x, y: y + h, w: w)

        putVerticalLine("|", x: x, y: y, h: h)
        putVerticalLine("|", x: x + w, y: y, h: h)
    }

    public func putHorizontalLine(
        _ char: UnicodeScalar,
        color: ConsoleColor? = nil,
        x: Int,
        y: Int,
        w: Int
    ) {

        for _x in x...x + w {
            put(char, color: color, x: _x, y: y)
        }
    }

    public func putVerticalLine(
        _ char: UnicodeScalar,
        color: ConsoleColor? = nil,
        x: Int,
        y: Int,
        h: Int
    ) {

        for _y in y...y + h {
            put(char, color: color, x: x, y: _y)
        }
    }

    private func calculateDiffPrint(old: String, new: String) -> String {
        // Debug means Xcode console. Xcode console means no ANSI color output!
        #if Xcode
            return new
        #else

            var outBuffer: [UnicodeScalar] = []

            // Use ScalarView as it's much faster to work with
            let oldScalars = old.unicodeScalars
            let newScalars = new.unicodeScalars

            outBuffer.reserveCapacity(max(oldScalars.count, newScalars.count))

            for (oldScalar, newScalar) in zip(oldScalars, newScalars) {
                if oldScalar == newScalar {
                    outBuffer.append(oldScalar)
                    continue
                }

                // Red when old != whitespace and new == whitespace
                if !CharacterSet.whitespacesAndNewlines.contains(oldScalar)
                    && CharacterSet.whitespacesAndNewlines.contains(newScalar)
                {
                    outBuffer.append(
                        contentsOf: ConsoleColor.red.terminalForeground.ansi.unicodeScalars
                    )
                    outBuffer.append(oldScalar)
                    outBuffer.append(contentsOf: UInt8(0).ansi.unicodeScalars)
                }

                // Green when new != whitespace
                if !CharacterSet.whitespacesAndNewlines.contains(newScalar) {
                    outBuffer.append(
                        contentsOf: ConsoleColor.green.terminalForeground.ansi.unicodeScalars
                    )
                    outBuffer.append(newScalar)
                    outBuffer.append(contentsOf: UInt8(0).ansi.unicodeScalars)
                }
            }

            return String(String.UnicodeScalarView(outBuffer))

        #endif
    }

    /// Any print call made to this console printer while inside this block will
    /// only modify the diff stored, and not print its contents to stdout.
    public func storingDiff(do block: () -> Void) {
        _storingDiff = true
        block()
        _storingDiff = false
    }

    public func print(trimming: Bool = true) {
        let newBuffer = getPrintBuffer(trimming: trimming)

        if !_storingDiff {
            // Calc diff
            if diffingPrint, let last = lastPrintBuffer {
                target.print(calculateDiffPrint(old: last, new: newBuffer))
            } else {
                target.print(newBuffer)
            }
        }

        if diffingPrint {
            lastPrintBuffer = newBuffer
        }
    }

    private func getPrintBuffer(trimming: Bool = true) -> String {
        if !trimming {
            return
                buffer
                .map { $0.string(colorized: colorized && target.supportsTerminalColors) }
                .joined()
        }

        var maxY = 0

        for i in (0..<bufferHeight).reversed() {
            let l = line(index: i)
            if l.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                maxY = i
                break
            }
        }

        if maxY == 0 {
            return ""
        }

        var acc = ""
        for i in 0...maxY {
            let l = line(index: i)

            // Trim trailing whitespace
            let endIndex =
                l.lastIndex {
                    $0.unicodeScalars.contains { scalar in
                        !CharacterSet.whitespaces.contains(scalar)
                    }
                }.map {
                    l.index(after: $0) // Include the index that was found
                }

            acc += l[..<(endIndex ?? l.endIndex)] + "\n"
        }
        return acc
    }

    private func line(index: Int) -> String {
        let offset = index * bufferWidth
        let offsetNext = (index + 1) * bufferWidth

        let offNext = offsetNext - 1

        return buffer[offset..<offNext]
            .map { $0.string(colorized: colorized && target.supportsTerminalColors) }
            .joined()
    }

    /// Joins dashes and vertical bars into box drawing ASCII chars
    public func joinBoxLines() {
        // Sides bitmap
        struct Sides: Hashable, OptionSet {
            var hashValue: Int {
                return rawValue
            }
            var rawValue: Int

            static let left = Sides(rawValue: 1 << 0)
            static let right = Sides(rawValue: 1 << 1)
            static let top = Sides(rawValue: 1 << 2)
            static let bottom = Sides(rawValue: 1 << 3)

            init(rawValue: Int) {
                self.rawValue = rawValue
            }
        }

        let substitutions: [Sides: Character] = [
            [.left]: "─",
            [.right]: "─",
            [.top]: "│",
            [.bottom]: "│",
            [.left, .right]: "─",
            [.top, .bottom]: "│",
            [.bottom, .right]: "╭",
            [.top, .right]: "╰",
            [.left, .bottom]: "╮",
            [.left, .top]: "╯",
            [.top, .right, .bottom]: "├",
            [.top, .left, .bottom]: "┤",
            [.left, .bottom, .right]: "┬",
            [.left, .top, .right]: "┴",
            [.left, .top, .right, .bottom]: "┼",
        ]

        let isGrid = (["-", "|"] + substitutions.values).contains

        for y in 0..<bufferHeight {
            for x in 0..<bufferWidth {

                if !isGrid(get(x, y)) {
                    continue
                }

                var sides: Sides = []

                if x > 0 {
                    if isGrid(get(x - 1, y)) {
                        sides.insert(.left)
                    }
                }
                if x < bufferWidth - 2 {
                    if isGrid(get(x + 1, y)) {
                        sides.insert(.right)
                    }
                }

                if y > 0 {
                    if isGrid(get(x, y - 1)) {
                        sides.insert(.top)
                    }
                }
                if y < bufferHeight - 1 {
                    if isGrid(get(x, y + 1)) {
                        sides.insert(.bottom)
                    }
                }

                if let str = substitutions[sides] {
                    let currentColor = getColor(x, y)

                    putChar(str, color: currentColor, x: x, y: y)
                }
            }
        }
    }

    private struct ConsoleCharacter {
        var character: Character
        var color: ConsoleColor?

        init(character: Character) {
            self.character = character
            color = nil
        }

        init(character: Character, color: ConsoleColor?) {
            self.character = character
            self.color = color
        }

        func string(colorized: Bool) -> String {
            if colorized, let color = color {
                return String(character).terminalColorize(color)
            }

            return String(character)
        }
    }
}
