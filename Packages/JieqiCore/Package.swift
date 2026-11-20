// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "JieqiCore",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(name: "JieqiCore", targets: ["JieqiCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/6tail/lunar-swift.git", exact: "1.1.9"),
    ],
    targets: [
        .target(
            name: "JieqiCore",
            dependencies: [
                .product(name: "LunarSwift", package: "lunar-swift"),
            ]
        ),
    ]
)
