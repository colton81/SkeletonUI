// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "SkeletonUI",
    platforms: [
        .iOS(.v16),
        .tvOS(.v13),
        .watchOS(.v6),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SkeletonUI",
            targets: ["SkeletonUI"]
        )
    ],
    dependencies: [
       
    ],
    targets: [
        .target(
            name: "SkeletonUI"
        ),
        .testTarget(
            name: "SkeletonUISnapshotTests",
            dependencies: ["SkeletonUI"]
        ),
        .testTarget(
            name: "SkeletonUIUnitTests",
            dependencies: ["SkeletonUI"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
