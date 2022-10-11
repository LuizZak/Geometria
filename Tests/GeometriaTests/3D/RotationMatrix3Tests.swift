import XCTest
import Geometria

class RotationMatrix3Tests: XCTestCase {
    typealias RotationMatrix = RotationMatrix3D
    typealias Vector = Vector3D

    let accuracy: Double = 1e-16

    // MARK: Full 3-axis rotations

    func testMake3DRotation_xyz_rightHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .xyz,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, ( 0.35355339059327384, 0.3535533905932738,  0.8660254037844386    ))
        assertEqual(sut.r1, ( 0.6123724356957946,  0.6123724356957945, -0.5000000000000001    ))
        assertEqual(sut.r2, (-0.7071067811865475,  0.7071067811865476,  3.0616169978683836e-17))
    }

    func testMake3DRotation_xyz_leftHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .xyz,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, ( 0.35355339059327384, -0.3535533905932738 , -0.8660254037844386    ))
        assertEqual(sut.r1, ( 0.6123724356957946 ,  -0.6123724356957945,  0.5000000000000001    ))
        assertEqual(sut.r2, (-0.7071067811865475 , -0.7071067811865476 ,  3.0616169978683836e-17))
    }

    func testMake3DRotation_xzy_rightHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .xzy,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, ( 0.35355339059327384,  0.8660254037844386    ,  0.3535533905932738))
        assertEqual(sut.r1, ( 0.7071067811865475 ,  3.0616169978683836e-17, -0.7071067811865476))
        assertEqual(sut.r2, (-0.6123724356957946 , 0.5000000000000001     , -0.6123724356957945))
    }

    func testMake3DRotation_xzy_leftHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .xzy,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, ( 0.35355339059327384, -0.8660254037844386    , -0.3535533905932738))
        assertEqual(sut.r1, ( 0.7071067811865475 ,  3.0616169978683836e-17,  0.7071067811865476))
        assertEqual(sut.r2, (-0.6123724356957946 , -0.5000000000000001    ,  0.6123724356957945))
    }

    func testMake3DRotation_yxz_rightHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .yxz,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, (-0.6123724356957945 ,  0.6123724356957946 ,  0.5000000000000001    ))
        assertEqual(sut.r1, (-0.3535533905932738 , 0.35355339059327384 , -0.8660254037844386    ))
        assertEqual(sut.r2, (-0.7071067811865476 , -0.7071067811865475 ,  3.0616169978683836e-17))
    }

    func testMake3DRotation_yxz_leftHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .yxz,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, ( 0.6123724356957945,  0.6123724356957946 , -0.5000000000000001    ))
        assertEqual(sut.r1, ( 0.3535533905932738,  0.35355339059327384,  0.8660254037844386    ))
        assertEqual(sut.r2, ( 0.7071067811865476, -0.7071067811865475 ,  3.0616169978683836e-17))
    }

    func testMake3DRotation_yzx_rightHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .yzx,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, ( 3.0616169978683836e-17,  0.7071067811865475 ,  0.7071067811865476))
        assertEqual(sut.r1, (-0.8660254037844386    ,  0.35355339059327384, -0.3535533905932738))
        assertEqual(sut.r2, (-0.5000000000000001    , -0.6123724356957946 ,  0.6123724356957945))
    }

    func testMake3DRotation_yzx_leftHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .yzx,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, (3.0616169978683836e-17,  0.7071067811865475, -0.7071067811865476))
        assertEqual(sut.r1, (0.8660254037844386    , 0.35355339059327384,  0.3535533905932738))
        assertEqual(sut.r2, (0.5000000000000001    , -0.6123724356957946, -0.6123724356957945))
    }

    func testMake3DRotation_zxy_rightHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .zxy,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, ( 0.6123724356957945, 0.5000000000000001    , -0.6123724356957946 ))
        assertEqual(sut.r1, (-0.7071067811865476, 3.0616169978683836e-17, -0.7071067811865475 ))
        assertEqual(sut.r2, (-0.3535533905932738, 0.8660254037844386    ,  0.35355339059327384))
    }

    func testMake3DRotation_zxy_leftHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .zxy,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, (-0.6123724356957945, -0.5000000000000001    , -0.6123724356957946 ))
        assertEqual(sut.r1, ( 0.7071067811865476,  3.0616169978683836e-17, -0.7071067811865475 ))
        assertEqual(sut.r2, ( 0.3535533905932738, -0.8660254037844386    ,  0.35355339059327384))
    }

    func testMake3DRotation_zyx_rightHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .zyx,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, ( 3.0616169978683836e-17,  0.7071067811865476, -0.7071067811865475 ))
        assertEqual(sut.r1, (-0.5000000000000001    , -0.6123724356957945, -0.6123724356957946 ))
        assertEqual(sut.r2, (-0.8660254037844386    ,  0.3535533905932738,  0.35355339059327384))
    }

    func testMake3DRotation_zyx_leftHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .zyx,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, (3.0616169978683836e-17, -0.7071067811865476, -0.7071067811865475 ))
        assertEqual(sut.r1, (0.5000000000000001    ,  0.6123724356957945, -0.6123724356957946 ))
        assertEqual(sut.r2, (0.8660254037844386    , -0.3535533905932738,  0.35355339059327384))
    }

    func testMake3DRotation_zxz_rightHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .zxz,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, (-0.35355339059327373,  0.3535533905932739, -0.8660254037844386   ))
        assertEqual(sut.r1, (-0.7071067811865476 , -0.7071067811865475, -5.302876193624534e-17))
        assertEqual(sut.r2, (-0.6123724356957945 ,  0.6123724356957946,  0.5000000000000001   ))
    }

    func testMake3DRotation_zxz_leftHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .zxz,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, (-0.35355339059327373, -0.3535533905932739, -0.8660254037844386   ))
        assertEqual(sut.r1, ( 0.7071067811865476 , -0.7071067811865475,  5.302876193624534e-17))
        assertEqual(sut.r2, (-0.6123724356957945 , -0.6123724356957946,  0.5000000000000001   ))
    }

    func testMake3DRotation_xzx_rightHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .xzx,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, ( 0.5000000000000001   ,  0.6123724356957946, -0.6123724356957945 ))
        assertEqual(sut.r1, (-5.302876193624534e-17, -0.7071067811865475, -0.7071067811865476 ))
        assertEqual(sut.r2, (-0.8660254037844386   ,  0.3535533905932739, -0.35355339059327373))
    }

    func testMake3DRotation_xzx_leftHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .xzx,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, ( 0.5000000000000001   , -0.6123724356957946, -0.6123724356957945 ))
        assertEqual(sut.r1, ( 5.302876193624534e-17, -0.7071067811865475,  0.7071067811865476 ))
        assertEqual(sut.r2, (-0.8660254037844386   , -0.3535533905932739, -0.35355339059327373))
    }

    func testMake3DRotation_yxy_rightHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .yxy,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, (-0.35355339059327373, 0.8660254037844386   ,  0.3535533905932739))
        assertEqual(sut.r1, ( 0.6123724356957945 , 0.5000000000000001   , -0.6123724356957946))
        assertEqual(sut.r2, (-0.7071067811865476 , 5.302876193624534e-17, -0.7071067811865475))
    }

    func testMake3DRotation_yxy_leftHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .yxy,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, (-0.35355339059327373,  0.8660254037844386   , -0.3535533905932739))
        assertEqual(sut.r1, ( 0.6123724356957945 ,  0.5000000000000001   ,  0.6123724356957946))
        assertEqual(sut.r2, ( 0.7071067811865476 , -5.302876193624534e-17, -0.7071067811865475))
    }

    func testMake3DRotation_xyx_rightHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .xyx,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, ( 0.5000000000000001   ,  0.6123724356957945 ,  0.6123724356957946))
        assertEqual(sut.r1, ( 0.8660254037844386   , -0.35355339059327373, -0.3535533905932739))
        assertEqual(sut.r2, (-5.302876193624534e-17,  0.7071067811865476 , -0.7071067811865475))
    }

    func testMake3DRotation_xyx_leftHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .xyx,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, (0.5000000000000001   ,  0.6123724356957945    , -0.6123724356957946))
        assertEqual(sut.r1, (0.8660254037844386   , -0.35355339059327373   ,  0.3535533905932739))
        assertEqual(sut.r2, (5.302876193624534e-17, -0.7071067811865476    , -0.7071067811865475))
    }

    func testMake3DRotation_zyz_rightHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .zyz,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, (-0.7071067811865475,  0.7071067811865476 ,  5.302876193624534e-17))
        assertEqual(sut.r1, (-0.3535533905932739, -0.35355339059327373, -0.8660254037844386   ))
        assertEqual(sut.r2, (-0.6123724356957946, -0.6123724356957945 ,  0.5000000000000001   ))
    }

    func testMake3DRotation_zyz_leftHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .zyz,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, (-0.7071067811865475, -0.7071067811865476 , -5.302876193624534e-17))
        assertEqual(sut.r1, ( 0.3535533905932739, -0.35355339059327373, -0.8660254037844386   ))
        assertEqual(sut.r2, ( 0.6123724356957946, -0.6123724356957945 ,  0.5000000000000001   ))
    }

    func testMake3DRotation_yzy_rightHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .yzy,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, (-0.7071067811865475,  5.302876193624534e-17,  0.7071067811865476 ))
        assertEqual(sut.r1, (-0.6123724356957946,  0.5000000000000001   , -0.6123724356957945 ))
        assertEqual(sut.r2, (-0.3535533905932739, -0.8660254037844386   , -0.35355339059327373))
    }

    func testMake3DRotation_yzy_leftHanded() {
        let sut = RotationMatrix
            .make3DRotation(
                .pi / 2,
                .pi / 3,
                .pi / 4,
                order: .yzy,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, (-0.7071067811865475, -5.302876193624534e-17, -0.7071067811865476 ))
        assertEqual(sut.r1, ( 0.6123724356957946,  0.5000000000000001   , -0.6123724356957945 ))
        assertEqual(sut.r2, ( 0.3535533905932739, -0.8660254037844386   , -0.35355339059327373))
    }

    // MARK: Individual axis rotations

    func testMake3DRotationX_rightHanded() {
        let sut = RotationMatrix
            .make3DRotationX(
                .pi / 2,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, (1.0, 0.0                  ,  0.0                  ))
        assertEqual(sut.r1, (0.0, 6.123233995736766e-17, -1.0                  ))
        assertEqual(sut.r2, (0.0, 1.0                  ,  6.123233995736766e-17))
    }

    func testMake3DRotationX_leftHanded() {
        let sut = RotationMatrix
            .make3DRotationX(
                .pi / 2,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, (1.0,  0.0                  , 0.0                  ))
        assertEqual(sut.r1, (0.0,  6.123233995736766e-17, 1.0                  ))
        assertEqual(sut.r2, (0.0, -1.0                  , 6.123233995736766e-17))
    }

    func testMake3DRotationY_rightHanded() {
        let sut = RotationMatrix
            .make3DRotationY(
                .pi / 2,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, ( 6.123233995736766e-17, 0.0, 1.0                  ))
        assertEqual(sut.r1, ( 0.0                  , 1.0, 0.0                  ))
        assertEqual(sut.r2, (-1.0                  , 0.0, 6.123233995736766e-17))
    }

    func testMake3DRotationY_leftHanded() {
        let sut = RotationMatrix
            .make3DRotationY(
                .pi / 2,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, (6.123233995736766e-17, 0.0, -1.0                  ))
        assertEqual(sut.r1, (0.0                  , 1.0,  0.0                  ))
        assertEqual(sut.r2, (1.0                  , 0.0,  6.123233995736766e-17))
    }

    func testMake3DRotationZ_rightHanded() {
        let sut = RotationMatrix
            .make3DRotationY(
                .pi / 2,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, ( 6.123233995736766e-17, 0.0, 1.0                  ))
        assertEqual(sut.r1, ( 0.0                  , 1.0, 0.0                  ))
        assertEqual(sut.r2, (-1.0                  , 0.0, 6.123233995736766e-17))
    }

    func testMake3DRotationZ_leftHanded() {
        let sut = RotationMatrix
            .make3DRotationY(
                .pi / 2,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, (6.123233995736766e-17, 0.0, -1.0                  ))
        assertEqual(sut.r1, (0.0                  , 1.0,  0.0                  ))
        assertEqual(sut.r2, (1.0                  , 0.0,  6.123233995736766e-17))
    }

    // MARK: Axis-angle rotation

    func testMake3DRotationFromAxisAngle_rightHanded() {
        let sut = RotationMatrix
            .make3DRotationFromAxisAngle(
                axis: Vector(x: 1, y: 2, z: 3),
                .pi / 2,
                orientation: .rightHanded
            )

        assertEqual(sut.r0, ( 0.07142857142857148, -0.6589265828801303 , 0.7488081981105631 ))
        assertEqual(sut.r1, ( 0.9446408685944161 ,  0.28571428571428575, 0.16131018665900415))
        assertEqual(sut.r2, (-0.3202367695391345 ,  0.6958326704838529 , 0.6428571428571429 ))
    }

    func testMake3DRotationFromAxisAngle_leftHanded() {
        let sut = RotationMatrix
            .make3DRotationFromAxisAngle(
                axis: Vector(x: 1, y: 2, z: 3),
                .pi / 2,
                orientation: .leftHanded
            )

        assertEqual(sut.r0, ( 0.07142857142857148, 0.9446408685944161 , -0.3202367695391345))
        assertEqual(sut.r1, (-0.6589265828801303 , 0.28571428571428575,  0.6958326704838529))
        assertEqual(sut.r2, ( 0.7488081981105631 , 0.16131018665900415,  0.6428571428571429))
    }

    // MARK: Angle between vectors rotation

    func testMake3DRotationBetween_axialVectors_rightHanded() {
        let a = Vector(x: 1, y: 0, z: 0)
        let b = Vector(x: 0, y: 1, z: 0)

        let sut = RotationMatrix.make3DRotationBetween(a, b, orientation: .rightHanded)

        let rotated = sut.transformPoint(a)
        assertEqual(rotated, b, accuracy: accuracy)
        assertEqual(sut.r0, (6.123233995736766e-17, -1.0                  , 0.0))
        assertEqual(sut.r1, (1.0                  ,  6.123233995736766e-17, 0.0))
        assertEqual(sut.r2, (0.0                  ,  0.0                  , 1.0))
    }

    func testMake3DRotationBetween_axialVectors_leftHanded() {
        let a = Vector(x: 1, y: 0, z: 0)
        let b = Vector(x: 0, y: 1, z: 0)

        let sut = RotationMatrix.make3DRotationBetween(a, b, orientation: .leftHanded)

        let rotated = sut.transformPoint(a)
        assertEqual(rotated, -b, accuracy: accuracy)
        assertEqual(sut.r0, ( 6.123233995736766e-17, 1.0                  , 0.0))
        assertEqual(sut.r1, (-1.0                  , 6.123233995736766e-17, 0.0))
        assertEqual(sut.r2, ( 0.0                  , 0.0                  , 1.0))
    }

    func testMake3DRotationBetween_equalDirectionVectors() {
        let a = Vector(x: 1, y: 0, z: 0)
        let b = Vector(x: 2, y: 0, z: 0)

        let sut = RotationMatrix.make3DRotationBetween(a, b, orientation: .rightHanded)

        XCTAssertEqual(sut, .identity)
    }

    func testMake3DRotationBetween_oppositeDirectionVectors_rightHanded() {
        let a = Vector(x: 1, y: 0, z: 0)
        let b = Vector(x: -1, y: 0, z: 0)

        let sut = RotationMatrix.make3DRotationBetween(a, b, orientation: .rightHanded)

        let rotated = sut.transformPoint(a)
        assertEqual(rotated, b, accuracy: accuracy)
        assertEqual(sut.r0, (-1.0,  0.0,  0.0))
        assertEqual(sut.r1, ( 0.0, -1.0,  0.0))
        assertEqual(sut.r2, ( 0.0,  0.0, -1.0))
    }

    func testMake3DRotationBetween_oppositeDirectionVectors_leftHanded() {
        let a = Vector(x: 1, y: 0, z: 0)
        let b = Vector(x: -1, y: 0, z: 0)

        let sut = RotationMatrix.make3DRotationBetween(a, b, orientation: .leftHanded)

        let rotated = sut.transformPoint(a)
        assertEqual(rotated, b, accuracy: accuracy)
        assertEqual(sut.r0, (-1.0,  0.0,  0.0))
        assertEqual(sut.r1, ( 0.0, -1.0,  0.0))
        assertEqual(sut.r2, ( 0.0,  0.0, -1.0))
    }
}
