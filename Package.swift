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
            targets: ["NativeScript"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NativeScript",
            dependencies: [],
            path: "Sources/NativeScript",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include"),
                .headerSearchPath("include/runtime"),
                .define("NS_ENABLE_RUNTIME", to: "1"),
            ],
            cxxSettings: [
                .headerSearchPath("include"),
                .headerSearchPath("include/runtime"),
                .define("NS_ENABLE_RUNTIME", to: "1"),
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx)
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("UIKit"),
                .linkedFramework("JavaScriptCore"),
                .linkedLibrary("c++"),
                .linkedLibrary("z"),
                .linkedLibrary("sqlite3"),
            ]
        )
    ],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx17
)