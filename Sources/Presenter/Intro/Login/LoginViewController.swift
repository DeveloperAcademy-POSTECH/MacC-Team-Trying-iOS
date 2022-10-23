//
//  LoginViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit
import Lottie

final class LoginViewController: PlanetAnimatedViewController<LoginViewModel> {

    lazy var logoLabel = LogoLabel()
    lazy var logoImageView = UIImageView()
    lazy var loginButton = EmailLoginButton()
    lazy var signUpButton = SignUpButton(type: .system)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        beginAnimations()
        bringsInteractionFront()
    }

    override func setAttribute() {
        super.setAttribute()

        loginButton.alpha = 0
        signUpButton.alpha = 0
        logoImageView.image = .init(.img_logo)
        logoLabel.font = .gmarksans(weight: .bold, size: ._30)
        loginButton.addTarget(self, action: #selector(loginBttonDidTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTapped), for: .touchUpInside)
        setNavigationBar()
    }

    override func setLayout() {
        super.setLayout()
        
        view.addSubview(logoLabel)
        view.addSubview(loginButton)
        view.addSubview(logoImageView)
        view.addSubview(signUpButton)

        logoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(26)
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(70)
        }
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(-58)
            make.height.equalTo(58)
        }
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(10)
        }
    }
}

extension LoginViewController {

    private func beginAnimations() {

        enterAnimator?.addAnimations {
            self.loginButton.alpha = 1
            self.signUpButton.alpha = 1

            self.loginButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(67)
            }
            self.view.layoutIfNeeded()
        }

        enterAnimator?.startAnimation(afterDelay: fastDelay)
    }

    private func bringsInteractionFront() {
        view.bringSubviewToFront(loginButton)
        view.bringSubviewToFront(signUpButton)
    }

    private func setNavigationBar() {
        navigationItem.title = ""
    }
}

// MARK: - Button Clicked
extension LoginViewController {

    @objc
    func loginBttonDidTapped() {
        leaveAnimator?.addAnimations {
            self.loginButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(100)
            }
            self.view.layoutIfNeeded()
        }

        leaveAnimator?.addCompletion { [weak self] _ in
            self?.viewModel.loginButtonDidTapped()
        }

        leaveAnimator?.startAnimation()
    }

    @objc
    func signUpButtonDidTapped() {
        leaveAnimator?.addAnimations {
            self.loginButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(100)
            }
            self.view.layoutIfNeeded()
        }

        leaveAnimator?.addCompletion { [weak self] _ in
            self?.viewModel.signUpButtonDidTapped()
        }

        leaveAnimator?.startAnimation()
    }
}
