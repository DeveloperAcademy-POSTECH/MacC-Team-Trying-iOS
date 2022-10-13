//
//  TestViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/11.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class TestViewController: BaseViewController {
    var viewModel: TestViewModel?

    private lazy var viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setConstraints()
        bind()
    }
}

// MARK: - UI
extension TestViewController {
    /// 화면에 그려질 View들을 추가합니다.
    private func setUI() {
        view.addSubview(viewLabel)
    }
    
    /// 화면에 그려진 View들의 Constraints를 SnapKit을 사용하여 설정합니다.
    private func setConstraints() {
        viewLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Bind
extension TestViewController {
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
    }
}
