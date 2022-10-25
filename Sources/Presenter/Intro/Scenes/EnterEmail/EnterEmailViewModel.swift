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
    func coordinateToEnterPasswordScene(email: String)
    func coordinateToConfirmSignUpScene(email: String)
}

protocol EnterEmailBusinessLogic: BusinessLogic {
    func enterEmailButtonDidTapped()
    func textFieldDidChange(_ text: String)
    func goNext()
}

final class EnterEmailViewModel: BaseViewModel, EnterEmailBusinessLogic {

    let coordinator: EnterEmailCoordinatorLogic

    private let checkEmailService = CheckEmailService()
    
    @Published var emailTextFieldState: TextFieldState
    @Published var isLoading: Bool
    @Published var leaveAnimation: Bool
    var email: String
    var nextScene: NextScene

    init(coordinator: EnterEmailCoordinatorLogic) {
        self.coordinator = coordinator
        self.leaveAnimation = false
        self.isLoading = false
        self.emailTextFieldState = .empty
        self.email = ""
        self.nextScene = .confirmSignup
    }

    func enterEmailButtonDidTapped() {
        Task {
            do {
                let isExist = try await checkEmailService.checkEmail(.init(email: email))
                let nextScene: NextScene = isExist.exist ? .enterPassword : .confirmSignup
                self.nextScene = nextScene
                self.leaveAnimation = true
            } catch {

            }
        }
    }

    enum NextScene {
        case confirmSignup
        case enterPassword
    }

    func goNext() {
        DispatchQueue.main.async {
            self.routeToScene(self.nextScene)
        }
    }

    private func routeToScene(_ next: NextScene) {
        switch next {
        case .confirmSignup:
            self.coordinator.coordinateToConfirmSignUpScene(email: email)
        case .enterPassword:
            self.coordinator.coordinateToEnterPasswordScene(email: email)
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
