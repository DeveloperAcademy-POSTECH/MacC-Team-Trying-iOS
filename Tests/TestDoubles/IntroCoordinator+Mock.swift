//
//  IntroCoordinator+Mock.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
@testable import MatStar

final class MockIntroCoordinator: IntroCoordinatorProtocol {
    var navigationController: UINavigationController?
    var coordinateToEnterEmailSceneCount: Int = 0
    func coordinateToEnterEmailScene() {
        coordinateToEnterEmailSceneCount += 1
    }
}
