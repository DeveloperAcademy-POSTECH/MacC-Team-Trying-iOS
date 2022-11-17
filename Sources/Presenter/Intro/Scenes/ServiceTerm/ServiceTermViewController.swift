//
//  ServiceTermViewController.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/08.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class ServiceTermViewController: IntroBaseViewController<ServiceTermViewModel> {

    lazy var titleLabel = IntroSubTitleLabel()
    lazy var checkButton1 = CheckMarkButton(type: .system)
    lazy var termLabel1 = TermLabel()
    lazy var checkButton2 = CheckMarkButton(type: .system)
    lazy var termLabel2 = TermLabel()
    lazy var checkButton3 = CheckMarkButton(type: .system)
    lazy var termLabel3 = TermLabel()
    lazy var termButton3 = UIButton()
    lazy var checkButton4 = CheckMarkButton(type: .system)
    lazy var termLabel4 = TermLabel()
    lazy var termButton4 = UIButton()
    lazy var buttons: [CheckMarkButton] = [checkButton1, checkButton2, checkButton3, checkButton4]
    lazy var nextButton = IntroButton(type: .system)

    override func bind() {
        viewModel.$isChecked
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isChecked in
                self?.buttons.enumerated().forEach { index, button in
                    button.isChecked = isChecked[index]
                }
                self?.nextButton.isEnabled = isChecked.allSatisfy({ $0 == true })
            }
            .cancel(with: cancelBag)
    }

    override func setAttribute() {
        super.setAttribute()

        navigationItem.backButtonTitle = ""
        navigationItem.title = "이용약관"

        titleLabel.numberOfLines = 0
        let attributedString = NSMutableAttributedString()
            .gmarketSansBold(string: "우주라이크 ", fontSize: ._15)
            .gmarketSansLight(string: "이용을 위해\n약관에 동의해 주세요.", fontSize: ._15)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: .init(location: 0, length: attributedString.length)
        )
        titleLabel.attributedText = attributedString
        nextButton.isEnabled = false
        nextButton.title = "다음"
        nextButton.addTarget(self, action: #selector(nextButtonDidTapped), for: .touchUpInside)

        termLabel1.text = "전체동의"
        termLabel2.text = "(필수)만 14세 이상입니다."
        termLabel3.text = "(필수) 우주라이크 회원약관 및 이용약관 동의"
        termLabel4.text = "(필수) 개인정보처리방침"

        termButton3.titleLabel?.font = .designSystem(weight: .regular, size: ._13)
        termButton3.setTitle("보기", for: .normal)
        termButton3.setTitleColor(.designSystem(.grayC5C5C5), for: .normal)
        termButton3.addTarget(self, action: #selector(termButton3DidTapped), for: .touchUpInside)

        termButton4.titleLabel?.font = .designSystem(weight: .regular, size: ._13)
        termButton4.setTitle("보기", for: .normal)
        termButton4.addTarget(self, action: #selector(termButton4DidTapped), for: .touchUpInside)
        termButton4.setTitleColor(.designSystem(.grayC5C5C5), for: .normal)

        checkButton1.addTarget(self, action: #selector(checkButton1DidTapped), for: .touchUpInside)
        checkButton2.addTarget(self, action: #selector(checkButton2DidTapped), for: .touchUpInside)
        checkButton3.addTarget(self, action: #selector(checkButton3DidTapped), for: .touchUpInside)
        checkButton4.addTarget(self, action: #selector(checkButton4DidTapped), for: .touchUpInside)
    }

    override func setLayout() {
        super.setLayout()

        view.addSubview(titleLabel)
        view.addSubview(checkButton1)
        view.addSubview(checkButton2)
        view.addSubview(checkButton3)
        view.addSubview(checkButton4)
        view.addSubview(termLabel1)
        view.addSubview(termLabel2)
        view.addSubview(termLabel3)
        view.addSubview(termLabel4)
        view.addSubview(nextButton)
        view.addSubview(termButton3)
        view.addSubview(termButton4)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        checkButton1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(25)
        }
        termLabel1.snp.makeConstraints { make in
            make.leading.equalTo(checkButton1.snp.trailing).offset(23)
            make.top.bottom.equalTo(checkButton1)
        }
        checkButton2.snp.makeConstraints { make in
            make.top.equalTo(checkButton1.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(25)
        }
        termLabel2.snp.makeConstraints { make in
            make.leading.equalTo(checkButton2.snp.trailing).offset(23)
            make.top.bottom.equalTo(checkButton2)
        }
        checkButton3.snp.makeConstraints { make in
            make.top.equalTo(checkButton2.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(25)
        }
        termLabel3.snp.makeConstraints { make in
            make.leading.equalTo(checkButton3.snp.trailing).offset(23)
            make.top.bottom.equalTo(checkButton3)
        }
        checkButton4.snp.makeConstraints { make in
            make.top.equalTo(checkButton3.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(25)

        }
        termLabel4.snp.makeConstraints { make in
            make.leading.equalTo(checkButton4.snp.trailing).offset(23)
            make.top.bottom.equalTo(checkButton4)
        }
        termButton3.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalTo(termLabel3)
        }
        termButton4.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalTo(termLabel4)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(58)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

extension ServiceTermViewController {
    @objc
    func nextButtonDidTapped() {
        viewModel.nextButtonDidTapped()
    }

    @objc
    func checkButton1DidTapped() {
        viewModel.checkButton1DidTapped()
    }

    @objc
    func checkButton2DidTapped() {
        viewModel.checkButton2DidTapped()
    }

    @objc
    func checkButton3DidTapped() {
        viewModel.checkButton3DidTapped()
    }

    @objc
    func checkButton4DidTapped() {
        viewModel.checkButton4DidTapped()
    }

    @objc
    func termButton3DidTapped() {
        let viewController = TermViewController(viewModel: .init())
        viewController.termType = .service
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    func termButton4DidTapped() {
        let viewController = TermViewController(viewModel: .init())
        viewController.termType = .privacy
        navigationController?.pushViewController(viewController, animated: true)
    }
}
