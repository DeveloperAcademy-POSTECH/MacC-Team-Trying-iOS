//
//  EnterCodeViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol EnterCodeCoordinatorLogic {
    func coordinateToSignUpEnterPassword()
}

protocol EnterCodeBuisnessLogic: BusinessLogic {
    func nextButtonDidTapped()
    func textFieldDidChange(_ text: String)
}

final class EnterCodeViewModel: BaseViewModel, EnterCodeBuisnessLogic {
    let coordinator: EnterCodeCoordinatorLogic

    @Published var codeTextFieldState: TextFieldState
    var certificationCode: String

    init(coordinator: EnterCodeCoordinatorLogic) {
        self.codeTextFieldState = .empty
        self.certificationCode = ""
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {

        // TODO: 통신
        if rightCode == certificationCode {
            coordinator.coordinateToSignUpEnterPassword()
        } else {
            codeTextFieldState = .wrongCertificationNumber
        }
    }

    func textFieldDidChange(_ text: String) {
        certificationCode = text
        codeTextFieldState = .empty
    }
}

extension EnterCodeViewModel {
    var rightCode: String {
        "aaaaaa"
    }
}
