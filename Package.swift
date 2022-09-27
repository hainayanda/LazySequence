// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "LazySequence",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_10),
        .tvOS(.v10)
    ],
    products: [
        .library(
            name: "LazySequence",
            targets: ["LazySequence"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/hainayanda/Chary.git", from: "1.0.3"),
        // uncomment code below to test
//        .package(url: "https://github.com/Quick/Quick.git", from: "5.0.1"),
//        .package(url: "https://github.com/Quick/Nimble.git", from: "10.0.0")
    ],
    targets: [
        .target(
            name: "LazySequence",
            dependencies: ["Chary"],
            path: "LazySequence/Classes"
        ),
        // uncomment code below to test
//        .testTarget(
//            name: "LazySequenceTests",
//            dependencies: [
//                "LazySequence", "Quick", "Nimble"
//            ],
//            path: "Example/Tests",
//            exclude: ["Info.plist"]
//        )
    ]
)
