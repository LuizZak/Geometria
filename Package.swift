// swift-tools-version:5.3
import PackageDescription
import class Foundation.ProcessInfo

let geometriaDependencies: [Target.Dependency] = [
    .product(name: "Numerics", package: "swift-numerics")
]
let reportingSwiftSettings: [SwiftSetting] = [
    .unsafeFlags([
        "-driver-time-compilation",
        "-Xfrontend",
        "-warn-long-function-bodies=500",
        "-Xfrontend",
        "-warn-long-expression-type-checking=50"
    ])
]

let geometriaTarget: Target = .target(
    name: "Geometria",
    dependencies: geometriaDependencies,
    swiftSettings: []
)
let geometriaTestsTarget: Target = .testTarget(
    name: "GeometriaTests",
    dependencies: ["Geometria"],
    swiftSettings: []
)
let geometriaAlgorithmsTarget: Target = .target(
    name: "GeometriaAlgorithms",
    dependencies: geometriaDependencies + ["Geometria"],
    swiftSettings: []
)
let geometriaAlgorithmsTestTarget: Target = .testTarget(
    name: "GeometriaAlgorithmsTests",
    dependencies: geometriaDependencies + ["GeometriaAlgorithms"],
    swiftSettings: []
)

if ProcessInfo.processInfo.environment["REPORT_BUILD_TIME"] == "YES" {
    geometriaTarget.swiftSettings?.append(contentsOf: reportingSwiftSettings)
    geometriaTestsTarget.swiftSettings?.append(contentsOf: reportingSwiftSettings)
    geometriaAlgorithmsTarget.swiftSettings?.append(contentsOf: reportingSwiftSettings)
    geometriaAlgorithmsTestTarget.swiftSettings?.append(contentsOf: reportingSwiftSettings)
}

let package = Package(
    name: "Geometria",
    products: [
        .library(
            name: "Geometria",
            targets: ["Geometria"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0"),
    ],
    targets: [
        geometriaTarget,
        geometriaTestsTarget,
        geometriaAlgorithmsTarget,
        geometriaAlgorithmsTestTarget,
    ]
)
