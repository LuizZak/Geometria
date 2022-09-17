import Geometria

extension Vector2: VisualizableGeometricType where Scalar: Numeric & CustomStringConvertible {
    func addVisualization(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Vector3: VisualizableGeometricType where Scalar: Numeric & CustomStringConvertible {
    func addVisualization(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Line3: VisualizableGeometricType where Scalar: Numeric & CustomStringConvertible {
    func addVisualization(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension LineSegment3: VisualizableGeometricType where Scalar: Numeric & CustomStringConvertible {
    func addVisualization(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Ray3: VisualizableGeometricType where Vector: VectorAdditive, Scalar: Numeric & CustomStringConvertible {
    func addVisualization(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension DirectionalRay3: VisualizableGeometricType where Scalar: CustomStringConvertible {
    func addVisualization(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension AABB3: VisualizableGeometricType where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    func addVisualization(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension NRectangle: VisualizableGeometricType where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    func addVisualization(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension NSquare: VisualizableGeometricType where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    func addVisualization(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Torus3: VisualizableGeometricType where Vector: VectorReal, Scalar: CustomStringConvertible {
    func addVisualization(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}
