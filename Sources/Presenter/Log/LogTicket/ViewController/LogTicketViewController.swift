//
//  LogTicketViewController.swift
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

enum ReviewState {
    case onlyMe
    case onlyMate
    case both
    case noReview
}

final class LogTicketViewController: BaseViewController {
    
    private var reviewState = ReviewState.noReview
    
    private var didTapLikeButton: Bool = false
    
    var viewModel: LogTicketViewModel
    
    private var firstView = UIView()
    
    private var secondView = UIView()
    
    // MARK: Initializer
    init(viewModel: LogTicketViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            try await viewModel.fetchReviews()
            setReviewState()
            print("#################")
            print(self.reviewState)
            setUI()
        }
    }
}
// MARK: - UI
extension LogTicketViewController {
    
    private func setReviewState() {
        let myReview = viewModel.reviews[0]
        let mateReview = viewModel.reviews[1]
        
        let myReviewExist = (myReview.name.isEmpty) ? false : true
        let mateReviewExist = (mateReview.name.isEmpty) ? false : true
        
        let reviewState = (myReviewExist, mateReviewExist)
        
        switch reviewState {
        case (true, true):
            self.reviewState = .both
        case (true, false):
            self.reviewState = .onlyMe
        case (false, true):
            self.reviewState = .onlyMate
        case (false, false):
            self.reviewState = .noReview
        }
    }
    
    private func setUI() {
        super.backgroundView.isHidden = true
        setLayout()
    }
    
    func configureTicketView(ticketView: LogTicketView, index: Int) {
        ticketView.imageUrl = viewModel.reviews[index].imagesURL
        ticketView.bodyTextView.text = viewModel.reviews[index].content
        ticketView.courseNameLabel.text = viewModel.reviews[index].name
        ticketView.dateLabel.text = viewModel.course.date
        ticketView.numberLabel.text = "\(viewModel.currentIndex + 1)번째"
        ticketView.fromLabel.text = "수정"
    }
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        
        view.addSubviews(
            firstView,
            secondView
        )
        
        firstView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(DeviceInfo.screenWidth * 0.8974358974)
            make.height.equalTo(DeviceInfo.screenHeight * 0.8163507109)
        }
        secondView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(DeviceInfo.screenWidth * 0.8974358974)
            make.height.equalTo(DeviceInfo.screenHeight * 0.8163507109)
        }
        
        switch reviewState {
        case .onlyMe:
            onlyMe()
        case .onlyMate:
            onlyMate()
        case .both:
            both()
        case .noReview:
            break
        }
        
        secondView.isHidden = true
    }
    
    @objc
    func tapLikeButton() {
        print("like Button Tapped")
        viewModel.tapLikeButton()
    }
    
    private func onlyMe() {
        
        let myTicketView = LogTicketView()
        let logTicketEmptyView = LogTicketEmptyView()
        
        firstView.addSubview(myTicketView)
        secondView.addSubview(logTicketEmptyView)
        
        myTicketView.flopButton.addTarget(self, action: #selector(tapFlopButton), for: .touchUpInside)
        myTicketView.likebutton.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        logTicketEmptyView.flopButton.addTarget(self, action: #selector(tapFlopButton), for: .touchUpInside)
        
        configureTicketView(ticketView: myTicketView, index: 0)
        logTicketEmptyView.bottomButton.isHidden = true
        logTicketEmptyView.logTicketEmptyViewLabel.text = "메이트의 후기가 아직 없어요!"
        
        myTicketView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        logTicketEmptyView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    private func onlyMate() {
        let logTicketEmptyView = LogTicketEmptyView()
        let mateTicketView = LogTicketView()
        
        firstView.addSubview(mateTicketView)
        secondView.addSubview(logTicketEmptyView)
        
        configureTicketView(ticketView: mateTicketView, index: 1)
        
        logTicketEmptyView.flopButton.addTarget(self, action: #selector(tapFlopButton), for: .touchUpInside)
        mateTicketView.flopButton.addTarget(self, action: #selector(tapFlopButton), for: .touchUpInside)
        mateTicketView.likebutton.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        
        mateTicketView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        logTicketEmptyView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    private func both() {
        
        let myTicketView = LogTicketView()
        let mateTicketView = LogTicketView()
        
        firstView.addSubview(myTicketView)
        secondView.addSubview(mateTicketView)
        
        configureTicketView(ticketView: myTicketView, index: 0)
        configureTicketView(ticketView: mateTicketView, index: 1)
        
        myTicketView.flopButton.addTarget(self, action: #selector(tapFlopButton), for: .touchUpInside)
        mateTicketView.flopButton.addTarget(self, action: #selector(tapFlopButton), for: .touchUpInside)
        myTicketView.likebutton.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        mateTicketView.likebutton.addTarget(self, action: #selector(tapLikeButton), for: .touchUpInside)
        
        myTicketView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        mateTicketView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    @objc
    func tapFlopButton() {
        
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        // MARK: Card Flip Animation
        UIView.transition(with: firstView, duration: 0.7, options: transitionOptions, animations: {
            self.firstView.isHidden.toggle()
        })
        
        UIView.transition(with: secondView, duration: 0.7, options: transitionOptions, animations: {
            self.secondView.isHidden.toggle()
        })
        
        viewModel.tapFlopButton()
    }
}
