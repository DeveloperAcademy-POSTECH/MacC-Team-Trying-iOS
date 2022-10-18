//
//  FindPasswordViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class FindPasswordViewController: BaseViewController {
    var viewModel: FindPasswordViewModel

    init(viewModel: FindPasswordViewModel) {
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

    lazy var titleLabels = IntroTitleLabels()
    lazy var emailView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .email)
    lazy var sendEmailButton = IntroButton(type: .system)
}

// MARK: - UI
extension FindPasswordViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }

    private func setAttributes() {
        title = "비밀번호 찾기"
        sendEmailButton.title = "확인"
        titleLabels.title = "회원가입 시 등록한 이메일 정보로"
        titleLabels.subTitle = "비밀번호를 재설정 할 수 있습니다."
        sendEmailButton.addTarget(self, action: #selector(sendEmailButtonDidTapped), for: .touchUpInside)
    }

    private func setLayout() {
        view.addSubview(titleLabels)
        view.addSubview(emailView)
        view.addSubview(sendEmailButton)

        titleLabels.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(54)
        }
        emailView.snp.makeConstraints { make in
            make.top.equalTo(titleLabels.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        sendEmailButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

extension FindPasswordViewController {
    @objc
    func sendEmailButtonDidTapped() {
        viewModel.sendEmailButtonDidTapped()
    }
}
