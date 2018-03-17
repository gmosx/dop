// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Dop",
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "DopJobs",
            dependencies: [
            ]
        ),
        .target(
            name: "dop",
            dependencies: [
                "Utility",
                "DopJobs",
            ]
        ),
    ]
)
