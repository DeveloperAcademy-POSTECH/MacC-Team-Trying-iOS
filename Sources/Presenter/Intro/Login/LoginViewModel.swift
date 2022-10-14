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

final class LoginViewModel: BaseViewModel {
    let coordinator: LoginCoordinatorLogic

    init(coordinator: LoginCoordinatorLogic) {
        self.coordinator = coordinator
    }

    func loginButtonDidTapped() {
        coordinator.coordinateToEnterEmailScene()
    }
}
