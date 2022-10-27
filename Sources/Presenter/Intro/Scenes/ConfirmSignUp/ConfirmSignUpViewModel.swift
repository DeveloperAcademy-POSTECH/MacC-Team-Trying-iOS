//
//  ConfirmSignUpViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol ConfirmSignUpCoordinatorLogic {
    func coordinateToEnterCodeScene(email: String)
}

protocol ConfirmSignUpBuisnessLogic: BusinessLogic {
    func signUpButtonDidTapped()
    func textFieldDidChange(_ text: String)
    func goNext()
}

final class ConfirmSignUpViewModel: BaseViewModel, ConfirmSignUpBuisnessLogic {

    let coordinator: ConfirmSignUpCoordinatorLogic

    private let emailVerificationService = EmailVerificationService()

    @Published var emailTextFieldState: TextFieldState
    @Published var email: String
    @Published var isLoading: Bool
    @Published var viewType: ViewType
    @Published var leaveAnimation: Bool

    enum ViewType {
        case confirmSignUp
        case signup

        var emailTextFieldState: TextFieldState {
            switch self {
            case .signup: return .empty
            case .confirmSignUp: return .good
            }
        }
    }

    init(
        viewType: ViewType,
        email: String,
        coordinator: ConfirmSignUpCoordinatorLogic
    ) {
        self.viewType = viewType
        self.email = email
        self.emailTextFieldState = viewType.emailTextFieldState
        self.isLoading = false
        self.coordinator = coordinator
        self.leaveAnimation = false
    }

    func signUpButtonDidTapped() {
        Task {
            do {
                isLoading = true
                _ = try await emailVerificationService.checkEmail(.init(email: email))
                isLoading = false
                leaveAnimation = true
            } catch {
                emailTextFieldState = .duplicatedSignUp
                isLoading = false
            }
        }
    }

    func goNext() {
        DispatchQueue.main.async {
            self.coordinator.coordinateToEnterCodeScene(email: self.email)
        }
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
