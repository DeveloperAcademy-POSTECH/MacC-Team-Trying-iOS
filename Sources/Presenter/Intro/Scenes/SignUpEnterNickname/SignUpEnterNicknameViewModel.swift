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

    var type: SignUpType

    var nickname: String

    enum SignUpType {
        case email(SignUpRequestModel.Email)
        case apple(String)
        case kakao(String)
    }

    init(
        type: SignUpType,
        coordinator: SignUpEnterNicknameCoordinatorLogic
    ) {
        self.type = type
        self.nickname = ""
        self.nicknameTextFieldState = .emptyNickname
        self.isLoading = false
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        Task {
            do {
                self.isLoading = true
                let deviceToken = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
                switch type {
                case .email(let model):
                    let accessToken = try await signUpService.signup(
                        .init(email: model.email, password: model.password, name: nickname, deviceToken: deviceToken)
                    )
                    UserDefaults.standard.set(accessToken.accessToken, forKey: "accessToken")
                    FcmCenter.shared.toggleAlarmAPI()
                case .apple(let identifier):
                    let accessToken = try await signUpService.signupWithApple(
                        .init(identifier: identifier, name: nickname, deviceToken: deviceToken)
                    )
                    UserDefaults.standard.set(accessToken.accessToken, forKey: "accessToken")
                    FcmCenter.shared.toggleAlarmAPI()
                case .kakao(let identifier):
                    let accessToken = try await signUpService.signupWitHKakao(
                        .init(identifier: identifier, name: nickname, deviceToken: deviceToken)
                    )
                    UserDefaults.standard.set(accessToken.accessToken, forKey: "accessToken")
                    FcmCenter.shared.toggleAlarmAPI()
                }

                self.isLoading = false

                DispatchQueue.main.async {
                    self.coordinator.coordinateToCreatePlanetScene()
                }
            } catch {
                nicknameTextFieldState = .doubleNickname
                self.isLoading = false
            }
        }
    }

    func textFieldDidChange(_ text: String) {
        nickname = text
        let nicknamePattern = #"^[가-힣A-Za-z0-9].{1,8}"#
        let result = nickname.range(of: nicknamePattern, options: .regularExpression)
        nicknameTextFieldState = result != nil ? .validNickname : .invalidNickname
    }
}
