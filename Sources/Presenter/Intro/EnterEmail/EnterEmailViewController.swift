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

final class EnterEmailViewController: IntroAnimatedViewController<EnterEmailViewModel> {

    lazy var titleLabels = IntroTitleLabels()
    lazy var emailTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .email)
    lazy var nextButton = IntroButton(type: .system)
    lazy var planetImageView = UIImageView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.emailTextFieldView.textFieldBecomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateInitViews()
    }

    override func setAttribute() {
        super.setAttribute()

        planetImageView.alpha = 0
        planetImageView.image = .init(.img_planet)
        nextButton.title = "계속하기"
        titleLabels.title = "맛스타 이용을 위해서"
        titleLabels.subTitle = "로그인을 해주세요!"
        title = "로그인"
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
        planetImageView.sizeToFit()
    }

}

// MARK: - UI
extension EnterEmailViewController {

    private func animateInitViews() {
        planetImageView.snp.updateConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(179)
        }
        UIView.animate(
            withDuration: fastDuration,
            delay: fastDelay,
            animations: {
                self.planetImageView.alpha = 1
                self.view.layoutIfNeeded()
            }
        )
        view.bringSubviewToFront(emailTextFieldView)
        view.bringSubviewToFront(nextButton)
    }
}

// MARK: - Button Clicked
extension EnterEmailViewController {
    @objc
    func loginButtonDidTapped() {
        viewModel.enterEmailButtonDidTapped()
    }
}
