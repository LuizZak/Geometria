// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Geometria",
    products: [
        .library(
            name: "Geometria",
            targets: ["Geometria"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "Geometria",
            dependencies: [.product(name: "Numerics", package: "swift-numerics")]),
        .testTarget(
            name: "GeometriaTests",
            dependencies: ["Geometria"]),
    ]
)
