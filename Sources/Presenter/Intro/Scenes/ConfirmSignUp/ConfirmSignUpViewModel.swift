//
//  ConfirmSignUpViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol ConfirmSignUpCoordinatorLogic {
    func coordinateToEnterCodeScene()
}

protocol ConfirmSignUpBuisnessLogic: BusinessLogic {
    func signUpButtonDidTapped()
}

final class ConfirmSignUpViewModel: BaseViewModel, ConfirmSignUpBuisnessLogic {
    let coordinator: ConfirmSignUpCoordinatorLogic

    init(coordinator: ConfirmSignUpCoordinatorLogic) {
        self.coordinator = coordinator
    }

    func signUpButtonDidTapped() {
        coordinator.coordinateToEnterCodeScene()
    }
}
