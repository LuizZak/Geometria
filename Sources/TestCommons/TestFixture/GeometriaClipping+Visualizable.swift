import MiniP5Printer
import Geometria
import GeometriaClipping

extension LinePolygon2Parametric: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Circle2Parametric: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Compound2Parametric: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Parametric2GeometrySimplex: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Parametric2Contour: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self, style: style, file: file, line: line)
    }
}

extension Union2Parametric: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self.lhs, style: style, file: file, line: line)
        printer.add(self.rhs, style: style, file: file, line: line)
    }
}

extension Intersection2Parametric: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self.lhs, style: style, file: file, line: line)
        printer.add(self.rhs, style: style, file: file, line: line)
    }
}

extension Subtraction2Parametric: VisualizableGeometricType2 where Vector.Scalar: CustomStringConvertible {
    public func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?, file: StaticString = #file, line: UInt = #line) {
        printer.add(self.lhs, style: style, file: file, line: line)
        printer.add(self.rhs, style: style, file: file, line: line)
    }
}
