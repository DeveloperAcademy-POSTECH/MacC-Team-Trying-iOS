import ProjectDescription
import ProjectDescriptionHelpers

let productName: String = "우주라이크"
let projectName: String = "ComeIt"

let project = Project(
    name: productName,
    organizationName: "Try-ing",
    options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    settings: .settings(
        base: ["OTHER_LDFLAGS" : "$(OTHER_LDFLAGS) -ObjC"],
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ],
        defaultSettings: .recommended
    ),
    targets: [
        Target(
            name: productName,
            platform: .iOS,
            product: .app,
            bundleId: "com.Try-ing.\(projectName)",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .file(path: "SupportingFiles/\(projectName)-Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: "SupportingFiles/\(projectName).entitlements",
            scripts: [.SwiftLintShell],
            dependencies: [
                .external(name: "CancelBag"),
                .external(name: "FirebaseMessaging"),
                .external(name: "Lottie"),
                .external(name: "SnapKit"),
                .external(name: "KakaoSDKUser")
            ]
        ),
        Target(
            name: "\(productName)Tests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.Try-ing.\(projectName)Tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: productName)]
        )
    ]
)
