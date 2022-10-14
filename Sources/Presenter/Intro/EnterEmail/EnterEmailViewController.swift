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

final class EnterEmailViewController: BaseViewController {
    var viewModel: EnterEmailViewModel?

    private func bind() {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
    }
}

// MARK: - UI
extension EnterEmailViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }

    private func setAttributes() {
        
    }

    private func setLayout() {
        
    }
}
