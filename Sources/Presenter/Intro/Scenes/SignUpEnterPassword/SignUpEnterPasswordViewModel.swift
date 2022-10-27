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
    func coordinateSignUpEnterNickname(email: String, password: String)
}

protocol SignUpEnterPasswordBusinessLogic: BusinessLogic {
    func nextButtonDidTapped()
    func textFieldDidChange(_ text: String)
}

final class SignUpEnterPasswordViewModel: BaseViewModel, SignUpEnterPasswordBusinessLogic {
    let coordinator: SignUpEnterPasswordCoordinatorLogic

    @Published var passwordTextFieldState: TextFieldState
    @Published var isLoading: Bool
    let email: String
    var password: String

    init(
        email: String,
        coordinator: SignUpEnterPasswordCoordinatorLogic
    ) {
        self.email = email
        self.passwordTextFieldState = .emptyPassword
        self.password = ""
        self.isLoading = false
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        coordinator.coordinateSignUpEnterNickname(email: email, password: password)
    }

    func textFieldDidChange(_ text: String) {
        password = text

        // TODO: 정규식 고쳐야함
        let passwordPattern = #"^[A-Za-z0-9]{8,12}"#
        let result = text.range(of: passwordPattern, options: .regularExpression)
        passwordTextFieldState = (result != nil) ? .validPassword : .invalidPassword
    }
}
