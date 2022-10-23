//
//  SignUpEnterNicknameViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol SignUpEnterNicknameCoordinatorLogic {}

protocol SignUpEnterNicknameBusinessLogic: BusinessLogic {}

final class SignUpEnterNicknameViewModel: BaseViewModel, SignUpEnterNicknameBusinessLogic {
    let coordinator: ConfirmPasswordCoordinatorLogic

    init(coordinator: ConfirmPasswordCoordinatorLogic) {
        self.coordinator = coordinator
    }
}
