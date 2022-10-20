//
//  SearchTestViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class SearchTestViewController: BaseViewController {
    var viewModel: SearchTestViewModel?
    
    private lazy var smallButton1 = SmallRectButton(type: .add)
    private lazy var smallButton2 = SmallRectButton(type: .delete)
    
    private lazy var smallButton3 = SmallRoundButton(type: .addCourse)
    private lazy var smallButton4 = SmallRoundButton(type: .selectDate)
    
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
extension SearchTestViewController: NavigationBarConfigurable {
    private func setUI() {
        configureSearchNavigationBar(target: self, action: nil)
        setAttributes()
        setLayout()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        view.addSubviews(smallButton1, smallButton2)
        
        smallButton1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        
        smallButton2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(smallButton1.snp.bottom).offset(100)
        }
        
        view.addSubviews(smallButton3, smallButton4)
        
        smallButton3.snp.makeConstraints { make in
            make.top.equalTo(smallButton2.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
        
        smallButton4.snp.makeConstraints { make in
            make.top.equalTo(smallButton3.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
    }
}
