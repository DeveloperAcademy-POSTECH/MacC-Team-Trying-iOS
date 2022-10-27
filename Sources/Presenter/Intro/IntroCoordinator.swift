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
                                   CreatePlanetCoordinatorLogic,
                                   CreatePlanetCompleteCoordinatorLogic,
                                   WaitingInvitationCoordinatorLogic,
                                   InvitationCodeCoordinatorLogic,
                                   FindPlanetCoordinatorLogic,
                                   WaitingInvitationCoordinatorLogic {
    var navigationController: UINavigationController? { get }
}

protocol IntroCoordinatorDelegate: AnyObject {
    func coordinateToMainScene()
}

final class IntroCoordinator: IntroCoordinatorProtocol {

    weak var navigationController: UINavigationController?

    weak var delegate: IntroCoordinatorDelegate?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start() {
        let startController = LoginViewController(viewModel: LoginViewModel(coordinator: self))
        navigationController?.setViewControllers([startController], animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - CoordinatorLogic
extension IntroCoordinator {

    func coordinateToEnterEmailScene() {
        let enterEmail = EnterEmailViewController(viewModel: .init(coordinator: self))
        navigationController?.pushViewController(enterEmail, animated: true)
    }

    func coordinateToEnterPasswordScene(email: String) {
        let enterPassword = EnterPasswordViewController(viewModel: .init(email: email, coordinator: self))
        navigationController?.pushViewController(enterPassword, animated: true)
    }

    func coordinateToMainScene() {
        delegate?.coordinateToMainScene()
    }

    func coordinateToFindPasswordScene(email: String) {
        let findPassword = FindPasswordViewController(
            viewModel: .init(
                email: email,
                coordinator: self
            )
        )
        navigationController?.pushViewController(findPassword, animated: true)
    }

    func coordinateToConfirmPasswordScene() {
        let confirmPassword = ConfirmPasswordViewController(viewModel: .init(coordinator: self))
        navigationController?.pushViewController(confirmPassword, animated: true)
    }

    func coordinateToEnterCodeScene(email: String) {
        let enterCode = EnterCodeViewController(
            viewModel: .init(
                email: email,
                coordinator: self
            )
        )
        navigationController?.pushViewController(enterCode, animated: true)
    }

    func coordinateToConfirmSignUpScene(email: String) {
        let confirmSignUp = ConfirmSignUpViewController(
            viewModel: .init(
                viewType: .confirmSignUp,
                email: email,
                coordinator: self
            )
        )
        navigationController?.pushViewController(confirmSignUp, animated: true)
    }

    func coordinateToSignUpEmailScene() {
        let signUp = ConfirmSignUpViewController(
            viewModel: .init(
                viewType: .signup,
                email: "",
                coordinator: self
            )
        )
        navigationController?.pushViewController(signUp, animated: true)
    }

    func coordinateToFindPlanetScene(planetName: String, planetImageName: String, code: String) {
        let findPlanet = FindPlanetViewController(viewModel: .init(planetImage: planetImageName, planetName: planetName, code: code, coordinator: self))
        navigationController?.pushViewController(findPlanet, animated: true)
    }

    func coordinateToSignUpEnterPassword(email: String) {
        let signUpEnterPassword = SignUpEnterPasswordViewController(
            viewModel: .init(
                email: email,
                coordinator: self
            )
        )
        navigationController?.pushViewController(signUpEnterPassword, animated: true)
    }

    func coordinateSignUpEnterNickname(email: String, password: String) {
        let signUpEnterNickname = SignUpEnterNicknameViewController(
            viewModel: .init(
                email: email,
                password: password,
                coordinator: self
            )
        )
        navigationController?.pushViewController(signUpEnterNickname, animated: true)
    }

    func coordinateToCreatePlanetScene() {
        let createPlanet = CreatePlanetViewController(viewModel: .init(coordinator: self))
        navigationController?.pushViewController(createPlanet, animated: true)
    }

    func coordinateToCreatePlanetCompleteScene(selectedPlanet: String, planetName: String, code: String) {
        let createPlanetComplete = CreatePlanetCompleteViewController(
            viewModel: .init(
                selectedPlanet: selectedPlanet,
                planetName: planetName,
                code: code,
                coordinator: self
            )
        )
        navigationController?.pushViewController(createPlanetComplete, animated: true)
    }

    func coordinateToWaitingInvitationScene(selectedPlanet: String, planetName: String, code: String) {
        let waitingInvitationViewController = WaitingInvitationViewController(
            viewModel: .init(
                selectedPlanet: selectedPlanet,
                planetName: planetName,
                code: code,
                coordinator: self
            )
        )
        navigationController?.pushViewController(waitingInvitationViewController, animated: true)
    }

    func coordinateToInvitationCodeScene() {
        let invitationCodeViewController = InvitationCodeViewController(viewModel: .init(coordinator: self))
        navigationController?.pushViewController(invitationCodeViewController, animated: true)
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
