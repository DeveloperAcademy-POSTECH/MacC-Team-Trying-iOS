//
//  SignUpEnterPasswordViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class SignUpEnterPasswordViewController: IntroBaseViewController<SignUpEnterPasswordViewModel> {

    lazy var titleLabels = IntroTitleLabels()
    lazy var codeTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .password)
    lazy var nextButton = IntroButton(type: .system)

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setNotification()
    }

    override func bind() {

        viewModel.$passwordTextFieldState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                self?.codeTextFieldView.updateState(currentState)
                self?.nextButton.isEnabled = currentState == .validPassword
            }
            .cancel(with: cancelBag)
    }

    override func setAttribute() {
        super.setAttribute()

        navigationItem.backButtonTitle = ""
        navigationItem.title = "회원가입"

        titleLabels.subTitle = "비밀번호를 입력해 주세요!"

        codeTextFieldView.delegate = self

        nextButton.title = "다음"
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(titleLabels)
        view.addSubview(codeTextFieldView)
        view.addSubview(nextButton)

        titleLabels.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(54)
        }
        codeTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleLabels.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

extension SignUpEnterPasswordViewController {

    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            self.nextButton.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight + Constants.Constraints.spaceBetweenkeyboardAndButton)
            }

            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        self.nextButton.snp.updateConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }

        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
}

extension SignUpEnterPasswordViewController {

    @objc
    func nextButtonDidTap() {
        viewModel.nextButtonDidTapped()
    }
}

extension SignUpEnterPasswordViewController: TextFieldWithMessageViewComponentDelegate {

    func textFieldDidChange(_ text: String) {
        viewModel.textFieldDidChange(text)
    }
}
