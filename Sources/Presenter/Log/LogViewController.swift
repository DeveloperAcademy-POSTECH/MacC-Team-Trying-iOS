//
//  FeedViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Modified by 정영진 on 2022/10/21
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class LogViewController: BaseViewController {

    var viewModel: LogViewModel?
    
    private var logTicketView = LogTicketView()
    /// View Model과 bind 합니다.
    private func bind() {
        // input

        // output
    }
    // MARK: Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logTicketView)
        configure()
        setUI()
        bind()
    }
}
// MARK: - UI
extension LogViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }
    /// Attributes를 설정합니다.
    private func setAttributes() {
        
    }
    
    private func configure() {
        guard let viewModel = viewModel else {
            print("fatal error")
            return
        }
        logTicketView.dateLabel.text = viewModel.data?.date
        logTicketView.numberLabel.text = "\(viewModel.data!.id)번째"
        logTicketView.courseNameLabel.text = viewModel.data?.title
        logTicketView.fromLabel.text = viewModel.data?.planet
        logTicketView.imageUrl = viewModel.data!.images
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        logTicketView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(DeviceInfo.screenHeight * 0.05924170616)
            make.centerX.equalToSuperview()
            make.width.equalTo(DeviceInfo.screenWidth * 0.8974358974)
            make.height.equalTo(DeviceInfo.screenHeight * 0.8163507109)
        }
    }
}
