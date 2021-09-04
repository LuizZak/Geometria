// swift-tools-version:5.3
import PackageDescription
import class Foundation.ProcessInfo

let swiftSettings: [SwiftSetting]
if let _ = ProcessInfo.processInfo.environment["REPORT_BUILD_TIME"] {
    swiftSettings = [
        .unsafeFlags([
            "-Xfrontend",
            "-warn-long-function-bodies=600",
            "-Xfrontend",
            "-warn-long-expression-type-checking=100"
        ])
    ]
} else {
    swiftSettings = []
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
        .target(
            name: "Geometria",
            dependencies: [
                .product(name: "Numerics", package: "swift-numerics")
            ],
            swiftSettings: swiftSettings),
        .testTarget(
            name: "GeometriaTests",
            dependencies: ["Geometria"]),
    ]
)
