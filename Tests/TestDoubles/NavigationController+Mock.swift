//
//  NavigationController+Mock.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
@testable import MatStar

final class MockNavigationController: UINavigationController {
    var pushViewControllerCalled: Bool = false
    var pushedViewController: UIViewController?
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        pushViewControllerCalled = true
        pushedViewController = viewController
    }
}
