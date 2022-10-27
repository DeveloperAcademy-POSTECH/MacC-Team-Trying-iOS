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
    func textFieldDidChange(_ text: String)
}

final class ConfirmSignUpViewModel: BaseViewModel, ConfirmSignUpBuisnessLogic {
    let coordinator: ConfirmSignUpCoordinatorLogic

    @Published var emailTextFieldState: TextFieldState
    @Published var email: String

    init(email: String, coordinator: ConfirmSignUpCoordinatorLogic) {
        self.email = email
        self.emailTextFieldState = .good
        self.coordinator = coordinator
    }

    func signUpButtonDidTapped() {
        coordinator.coordinateToEnterCodeScene()
    }

    func textFieldDidChange(_ text: String) {
        email = text

        if text.isEmpty {
            emailTextFieldState = .empty
            return
        }

        let emailPattern = #"^\S+@\S+\.\S+$"#
        let result = text.range(of: emailPattern, options: .regularExpression)
        emailTextFieldState = (result != nil) ? .good : .invalidEmail
    }
}
