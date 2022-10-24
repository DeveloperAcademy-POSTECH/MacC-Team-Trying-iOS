//
//  SignUpEnterPasswordViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol SignUpEnterPasswordCoordinatorLogic {
    func coordinateSignUpEnterNickname()
}

protocol SignUpEnterPasswordBusinessLogic: BusinessLogic {
    func nextButtonDidTapped()
}

final class SignUpEnterPasswordViewModel: BaseViewModel, SignUpEnterPasswordBusinessLogic {
    let coordinator: SignUpEnterPasswordCoordinatorLogic

    init(coordinator: SignUpEnterPasswordCoordinatorLogic) {
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        coordinator.coordinateSignUpEnterNickname()
    }
}
