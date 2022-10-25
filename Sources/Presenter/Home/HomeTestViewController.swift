//
//  HomeTestViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class HomeTestViewController: BaseViewController {
    
    private lazy var mainButton1 = MainButton(type: .next)
    private lazy var mainButton2 = MainButton(type: .done)
    private lazy var mainButton3 = MainButton(type: .next)
    private lazy var mainButton4 = MainButton(type: .done)
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainButton3.isEnabled = false
        mainButton4.isEnabled = false
        setUI()
        bind()
    }
}

// MARK: - UI
extension HomeTestViewController: NavigationBarConfigurable {
    private func setUI() {
        configureMapNavigationBar(target: self, dismissAction: #selector(backButtonPressed(_:)), pushAction: #selector(pushButtonPressed(_:)))
        setAttributes()
        setLayout()
    }

    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        view.addSubviews(mainButton1, mainButton2, mainButton3, mainButton4)
        
        mainButton1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        
        mainButton2.snp.makeConstraints { make in
            make.centerX.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(mainButton1.snp.bottom).offset(100)
        }
        
        mainButton3.snp.makeConstraints { make in
            make.centerX.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(mainButton2.snp.bottom).offset(100)
        }
        
        mainButton4.snp.makeConstraints { make in
            make.centerX.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(mainButton3.snp.bottom).offset(100)
        }
    }
}

// MARK: - User Interaction
extension HomeTestViewController {
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        print("pop")
    }
    
    @objc
    private func pushButtonPressed(_ sender: UIButton) {
        print("push")
    }
}
