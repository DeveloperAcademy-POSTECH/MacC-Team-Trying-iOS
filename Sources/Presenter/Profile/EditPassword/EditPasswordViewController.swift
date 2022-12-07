//
//  EditPasswordViewController.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class EditPasswordViewController: BaseViewController {

    let viewModel: EditPasswordViewModel

    init(viewModel: EditPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    lazy var passwordTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .password)
    lazy var passwordChangeTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .password)
    lazy var rePasswordChangeTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .password)
    lazy var nextButton = IntroButton(type: .system)

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {

        viewModel.$nextButtonIsEnable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.nextButton.isEnabled = isEnabled
            }
            .cancel(with: cancelBag)

        viewModel.$passwordState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                self?.passwordTextFieldView.updateState(currentState)
            }
            .cancel(with: cancelBag)

        viewModel.$changePasswordState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                self?.passwordChangeTextFieldView.updateState(currentState)
            }
            .cancel(with: cancelBag)

        viewModel.$repasswordState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                self?.rePasswordChangeTextFieldView.updateState(currentState)
            }
            .cancel(with: cancelBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeNotifications()
    }

}

// MARK: - UI
extension EditPasswordViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }

    private func setAttributes() {
        navigationItem.title = "비밀번호 수정"
        passwordTextFieldView.delegate = self
        passwordTextFieldView.updatePlaceholder("현재 비밀번호")
        passwordChangeTextFieldView.delegate = self
        passwordChangeTextFieldView.updatePlaceholder("변경  비밀번호")
        rePasswordChangeTextFieldView.delegate = self
        rePasswordChangeTextFieldView.updatePlaceholder("변경 비밀번호 확인")
        nextButton.title = "수정 완료"
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }

    private func setLayout() {
        view.addSubview(passwordTextFieldView)
        view.addSubview(passwordChangeTextFieldView)
        view.addSubview(rePasswordChangeTextFieldView)
        view.addSubview(nextButton)

        passwordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        passwordChangeTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        rePasswordChangeTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(passwordChangeTextFieldView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

    @objc
    func nextButtonDidTap() {
        viewModel.editPassword()

    }
}

extension EditPasswordViewController: TextFieldWithMessageViewComponentDelegate {

    func textFieldDidChange(_ textFieldView: UIView, _ text: String) {
        if textFieldView == passwordTextFieldView {
            viewModel.textField1DidChange(text)
        } else if textFieldView == rePasswordChangeTextFieldView {
            viewModel.textField3DidChange(text)
        } else {
            viewModel.textField2DidChange(text)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }

    private func setNotifications() {
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

    private func removeNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
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
