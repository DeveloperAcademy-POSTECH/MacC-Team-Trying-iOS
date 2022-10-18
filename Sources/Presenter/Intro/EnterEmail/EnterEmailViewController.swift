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

final class EnterEmailViewController: IntroAnimatedViewController {
    let viewModel: EnterEmailViewModel

    init(viewModel: EnterEmailViewModel) {
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateInitViews()
    }

    lazy var logoLabel = LogoLabel()
    lazy var emailTextFieldView: TextFieldWithMessageViewComponent = TextFieldWithMessageView(textType: .email)
    lazy var nextButton = IntroButton(type: .system)
    lazy var planetImageView = UIImageView()
}

// MARK: - UI
extension EnterEmailViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }

    private func setAttributes() {
        planetImageView.alpha = 0
        planetImageView.image = .init(.img_planet)
        nextButton.title = "계속하기"
    }

    private func setLayout() {
        view.addSubview(logoLabel)
        view.addSubview(emailTextFieldView)
        view.addSubview(nextButton)
        view.addSubview(planetImageView)

        logoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(26)
        }
        emailTextFieldView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
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
        self.emailTextFieldView.textFieldBecomeFirstResponder()
        
        view.bringSubviewToFront(emailTextFieldView)
        view.bringSubviewToFront(nextButton)
    }
}
