import RealModule
import Foundation

// This source code is partially based on SharpDX's Matrix3x2.cs & MathUtils.cs
// implementations, the license of which is stated bellow:

// Copyright (c) 2010-2014 SharpDX - Alexandre Mutel
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// -----------------------------------------------------------------------------
// Original code from SlimMath project. http://code.google.com/p/slimmath/
// Greetings to SlimDX Group. Original code published with the following license:
// -----------------------------------------------------------------------------
/*
 * Copyright (c) 2007-2011 SlimDX Group
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/// Plain 3-row 2-column Matrix for 2D [affine transformations] with
/// double-precision floating-point components.
///
/// [affine transformations]: http://en.wikipedia.org/wiki/Affine_transformation
public typealias Matrix3x2D = Matrix3x2<Double>

/// Plain 3-row 2-column Matrix for 2D [affine transformations] with floating-point
/// components.
///
/// [affine transformations]: http://en.wikipedia.org/wiki/Affine_transformation
public struct Matrix3x2<Scalar: FloatingPoint & ElementaryFunctions>: Hashable, CustomStringConvertible {
    public typealias Vector = Vector2<Scalar>
    
    /// Gets the identity matrix.
    public static var identity: Self { Self(m11: 1, m12: 0,
                                            m21: 0, m22: 1,
                                            m31: 0, m32: 0) }
    
    /// Element (1,1)
    public let m11: Scalar
    
    /// Element (1,2)
    public let m12: Scalar
    
    /// Element (2,1)
    public let m21: Scalar
    
    /// Element (2,2)
    public let m22: Scalar
    
    /// Element (3,1)
    public let m31: Scalar
    
    /// Element (3,2)
    public let m32: Scalar
    
    /// Gets the first row in the matrix; that is M11 and M12.
    public var row1: [Scalar] { [m11, m12] }
    
    /// Gets the second row in the matrix; that is M21 and M22.
    public var row2: [Scalar] { [m21, m22] }
    
    /// Gets the third row in the matrix; that is M31 and M32.
    public var row3: [Scalar] { [m31, m32] }
    
    /// Gets the first column in the matrix; that is M11, M21, and M31.
    public var column1: [Scalar] { [m11, m21, m31] }
    
    /// Gets the second column in the matrix; that is M12, M22, and M32.
    public var column2: [Scalar] { [m12, m22, m32] }
    
    /// Gets the translation of the matrix; that is M31 and M32.
    public var translationVector: Vector { Vector(x: m31, y: m32) }
    
    /// Gets the scale of the matrix; that is M11 and M22.
    public var scaleVector: Vector { Vector(x: m11, y: m22) }
    
    /// Gets a value indicating whether this instance is an identity matrix.
    ///
    /// `true` if this instance is an identity matrix; otherwise, `false`.
    public var isIdentity: Bool { Matrix3x2.identity == self }
    
    /// Gets or sets the component at the specified index.
    ///
    /// - Parameter index: The zero-based index of the component to access.
    /// - Returns: The value of the component at the specified index.
    public subscript(index index: Int) -> Scalar {
        switch index {
        case 0:
            return m11
        case 1:
            return m12
        case 2:
            return m21
        case 3:
            return m22
        case 4:
            return m31
        case 5:
            return m32
        default:
            fatalError("Indices for Matrix3x2 run from 0 to 5, inclusive.")
        }
    }
    
    /// Gets or sets the component at the specified index.
    ///
    /// - Parameter row: The row of the matrix to access.
    /// - Parameter column: The column of the matrix to access.
    /// - Returns: The value of the component at the specified index.
    ///
    /// - precondition: `row >= 0 && row <= 2 && column >= 0 && column <= 1`
    public subscript(column column: Int, row row: Int) -> Scalar {
        precondition(row >= 0 || row <= 2,
                     "Rows for Matrix3x2 run from 0 to 2, inclusive.")
        precondition(column >= 0 || column <= 1,
                     "Rows and columns for Matrix3x2 run from 0 to 1, inclusive.")
        
        return self[index: row * 2 + column]
    }
    
    /// Returns a `String` that represents this instance.
    public var description: String {
        "[M11:\(m11) M12:\(m12)] [M21:\(m21) M22:\(m22)] [M31:\(m31) M32:\(m32)]"
    }
    
    /// Initializes a new instance of the `Matrix3x2` struct.
    ///
    /// - Parameter value: The value that will be assigned to all components.
    public init(value: Scalar) {
        m11 = value
        m12 = value
        m21 = value
        m22 = value
        m31 = value
        m32 = value
    }
    
    /// Initializes a new instance of the `Matrix3x2` struct.
    ///
    /// - Parameter m11: The value to assign at row 1 column 1 of the matrix.
    /// - Parameter m12: The value to assign at row 1 column 2 of the matrix.
    /// - Parameter m21: The value to assign at row 2 column 1 of the matrix.
    /// - Parameter m22: The value to assign at row 2 column 2 of the matrix.
    /// - Parameter m31: The value to assign at row 3 column 1 of the matrix.
    /// - Parameter m32: The value to assign at row 3 column 2 of the matrix.
    public init(m11: Scalar, m12: Scalar, m21: Scalar, m22: Scalar, m31: Scalar, m32: Scalar) {
        self.m11 = m11
        self.m12 = m12
        self.m21 = m21
        self.m22 = m22
        self.m31 = m31
        self.m32 = m32
    }
    
    /// Initializes a new instance of the `Matrix3x2` struct.
    ///
    /// - Parameter values: The values to assign to the components of the matrix.
    /// This must be an array with six elements, otherwise a runtime error is thrown
    ///
    /// - precondition: `values.count == 6`
    public init(values: [Scalar]) {
        precondition(values.count == 6, "There must be six input values for Matrix3x2")
        
        m11 = values[0]
        m12 = values[1]
        
        m21 = values[2]
        m22 = values[3]
        
        m31 = values[4]
        m32 = values[5]
    }
    
    /// Creates an array containing the elements of the matrix.
    ///
    /// - Returns: A six-element array containing the components of the matrix.
    public func toArray() -> [Scalar] {
        [m11, m12, m21, m22, m31, m32]
    }
    
    /// Calculates the determinant of this matrix.
    ///
    /// - Returns: Result of the determinant.
    public func determinant() -> Scalar {
        ((m11 * m22) as Scalar) - m12 * m21
    }
    
    /// Calculates the inverse of this matrix instance.
    public func inverted() -> Matrix3x2 {
        Matrix3x2.invert(self)
    }
    
    /// Determines the sum of two matrices.
    ///
    /// - Parameter left: The first matrix to add.
    /// - Parameter right: The second matrix to add.
    public static func add(_ left: Matrix3x2, _ right: Matrix3x2) -> Matrix3x2 {
        let m11 = left.m11 + right.m11
        let m12 = left.m12 + right.m12
        let m21 = left.m21 + right.m21
        let m22 = left.m22 + right.m22
        let m31 = left.m31 + right.m31
        let m32 = left.m32 + right.m32
        
        return Matrix3x2(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }
    
    /// Determines the difference between two matrices.
    ///
    /// - Parameter left: The first matrix to subtract.
    /// - Parameter right: The second matrix to subtract.
    public static func subtract(_ left: Matrix3x2, _ right: Matrix3x2) -> Matrix3x2 {
        let m11 = left.m11 - right.m11
        let m12 = left.m12 - right.m12
        let m21 = left.m21 - right.m21
        let m22 = left.m22 - right.m22
        let m31 = left.m31 - right.m31
        let m32 = left.m32 - right.m32
        
        return Matrix3x2(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }
    
    /// Scales a matrix by the given value.
    ///
    /// - Parameter left: The matrix to scale.
    /// - Parameter right: The amount by which to scale.
    public static func multiply(_ left: Matrix3x2, _ right: Scalar) -> Matrix3x2 {
        let m11 = left.m11 * right
        let m12 = left.m12 * right
        let m21 = left.m21 * right
        let m22 = left.m22 * right
        let m31 = left.m31 * right
        let m32 = left.m32 * right
        
        return Matrix3x2(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }
    
    /// Determines the product of two matrices.
    ///
    /// - Parameter left: The first matrix to multiply.
    /// - Parameter right: The second matrix to multiply.
    public static func multiply(_ left: Matrix3x2, _ right: Matrix3x2) -> Matrix3x2 {
        let m11: Scalar = (left.m11 * right.m11) as Scalar + (left.m12 * right.m21) as Scalar
        let m12: Scalar = (left.m11 * right.m12) as Scalar + (left.m12 * right.m22) as Scalar
        let m21: Scalar = (left.m21 * right.m11) as Scalar + (left.m22 * right.m21) as Scalar
        let m22: Scalar = (left.m21 * right.m12) as Scalar + (left.m22 * right.m22) as Scalar
        let m31: Scalar = (left.m31 * right.m11) as Scalar + (left.m32 * right.m21 + right.m31) as Scalar
        let m32: Scalar = (left.m31 * right.m12) as Scalar + (left.m32 * right.m22 + right.m32) as Scalar
        
        return Matrix3x2(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }
    
    /// Scales a matrix by the given value.
    ///
    /// - Parameter left: The matrix to scale.
    /// - Parameter right: The amount by which to scale. Must be greater than zero
    public static func divide(_ left: Matrix3x2, _ right: Scalar) -> Matrix3x2 {
        let inv = Scalar(1) / right
        
        let m11 = left.m11 * inv
        let m12 = left.m12 * inv
        let m21 = left.m21 * inv
        let m22 = left.m22 * inv
        let m31 = left.m31 * inv
        let m32 = left.m32 * inv
        
        return Matrix3x2(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }
    
    /// Determines the quotient of two matrices.
    ///
    /// - Parameter left: The first matrix to divide.
    /// - Parameter right: The second matrix to divide.
    public static func divide(_ left: Matrix3x2, _ right: Matrix3x2) -> Matrix3x2 {
        let m11 = left.m11 / right.m11
        let m12 = left.m12 / right.m12
        let m21 = left.m21 / right.m21
        let m22 = left.m22 / right.m22
        let m31 = left.m31 / right.m31
        let m32 = left.m32 / right.m32
        
        return Matrix3x2(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }
    
    /// Negates a matrix.
    ///
    /// - Parameter value: The matrix to be negated.
    public static func negate(_ value: Matrix3x2) -> Matrix3x2 {
        let m11 = -value.m11
        let m12 = -value.m12
        let m21 = -value.m21
        let m22 = -value.m22
        let m31 = -value.m31
        let m32 = -value.m32
        
        return Matrix3x2(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }
    
    /// Performs a linear interpolation between two matrices.
    ///
    /// Passing `amount` a value of 0 will cause `start` to be returned; a value
    /// of 1 will cause `end` to be returned.
    ///
    /// - Parameter start: Start matrix.
    /// - Parameter end: End matrix.
    /// - Parameter amount: Value between 0 and 1 indicating the weight of `end`.
    public static func lerp(start: Matrix3x2, end: Matrix3x2, amount: Scalar) -> Matrix3x2 {
        let m11 = Matrix3x2.lerp(from: start.m11, to: end.m11, amount: amount)
        let m12 = Matrix3x2.lerp(from: start.m12, to: end.m12, amount: amount)
        let m21 = Matrix3x2.lerp(from: start.m21, to: end.m21, amount: amount)
        let m22 = Matrix3x2.lerp(from: start.m22, to: end.m22, amount: amount)
        let m31 = Matrix3x2.lerp(from: start.m31, to: end.m31, amount: amount)
        let m32 = Matrix3x2.lerp(from: start.m32, to: end.m32, amount: amount)
        
        return Matrix3x2(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }
    
    /// Creates a matrix that scales along the x-axis and y-axis.
    ///
    /// - Parameter scale: Scaling factor for both axes.
    public static func scaling(scale: Vector) -> Matrix3x2 {
        scaling(x: scale.x, y: scale.y)
    }
    
    /// Creates a matrix that scales along the x-axis and y-axis.
    ///
    /// - Parameter x: Scaling factor that is applied along the x-axis.
    /// - Parameter y: Scaling factor that is applied along the y-axis.
    public static func scaling(x: Scalar, y: Scalar) -> Matrix3x2 {
        Matrix3x2(m11: x, m12: 0,
                m21: 0, m22: y,
                m31: 0, m32: 0)
    }
    
    /// Creates a matrix that uniformly scales along both axes.
    ///
    /// - Parameter scale: The uniform scale that is applied along both axes.
    public static func scaling(scale: Scalar) -> Matrix3x2 {
        Matrix3x2(m11: scale, m12: 0,
                m21: 0, m22: scale,
                m31: 0, m32: 0)
    }
    
    /// Creates a matrix that is scaling from a specified center.
    ///
    /// - Parameter x: Scaling factor that is applied along the x-axis.
    /// - Parameter y: Scaling factor that is applied along the y-axis.
    /// - Parameter center: The center of the scaling.
    public static func scaling(x: Scalar, y: Scalar, center: Vector) -> Matrix3x2 {
        Matrix3x2(m11: x, m12: 0,
                m21: 0, m22: y,
                m31: center.x - x * center.x, m32: center.y - y * center.y)
    }
    
    /// Creates a matrix that rotates.
    ///
    /// - Parameter angle: Angle of rotation in radians. Angles are measured
    /// clockwise when looking along the rotation axis.
    /// - Parameter result: When the method completes, contains the created
    /// rotation matrix.
    public static func rotation(angle: Scalar) -> Matrix3x2 {
        let cosAngle = Scalar.cos(angle)
        let sinAngle = Scalar.sin(angle)
        
        return Matrix3x2(m11: cosAngle, m12: sinAngle,
                       m21: -sinAngle, m22: cosAngle,
                       m31: 0, m32: 0)
    }
    
    /// Creates a matrix that rotates about a specified center.
    ///
    /// - Parameter angle: Angle of rotation in radians. Angles are measured
    /// clockwise when looking along the rotation axis.
    /// - Parameter center: The center of the rotation.
    public static func rotation(angle: Scalar, center: Vector) -> Matrix3x2 {
        translation(-center) * rotation(angle: angle) * translation(center)
    }
    
    /// Creates a translation matrix using the specified offsets.
    ///
    /// - Parameter value: The offset for both coordinate planes.
    /// - Parameter result: When the method completes, contains the created
    /// translation matrix.
    public static func translation(_ value: Vector) -> Matrix3x2 {
        translation(x: value.x, y: value.y)
    }
    
    /// Creates a translation matrix using the specified offsets.
    ///
    /// - Parameter x: X-coordinate offset.
    /// - Parameter y: Y-coordinate offset.
    public static func translation(x: Scalar, y: Scalar) -> Matrix3x2 {
        Matrix3x2(m11: 1, m12: 0,
                m21: 0, m22: 1,
                m31: x, m32: y)
    }
    
    /// Creates a transformation matrix.
    ///
    /// - Parameter xScale: Scaling factor that is applied along the x-axis.
    /// - Parameter yScale: Scaling factor that is applied along the y-axis.
    /// - Parameter angle: Angle of rotation in radians. Angles are measured
    /// clockwise when looking along the rotation axis.
    /// - Parameter xOffset: X-coordinate offset.
    /// - Parameter yOffset: Y-coordinate offset.
    public static func transformation(xScale: Scalar,
                                      yScale: Scalar,
                                      angle: Scalar,
                                      xOffset: Scalar,
                                      yOffset: Scalar) -> Matrix3x2 {

        scaling(x: xScale, y: yScale)
                * rotation(angle: angle)
                * translation(x: xOffset, y: yOffset)
    }
    
    /// Transforms a vector by this matrix.
    ///
    /// - Parameter matrix: The matrix to use as a transformation matrix.
    /// - Parameter point: The original vector to apply the transformation.
    /// - Returns: The result of the transformation for the input vector.
    @inlinable
    public static func transformPoint(matrix: Matrix3x2, point: Vector) -> Vector {
        let x = (point.x * matrix.m11) as Scalar + (point.y * matrix.m21) as Scalar + matrix.m31
        let y = (point.x * matrix.m12) as Scalar + (point.y * matrix.m22) as Scalar + matrix.m32
        
        return Vector(x: x, y: y)
    }
    
    /// Transforms a vector by this matrix.
    ///
    /// - Parameter matrix: The matrix to use as a transformation matrix.
    /// - Parameter point: The original vector to apply the transformation.
    /// - Returns: The result of the transformation for the input vector.
    @inlinable
    public static func transformPoint<V: Vector2Type>(matrix: Matrix3x2, point: V) -> V where V.Scalar == Scalar {
        let x = (point.x * matrix.m11) as Scalar + (point.y * matrix.m21) as Scalar + matrix.m31
        let y = (point.x * matrix.m12) as Scalar + (point.y * matrix.m22) as Scalar + matrix.m32
        
        return V(x: x, y: y)
    }
    
    /// Creates a skew matrix.
    ///
    /// - Parameter angleX: Angle of skew along the X-axis in radians.
    /// - Parameter angleY: Angle of skew along the Y-axis in radians.
    public static func skew(angleX: Scalar, angleY: Scalar) -> Matrix3x2 {
        Matrix3x2(m11: 1, m12: Scalar.tan(angleX),
                m21: Scalar.tan(angleY), m22: 1,
                m31: 0, m32: 0)
    }
    
    /// Calculates the inverse of the specified matrix.
    ///
    /// - Parameter value: The matrix whose inverse is to be calculated.
    /// - Parameter result: When the method completes, contains the inverse of the specified matrix.
    public static func invert(_ value: Matrix3x2) -> Matrix3x2 {
        let determinant = value.determinant()
        
        if Matrix3x2.isZero(determinant) {
            return identity
        }
        
        let invdet = Scalar(1) / determinant
        let offsetX = value.m31
        let offsetY = value.m32
        
        let m11 = value.m22 * invdet
        let m12 = -value.m12 * invdet
        let m21 = -value.m21 * invdet
        let m22 = value.m11 * invdet
        let m31: Scalar = ((value.m21 * offsetY as Scalar - offsetX * value.m22) as Scalar) * invdet
        let m32: Scalar = ((offsetX * value.m12 as Scalar - value.m11 * offsetY) as Scalar) * invdet
        
        return Matrix3x2(m11: m11, m12: m12, m21: m21, m22: m22, m31: m31, m32: m32)
    }
    
    /// Adds two matrices.
    ///
    /// - Parameter left: The first matrix to add.
    /// - Parameter right: The second matrix to add.
    /// - Returns: The sum of the two matrices.
    public static func + (left: Matrix3x2, right: Matrix3x2) -> Matrix3x2 {
        add(left, right)
    }
    
    /// Assert a matrix (return it unchanged).
    ///
    /// - Parameter value: The matrix to assert (unchanged).
    /// - Returns: The asserted (unchanged) matrix.
    public static prefix func + (value: Matrix3x2) -> Matrix3x2 {
        value
    }
    
    /// Subtracts two matrices.
    ///
    /// - Parameter left: The first matrix to subtract.
    /// - Parameter right: The second matrix to subtract.
    /// - Returns: The difference between the two matrices.
    public static func - (left: Matrix3x2, right: Matrix3x2) -> Matrix3x2 {
        subtract(left, right)
    }
    
    /// Negates a matrix.
    ///
    /// - Parameter value: The matrix to negate.
    /// - Returns: The negated matrix.
    public static prefix func - (value: Matrix3x2) -> Matrix3x2 {
        negate(value)
    }
    
    /// Scales a matrix by a given value.
    ///
    /// - Parameter right: The matrix to scale.
    /// - Parameter left: The amount by which to scale.
    /// - Returns: The scaled matrix.
    public static func * (left: Scalar, right: Matrix3x2) -> Matrix3x2 {
        multiply(right, left)
    }
    
    /// Scales a matrix by a given value.
    ///
    /// - Parameter left: The matrix to scale.
    /// - Parameter right: The amount by which to scale.
    /// - Returns: The scaled matrix.
    public static func * (left: Matrix3x2, right: Scalar) -> Matrix3x2 {
        multiply(left, right)
    }
    
    /// Multiplies two matrices.
    ///
    /// - Parameter left: The first matrix to multiply.
    /// - Parameter right: The second matrix to multiply.
    /// - Returns: The product of the two matrices.
    public static func * (left: Matrix3x2, right: Matrix3x2) -> Matrix3x2 {
        multiply(left, right)
    }
    
    /// Scales a matrix by a given value.
    ///
    /// - Parameter left: The matrix to scale.
    /// - Parameter right: The amount by which to scale.
    /// - Returns: The scaled matrix.
    public static func / (left: Matrix3x2, right: Scalar) -> Matrix3x2 {
        divide(left, right)
    }
    
    /// Divides two matrices.
    /// - Parameter left: The first matrix to divide.
    /// - Parameter right: The second matrix to divide.
    /// - Returns: The quotient of the two matrices.
    public static func / (left: Matrix3x2, right: Matrix3x2) -> Matrix3x2 {
        divide(left, right)
    }
    
    /// Interpolates between two values using a linear function by a given amount.
    ///
    /// - Remarks:
    /// See http://www.encyclopediaofmath.org/index.php/Linear_interpolation and
    /// http://fgiesen.wordpress.com/2012/08/15/linear-interpolation-past-present-and-future/
    ///
    /// - Parameter from: Value to interpolate from.
    /// - Parameter to: Value to interpolate to.
    /// - Parameter amount: Interpolation amount.
    /// - Returns: The result of linear interpolation of values based on the amount.
    private static func lerp(from: Scalar, to: Scalar, amount: Scalar) -> Scalar {
        ((1 - amount) * from as Scalar) + ((amount * to) as Scalar)
    }
    
    /// Determines whether the specified value is close to zero (0.0f).
    /// - Parameter a: The floating value.
    /// - Returns: `true` if the specified value is close to zero (0.0f);
    /// otherwise, `false`.
    private static func isZero(_ a: Scalar) -> Bool {
        let zeroTolerance = Scalar.leastNonzeroMagnitude
        
        return abs(a) < zeroTolerance
    }
}

// MARK: Conformances

extension Matrix3x2: Encodable where Scalar: Encodable { }
extension Matrix3x2: Decodable where Scalar: Decodable { }

// MARK: Geometry transformation

public extension Matrix3x2 {
    /// Transforms a given rectangle's bounds using this transformation matrix.
    ///
    /// The scale and rotation transformations use the origin (0, 0) for the base
    /// of the transformation, so scaling and rotating do not happen around the
    /// origin or center of the rectangle itself.
    @inlinable
    func transform<V: Vector2Type & VectorAdditive & VectorComparable>(_ rect: NRectangle<V>) -> NRectangle<V> where V.Scalar == Scalar {
        let topLeft = transform(rect.topLeft)
        let topRight = transform(rect.topRight)
        let bottomLeft = transform(rect.bottomLeft)
        let bottomRight = transform(rect.bottomRight)
        
        var minimum = V.pointwiseMin(topLeft, topRight)
        minimum = V.pointwiseMin(minimum, bottomLeft)
        minimum = V.pointwiseMin(minimum, bottomRight)
        
        var maximum = V.pointwiseMax(topLeft, topRight)
        maximum = V.pointwiseMax(maximum, bottomLeft)
        maximum = V.pointwiseMax(maximum, bottomRight)
        
        return NRectangle(minimum: minimum, maximum: maximum)
    }
    
    @inlinable
    func transform<V: Vector2Type>(_ point: V) -> V where V.Scalar == Scalar {
        Self.transformPoint(matrix: self, point: point)
    }
    
    @inlinable
    func transform<V: Vector2Type>(points: [V]) -> [V] where V.Scalar == Scalar {
        points.map(transform(_:))
    }
}
