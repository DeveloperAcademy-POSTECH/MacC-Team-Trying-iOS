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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupAnimations()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        leaveAnimator?.startAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        enterAnimator?.startAnimation(afterDelay: fastDelay)
    }

    override func bind() {

        viewModel.$emailTextFieldState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentState in
                self?.emailTextFieldView.updateState(currentState)
                self?.nextButton.isEnabled = currentState == .good
            }
            .cancel(with: cancelBag)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.nextButton.loading = isLoading
            }
            .cancel(with: cancelBag)

        viewModel.$leaveAnimation
            .receive(on: DispatchQueue.main)
            .filter { $0 == true }
            .sink { [weak self] _ in
                self?.leaveAnimator?.addCompletion { _ in
                    self?.viewModel.goNext()
                }
                self?.leaveAnimator?.startAnimation()
            }
            .cancel(with: cancelBag)

    }

    override func setAttribute() {
        super.setAttribute()

        title = "로그인"

        titleLabels.title = "COME IT 이용을 위해서"
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
            make.height.equalTo(planetImageView.snp.width).multipliedBy(1)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
//        self.emailTextFieldView.resignFirstResponder()
    }
}

extension EnterEmailViewController {

    private func setupAnimations() {
        
        enterAnimator?.addAnimations {
            self.planetImageView.alpha = 1
            self.planetImageView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(149)
            }
            self.view.layoutIfNeeded()
        }

        leaveAnimator?.addAnimations {
            self.planetImageView.alpha = 0
            self.planetImageView.snp.updateConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Button Clicked
extension EnterEmailViewController {

    @objc
    func loginButtonDidTapped() {
        viewModel.enterEmailButtonDidTapped()
    }
}

// MARK: TextFieldWithMessageViewComponentDelegate
extension EnterEmailViewController: TextFieldWithMessageViewComponentDelegate {

    func textFieldDidChange(_ text: String) {
        viewModel.textFieldDidChange(text)
    }
}
