//
//  EnterEmailViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol EnterEmailCoordinatorLogic {
    func coordinateToEnterPasswordScene()
    func coordinateToConfirmSignUpScene(email: String)
}

protocol EnterEmailBusinessLogic: BusinessLogic {
    func enterEmailButtonDidTapped()
    func textFieldDidChange(_ text: String)
}

final class EnterEmailViewModel: BaseViewModel, EnterEmailBusinessLogic {

    let coordinator: EnterEmailCoordinatorLogic

    private let checkEmailService = CheckEmailService()
    
    @Published var emailTextFieldState: TextFieldState
    @Published var isLoading: Bool
    var email: String

    init(coordinator: EnterEmailCoordinatorLogic) {
        self.coordinator = coordinator
        isLoading = false
        emailTextFieldState = .empty
        email = ""
    }

    func enterEmailButtonDidTapped() {
        Task {
            do {

                let isExist = try await checkEmailService.checkEmail(.init(email: email))
                let nextScene: NextScene = isExist.exist ? .enterPassword : .confirmSignup
                DispatchQueue.main.async {
                    self.routeToScene(nextScene)
                }
            } catch {
                isLoading = false
                print("통신 오류 에러 처리")
            }
        }
    }

    enum NextScene {
        case confirmSignup
        case enterPassword
    }

    private func routeToScene(_ next: NextScene) {
        switch next {
        case .confirmSignup:
            self.coordinator.coordinateToConfirmSignUpScene(email: self.email)
        case .enterPassword:
            self.coordinator.coordinateToEnterPasswordScene()
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
