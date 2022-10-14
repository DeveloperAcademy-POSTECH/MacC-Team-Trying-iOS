//
//  LoginViewController.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit
import PinLayout
import FlexLayout

final class LoginViewController: BaseViewController {
    let viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
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

    lazy var loginButton: UIButton = UIButton(type: .system)
}

// MARK: - UI
extension LoginViewController {
    private func setUI() {
        setAttribute()
        setLayout()
    }

    private func setAttribute() {
        loginButton.setTitle("이메일로 로그인", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 15
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(loginBttonDidTapped), for: .touchUpInside)
    }

    private func setLayout() {
        view.addSubview(loginButton)

        loginButton.pin.left().right().margin(20).bottom(100).height(60)
    }
}

// MARK: Button Clicked
extension LoginViewController {

    @objc
    private func loginBttonDidTapped() {
        viewModel.loginButtonDidTapped()
    }
}
