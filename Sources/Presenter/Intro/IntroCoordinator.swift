//
//  IntroCoordinator.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class IntroCoordinator: Coordinator {
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let startController = createLoginScene()
        navigationController?.setViewControllers([startController], animated: false)
    }

    func createLoginScene() -> UIViewController {
        LoginViewController(viewModel: .init(coordinator: self))
    }

    func createEnterEmailScene() -> UIViewController {
        EnterEmailViewController(viewModel: .init(coordinator: self))
    }
}

// MARK: - CoordinatorLogic
extension IntroCoordinator: LoginCoordinatorLogic, EnterEmailCoordinatorLogic {

    func coordinateToEnterEmailScene() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(createEnterEmailScene(), animated: true)
    }
}
