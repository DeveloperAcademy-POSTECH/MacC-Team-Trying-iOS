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
    
    private var testLabel: UILabel = {
       let label = UILabel()
        label.text = "로그-홈뷰입니다만?"
        label.tintColor = .white
        label.font = UIFont.designSystem(weight: .bold, size: ._30)
        return label
    }()
    
    private var mapButton: UIButton = {
       let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "map.fill"), for: .normal)
        return button
    }()
    
    private var testButton: UIButton = {
       let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "pencil.tip"), for: .normal)
        return button
    }()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
    }
    
    init(viewModel: LogHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
        
        // TODO: 삭제해야함
        self.view.backgroundColor = .systemCyan
        view.addSubviews(testLabel, mapButton, testButton)
        mapButton.addTarget(self, action: #selector(tapMapButton), for: .touchUpInside)
        testButton.addTarget(self, action: #selector(TapTestButton), for: .touchUpInside)
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        mapButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.right.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(80)
        }
        testButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.equalTo(mapButton.snp.centerX)
            make.top.equalTo(mapButton.snp.bottom).offset(30)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    @objc
    func tapMapButton() {
        viewModel?.pushMyConstellationView()
    }
    
    @objc
    func TapTestButton() {
        let viewModel = LogTicketViewModel.shared
        let viewController = LogTicketViewController(viewModel: viewModel)
        viewController.view.backgroundColor = .clear
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
}
