//
//  SignUpEnterNicknameViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol SignUpEnterNicknameCoordinatorLogic {
    func coordinateToCreatePlanetScene()
}

protocol SignUpEnterNicknameBusinessLogic: BusinessLogic {
    func nextButtonDidTapped()
    func textFieldDidChange(_ text: String)
}

final class SignUpEnterNicknameViewModel: BaseViewModel, SignUpEnterNicknameBusinessLogic {

    let coordinator: SignUpEnterNicknameCoordinatorLogic

    private let signUpService = SignUpService()

    @Published var nicknameTextFieldState: TextFieldState
    @Published var isLoading: Bool
    let email: String
    let password: String
    var nickname: String

    init(
        email: String,
        password: String,
        coordinator: SignUpEnterNicknameCoordinatorLogic
    ) {
        self.email = email
        self.password = password
        self.nickname = ""
        self.nicknameTextFieldState = .emptyNickname
        self.isLoading = false
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        Task {
            do {
                self.isLoading = true

                let accessToken = try await signUpService.signup(.init(email: email, password: password, name: nickname))
                UserDefaults.standard.set(accessToken.accessToken, forKey: "accessToken")

                self.isLoading = false

                DispatchQueue.main.async {
                    self.coordinator.coordinateToCreatePlanetScene()
                }
            } catch {
                self.isLoading = false
            }
        }

    }

    private func createSignUpRequestModel() -> SignUpRequestModel {
        .init(email: email, password: password, name: nickname)
    }

    func textFieldDidChange(_ text: String) {
        nickname = text

        let nicknamePattern = #"^[가-힣A-Za-z0-9].{1,8}"#
        let result = nickname.range(of: nicknamePattern, options: .regularExpression)
        nicknameTextFieldState = result != nil ? .validNickname : .invalidNickname
    }
}
