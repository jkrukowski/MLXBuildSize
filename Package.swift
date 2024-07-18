// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "MLXBuildSize",
    platforms: [
        .iOS(.v16),
        .macOS("13.3")
    ],
    products: [
        .library(
            name: "MLXBuildSize",
            targets: ["MLXBuildSize"]
        ),
        .executable(
            name: "mlxbuildsize-cli",
            targets: ["MLXBuildSizeCLI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ml-explore/mlx-swift", exact: "0.16.0")
    ],
    targets: [
        .target(
            name: "MLXBuildSize",
            dependencies: [
                .product(name: "MLX", package: "mlx-swift"),
                .product(name: "MLXFFT", package: "mlx-swift"),
                .product(name: "MLXNN", package: "mlx-swift")
            ]
        ),
        .executableTarget(
            name: "MLXBuildSizeCLI",
            dependencies: [
                "MLXBuildSize"
            ]
        )
    ]
)
