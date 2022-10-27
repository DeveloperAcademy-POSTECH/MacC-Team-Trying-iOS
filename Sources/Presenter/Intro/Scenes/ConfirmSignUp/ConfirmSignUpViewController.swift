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

        viewModel.$viewType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewType  in
                switch viewType {
                case .confirmSignUp:
                    self?.titleLabels.title = "등록된 이메일이 없네요."
                    self?.titleLabels.subTitle = "가입하시겠어요?"
                case .signup:
                    self?.titleLabels.title = "가입하실 이메일 주소를"
                    self?.titleLabels.subTitle = "입력해주세요!"
                }
            }
            .cancel(with: cancelBag)

        viewModel.$email
            .receive(on: DispatchQueue.main)
            .sink { [weak self] email in
                self?.emailTextFieldView.updateText(email)
            }
            .cancel(with: cancelBag)

        viewModel.$emailTextFieldState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                self?.emailTextFieldView.updateState(currentState)
                self?.signUpButton.isEnabled = currentState == .good
            }
            .cancel(with: cancelBag)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.signUpButton.loading = isLoading
            }
            .cancel(with: cancelBag)

        viewModel.$leaveAnimation
            .receive(on: DispatchQueue.main)
            .filter { $0 == true }
            .sink { [weak self] _ in
                self?.leaveAnimator?.addCompletion { [weak self] _ in
                    self?.viewModel.goNext()
                }

                self?.leaveAnimator?.startAnimation()
            }
            .cancel(with: cancelBag)
    }

    override func setAttribute() {
        super.setAttribute()

        navigationItem.title = "회원가입"

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
            make.height.equalTo(planetImageView.snp.width).multipliedBy(1)
        }
    }
}

extension ConfirmSignUpViewController {

    private func setupAnimations() {

        enterAnimator?.addAnimations {
            self.planetImageView.alpha = 1
            self.planetImageView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(149)
            }
            self.view.layoutIfNeeded()
        }

        leaveAnimator?.addAnimations {
            self.planetImageView.alpha = 0
            self.planetImageView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            }
            self.view.layoutIfNeeded()
        }
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
