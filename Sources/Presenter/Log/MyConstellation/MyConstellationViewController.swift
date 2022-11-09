//
//  MyConstellationViewController.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/08.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class MyConstellationViewController: BaseViewController {
    var viewModel: MyConstellationViewModel
    
    private var testLabel: UILabel = {
       let label = UILabel()
        label.text = "내 별자리 확인 뷰입니다만?"
        label.tintColor = .white
        label.font = UIFont.designSystem(weight: .bold, size: ._30)
        return label
    }()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        // output
    }
    
    init(viewModel: MyConstellationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - UI
extension MyConstellationViewController {
    private func setUI() {
        setAttributes()
        setConstraints()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setConstraints() {
        view.addSubview(testLabel)
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
