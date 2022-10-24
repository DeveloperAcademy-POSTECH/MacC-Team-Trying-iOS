//
//  EnterEmailViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol EnterEmailCoordinatorLogic {
    func coordinateToEnterPasswordScene()
    func coordinateToConfirmSignUpScene()
}

protocol EnterEmailBusinessLogic: BusinessLogic {
    func enterEmailButtonDidTapped()
    func textFieldDidChange(_ text: String)
}

final class EnterEmailViewModel: BaseViewModel, EnterEmailBusinessLogic {
    let coordinator: EnterEmailCoordinatorLogic

    @Published var enterEmailButtonEnable: TextFieldState = .empty

    init(coordinator: EnterEmailCoordinatorLogic) {
        self.coordinator = coordinator
    }

    func enterEmailButtonDidTapped() {
        // TODO: 화면 전환 분기처리
//        coordinator.coordinateToEnterPasswordScene()
        coordinator.coordinateToConfirmSignUpScene()
    }

    func textFieldDidChange(_ text: String) {
        if text.isEmpty {
            enterEmailButtonEnable = .empty
            return
        }

        let emailPattern = #"^\S+@\S+\.\S+$"#
        let result = text.range(of: emailPattern, options: .regularExpression)
        enterEmailButtonEnable = (result != nil) ? .good : .invalidEmail
    }
}
