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
}

protocol LoginBusinessLogic {
    func loginButtonDidTapped()
}

final class LoginViewModel: BaseViewModel, LoginBusinessLogic {
    let coordinator: LoginCoordinatorLogic

    init(coordinator: LoginCoordinatorLogic) {
        self.coordinator = coordinator
    }

    func loginButtonDidTapped() {
        coordinator.coordinateToEnterEmailScene()
    }
}
