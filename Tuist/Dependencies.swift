//
//  Dependencies.swift
//  Config
//
//  Created by 김승창 on 2022/10/11.
//

import ProjectDescription

let dependencies = Dependencies(
    carthage: .init(
        [
            .github(path: "airbnb/lottie-ios", requirement: .branch("master")),
            .github(path: "layoutBox/FlexLayout", requirement: .branch("master")),
            .github(path: "layoutBox/PinLayout", requirement: .branch("master"))
        ]
    ),
    swiftPackageManager: [
        .remote(url: "https://github.com/devxoul/CancelBag", requirement: .upToNextMajor(from: "1")),
        .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.0.1"))
    ],
    platforms: [.iOS]
)
