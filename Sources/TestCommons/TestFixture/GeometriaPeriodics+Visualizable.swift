import MiniP5Printer
import Geometria
import GeometriaPeriodics

extension LinePolygon2Periodic: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Circle2Periodic: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Compound2Periodic: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Periodic2GeometrySimplex: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Union2Periodic: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self.lhs, style: style, file: file, line: line)
        printer.add(self.rhs, style: style, file: file, line: line)
    }
}

extension Intersection2Periodic: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self.lhs, style: style, file: file, line: line)
        printer.add(self.rhs, style: style, file: file, line: line)
    }
}

extension Subtraction2Periodic: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self.lhs, style: style, file: file, line: line)
        printer.add(self.rhs, style: style, file: file, line: line)
    }
}
