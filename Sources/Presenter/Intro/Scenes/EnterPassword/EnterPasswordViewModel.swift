//
//  EnterPasswordViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol EnterPasswordCoordinatorLogic {
    func coordinateToMainScene()
    func coordinateToFindPasswordScene(email: String)
}

protocol EnterPasswordBusinessLogic: BusinessLogic {
    func loginButtonDidTapped()
    func findPasswordButtonDidTapped()
    func textFieldDidChange(_ text: String)
}

final class EnterPasswordViewModel: BaseViewModel, EnterPasswordBusinessLogic {

    private let coordinator: EnterPasswordCoordinatorLogic

    private let signInService = SignInService()

    @Published var passwordTextFieldState: TextFieldState
    @Published var isLoading: Bool
    let email: String
    var password: String

    init(
        email: String,
        coordinator: EnterPasswordCoordinatorLogic
    ) {
        self.passwordTextFieldState = .empty
        self.email = email
        self.password = ""
        self.isLoading = false
        self.coordinator = coordinator
    }

    func loginButtonDidTapped() {
        Task {
            do {
                self.isLoading = true

                let accessToken = try await signInService.signIn(.init(email: email, password: password))
                UserDefaults.standard.set(accessToken.accessToken, forKey: "accessToken")

                self.isLoading = false

                DispatchQueue.main.async {
                    self.coordinator.coordinateToMainScene()
                }
                
            } catch {
                passwordTextFieldState = .wrongPassword
                isLoading = false
            }
        }

    }

    func textFieldDidChange(_ text: String) {
        self.password = text
        passwordTextFieldState = .empty
    }

    func findPasswordButtonDidTapped() {
        coordinator.coordinateToFindPasswordScene(email: email)
    }
}
