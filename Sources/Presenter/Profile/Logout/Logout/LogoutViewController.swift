//
//  LogoutViewController.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

enum LogoutType {
    case logout
    case withdraw
}

final class LogoutViewController: BaseViewController {
    var viewModel = LogoutViewModel()
    var logoutType: LogoutType
    
    var myCancelBag = Set<AnyCancellable>()
    
    let agreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("위 내용을 확인 후 동의합니다.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -100, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderColor = .designSystem(.white)
        button.layer.borderWidth = 1
        button.tintColor = .designSystem(.mainYellow)
        return button
    }()

    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .designSystem(.gray818181)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.setTitleColor(.designSystem(.white), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.isEnabled = false
        return button
    }()
    
    init(logoutType: LogoutType) {
        self.logoutType = logoutType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        viewModel.$isAgreed
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] revievedValue in
                self?.setAgreeButton(checked: revievedValue)
                self?.setNextButton(revievedValue)
            })
            .store(in: &myCancelBag)
        
        // output
        
    }
    
    private func setAgreeButton(checked: Bool) {
        agreeButton.layer.borderColor = checked ? .designSystem(.mainYellow) : .designSystem(.white)
        agreeButton.setImage(UIImage(systemName: checked ? "checkmark.circle.fill" : "circle"), for: .normal)
    }
    
    private func setNextButton(_ agreed: Bool) {
        nextButton.setTitleColor(agreed ? .black : .white, for: .normal)
        nextButton.backgroundColor = .designSystem(agreed ? .mainYellow : .gray818181)
        nextButton.isEnabled = agreed ? true : false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.setTitle(logoutType == .logout ? "행성나가기" : "회원탈퇴", for: .normal)
        setUI()
        bind()
    }
    
    @objc
    func agreeButtonTapped() {
        viewModel.isAgreed.toggle()
    }
    
    @objc
    func nextButtonTapped() {
        print("다음으로 넘어갑니다")
    }
}

// MARK: - UI
extension LogoutViewController {
    private func setUI() {
        setAttributes()
        setConstraints()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        view.addSubview(agreeButton)
        view.addSubview(nextButton)
        agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setConstraints() {
        agreeButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(58)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(agreeButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(58)
        }
    }
}
