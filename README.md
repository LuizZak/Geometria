# Geometria

[![Swift](https://github.com/LuizZak/Geometria/actions/workflows/swift.yml/badge.svg)](https://github.com/LuizZak/Geometria/actions/workflows/swift.yml)

A collection of definitions and algorithms for working with 2- and 3- dimensional geometries in Swift.

(README.md is still in construction.)

### Type definitions

<table>
    <tr>
        <th>N-dimensional</th>
    </tr>
    <tr>
        <th>Primitive</th>
        <th>Geometria type</th>
        <th>Remarks</th>
    </tr>
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Minimum_bounding_box#Axis-aligned_minimum_bounding_box">Axis-aligned bounding-box</a>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/AABB.swift">AABB.swift</a>
        </td>
        <td>
            Defined as two point vectors describing the minimal and maximal coordinates contained within the AABB.
        </td>
    </tr>
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Line_(geometry)#Ray">Ray (unit vector direction)</a>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/DirectionalRay.swift">DirectionalRay.swift</a>
        </td>
        <td>
            Defined as a starting point vector and a <a href="https://en.wikipedia.org/wiki/Unit_vector">unit vector</a> describing the direction of the ray.
            </br>
            Conceptually it extends to infinity in only one of its two ends (pointed to by its direction unit vector).
        </td>
    </tr>
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Ellipsoid">N-dimensional Ellipsoid</a>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/Ellipsoid.swift">Ellipsoid.swift</a>
        </td>
        <td>
            Defined as a center point vector and an axis vector.
        </td>
    </tr>
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Line_(geometry)">Line</a>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/Line.swift">Line.swift</a>
        </td>
        <td>
            Defined as a pair of point vectors on the line.
            Conceptually it extends to infinity at both ends.
        </td>
    </tr>
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Line_segment">Line segment</a>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/LineSegment.swift">LineSegment.swift</a>
        </td>
        <td>
            Defined as start and end point vectors on the line.
            Conceptually it is contained only within the limits of start <-> end.
        </td>
    </tr>
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Capsule_(geometry)">N-dimensional capsule</a>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/NCapsule.swift">NCapsule.swift</a>
        </td>
        <td>
            Defined as a line segment containing two point vectors describing the span of the capsule's body, and a scalar
            radius that defines the maximal distance to the line segment points must be to be considered as contained within the capsule.
            <br/>
            Specializes as a Stadium in 2D and Capsule in 3D.
        </td>
    </tr>
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Hyperrectangle">Hyperrectangle</a>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/NRectangle.swift">NRectangle.swift</a>
        </td>
        <td>
            Defined as an origin (top-left in two dimensions) point vector and an N-dimensional size vector.
        </td>
    </tr>
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/N-sphere">N-sphere</a>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/NSphere.swift">NSphere.swift</a>
        </td>
        <td>
            Defined as a center point vector and a scalar radius.
        </td>
    </tr>
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Hypercube">N-dimensional cube (Hypercube)</a>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/NSquare.swift">NSquare.swift</a>
        </td>
        <td>
            Generalized for any dimension.
            <br/>
            Defined as an origin point (top-left in two dimensions) and a scalar value that describes the span of the
            cube, in each dimension.
            <br/>
            Forms a square in 2D, and a cube in 3D.
        </td>
    </tr>
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Plane_(geometry)#Point%E2%80%93normal_form_and_general_form_of_the_equation_of_a_plane">Plane</a>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/PointNormalPlane.swift">PointNormalPlane.swift</a>
        </td>
        <td>
            Defined as a point vector on the plane and a <a href="https://en.wikipedia.org/wiki/Unit_vector">unit vector</a> orthogonal to the plane's surface.
        </td>
    </tr>    
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Line_(geometry)#Ray">Ray (two-point)</a>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/Ray.swift">Ray.swift</a>
        </td>
        <td>
            Defined as a pair of points start and b describing the two points the ray crosses before projecting to infinity.
            </br>
            Similar in definition to a line and line segment, but extends in one direction to infinity.
        </td>
    </tr>
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Triangle">Triangle</a>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/Triangle.swift">Triangle.swift</a>
        </td>
        <td>
            Defined as a set of three point vectors.
        </td>
    </tr>
</table>
