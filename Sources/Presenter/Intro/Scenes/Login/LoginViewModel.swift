//
//  LoginViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol LoginCoordinatorLogic {
    func coordinateToEnterEmailScene()
    func coordinateToSignUpEmailScene()
    func coordinateToCreatePlanetScene()
}

protocol LoginBusinessLogic: BusinessLogic {
    func loginButtonDidTapped()
    func signUpButtonDidTapped()
}

final class LoginViewModel: BaseViewModel, LoginBusinessLogic {
    let coordinator: LoginCoordinatorLogic

    init(coordinator: LoginCoordinatorLogic) {
        self.coordinator = coordinator
    }

    func loginButtonDidTapped() {
        coordinator.coordinateToEnterEmailScene()
    }

    func signUpButtonDidTapped() {
        coordinator.coordinateToSignUpEmailScene()
    }
}
