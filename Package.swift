// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "NativeScriptSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "NativeScriptSDK",
            targets: ["NativeScriptWrapper"]),
    ],
    dependencies: [],
    targets: [
        // 保留原始 binary target 作为依赖
        .binaryTarget(
            name: "NativeScriptCore",
            path: "NativeScript.xcframework"
        ),
        // 添加 wrapper target 来改善链接行为
        .target(
            name: "NativeScriptWrapper",
            dependencies: ["NativeScriptCore"],
            path: "Sources/Wrapper",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include"),
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("UIKit"),
                .linkedFramework("JavaScriptCore"),
            ]
        )
    ]
)