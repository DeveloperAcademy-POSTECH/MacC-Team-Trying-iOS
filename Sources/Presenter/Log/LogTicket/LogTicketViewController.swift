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

final class LogTicketViewController: BaseViewController {

    var viewModel: LogTicketViewModel?
    
    private var logTicketView = LogTicketView()
    /// View Model과 bind 합니다.
    private func bind() {
        // input

        // output
    }
    // MARK: Life-Cycle
    init(viewModel: LogTicketViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.navigationController?.isNavigationBarHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
        addButtonTarget()
    }
}
// MARK: - UI
extension LogTicketViewController {
    private func setUI() {
        configureTicketView()
        setLayout()
    }
    private func configureTicketView() {
        guard let viewModel = viewModel else { return }
        logTicketView.dateLabel.text = viewModel.data?.date
        logTicketView.numberLabel.text = "\(viewModel.data!.id)번째"
        logTicketView.courseNameLabel.text = viewModel.data?.title
        logTicketView.fromLabel.text = viewModel.data?.planet
        logTicketView.imageUrl = viewModel.data!.images
        logTicketView.bodyTextView.text = viewModel.data?.body
    }
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        view.addSubview(logTicketView)
        logTicketView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(DeviceInfo.screenHeight * 0.05924170616)
            make.centerX.equalToSuperview()
            make.width.equalTo(DeviceInfo.screenWidth * 0.8974358974)
            make.height.equalTo(DeviceInfo.screenHeight * 0.8163507109)
        }
    }
    
    private func addButtonTarget() {
        logTicketView.dismissButton.addTarget(self, action: #selector(tapDismissButton), for: .touchUpInside)
        logTicketView.likebutton.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        logTicketView.flopButton.addTarget(self, action: #selector(tapFlopButton), for: .touchUpInside)
    }
    
    @objc
    func tapDismissButton() {
        guard let viewModel = viewModel else { return }
        viewModel.tapDismissButton()
    }
    
    @objc
    func tapLikeButton() {
        guard let viewModel = viewModel else { return }
        viewModel.tapLikeButton()
    }
    
    @objc
    func tapFlopButton() {
        guard let viewModel = viewModel else { return }
        viewModel.tapFlopButton()
    }
}
