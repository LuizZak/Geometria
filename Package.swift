// swift-tools-version:5.3
import PackageDescription
import class Foundation.ProcessInfo

let geometriaDependencies: [Target.Dependency] = [
    .product(name: "Numerics", package: "swift-numerics")
]

let geometriaTarget: Target
if let _ = ProcessInfo.processInfo.environment["REPORT_BUILD_TIME"] {
    geometriaTarget = .target(
        name: "Geometria",
        dependencies: geometriaDependencies,
        swiftSettings: [
            .unsafeFlags([
                "-Xfrontend",
                "-warn-long-function-bodies=600",
                "-Xfrontend",
                "-warn-long-expression-type-checking=100"
            ])
        ])
} else {
    geometriaTarget = .target(
        name: "Geometria",
        dependencies: geometriaDependencies)
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
        .testTarget(
            name: "GeometriaTests",
            dependencies: ["Geometria"]),
    ]
)
