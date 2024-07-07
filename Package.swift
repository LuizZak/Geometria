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

let testCommons: Target = .target(
    name: "TestCommons",
    dependencies: [
        .product(name: "MiniP5Printer", package: "MiniP5Printer"),
        "Geometria",
        "GeometriaAlgorithms",
        "GeometriaPeriodics",
    ]
)

// Geometria
let geometriaTarget: Target = .target(
    name: "Geometria",
    dependencies: geometriaDependencies,
    swiftSettings: []
)
let geometriaTestsTarget: Target = .testTarget(
    name: "GeometriaTests",
    dependencies: ["Geometria", "TestCommons"],
    swiftSettings: []
)

// GeometriaAlgorithms
let geometriaAlgorithmsTarget: Target = .target(
    name: "GeometriaAlgorithms",
    dependencies: geometriaDependencies + ["Geometria"],
    swiftSettings: []
)
let geometriaAlgorithmsTestTarget: Target = .testTarget(
    name: "GeometriaAlgorithmsTests",
    dependencies: geometriaDependencies + ["GeometriaAlgorithms", "TestCommons"],
    swiftSettings: []
)

// GeometriaPeriodics
let geometriaPeriodicsTarget: Target = .target(
    name: "GeometriaPeriodics",
    dependencies: geometriaDependencies + ["Geometria", .product(name: "MiniDigraph", package: "MiniDigraph")],
    swiftSettings: []
)
let geometriaPeriodicsTestTarget: Target = .testTarget(
    name: "GeometriaPeriodicsTests",
    dependencies: geometriaDependencies + ["GeometriaPeriodics", "TestCommons"],
    swiftSettings: []
)

let package = Package(
    name: "Geometria",
    products: [
        .library(
            name: "Geometria",
            targets: ["Geometria"]
        ),
        .library(
            name: "GeometriaAlgorithms",
            targets: ["GeometriaAlgorithms"]
        ),
        .library(
            name: "GeometriaPeriodics",
            targets: ["GeometriaPeriodics"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics.git", from: "1.0.0"),
        .package(url: "https://github.com/LuizZak/MiniP5Printer.git", .exactItem("0.0.2")),
        .package(url: "https://github.com/LuizZak/MiniDigraph.git", .exactItem("0.5.0")),
    ],
    targets: [
        geometriaTarget.applyReportBuildTime(),
        geometriaTestsTarget.applyReportBuildTime(),
        geometriaAlgorithmsTarget.applyReportBuildTime(),
        geometriaAlgorithmsTestTarget.applyReportBuildTime(),
        geometriaPeriodicsTarget.applyReportBuildTime(),
        geometriaPeriodicsTestTarget.applyReportBuildTime(),
        testCommons,
    ]
)

extension Target {
    func applyReportBuildTime() -> Self {
        guard ProcessInfo.processInfo.environment["REPORT_BUILD_TIME"] == "YES" else {
            return self
        }

        if swiftSettings == nil {
            swiftSettings = []
        }

        swiftSettings?.append(contentsOf: reportingSwiftSettings)

        return self
    }
}
