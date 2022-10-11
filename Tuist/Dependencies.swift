//
//  Dependencies.swift
//  Config
//
//  Created by 김승창 on 2022/10/11.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/devxoul/CancelBag", requirement: .upToNextMajor(from: "1")),
        .remote(url: "https://github.com/layoutBox/FlexLayout.git", requirement: .exact("1.3.18")),
        .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.0.1"))
    ],
    platforms: [.iOS]
)
