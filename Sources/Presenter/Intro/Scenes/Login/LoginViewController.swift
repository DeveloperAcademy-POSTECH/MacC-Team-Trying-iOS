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
    lazy var kakaoLoginButton = UIButton(type: .system)
    lazy var appleLoginButton = UIButton(type: .system)
    lazy var emailLoginButton = UIButton(type: .system)
    lazy var logoImageView = UIImageView()
    lazy var signUpButton = SignUpButton(type: .system)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupAnimations()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        enterAnimator?.startAnimation(afterDelay: fastDelay)
    }

    override func bind() {
        viewModel.$doneLogin
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                switch step {
                case .serviceTerm(let type):
                    self?.leaveAnimator?.addCompletion { [weak self] _ in
                        self?.viewModel.gotoServiceTerm(type: type)
                    }

                    self?.leaveAnimator?.startAnimation()
                case .main:
                    self?.leaveAnimator?.addCompletion { [weak self] _ in
                        self?.viewModel.gotoMain()
                    }

                    self?.leaveAnimator?.startAnimation()
                }
            }
            .cancel(with: cancelBag)
    }

    override func setAttribute() {
        super.setAttribute()

        navigationItem.title = ""

        emailLoginButton.contentMode = .scaleAspectFit
        kakaoLoginButton.contentMode = .scaleAspectFit
        appleLoginButton.contentMode = .scaleAspectFit

        emailLoginButton.imageView?.contentMode = .scaleAspectFit
        kakaoLoginButton.imageView?.contentMode = .scaleAspectFit
        appleLoginButton.imageView?.contentMode = .scaleAspectFit

        kakaoLoginButton.setImage(.init(.btn_kakao), for: .normal)
        appleLoginButton.setImage(.init(.btn_apple), for: .normal)
        emailLoginButton.setImage(.init(.btn_email), for: .normal)

        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonDidTapped), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonDidTapped), for: .touchUpInside)

        emailLoginButton.addTarget(self, action: #selector(emailLoginBttonDidTapped), for: .touchUpInside)

        kakaoLoginButton.alpha = 0
        appleLoginButton.alpha = 0
        emailLoginButton.alpha = 0
        signUpButton.alpha = 0
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTapped), for: .touchUpInside)

        logoImageView.image = .init(.planets)
        logoImageView.contentMode = .scaleAspectFill
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(logoLabel)
//        view.addSubview(logoImageView)
        view.addSubview(kakaoLoginButton)
        view.addSubview(appleLoginButton)
        view.addSubview(emailLoginButton)

        logoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(26)
        }
//        logoImageView.snp.makeConstraints { make in
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(190)
//            make.leading.trailing.equalToSuperview()
//            make.width.equalTo(logoImageView.snp.height).multipliedBy(436 / 449)
//        }
        appleLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(kakaoLoginButton.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        let heightConstraint1 = appleLoginButton.heightAnchor.constraint(equalTo: appleLoginButton.widthAnchor, multiplier: 58 / 350)
        heightConstraint1.priority = UILayoutPriority(1000)
        heightConstraint1.isActive = true

        kakaoLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(emailLoginButton.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        let heightConstraint2 = kakaoLoginButton.heightAnchor.constraint(equalTo: kakaoLoginButton.widthAnchor, multiplier: 58 / 350)
        heightConstraint2.priority = UILayoutPriority(1000)
        heightConstraint2.isActive = true

        emailLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(300)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        let heightConstraint3 = emailLoginButton.heightAnchor.constraint(equalTo: emailLoginButton.widthAnchor, multiplier: 58 / 350)
        heightConstraint3.priority = UILayoutPriority(1000)
        heightConstraint3.isActive = true
    }
}

extension LoginViewController {

    private func setupAnimations() {
        enterAnimator?.addAnimations {
            self.emailLoginButton.alpha = 1
            self.signUpButton.alpha = 1
            self.kakaoLoginButton.alpha = 1
            self.appleLoginButton.alpha = 1
            self.emailLoginButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            }
            self.view.layoutIfNeeded()
        }

        leaveAnimator?.addAnimations {
            self.emailLoginButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(300)
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Button Clicked
extension LoginViewController {

    @objc
    func kakaoLoginButtonDidTapped() {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.kakaoLoginButtonDidTapped()
        }
    }

    @objc
    func appleLoginButtonDidTapped() {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.appleLoginButtonDidTapped()
        }
    }

    @objc
    func emailLoginBttonDidTapped() {
        leaveAnimator?.addCompletion { [weak self] _ in
            self?.viewModel.emailLoginButtonDidTapped()
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
