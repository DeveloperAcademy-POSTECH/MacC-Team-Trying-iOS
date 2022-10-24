//
//  SignUpEnterNicknameViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class SignUpEnterNicknameViewController: IntroBaseViewController<SignUpEnterNicknameViewModel> {

    lazy var titleLabels = IntroTitleLabels()
    lazy var codeTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .nickname)
    lazy var nextButton = IntroButton(type: .system)

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setNotification()
    }
    
    override func setAttribute() {
        super.setAttribute()

        navigationItem.title = "회원가입"

        titleLabels.subTitle = "닉네임을 입력해 주세요!"

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

extension SignUpEnterNicknameViewController {

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

extension SignUpEnterNicknameViewController {
    @objc
    func nextButtonDidTap() {
        viewModel.nextButtonDidTapped()
    }
}
