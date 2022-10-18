//
//  ConfirmPasswordViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import PinLayout

final class ConfirmPasswordViewController: IntroBaseViewController<ConfirmPasswordViewModel> {

    lazy var emailImageView = UIImageView(image: .init(.ic_email_login))
    lazy var titleLabels = IntroTitleLabels()
    lazy var enterPasswordButton = IntroButton(type: .system)

    override func bind() {}

    override func setAttribute() {
        super.setAttribute()
        
        self.navigationItem.hidesBackButton = true
        enterPasswordButton.title = "비밀번호 입력하러 가기"
        titleLabels.title = "회원가입 시 등록한 이메일로"
        titleLabels.subTitle = "임시 패스워드가 발송 되었습니다."
        enterPasswordButton.addTarget(self, action: #selector(enterPasswordButtonDIdTapped), for: .touchUpInside)
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(emailImageView)
        view.addSubview(titleLabels)
        view.addSubview(enterPasswordButton)

        emailImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(166)
            make.centerY.equalToSuperview().offset(-40)
            make.width.equalTo(emailImageView.snp.height).multipliedBy(1).priority(1000)
        }
        titleLabels.snp.makeConstraints { make in
            make.top.equalTo(emailImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        enterPasswordButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Button Clicked
extension ConfirmPasswordViewController {
    @objc
    func enterPasswordButtonDIdTapped() {
        viewModel.enterPasswordButtonDIdTapped()
    }
}
