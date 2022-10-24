//
//  ConfirmSignUpViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class ConfirmSignUpViewController: PlanetAnimatedViewController<ConfirmSignUpViewModel> {

    lazy var titleLabels = IntroTitleLabels()
    lazy var emailTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .email)
    lazy var signUpButton = IntroButton(type: .system)
    lazy var planetImageView = UIImageView()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        beginAnimations()
        bringsInteractionFront()
    }

    override func bind() {

        viewModel.$email
            .receive(on: DispatchQueue.main)
            .sink { [weak self] email in
                self?.emailTextFieldView.updateText(email)
            }
            .cancel(with: cancelBag)

        viewModel.$emailTextFieldState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                self?.signUpButton.isEnabled = currentState == .good
            }
            .cancel(with: cancelBag)
    }

    override func setAttribute() {
        super.setAttribute()

        title = "로그인"

        titleLabels.title = "등록된 이메일이 없네요."
        titleLabels.subTitle = "가입하시겠어요?"

        planetImageView.alpha = 0
        planetImageView.image = .init(.img_planet)

        emailTextFieldView.delegate = self

        signUpButton.title = "가입하기"
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTapped), for: .touchUpInside)
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(titleLabels)
        view.addSubview(emailTextFieldView)
        view.addSubview(signUpButton)
        view.addSubview(planetImageView)

        titleLabels.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(54)
        }
        emailTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleLabels.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        planetImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(-46)
        }
    }
}

extension ConfirmSignUpViewController {

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

        view.bringSubviewToFront(emailTextFieldView)
        view.bringSubviewToFront(signUpButton)
    }
}

// MARK: - Button Clicked

extension ConfirmSignUpViewController {

    @objc
    func signUpButtonDidTapped() {
        viewModel.signUpButtonDidTapped()
    }
}

extension ConfirmSignUpViewController: TextFieldWithMessageViewComponentDelegate {

    func textFieldDidChange(_ text: String) {
        viewModel.textFieldDidChange(text)
    }
}
