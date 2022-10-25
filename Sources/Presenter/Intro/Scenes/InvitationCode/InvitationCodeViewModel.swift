//
//  InvitationCodeViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol InvitationCodeCoordinatorLogic {

}

protocol InvitationCodeBusinessLogic: BusinessLogic {
    func nextButtonDidTapped()
    func textFieldDidChange(_ text: String)
}

final class InvitationCodeViewModel: BaseViewModel, InvitationCodeBusinessLogic {
    let coordinator: InvitationCodeCoordinatorLogic

    enum Stage {
        case notFound
        case found
    }

    @Published var textFieldState: TextFieldState
    @Published var stage: Stage

    init(coordinator: InvitationCodeCoordinatorLogic) {
        self.textFieldState = .empty
        self.stage = .notFound
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        switch stage {
        case .notFound:
            // TODO: 통신
            self.stage = .found
        case .found:
            break

        }
    }

    func textFieldDidChange(_ text: String) {
        if text == rightCode {
            stage = .found
            textFieldState = .empty
        } else {
            stage = .notFound
            #warning("초대코드가 맞지 않을 경우 오류메시지 정하가")
        }
    }
}

extension InvitationCodeViewModel {
    var rightCode: String {
        "aaa"
    }
}
