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
    
    var viewModel: LogHomeViewModel
    
    private var testLabel: UILabel = {
       let label = UILabel()
        label.text = "로그-홈뷰입니다만?"
        label.tintColor = .white
        label.font = UIFont.designSystem(weight: .bold, size: ._30)
        return label
    }()
    
    private var mapButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "ic_map"), for: .normal)
        return button
    }()
    
    private var listButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "ic_list"), for: .normal)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life - Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
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
        view.addSubviews(
            testLabel,
            mapButton,
            listButton
        )
        mapButton.addTarget(self, action: #selector(tapMapButton), for: .touchUpInside)
        listButton.addTarget(self, action: #selector(TapTestButton), for: .touchUpInside)
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        mapButton.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth * 0.1102564103)
            make.height.equalTo(DeviceInfo.screenHeight * 0.0509478673)
            make.right.equalToSuperview().inset(DeviceInfo.screenWidth * 0.05128205128)
            make.top.equalToSuperview().inset(DeviceInfo.screenHeight * 0.0663507109)
        }
        listButton.snp.makeConstraints { make in
            make.width.height.equalTo(mapButton.snp.width)
            make.centerX.equalTo(mapButton.snp.centerX)
            make.top.equalTo(mapButton.snp.bottom).offset(DeviceInfo.screenWidth * 0.05128205128)
        }
    }
    
    @objc
    func tapMapButton() {
        viewModel.pushMyConstellationView()
    }
    
    @objc
    func TapTestButton() {
        let viewModel = LogTicketViewModel.shared
        let viewController = LogTicketViewController(viewModel: viewModel)
        viewController.view.backgroundColor = .clear
        viewController.modalPresentationStyle = .pageSheet
        self.present(viewController, animated: true)
    }
}
