//
//  InvitationCodeViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class InvitationCodeViewController: IntroBaseViewController<InvitationCodeViewModel> {

    lazy var backgroundView = BackgroundView(frame: view.bounds)
    lazy var titleLabels = IntroTitleLabels()
    lazy var codeTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .invitationCode)
    lazy var planetImageView = UIImageView()
    lazy var planetNameLabel = UILabel()
    lazy var nextButton = IntroButton(type: .system)


    var stageOneChangedAnimator: UIViewPropertyAnimator?
    var stageTwoChangedAnimator: UIViewPropertyAnimator?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeNotifications()
    }

    override func bind() {

        viewModel.$stage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stage in
                switch stage {
                case .notFound:
                    self?.stageOneChangedAnimator?.startAnimation()
                case .found:
                    self?.stageTwoChangedAnimator?.startAnimation()
                }
            }
            .cancel(with: cancelBag)
    }

    override func setAttribute() {
        super.setAttribute()

        navigationItem.title = "코드 입력"

        nextButton.title = "완료"

        titleLabels.title = "메이트가 공유한 코드를 통해서"
        titleLabels.subTitle = "행성에 입장할 수 있어요!!"

        codeTextFieldView.delegate = self

        stageOneChangedAnimator = UIViewPropertyAnimator(duration: 0.4, curve: .linear) {
            self.titleLabels.title = "메이트가 공유한 코드를 통해서"
            self.titleLabels.subTitle = "행성에 입장할 수 있어요!!"
        }
        stageTwoChangedAnimator = UIViewPropertyAnimator(duration: 0.4, curve: .linear) {
            self.titleLabels.title = "환영합니다 🎉"
            self.titleLabels.subTitle = "우디행성을 발견했어요!"
        }
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(backgroundView)
        view.addSubview(titleLabels)
        view.addSubview(codeTextFieldView)
        view.addSubview(planetImageView)
        view.addSubview(planetNameLabel)
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

extension InvitationCodeViewController: TextFieldWithMessageViewComponentDelegate {

    func textFieldDidChange(_ text: String) {
        viewModel.textFieldDidChange(text)
    }
}
