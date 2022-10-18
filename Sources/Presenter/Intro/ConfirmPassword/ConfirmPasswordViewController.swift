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

final class ConfirmPasswordViewController: BaseViewController {
    var viewModel: ConfirmPasswordViewModel

    init(viewModel: ConfirmPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }

    lazy var emailImageView = UIImageView(image: .init(.ic_email_login))
    lazy var titleLabels = IntroTitleLabels()
    lazy var enterPasswordButton = IntroButton(type: .system)
}

// MARK: - UI
extension ConfirmPasswordViewController {
    private func setUI() {
        setAttributes()
        addSubviews()
    }

    private func setAttributes() {
        self.navigationItem.hidesBackButton = true
        enterPasswordButton.title = "비밀번호 입력하러 가기"
        titleLabels.title = "회원가입 시 등록한 이메일로"
        titleLabels.subTitle = "임시 패스워드가 발송 되었습니다."
        enterPasswordButton.addTarget(self, action: #selector(enterPasswordButtonDIdTapped), for: .touchUpInside)
    }
    private func addSubviews() {
        view.addSubview(emailImageView)
        view.addSubview(titleLabels)
        view.addSubview(enterPasswordButton)
    }

    private func setLayout() {
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
