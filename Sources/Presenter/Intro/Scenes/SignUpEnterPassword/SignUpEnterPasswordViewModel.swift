//
//  SignUpEnterPasswordViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol SignUpEnterPasswordCoordinatorLogic {}

protocol SignUpEnterPasswordBusinessLogic: BusinessLogic {}

final class SignUpEnterPasswordViewModel: BaseViewModel, SignUpEnterPasswordBusinessLogic {
    let coordinator: ConfirmPasswordCoordinatorLogic

    init(coordinator: ConfirmPasswordCoordinatorLogic) {
        self.coordinator = coordinator
    }
}
