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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupAnimations()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        enterAnimator?.startAnimation(afterDelay: fastDelay)
    }
   
    override func setAttribute() {
        super.setAttribute()

        navigationItem.title = ""

        loginButton.alpha = 0
        loginButton.addTarget(self, action: #selector(loginBttonDidTapped), for: .touchUpInside)

        signUpButton.alpha = 0
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTapped), for: .touchUpInside)

        logoImageView.image = .init(.planets)
        logoImageView.contentMode = .scaleAspectFill
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(190)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(logoImageView.snp.height).multipliedBy(436 / 449)
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

    private func setupAnimations() {
        enterAnimator?.addAnimations {
            self.loginButton.alpha = 1
            self.signUpButton.alpha = 1

            self.loginButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(67)
            }
            self.view.layoutIfNeeded()
        }

        leaveAnimator?.addAnimations {
            self.loginButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(100)
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Button Clicked
extension LoginViewController {

    @objc
    func loginBttonDidTapped() {
        leaveAnimator?.addCompletion { [weak self] _ in
            self?.viewModel.loginButtonDidTapped()
        }

        leaveAnimator?.startAnimation()
    }

    @objc
    func signUpButtonDidTapped() {
        leaveAnimator?.addCompletion { [weak self] _ in
            self?.viewModel.signUpButtonDidTapped()
        }

        leaveAnimator?.startAnimation()
    }
}
