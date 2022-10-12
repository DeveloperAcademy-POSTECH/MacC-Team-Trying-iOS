//
//  HomeViewController.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class HomeViewController: BaseViewController {
    var viewModel: HomeViewModel?
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
}

// MARK: - UI
extension HomeViewController {
    private func setUI() {
        setAttributes()
        setConstraints()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setConstraints() {
        
    }
}
