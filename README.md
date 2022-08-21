# Geometria

[![Swift](https://github.com/LuizZak/Geometria/actions/workflows/swift.yml/badge.svg)](https://github.com/LuizZak/Geometria/actions/workflows/swift.yml)

A collection of definitions and algorithms for working with 2- and 3- dimensional geometries in Swift.

(README.md is still in construction.)

### Type definitions

<table>
    <svg display="hidden">
        <defs>
            <g id="dot">
                <circle r="4" stroke="none" fill="#00f"/>
            </g>
            <marker id="arrow-unit" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
                <path d="M 0 0 L 10 5 L 0 10 z" fill="#f00"/>
            </marker>
            <marker id="arrow-length" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
                <path d="M 0 0 L 10 5 L 0 10 z" fill="#00f"/>
            </marker>
            <marker id="circle" markerWidth="8" markerHeight="8" refX="4" refY="4" markerUnits="userSpaceOnUse">
                <use href="#dot" x="4" y="4"/>
            </marker>
        </defs>
    </svg>
    <tr>
        <th>N-dimensional</th>
    </tr>
    <tr>
        <th>Primitive</th>
        <th>Illustration</th>
        <th>Geometria type</th>
        <th>Remarks</th>
    </tr>
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Minimum_bounding_box#Axis-aligned_minimum_bounding_box">Axis-aligned bounding-box</a>
        </td>
        <td>
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <rect x="0" y="0" width="100%" height="100%" fill="white"/>
                <rect x="12" y="25" width="75" height="50" stroke="black" fill="transparent" stroke-width="2"/>
                <use href="#dot" x="12" y="25"/>
                <use href="#dot" x="87" y="75"/>
            </svg>
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
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <rect x="0" y="0" width="100%" height="100%" fill="white"/>
                <g transform="translate(20, 70) rotate(-35)" stroke-width="2">
                    <line x2="100" y2="0" stroke="black" stroke-linecap="round"/>
                    <line x2="15" y2="0" marker-end="url(#arrow-unit)"/>
                    <use href="#dot"/>
                </g>
            </svg>
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
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <rect x="0" y="0" width="100%" height="100%" fill="white"/>
                <g transform="translate(-6, 17) scale(0.4, 0.3)" stroke-width="3">
                    <g>
                        <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M228,112.5c0,16.463-39.176,29.808-87.5,29.808   c-48.325,0-87.5-13.345-87.5-29.808"/>
                        <g>
                            <g>
                                <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M53,112.5c0-0.999,0.144-1.985,0.426-2.959"/>
                                <path fill="none" stroke="#231F20" stroke-miterlimit="10" stroke-dasharray="6.1156,6.1156" d="     M56.397,104.247C66.904,91.799,100.58,82.692,140.5,82.692c42.541,0,77.992,10.342,85.868,24.049"/>
                                <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M227.574,109.541     c0.281,0.974,0.426,1.96,0.426,2.959"/>
                            </g>
                        </g>
                    </g>
                    <g fill="none" stroke="black">
                        <circle cx="140" cy="111" r="88"/>
                        <line x1="140" y1="111" x2="220" y2="111" stroke-dasharray="6.1156,6.1156" marker-end="url(#arrow-length)"/>
                        <line x1="140" y1="111" x2="140" y2="35" stroke-dasharray="6.1156,6.1156" marker-end="url(#arrow-length)"/>
                        <line x1="140" y1="111" x2="110" y2="130" stroke-dasharray="6.1156,6.1156" marker-end="url(#arrow-length)"/>
                        <circle cx="200" cy="111" r="10" stroke="none" fill="#00f" transform="scale(0.7, 1)"/>
                    </g>
                </g>
            </svg>
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
            <a href="https://en.wikipedia.org/wiki/Hyperplane">Hyperplane</a>
        </td>
        <td>
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <g>
                    <rect fill="white" height="100%" width="100%" x="0" y="0"/>
                    <g stroke-linejoin="round" stroke-width="0.75">
                    <g stroke="#c0c0c0">
                        <path d="m-10.12,-13.11l0,128.38"/>
                        <path d="m2.71,-13.11l0,128.38"/>
                        <path d="m15.55,-13.11l0,128.38"/>
                        <path d="m28.39,-13.11l0,128.38"/>
                        <path d="m41.23,-13.11l0,128.38"/>
                        <path d="m54.07,-13.11l0,128.38"/>
                        <path d="m66.91,-13.11l0,128.38"/>
                        <path d="m79.74,-13.11l0,128.38"/>
                        <path d="m92.58,-13.11l0,128.38"/>
                        <path d="m105.42,-13.11l0,128.38"/>
                        <path d="m118.26,-13.11l0,128.38"/>
                        <path d="m-16.54,-6.69l128.38,0"/>
                        <path d="m-16.54,6.14l128.38,0"/>
                        <path d="m-16.54,18.98l128.38,0"/>
                        <path d="m-3.7,31.82l128.38,0"/>
                        <path d="m-3.7,44.66l128.38,0"/>
                        <path d="m-3.7,57.5l128.38,0"/>
                        <path d="m-3.7,70.34l128.38,0"/>
                        <path d="m-3.7,83.17l128.38,0"/>
                        <path d="m-3.7,96.01l128.38,0"/>
                    </g>
                    </g>
                </g>
                <g>
                    <line fill="none" stroke="black" stroke-linecap="round" x1="-5.22" x2="115.73" y1="83.16" y2="83.16"/>
                    <line fill="none" stroke="black" stroke-linecap="round" x1="15.55" x2="15.55" y1="-6.98" y2="105.91"/>
                </g>
                <g stroke-width="2">
                    <line stroke="black" stroke-linecap="round" x1="-0.95" x2="102.34" y1="-0.95" y2="102.38"/>
                    <path d="m-2.5,-2.58l106.26,106.81l-106.34,0.7l-1.88,-97.18l1.96,-10.33z" fill="#3478e5" fill-opacity="0.31" stroke="black" stroke-linecap="round" stroke-width="0"/>
                </g>
                <g stroke-width="1.5">
                    <line stroke="red" stroke-linecap="round" x1="50" y1="50" x2="60" y2="40" marker-end="url(#arrow-unit)"/>
                    <use href="#dot" x="50" y="50"/>
                </g>
            </svg>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/Hyperplane.swift">Hyperplane.swift</a>
        </td>
        <td>
            Defined as a point vector on the plane and a <a href="https://en.wikipedia.org/wiki/Unit_vector">unit vector</a> orthogonal to the hyperplane's surface. Defines a split between two <a href="https://en.wikipedia.org/wiki/Half-space_(geometry)">half-spaces</a> of the space it is contained within. Is considered a convex, volumetric space that can be intersected against lines and contain points.
        </td>
    </tr> 
    <tr>
        <td>
            <a href="https://en.wikipedia.org/wiki/Line_(geometry)">Line</a>
        </td>
        <td>
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <rect x="0" y="0" width="100%" height="100%" fill="white"/>
                <g transform="translate(20, 70) rotate(-35)" stroke-width="2">
                    <line x1="-100" x2="100" y2="0" stroke="black" stroke-linecap="round"/>
                    <use href="#dot"/>
                    <use href="#dot" x="70"/>
                </g>
            </svg>
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
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <rect x="0" y="0" width="100%" height="100%" fill="white"/>
                <g transform="translate(20, 70) rotate(-35)" stroke-width="2">
                    <line x1="0" x2="70" y2="0" stroke="black" stroke-linecap="round"/>
                    <use href="#dot"/>
                    <use href="#dot" x="70"/>
                </g>
            </svg>
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
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <rect x="0" y="0" width="100%" height="100%" fill="white"/>
                <g transform="translate(12) scale(0.25)" stroke-width="4">
                    <g>
                        <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M228,112.5c0,16.463-39.176,29.808-87.5,29.808   c-48.325,0-87.5-13.345-87.5-29.808"/>
                        <g>
                            <g>
                                <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M53,112.5c0-0.999,0.144-1.985,0.426-2.959"/>
                                <path fill="none" stroke="#231F20" stroke-miterlimit="10" stroke-dasharray="6.1156,6.1156" d="     M56.397,104.247C66.904,91.799,100.58,82.692,140.5,82.692c42.541,0,77.992,10.342,85.868,24.049"/>
                                <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M227.574,109.541     c0.281,0.974,0.426,1.96,0.426,2.959"/>
                            </g>
                        </g>
                    </g>
                    <g>
                        <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M228,287.5c0,16.463-39.176,29.808-87.5,29.808   c-48.325,0-87.5-13.345-87.5-29.808"/>
                        <g>
                            <g>
                                <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M53,287.5c0-0.998,0.144-1.985,0.426-2.959"/>
                                <path fill="none" stroke="#231F20" stroke-miterlimit="10" stroke-dasharray="6.1156,6.1156" d="     M56.397,279.247c10.507-12.448,44.183-21.555,84.103-21.555c42.541,0,77.992,10.342,85.868,24.049"/>
                                <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M227.574,284.541     c0.281,0.974,0.426,1.961,0.426,2.959"/>
                            </g>
                        </g>
                    </g>
                    <g>
                        <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M140.895,375C92.529,375,53,335.864,53,287.5v-175   C53,64.136,92.333,25,140.697,25"/>
                        <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M139.692,25.001   c48.364,0,88.308,39.136,88.308,87.5V287.5c0,48.366-39.539,87.5-87.904,87.5"/>
                    </g>
                    <g>
                        <path d="M140,110 h85"
                              stroke="black"
                              stroke-dasharray="6.1156,6.1156"
                              marker-end="url(#arrow-length)"/>
                        <path d="M140,110 v170"
                              stroke="black"
                              marker-start="url(#circle)"
                              marker-mid="url(#circle)"
                              marker-end="url(#circle)"/>
                    </g>
                </g>
            </svg>
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
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <rect x="0" y="0" width="100%" height="100%" fill="white"/>
                <g stroke-width="1" transform="translate(12.5, 37)">
                    <g transform="skewY(10)">
                        <rect width="50" height="30" stroke="black" fill="transparent"/>
                        <rect x="20" y="-15" width="50" height="30" stroke="black" fill="transparent"/>
                    </g>
                    <g transform="skewY(-30)">
                        <rect width="20" height="30" stroke="black" fill="transparent"/>
                        <rect x="50" y="38" width="20" height="30" stroke="black" fill="transparent"/>
                    </g>
                    <use href="#dot" y="30"/>
                    <path d="M0,31.5 l47,6" marker-end="url(#arrow-length)"/>
                    <path d="M0,31.5 l0,-30" marker-end="url(#arrow-length)"/>
                    <path d="M0,31.5 l18,-12" marker-end="url(#arrow-length)"/>
                </g>
            </svg>
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
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <rect x="0" y="0" width="100%" height="100%" fill="white"/>
                <g transform="translate(-6, 5) scale(0.4)" stroke-width="3">
                    <g>
                        <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M228,112.5c0,16.463-39.176,29.808-87.5,29.808   c-48.325,0-87.5-13.345-87.5-29.808"/>
                        <g>
                            <g>
                                <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M53,112.5c0-0.999,0.144-1.985,0.426-2.959"/>
                                <path fill="none" stroke="#231F20" stroke-miterlimit="10" stroke-dasharray="6.1156,6.1156" d="     M56.397,104.247C66.904,91.799,100.58,82.692,140.5,82.692c42.541,0,77.992,10.342,85.868,24.049"/>
                                <path fill="none" stroke="#231F20" stroke-miterlimit="10" d="M227.574,109.541     c0.281,0.974,0.426,1.96,0.426,2.959"/>
                            </g>
                        </g>
                    </g>
                    <g>
                        <circle cx="140" cy="111" r="88" fill="transparent" stroke="black"/>
                    </g>
                    <g fill="none" stroke="black">
                        <line x1="140" y1="111" x2="220" y2="111" stroke-dasharray="6.1156,6.1156" marker-end="url(#arrow-length)"/>
                        <use href="#dot" x="70" y="55.5" transform="scale(2)"/>
                    </g>
                </g>
            </svg>
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
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <rect x="0" y="0" width="100%" height="100%" fill="white"/>
                <g stroke-width="0.75" transform="translate(12.5, 30) scale(1.5)" stroke-linejoin="round">
                    <g transform="skewY(10)">
                        <rect width="30" height="30" stroke="black" fill="transparent"/>
                        <rect x="20" y="-15.1" width="30" height="30" stroke="black" fill="transparent"/>
                    </g>
                    <g transform="skewY(-30)">
                        <rect width="20" height="30" stroke="black" fill="transparent"/>
                        <rect x="30" y="22.7" width="20" height="30" stroke="black" fill="transparent"/>
                    </g>
                </g>
                <g fill="none" stroke="black">
                    <path d="M13,74 l43,9" stroke="none" marker-end="url(#arrow-length)"/>
                    <use href="#dot" x="13" y="74"/>
                </g>
            </svg>
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
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <rect x="0" y="0" width="100%" height="100%" fill="white"/>
                <defs>
                    <mask id="myMask">
                        <g transform="rotate(30)">
                            <rect fill="white" x="-50" y="-5" width="200" height="100%"/>
                        </g>
                    </mask>
                </defs>
                <g stroke-width="0.75" stroke-linejoin="round" transform="translate(12.5, 30) scale(1.5) skewY(10) skewX(-40)">
                    <g stroke="#c0c0c0" mask="url(#myMask)">
                        <path d="M -15,-30  v100"/>
                        <path d="M -5,-30   v100"/>
                        <path d="M 5,-30    v100"/>
                        <path d="M 15,-30   v100"/>
                        <path d="M 25,-30   v100"/>
                        <path d="M 35,-30   v100"/>
                        <path d="M 45,-30   v100"/>
                        <path d="M 55,-30   v100"/>
                        <path d="M 65,-30   v100"/>
                        <path d="M 75,-30   v100"/>
                        <path d="M 85,-30   v100"/>
                        <g display="none">
                            <path d="M -20,-30  v100"/>
                            <path d="M -10,-30  v100"/>
                            <path d="M 0,-30    v100"/>
                            <path d="M 10,-30   v100"/>
                            <path d="M 20,-30   v100"/>
                            <path d="M 30,-30   v100"/>
                            <path d="M 40,-30   v100"/>
                            <path d="M 50,-30   v100"/>
                            <path d="M 60,-30   v100"/>
                            <path d="M 70,-30   v100"/>
                            <path d="M 80,-30   v100"/>
                        </g>
                        <path d="M -20,-25  h100"/>
                        <path d="M -20,-15  h100"/>
                        <path d="M -20,-5   h100"/>
                        <path d="M -10,5    h100"/>
                        <path d="M -10,15   h100"/>
                        <path d="M -10,25   h100"/>
                        <path d="M -10,35   h100"/>
                        <path d="M -10,45   h100"/>
                        <path d="M -10,55   h100"/>
                        <g display="none">
                            <path d="M -20,-20  h100"/>
                            <path d="M -20,-10  h100"/>
                            <path d="M -20,0    h100"/>
                            <path d="M -10,10   h100"/>
                            <path d="M -10,20   h100"/>
                            <path d="M -10,30   h100"/>
                            <path d="M -10,40   h100"/>
                            <path d="M -10,50   h100"/>
                        </g>
                    </g>
                </g>
                <g stroke="#000000" transform="translate(27, 4)">
                    <path d="M20,50 l-12,-7" marker-start="url(#circle)" marker-end="url(#arrow-unit)"/>
                </g>
            </svg>
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
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <rect x="0" y="0" width="100%" height="100%" fill="white"/>
                <g transform="translate(20, 70) rotate(-35)" stroke-width="2">
                    <line x1="0" x2="100" y2="0" stroke="black" stroke-linecap="round"/>
                    <use href="#dot"/>
                    <use href="#dot" x="70"/>
                </g>
            </svg>
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
            <svg width="100" height="100" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <rect x="0" y="0" width="100%" height="100%" fill="white"/>
                <path d="M17,75 l20,-55 l40,30 z" fill="none" stroke="black"
                        marker-start="url(#circle)"
                        marker-mid="url(#circle)"
                        marker-end="url(#circle)"/>
            </svg>
        </td>
        <td>
            <a href="Sources/Geometria/Generalized/Triangle.swift">Triangle.swift</a>
        </td>
        <td>
            Defined as a set of three point vectors.
        </td>
    </tr>
</table>
