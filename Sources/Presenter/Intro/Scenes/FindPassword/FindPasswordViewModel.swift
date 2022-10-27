//
//  FindPasswordViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol FindPasswordCoordinatorLogic {
    func coordinateToConfirmPasswordScene()
}

protocol FindPasswordBusinessLogic: BusinessLogic {
    func sendEmailButtonDidTapped()
    func textFieldDidChange(_ text: String)
}

final class FindPasswordViewModel: BaseViewModel, FindPasswordBusinessLogic {
    let coordinator: FindPasswordCoordinatorLogic

    private let emailVerificationService = EmailVerificationService()

    @Published var email: String
    @Published var emailState: TextFieldState

    init(
        email: String,
        coordinator: FindPasswordCoordinatorLogic
    ) {
        self.email = email
        self.emailState = .good
        self.coordinator = coordinator
    }

    func sendEmailButtonDidTapped() {
        Task {
            do {
                _ = try await emailVerificationService.resetPassword(.init(email: email))

                DispatchQueue.main.async {
                    self.coordinator.coordinateToConfirmPasswordScene()
                }
            } catch {
                emailState = .isNotSignUp
            }
        }
    }

    func textFieldDidChange(_ text: String) {
        email = text

        if text.isEmpty {
            emailState = .empty
            return
        }

        let emailPattern = #"^\S+@\S+\.\S+$"#
        let result = text.range(of: emailPattern, options: .regularExpression)
        emailState = (result != nil) ? .good : .invalidEmail
    }
}
