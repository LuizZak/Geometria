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

let geometriaTarget: Target
let geometriaTestsTarget: Target
if ProcessInfo.processInfo.environment["REPORT_BUILD_TIME"] == "YES" {
    geometriaTarget = .target(
        name: "Geometria",
        dependencies: geometriaDependencies,
        swiftSettings: reportingSwiftSettings)
    
    geometriaTestsTarget = .testTarget(
        name: "GeometriaTests",
        dependencies: ["Geometria"],
        swiftSettings: reportingSwiftSettings
    )
} else {
    geometriaTarget = .target(
        name: "Geometria",
        dependencies: geometriaDependencies
    )
    
    geometriaTestsTarget = .testTarget(
        name: "GeometriaTests",
        dependencies: ["Geometria"]
    )
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
    ]
)
