//
//  Scripts.swift
//  Config
//
//  Created by 김승창 on 2022/10/13.
//

import ProjectDescription

public extension TargetScript {
    static let SwiftLintShell = TargetScript.pre(
        path: .relativeToRoot("Scripts/SwiftLint/set_swiftlint.sh"),
        name: "SwiftLintShell"
    )
}
