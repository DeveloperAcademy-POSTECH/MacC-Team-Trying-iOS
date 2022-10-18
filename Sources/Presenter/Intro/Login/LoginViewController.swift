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

final class LoginViewController: IntroAnimatedViewController {
    let viewModel: LoginBusinessLogic

    init(viewModel: LoginBusinessLogic) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {}

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateInitViews()
    }

    lazy var logoLabel = LogoLabel()
    lazy var logoImageView = UIImageView()
    lazy var loginButton = EmailLoginButton()
    lazy var signUpButton = SignUpButton(type: .system)
}

// MARK: - UI
extension LoginViewController {
    private func setUI() {
        setAttribute()
        setLayout()
    }

    private func setAttribute() {

        loginButton.alpha = 0
        signUpButton.alpha = 0
        logoImageView.image = .init(.img_logo)
        loginButton.addTarget(self, action: #selector(loginBttonDidTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTapped), for: .touchUpInside)
    }

    private func setLayout() {
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

    private func animateInitViews() {

        loginButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(67)
        }
        UIView.animate(withDuration: 1.5, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1) {
            self.loginButton.alpha = 1
            self.signUpButton.alpha = 1
            self.view.layoutIfNeeded()
        }

        view.bringSubviewToFront(loginButton)
        view.bringSubviewToFront(signUpButton)
    }
}

// MARK: Button Clicked
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
