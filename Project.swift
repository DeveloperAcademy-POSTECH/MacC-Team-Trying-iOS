import ProjectDescription
import ProjectDescriptionHelpers

let projectName: String = "ComeIt"

let project = Project(
    name: projectName,
    organizationName: "Try-ing",
    options: .options(
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    targets: [
        Target(
            name: projectName,
            platform: .iOS,
            product: .app,
            bundleId: "com.Try-ing.\(projectName)",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .file(path: "SupportingFiles/\(projectName)-Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: [.SwiftLintShell],
            dependencies: [
                .external(name: "CancelBag"),
                .external(name: "FlexLayout"),
                .external(name: "Lottie"),
                .external(name: "PinLayout"),
                .external(name: "SnapKit")
            ]
        ),
        Target(
            name: "\(projectName)Tests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.Try-ing.\(projectName)Tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: projectName)]
        )
    ]
)
