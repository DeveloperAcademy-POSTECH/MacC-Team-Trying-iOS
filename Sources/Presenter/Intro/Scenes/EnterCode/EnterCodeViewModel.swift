//
//  EnterCodeViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol EnterCodeCoordinatorLogic {
    func coordinateToSignUpEnterPassword(email: String)
}

protocol EnterCodeBuisnessLogic: BusinessLogic {
    func nextButtonDidTapped()
    func textFieldDidChange(_ text: String)
}

final class EnterCodeViewModel: BaseViewModel, EnterCodeBuisnessLogic {

    let coordinator: EnterCodeCoordinatorLogic

    private let emailVerificationService = EmailVerificationService()

    @Published var codeTextFieldState: TextFieldState
    @Published var isLoading: Bool

    var certificationCode: String
    let email: String

    init(
        email: String,
        coordinator: EnterCodeCoordinatorLogic
    ) {
        self.email = email
        self.codeTextFieldState = .empty
        self.certificationCode = ""
        self.isLoading = false
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        Task {
            do {
                self.isLoading = true
                _ = try await emailVerificationService.verificateCode(.init(email: self.email, code: self.certificationCode))
                self.isLoading = false

                DispatchQueue.main.async {
                    self.coordinator.coordinateToSignUpEnterPassword(email: self.email)
                }
                
            } catch {
                self.isLoading = false
                codeTextFieldState = .wrongCertificationNumber
            }
        }
    }

    func textFieldDidChange(_ text: String) {
        certificationCode = text
        codeTextFieldState = text.count >= 6 ? .good : .empty
    }
}
