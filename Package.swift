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
        // 保留原始 binary target
        .binaryTarget(
            name: "NativeScript",
            path: "NativeScript.xcframework"
        ),
        // 创建一个简单的 wrapper target，不指定自定义路径
        .target(
            name: "NativeScriptWrapper",
            dependencies: ["NativeScript"],
            // 不指定 path，使用默认的 Sources/NativeScriptWrapper
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include"),
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("UIKit"),
                .linkedFramework("JavaScriptCore"),
            ]
        )
    ]
)