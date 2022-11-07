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
//    private var feedCollectionView: UICollectionView?
    
    private var logTicketView = LogTicketView()

    private var data = [TestViewModel]() // MARK: 임시 데이터 연동
    /// View Model과 bind 합니다.
    private func bind() {
        // input

        // output
    }
    // MARK: Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setUI()
        bind()
        view.addSubview(logTicketView)
        logTicketView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.9)
        }
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
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        
    }
    // TODO: MOCK용 임시 함수
    private func setData() {
        for _ in 0...10 {
            let model = TestViewModel(
                id: 1,
                planet: "우디네 행성",
                planetImage: "woodyPlanetImage",
                title: "부산풀코스",
                body: "배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.",
                date: "2022년 10월 20일",
                tag: ["삐갈레브레드", "포항공과대학교", "귀여운승창이"],
                images: ["lakeImage", "lakeImage", "lakeImage", "lakeImage"]
            )
            data.append(model)
        }
    }
}
