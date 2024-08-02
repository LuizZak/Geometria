# GeometriaClipping Overview

This document contains information about concepts used by the `GeometriaClipping` extension library contained within this package.

`GeometriaClipping` is a 2-dimensional parametric clipping package that works on lines and circular arcs, reduced as 'simplexes', which compose larger objects called 'parametric geometries'.

Parametric Simplex
---

- Represents the simplest drawing operation, a line or a circular arc;
- Contains a startPeriod/endPeriod, which defines when it should be stroked
    when drawing from say 0-1 in its parent geometry. Simplexes are chained in
    sequence, with the end period of a simplex connecting directly into the next
    simplex's start period;
- Needs to be 'clampable' between a range (start, end], where the result is
    the same stroke operation, but cut to be within range cut to
    (max(startPeriod, start), min(endPeriod, end)]. This affects the end points
    of the stroke in relative terms, so e.g. a clamp of (startPeriod, (endPeriod - startPeriod) / 
    2]
    results in the same start point, but an ending point halfway around the stroke
    path;
- Needs to be 'computable' @ period 'p', effectively computing a global point
    on the line/arc at the given period relative to its startPeriod/endPeriod;
- Needs to have an intersection function defined that returns periods on
    any input pair of simplexes simplex1/simplex2, as pairs of periods (period1, period2)
    that must map to the same global point 'p' when computed with the rule above -
    this is required for the intersection process.

Parametric Geometry
---

- Composed of sequential simplexes joined end-to-end, looping back around to
    the start at 'endPeriod';
- Has a global startPeriod/endPeriod that matches the one of the simplexes;
- Periods are comparable and wrap around, so endPeriod + n is the same as
    startPeriod + n, assuming 'n' is < endPeriod - startPeriod - this only holds
    true for geometries and not simplexes as they don't have any notion of 'wrapping'
    by themselves;
- Needs a 'contains' function that queries for a global point's containment;
- Needs a 'simplexes in range' that performs a clamp of simplexes within a given
    range (start, end] using the 'clampable' property of simplexes, dropping simplexes
    that are completely out of the range;
- Has a 'compute at' function that takes a period 'p' and produces an appropriate
    global point using the simplexes and their periods.

Intersections
---

- With the intersection function defined for simplexes, intersecting parametric
    geometries results in a list of pairs for all possible intersections between
    each simplex in geometry1/geometry2.

Example: Union operation
---

- Takes as input two geometries, geometry1/geometry2, and returns up to two geometries;
- Start with collecting all intersections of geometry1/geometry2;
- Query if there are any intersections at all;
    - If not, check for containment using each period geometry's 'compute at' and
        'contains' function, and the result is the appropriate geometry not contained
        within the other;
    - If neither geometry is contained within the other, the result is a tuple
        of (geometry1, geometry2).
- Start by querying a random starting point on geometry1, and check if it is contained
    within geometry2;
    - If so, find the next intersection on geometry1 past the starting point;
    - If not, find instead the _previous_ intersection on geometry1.
- Loop around the geometries, keeping track of which intersections have been seen, and
    repeat the following, starting with 'current' as geometry1 and 'current point'
    as the point computed above:
    - Compute the 'next' intersection point on the current geometry;
    - Store current's 'simplex in range' ('current point', 'next point'];
    - At the end, store 'next' as 'current', and flip the current geometry
        being stroked from geometry1/geometry2;
    - Repeat until 'current' has already been visited.
- The result is then a parametric geometry of all the simplexes collected.
