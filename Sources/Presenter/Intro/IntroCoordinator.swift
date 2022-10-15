//
//  IntroCoordinator.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

protocol IntroCoordinatorProtocol: Coordinator, LoginCoordinatorLogic, EnterEmailCoordinatorLogic {
    var navigationController: UINavigationController? { get }

    func coordinateToEnterEmailScene()
}

final class IntroCoordinator: IntroCoordinatorProtocol {
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let startController = createLoginScene()
        navigationController?.setViewControllers([startController], animated: false)
    }

    func createLoginScene() -> UIViewController {
        let loginViewModel = LoginViewModel(coordinator: self)
        return LoginViewController(viewModel: loginViewModel)
    }

    func createEnterEmailScene() -> UIViewController {
        EnterEmailViewController(viewModel: .init(coordinator: self))
    }
}

// MARK: - CoordinatorLogic
extension IntroCoordinator {

    func coordinateToEnterEmailScene() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(createEnterEmailScene(), animated: true)
    }
}
