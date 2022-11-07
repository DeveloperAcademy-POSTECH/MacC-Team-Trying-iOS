//
//  LogHomeViewController.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/07.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class LogHomeViewController: BaseViewController {
    var viewModel: LogHomeViewModel?
    
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
extension LogHomeViewController {
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
