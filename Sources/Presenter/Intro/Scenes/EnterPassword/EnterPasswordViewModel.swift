//
//  EnterPasswordViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol EnterPasswordCoordinatorLogic {
    func coordinateToMainScene()
    func coordinateToFindPasswordScene(email: String)
    func coordinateToCreatePlanetScene()
    func coordinateToWarningMateExitScene()
    func coordinateToWaitingInvitationScene(selectedPlanet: String, planetName: String, code: String)
}

protocol EnterPasswordBusinessLogic: BusinessLogic {
    func loginButtonDidTapped()
    func findPasswordButtonDidTapped()
    func textFieldDidChange(_ text: String)
}

final class EnterPasswordViewModel: BaseViewModel, EnterPasswordBusinessLogic {

    private let coordinator: EnterPasswordCoordinatorLogic

    private let signInService = SignInService()
    private let userService: UserService

    @Published var passwordTextFieldState: TextFieldState
    @Published var isLoading: Bool
    let email: String
    var password: String

    init(
        email: String,
        coordinator: EnterPasswordCoordinatorLogic,
        userService: UserService = UserService()
    ) {
        self.passwordTextFieldState = .empty
        self.email = email
        self.password = ""
        self.isLoading = false
        self.coordinator = coordinator
        self.userService = userService
    }

    func loginButtonDidTapped() {
        Task {
            do {
                self.isLoading = true
                let deviceToken = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
                let accessToken = try await signInService.signIn(.init(email: email, password: password, deviceToken: deviceToken))
                UserDefaults.standard.set(accessToken.accessToken, forKey: "accessToken")

                let userInformations = try await userService.getUserInformations()

                print("✨ ", userInformations)

                self.isLoading = false

                if userInformations.planet == nil {
                    DispatchQueue.main.async { [weak self] in
                        self?.coordinator.coordinateToCreatePlanetScene()
                    }

                } else if userInformations.mate == nil {
                    guard let planet = userInformations.planet else { return }
                    if planet.hasBeenMateEntered {
                        DispatchQueue.main.async { [weak self] in
                            self?.coordinator.coordinateToWarningMateExitScene()
                        }
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            self?.coordinator.coordinateToWaitingInvitationScene(
                                selectedPlanet: planet.image,
                                planetName: planet.name,
                                code: planet.code ?? ""
                            )
                        }
                    }
                    return
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.coordinator.coordinateToMainScene()
                    }
                }
            } catch {
                passwordTextFieldState = .wrongPassword
                isLoading = false
            }
        }

    }

    func textFieldDidChange(_ text: String) {
        self.password = text
        passwordTextFieldState = .empty
    }

    func findPasswordButtonDidTapped() {
        coordinator.coordinateToFindPasswordScene(email: email)
    }
}
