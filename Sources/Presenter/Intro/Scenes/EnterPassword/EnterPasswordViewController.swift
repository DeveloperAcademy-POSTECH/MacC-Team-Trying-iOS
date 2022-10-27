//
//  EnterPasswordViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class EnterPasswordViewController: PlanetAnimatedViewController<EnterPasswordViewModel> {

    lazy var titleLabels = IntroTitleLabels()
    lazy var passwordTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .password)
    lazy var loginButton = IntroButton(type: .system)
    lazy var findPasswordButton = FindPasswordButton(type: .system)
    lazy var planetImageView = UIImageView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupAnimations()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        leaveAnimator?.startAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        enterAnimator?.startAnimation(afterDelay: fastDelay)
    }

    override func bind() {

        viewModel.$passwordTextFieldState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                self?.passwordTextFieldView.updateState(currentState)
            }
            .cancel(with: cancelBag)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.loginButton.loading = isLoading
            }
            .cancel(with: cancelBag)

    }

    override func setAttribute() {
        super.setAttribute()

        navigationItem.backButtonTitle = ""
        navigationItem.title = "로그인"

        titleLabels.title = "다시 찾아주셨네요!"
        titleLabels.subTitle = "반갑습니다"

        planetImageView.alpha = 0
        planetImageView.image = .init(.img_planet)

        passwordTextFieldView.delegate = self

        loginButton.title = "들어가기"
        loginButton.addTarget(self, action: #selector(loginButtonDidTapped), for: .touchUpInside)
        
        findPasswordButton.addTarget(self, action: #selector(findPasswordButtonDidTapped), for: .touchUpInside)
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(titleLabels)
        view.addSubview(passwordTextFieldView)
        view.addSubview(loginButton)
        view.addSubview(findPasswordButton)
        view.addSubview(planetImageView)

        titleLabels.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(54)
        }
        passwordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleLabels.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        findPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        planetImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(-46)
            make.height.equalTo(planetImageView.snp.width).multipliedBy(1)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
//        self.passwordTextFieldView.resignFirstResponder()
    }
}

// MARK: - UI
extension EnterPasswordViewController {

    private func setupAnimations() {
        enterAnimator?.addAnimations {
            self.planetImageView.alpha = 1
            self.planetImageView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(149)
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Button Clicked
extension EnterPasswordViewController {

    @objc
    func loginButtonDidTapped() {
        viewModel.loginButtonDidTapped()
    }

    @objc
    func findPasswordButtonDidTapped() {
        viewModel.findPasswordButtonDidTapped()
    }
}

extension EnterPasswordViewController: TextFieldWithMessageViewComponentDelegate {

    func textFieldDidChange(_ text: String) {
        viewModel.textFieldDidChange(text)
    }
}
