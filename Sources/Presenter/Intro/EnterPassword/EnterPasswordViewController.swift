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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        beginAnimations()
        bringsInteractionFront()
    }

    override func setAttribute() {
        super.setAttribute()

        loginButton.title = "들어가기"
        titleLabels.title = "다시 찾아주셨네요!"
        titleLabels.subTitle = "반갑습니다"
        planetImageView.alpha = 0
        planetImageView.image = .init(.img_planet)
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
        }
    }
}

// MARK: - UI
extension EnterPasswordViewController {

    private func beginAnimations() {
        enterAnimator?.addAnimations {
            self.planetImageView.alpha = 1
            self.planetImageView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(179)
            }
            self.view.layoutIfNeeded()
        }

        enterAnimator?.startAnimation(afterDelay: fastDelay)
    }

    private func bringsInteractionFront() {

        view.bringSubviewToFront(passwordTextFieldView)
        view.bringSubviewToFront(loginButton)
        view.bringSubviewToFront(findPasswordButton)
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
