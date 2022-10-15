//
//  FeedTestViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class FeedTestViewController: BaseViewController {
    var viewModel: FeedTestViewModel?
    
    private lazy var navigationBar1 = CustomNavigationBar(type: .map)
    private lazy var navigationBar2 = CustomNavigationBar(type: .search)
    private lazy var navigationBar3 = CustomNavigationBar(type: .courseDetail)
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setUI()
        bind()
    }
}

// MARK: - UI
extension FeedTestViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        view.addSubviews(navigationBar1, navigationBar2, navigationBar3)
        
        navigationBar1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.top)
        }
        
        navigationBar2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationBar1.snp.bottom).offset(100)
        }
        
        navigationBar3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationBar2.snp.bottom).offset(100)
        }
    }
}
