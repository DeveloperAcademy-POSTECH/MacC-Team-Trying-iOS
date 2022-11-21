//
//  LoginViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import Foundation
import CancelBag
import AuthenticationServices

protocol LoginCoordinatorLogic {
    func coordinateToEnterEmailScene()
    func coordinateToSignUpEmailScene()
    func coordinateToCreatePlanetScene()
    func coordinateToWarningMateExitScene()
    func coordinateToWaitingInvitationScene(selectedPlanet: String, planetName: String, code: String)
    func coordinateToServiceTermScene(type: SignUpEnterNicknameViewModel.SignUpType)
    func coordinateToMainScene()
}

protocol LoginBusinessLogic: BusinessLogic {
    func appleLoginButtonDidTapped()
    func kakaoLoginButtonDidTapped()
    func emailLoginButtonDidTapped()
    func signUpButtonDidTapped()
    func gotoMain()
    func gotoServiceTerm(type: SignUpEnterNicknameViewModel.SignUpType)
}

final class LoginViewModel: BaseViewModel, LoginBusinessLogic {

    let coordinator: LoginCoordinatorLogic
    let kakaoLoginManager: KakaoLoginManager
    let appleLoginManager: AppleLoginManager
    let signinServcee: SignInService
    let userService: UserService

    enum RouteStep {
        case main
        case serviceTerm(SignUpEnterNicknameViewModel.SignUpType)
        case createPlanet
        case warning
        case waitingMate(selectedPlanet: String, planetName: String, code: String)
    }

    @Published var doneLogin: RouteStep?

    init(
        coordinator: LoginCoordinatorLogic,
        kakaoLoginManager: KakaoLoginManager = KakaoLoginManagerImpl(),
        appleLoginManager: AppleLoginManager = AppleLoginManager(),
        signinService: SignInService = SignInService(),
        userService: UserService = UserService()
    ) {
        self.doneLogin = nil
        self.coordinator = coordinator
        self.kakaoLoginManager = kakaoLoginManager
        self.appleLoginManager = appleLoginManager
        self.signinServcee = signinService
        self.userService = userService
        super.init()

        self.appleLoginManager.delegate = self
    }

    func appleLoginButtonDidTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        authorizationController.delegate = appleLoginManager
        authorizationController.presentationContextProvider = appleLoginManager
        authorizationController.performRequests()
    }

    func kakaoLoginButtonDidTapped() {

        LoadingView.shared.show()
        Task {
            do {
                guard let token = try await kakaoLoginManager.kakaoLogin() else { return }
                let deviceToken = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
                let accessToken = try await signinServcee.signInWithKakao(.init(identifier: token, deviceToken: deviceToken))
                UserDefaults.standard.set(accessToken.accessToken, forKey: "accessToken")

                let userInformations = try await userService.getUserInformations()

                print("✨ ", userInformations)
                if userInformations.planet == nil {
                    self.doneLogin = .createPlanet
                } else if userInformations.mate == nil {
                    guard let planet = userInformations.planet else { return }
                    if planet.hasBeenMateEntered {
                        self.doneLogin = .warning
                    } else {
                        self.doneLogin = .waitingMate(
                            selectedPlanet: planet.image,
                            planetName: planet.name,
                            code: planet.code ?? ""
                        )
                    }
                    return
                } else {
                    self.doneLogin = .main
                }

            } catch SignInError.nouser(let identifier) {
                self.doneLogin = .serviceTerm(.kakao(identifier))
            } catch {
                await LoadingView.shared.hide()
            }
        }
    }

    func gotoWaitMate(selectedPlanet: String, planetName: String, code: String) {
        DispatchQueue.main.async { [weak self] in
            LoadingView.shared.hide()
            self?.coordinator.coordinateToWaitingInvitationScene(
                selectedPlanet: selectedPlanet,
                planetName: planetName,
                code: code
            )
        }
    }

    func gotoWarning() {
        DispatchQueue.main.async { [weak self] in
            LoadingView.shared.hide()
            self?.coordinator.coordinateToWarningMateExitScene()
        }
    }
    func gotoCreatPlanet() {
        DispatchQueue.main.async { [weak self] in
            LoadingView.shared.hide()
            self?.coordinator.coordinateToCreatePlanetScene()
        }
    }

    func gotoMain() {
        DispatchQueue.main.async { [weak self] in
            LoadingView.shared.hide()
            self?.coordinator.coordinateToMainScene()
        }
    }

    func gotoServiceTerm(type: SignUpEnterNicknameViewModel.SignUpType) {
        DispatchQueue.main.async { [weak self] in
            LoadingView.shared.hide()
            self?.coordinator.coordinateToServiceTermScene(type: type)
        }
    }

    func emailLoginButtonDidTapped() {
        coordinator.coordinateToEnterEmailScene()
    }

    func signUpButtonDidTapped() {
        coordinator.coordinateToSignUpEmailScene()
    }
}

extension LoginViewModel: AppleLoginManagerDelegate {

    func appleLoginFail(_ error: LoginError) {

    }

    func appleLoginSuccess(_ user: AppleLoginManager.AppleUser) {
        Task {
            do {
                let deviceToken = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
                let accessToken = try await signinServcee.signInWithApple(.init(identifier: user.userIdentifier, deviceToken: deviceToken))
                UserDefaults.standard.set(accessToken.accessToken, forKey: "accessToken")

                self.doneLogin = .main
            } catch SignInError.nouser(let identifier) {
                self.doneLogin = .serviceTerm(.apple(identifier))
            } catch {
                await LoadingView.shared.hide()
            }
        }
    }
}
