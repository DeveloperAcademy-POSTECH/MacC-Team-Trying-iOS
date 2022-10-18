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

final class LoginViewController: IntroAnimatedViewController<LoginViewModel> {

    lazy var logoLabel = LogoLabel()
    lazy var logoImageView = UIImageView()
    lazy var loginButton = EmailLoginButton()
    lazy var signUpButton = SignUpButton(type: .system)

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateInitViews()
    }

    override func setAttribute() {
        super.setAttribute()

        loginButton.alpha = 0
        signUpButton.alpha = 0
        logoImageView.image = .init(.img_logo)
        loginButton.addTarget(self, action: #selector(loginBttonDidTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTapped), for: .touchUpInside)
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

// MARK: - UI
extension LoginViewController {

    private func animateInitViews() {
        loginButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(67)
        }
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.allowUserInteraction]) {
            self.loginButton.alpha = 1
            self.signUpButton.alpha = 1
            self.view.layoutIfNeeded()
        }

        view.bringSubviewToFront(loginButton)
        view.bringSubviewToFront(signUpButton)
    }
}

// MARK: - Button Clicked
extension LoginViewController {

    @objc
    func loginBttonDidTapped() {
        viewModel.loginButtonDidTapped()
    }

    @objc
    func signUpButtonDidTapped() {
        viewModel.signUpButtonDidTapped()
    }
}
