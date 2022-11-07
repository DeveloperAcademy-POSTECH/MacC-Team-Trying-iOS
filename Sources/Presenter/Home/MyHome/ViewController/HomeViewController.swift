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
import Lottie

final class HomeViewController: BaseViewController {
    
    lazy var backgroundView = BackgroundView(frame: view.bounds)
    let viewModel: HomeViewModel
    
    let homeTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.gmarksans(weight: .bold, size: ._20)
        label.attributedText = String.makeAtrributedString(
            name: "카리나",
            appendString: " 님과 함께",
            changeAppendStringSize: ._15,
            changeAppendStringWieght: .light,
            changeAppendStringColor: .white
        )
        label.textColor = .white
        return label
    }()
    
    lazy var alarmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "AlarmButton"), for: .normal)
        button.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let ddayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.gmarksans(weight: .bold, size: ._25)
        label.text = "D+254"
        label.textColor = .white
        return label
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setAttributes()
        setUI()
    }
    
    @objc
    func alarmButtonTapped() {
        print("알람버튼이눌렸습니다")
    }
}

// MARK: - UI
extension HomeViewController {
    func setAttributes() {
        view.addSubview(homeTitle)
        view.addSubview(alarmButton)
        view.addSubview(ddayLabel)
    }
    
    func setUI() {
        homeTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(200)
            make.height.equalTo(25)
        }
        
        alarmButton.snp.makeConstraints { make in
            make.top.equalTo(homeTitle.snp.top)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(32)
        }
        
        ddayLabel.snp.makeConstraints { make in
            make.top.equalTo(homeTitle.snp.bottom)
            make.leading.equalTo(homeTitle.snp.leading)
        }
    }
}
