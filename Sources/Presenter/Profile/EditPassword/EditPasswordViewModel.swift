//
//  EditPasswordViewModel.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol EditPasswordCoordinatorLogic {
    func back()
}

final class EditPasswordViewModel: BaseViewModel {
    private let userService: UserService

    var coordinator: EditPasswordCoordinatorLogic

    @Published var passwordState: TextFieldState
    @Published var changePasswordState: TextFieldState
    @Published var repasswordState: TextFieldState

    var password: String
    var changePassword: String
    var repassword: String

    init(
        userService: UserService = UserService(),
        coordinator: EditPasswordCoordinatorLogic
    ) {
        self.password = ""
        self.changePassword = ""
        self.repassword = ""
        self.userService = userService
        self.coordinator = coordinator
        self.passwordState = .empty
        self.repasswordState = .empty
        self.changePasswordState = .empty
    }

    func editPassword() {
        Task {
            do {
                _ = try await userService.editPassword(password: password, changePw: repassword)

                DispatchQueue.main.async { [weak self] in
                    self?.coordinator.back()
                }
            } catch {
                ToastFactory.show(message: "비밀번호가 일치하지 않아요!")
            }
        }
    }

    func textField1DidChange(_ text: String) {
        password = text

        // TODO: 정규식 고쳐야함
        let passwordPattern = #"^[A-Za-z0-9]{8,12}"#
        let result = text.range(of: passwordPattern, options: .regularExpression)
        passwordState = (result != nil) ? .validPassword : .invalidPassword
    }

    func textField2DidChange(_ text: String) {
        changePassword = text

        // TODO: 정규식 고쳐야함
        let passwordPattern = #"^[A-Za-z0-9]{8,12}"#
        let result = text.range(of: passwordPattern, options: .regularExpression)
        changePasswordState = (result != nil) ? .validPassword : .invalidPassword
    }

    func textField3DidChange(_ text: String) {
        repassword = text

        repasswordState = repassword == changePassword  ? .goodDoubleCheckPassword : .doubleCheckPassword
    }
}
