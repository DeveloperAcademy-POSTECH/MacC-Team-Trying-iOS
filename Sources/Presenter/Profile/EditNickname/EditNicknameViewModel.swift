//
//  EditNicknameViewModel.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol EditNicknamCoordinatorLogic {
    func back()
}

final class EditNicknameViewModel: BaseViewModel {

    let coordinator: EditNicknamCoordinatorLogic

    private let signUpService = SignUpService()

    @Published var nicknameTextFieldState: TextFieldState
    @Published var isLoading: Bool

    var nickname: String

    init(
        nickname: String,
        coordinator: EditNicknamCoordinatorLogic
    ) {
        self.nickname = nickname
        self.nicknameTextFieldState = .emptyNickname
        self.isLoading = false
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        Task {
            do {

                

                DispatchQueue.main.async {
                    self.coordinator.back()
                }
            } catch {
                nicknameTextFieldState = .doubleNickname
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
