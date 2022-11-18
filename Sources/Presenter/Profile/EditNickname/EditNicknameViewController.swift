//
//  EditNicknameViewController.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class EditNicknameViewController: BaseViewController {

    let viewModel: EditNicknameViewModel

    init(viewModel: EditNicknameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var titleLabels = IntroTitleLabels()
    lazy var codeTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .nickname)
    lazy var nextButton = IntroButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        setAttribute()
        setLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeNotifications()
    }

    private func bind() {

        viewModel.$nicknameTextFieldState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                self?.codeTextFieldView.updateState(currentState)
                self?.nextButton.isEnabled = currentState == .validNickname
            }
            .cancel(with: cancelBag)

    }

    private func setAttribute() {

        navigationItem.backButtonTitle = ""
        navigationItem.title = "닉네임 수정"

        titleLabels.subTitle = "닉네임을 입력해 주세요!"

        codeTextFieldView.delegate = self

        nextButton.title = "수정 완료"
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }

    private func setLayout() {

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

extension EditNicknameViewController {
    @objc
    func nextButtonDidTap() {
        viewModel.nextButtonDidTapped()
    }
}

extension EditNicknameViewController: TextFieldWithMessageViewComponentDelegate {

    func textFieldDidChange(_ text: String) {
        viewModel.textFieldDidChange(text)
    }

    func textFieldDidChange(_ textFieldView: UIView, _ text: String) { }
}
