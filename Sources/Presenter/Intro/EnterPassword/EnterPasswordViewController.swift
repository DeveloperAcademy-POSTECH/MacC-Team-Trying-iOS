//
//  EnterPasswordViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class EnterPasswordViewController: IntroAnimatedViewController {
    var viewModel: EnterPasswordViewModel

    init(viewModel: EnterPasswordViewModel) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.passwordTextFieldView.textFieldBecomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateInitViews()
    }

    lazy var titleLabels = IntroTitleLabels()
    lazy var passwordTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .password)
    lazy var loginButton = IntroButton(type: .system)
    lazy var findPasswordButton = FindPasswordButton(type: .system)
    lazy var planetImageView = UIImageView()
}

// MARK: - UI
extension EnterPasswordViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }

    private func setAttributes() {
        title = "로그인"
        planetImageView.alpha = 0
        planetImageView.image = .init(.img_planet)
        loginButton.title = "들어가기"
        titleLabels.title = "다시 찾아주셨네요!"
        titleLabels.subTitle = "반갑습니다"
        loginButton.addTarget(self, action: #selector(loginButtonDidTapped), for: .touchUpInside)
        findPasswordButton.addTarget(self, action: #selector(findPasswordButtonDidTapped), for: .touchUpInside)
    }

    private func setLayout() {
        view.addSubview(titleLabels)
        view.addSubview(passwordTextFieldView)
        view.addSubview(loginButton)
        view.addSubview(findPasswordButton)
        view.addSubview(planetImageView)

        titleLabels.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(54)
        }
        passwordTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleLabels.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        findPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        planetImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(-46)
        }
        planetImageView.sizeToFit()
    }

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
        view.bringSubviewToFront(passwordTextFieldView)
        view.bringSubviewToFront(loginButton)
        view.bringSubviewToFront(findPasswordButton)
    }
}

// MARK: - Button Clicked
extension EnterPasswordViewController {

    @objc
    func loginButtonDidTapped() {
        viewModel.loginButtonDidTapped()
    }

    @objc
    func findPasswordButtonDidTapped() {
        viewModel.findPasswordButtonDidTapped()
    }
}
