//
//  ProfileTestViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class ProfileTestViewController: BaseViewController {
    var viewModel: ProfileTestViewModel?
    
    private lazy var textField1 = CustomTextField(type: .placeSearch)
    private lazy var textField2 = CustomTextField(type: .courseTitle)
    private lazy var textField3 = CustomTextField(type: .location)
    private lazy var textField4 = CustomTextField(type: .shopTitle)
    private lazy var textView = CustomTextView()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
}

// MARK: - UI
extension ProfileTestViewController: NavigationBarConfigurable {
    private func setUI() {
        configureCourseDetailNavigationBar(target: self, popAction: #selector(backButtonPressed(_:)), selectDateAction: #selector(selectDateButtonPressed(_:)))
        setAttributes()
        setLayout()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        view.addSubviews(textField1, textField2, textField3, textField4, textView)
        
        textField1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalToSuperview()
        }
        
        textField2.snp.makeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        textField3.snp.makeConstraints { make in
            make.top.equalTo(textField2.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        textField4.snp.makeConstraints { make in
            make.top.equalTo(textField3.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(textField4.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
    }
}

// MARK: - User Interaction
extension ProfileTestViewController {
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        print("pop")
    }
    
    @objc
    private func selectDateButtonPressed(_ sender: UIButton) {
        print("select date")
    }
}
