/// Represents a 3D axis-aligned bounding box with two double-precision
/// floating-point vectors that describe the minimal and maximal coordinates
/// of the box's opposite corners.
public typealias AABB3D = AABB3<Vector3D>

/// Represents a 3D axis-aligned bounding box with two single-precision
/// floating-point vectors that describe the minimal and maximal coordinates
/// of the box's opposite corners.
public typealias AABB3F = AABB3<Vector3F>

/// Represents a 3D axis-aligned bounding box with two integer vectors that
/// describe the minimal and maximal coordinates of the box's opposite corners.
public typealias AABB3i = AABB3<Vector3i>

/// Typealias for `AABB<V>`, where `V` is constrained to ``Vector3Type``.
public typealias AABB3<V: Vector3Type> = AABB<V>

extension AABB3: Convex3Type where Vector: Vector3FloatingPoint {
    
}

extension AABB3: ClosestPointQueryGeometry where Vector: Vector3FloatingPoint {
    public func closestPointTo<LineT: LineFloatingPoint>(line: LineT) -> ClosestPointQueryResult<Vector> where LineT.Vector == Vector {
        let infiniteLine = Line(line)

        // Check for intersection first
        switch intersection(with: infiniteLine) {
        case .enter(let pn),
            .exit(let pn),
            .enterExit(let pn, _),
            .singlePoint(let pn):

            let pOnLine = line.project(pn.point)
            if pOnLine == pn.point {
                return .intersection
            }
            
            return .closest(clamp(pOnLine))

        case .contained:
            return .intersection

        case .noIntersection:
            break
        }

        let center = self.center

        let centerOnLine = line.project(center)
        guard let closestVertex = vertices.closestPoint(to: centerOnLine) else {
            return .closest(centerOnLine)
        }

        // Fetch the octant of the closest vertex with respect to the center of
        // the AABB so we can have a magnitude measure which can be mapped back
        // into vertices by multiplying by `center + octant * octantSign`, where
        // the `octantSign` is a vector of `1` scalars, where one scalar is `-1`.
        let octantOffset = closestVertex - center

        // Neighbor octants are the octants with a single sign flip on each
        // coordinate (three total for any octant)
        let nOctant1 = center + octantOffset * Vector(x: -1, y:  1, z:  1)
        let nOctant2 = center + octantOffset * Vector(x:  1, y: -1, z:  1)
        let nOctant3 = center + octantOffset * Vector(x:  1, y:  1, z: -1)
        
        let edge1 = LineSegment(start: closestVertex, end: nOctant1)
        let edge2 = LineSegment(start: closestVertex, end: nOctant2)
        let edge3 = LineSegment(start: closestVertex, end: nOctant3)

        let closestEdge1 = edge1.shortestLine(to: line)?.start
        let closestEdge2 = edge2.shortestLine(to: line)?.start
        let closestEdge3 = edge3.shortestLine(to: line)?.start

        guard
            let edge1 = closestEdge1 ?? closestEdge2 ?? closestEdge3,
            let edge2 = closestEdge2 ?? closestEdge3 ?? closestEdge1,
            let edge3 = closestEdge3 ?? closestEdge1 ?? closestEdge2
        else {
            return .closest(centerOnLine)
        }

        let edge1d = edge1.distanceSquared(to: centerOnLine)
        let edge2d = edge2.distanceSquared(to: centerOnLine)
        let edge3d = edge3.distanceSquared(to: centerOnLine)

        if edge1d < edge2d && edge1d < edge3d {
            return .closest(edge1)
        }
        if edge2d < edge3d && edge2d < edge1d {
            return .closest(edge2)
        }

        return .closest(edge3)
    }
}
