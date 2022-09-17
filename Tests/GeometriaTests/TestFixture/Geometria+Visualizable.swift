import Geometria

extension Vector2: VisualizableGeometricType2 where Scalar: Numeric & CustomStringConvertible {
    func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Vector3: VisualizableGeometricType3 where Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Line2: VisualizableGeometricType2 where Scalar: Numeric & CustomStringConvertible {
    func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Line3: VisualizableGeometricType3 where Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension LineSegment2: VisualizableGeometricType2 where Scalar: Numeric & CustomStringConvertible {
    func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension LineSegment3: VisualizableGeometricType3 where Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Ray3: VisualizableGeometricType3 where Vector: VectorAdditive, Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension DirectionalRay3: VisualizableGeometricType3 where Scalar: CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension AABB2: VisualizableGeometricType2 where Vector: Vector2Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    func addVisualization2D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension AABB3: VisualizableGeometricType3 where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension NRectangle: VisualizableGeometricType3 where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension NSquare: VisualizableGeometricType3 where Vector: Vector3Additive & VectorDivisible, Scalar: Numeric & CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}

extension Torus3: VisualizableGeometricType3 where Vector: VectorReal, Scalar: CustomStringConvertible {
    func addVisualization3D(to printer: P5Printer, style: P5Printer.Style?) {
        printer.add(self, style: style)
    }
}
