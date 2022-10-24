//
//  EnterEmailViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class EnterEmailViewController: PlanetAnimatedViewController<EnterEmailViewModel> {

    lazy var titleLabels = IntroTitleLabels()
    lazy var emailTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .email)
    lazy var nextButton = IntroButton(type: .system)
    lazy var planetImageView = UIImageView()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        beginAnimations()
        bringsInteractionFront()
    }

    override func setAttribute() {
        super.setAttribute()

        title = "로그인"

        titleLabels.title = "맛스타 이용을 위해서"
        titleLabels.subTitle = "로그인을 해주세요!"

        planetImageView.alpha = 0
        planetImageView.image = .init(.img_planet)

        emailTextFieldView.delegate = self

        nextButton.title = "계속하기"
        nextButton.addTarget(self, action: #selector(loginButtonDidTapped), for: .touchUpInside)
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(titleLabels)
        view.addSubview(emailTextFieldView)
        view.addSubview(nextButton)
        view.addSubview(planetImageView)

        titleLabels.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(54)
        }
        emailTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleLabels.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        planetImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(-46)
        }
    }
}

extension EnterEmailViewController {

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
        view.bringSubviewToFront(nextButton)
    }
}

// MARK: - Button Clicked
extension EnterEmailViewController {

    @objc
    func loginButtonDidTapped() {
        leaveAnimator?.addAnimations {
            self.planetImageView.alpha = 0
            self.planetImageView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            }
            self.view.layoutIfNeeded()
        }

        leaveAnimator?.addCompletion { [weak self] _ in
            self?.viewModel.enterEmailButtonDidTapped()
        }

        leaveAnimator?.startAnimation()
    }
}

// MARK: TextFieldWithMessageViewComponentDelegate
extension EnterEmailViewController: TextFieldWithMessageViewComponentDelegate {

    func textFieldDidChange(_ text: String) {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let result = text.range(of: emailPattern, options: .regularExpression)
        let validEmail = (result != nil)
        if validEmail {
            emailTextFieldView.showError(type: .noError)
        } else {
            emailTextFieldView.showError(type: .invalidEmail)
        }
    }
}
