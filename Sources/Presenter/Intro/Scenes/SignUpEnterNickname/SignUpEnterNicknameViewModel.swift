//
//  SignUpEnterNicknameViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

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

    @Published var nicknameTextFieldState: TextFieldState
    var nickname: String

    init(coordinator: SignUpEnterNicknameCoordinatorLogic) {
        self.nicknameTextFieldState = .emptyNickname
        self.nickname = ""
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        coordinator.coordinateToCreatePlanetScene()
    }

    func textFieldDidChange(_ text: String) {
        nickname = text

        // TODO: 닉네임 정규식
        let nicknamePattern = "^[A-Za-z0-9].{8,12}"
        let result = text.range(of: nicknamePattern, options: .regularExpression)
        nicknameTextFieldState = result != nil ? .validNickname : .invalidNickname
    }
}
