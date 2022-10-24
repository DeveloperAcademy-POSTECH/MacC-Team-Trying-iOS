//
//  IntroCoordinator.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

protocol IntroCoordinatorProtocol: Coordinator,
                                   LoginCoordinatorLogic,
                                   EnterEmailCoordinatorLogic,
                                   EnterPasswordCoordinatorLogic,
                                   ConfirmSignUpCoordinatorLogic,
                                   EnterCodeCoordinatorLogic,
                                   SignUpEnterPasswordCoordinatorLogic,
                                   SignUpEnterNicknameCoordinatorLogic,
                                   FindPasswordCoordinatorLogic,
                                   ConfirmPasswordCoordinatorLogic,
                                   CreatePlanetCoordinatorLogic {
    var navigationController: UINavigationController? { get }
}

final class IntroCoordinator: IntroCoordinatorProtocol {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let startController = createLoginScene()
        navigationController?.setViewControllers([startController], animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func createLoginScene() -> UIViewController {
        let loginViewModel = LoginViewModel(coordinator: self)
        return LoginViewController(viewModel: loginViewModel)
    }

    func createEnterEmailScene() -> UIViewController {
        EnterEmailViewController(viewModel: .init(coordinator: self))
    }

    func createEnterPasswordScene() -> UIViewController {
        EnterPasswordViewController(viewModel: .init(coordinator: self))
    }

    func createFindPasswordScene() -> UIViewController {
        FindPasswordViewController(viewModel: .init(coordinator: self))
    }

    func createConfirmPasswordScene() -> UIViewController {
        ConfirmPasswordViewController(viewModel: .init(coordinator: self))
    }

    func createEnterCodeScene() -> UIViewController {
        EnterCodeViewController(viewModel: .init(coordinator: self))
    }

    func createSignUpEnterPasswordScene() -> UIViewController {
        SignUpEnterPasswordViewController(viewModel: .init(coordinator: self))
    }

    func createSignUpEnterNicknameScene() -> UIViewController {
        SignUpEnterNicknameViewController(viewModel: .init(coordinator: self))
    }
}

// MARK: - CoordinatorLogic
extension IntroCoordinator {

    func coordinateToEnterEmailScene() {
        navigationController?.pushViewController(createEnterEmailScene(), animated: true)
    }

    func coordinateToEnterPasswordScene() {
        navigationController?.pushViewController(createEnterPasswordScene(), animated: true)
    }

    func coordinateToHomeScene() {
        // TODO: 홈으로 넘어가는 델리게이트구현
    }

    func coordinateToFindPasswordScene() {
        navigationController?.pushViewController(createFindPasswordScene(), animated: true)
    }

    func coordinateToConfirmPasswordScene() {
        navigationController?.pushViewController(createConfirmPasswordScene(), animated: true)
    }

    func coordinateToEnterCodeScene() {
        navigationController?.pushViewController(createEnterCodeScene(), animated: true)
    }

    func coordinateToConfirmSignUpScene(email: String) {
        let destinationViewController = ConfirmSignUpViewController(viewModel: .init(email: email, coordinator: self))
        navigationController?.pushViewController(destinationViewController, animated: true)
    }

    func coordinateToSignUpEnterPassword() {
        navigationController?.pushViewController(createSignUpEnterPasswordScene(), animated: true)
    }

    func coordinateSignUpEnterNickname() {
        navigationController?.pushViewController(createSignUpEnterNicknameScene(), animated: true)
    }

    func coordinateToCreatePlanetScene() {
        let createPlanetViewController = CreatePlanetViewController(viewModel: .init(coordinator: self))
        navigationController?.pushViewController(createPlanetViewController, animated: true)
    }

    func backToConfirmPasswordScene() {
        let viewControllers: [UIViewController] = self.navigationController?.viewControllers ?? []
        if viewControllers.count >= 3 {
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        } else {
            // TODO: 오류처리
        }
    }
}
