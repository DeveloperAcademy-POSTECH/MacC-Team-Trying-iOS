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

    enum RouteStep {
        case main
        case serviceTerm(SignUpEnterNicknameViewModel.SignUpType)
    }

    @Published var doneLogin: RouteStep?

    init(
        coordinator: LoginCoordinatorLogic,
        kakaoLoginManager: KakaoLoginManager = KakaoLoginManagerImpl(),
        appleLoginManager: AppleLoginManager = AppleLoginManager(),
        signinService: SignInService = SignInService()

    ) {
        self.doneLogin = nil
        self.coordinator = coordinator
        self.kakaoLoginManager = kakaoLoginManager
        self.appleLoginManager = appleLoginManager
        self.signinServcee = signinService
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
                let accessToken = try await signinServcee.signInWithKakao(.init(identifier: token, deviceToken: "1"))
                UserDefaults.standard.set(accessToken.accessToken, forKey: "accessToken")
                self.doneLogin = .main
            } catch SignInError.nouser(let identifier) {
                self.doneLogin = .serviceTerm(.kakao(identifier))
            } catch {
                await LoadingView.shared.hide()
            }
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
                let accessToken = try await signinServcee.signInWithApple(.init(identifier: user.userIdentifier, deviceToken: "1"))
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
