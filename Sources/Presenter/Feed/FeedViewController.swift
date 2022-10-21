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

final class FeedViewController: BaseViewController {

    var viewModel: FeedViewModel?
    private var feedCollectionView: UICollectionView?

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
    }
}

// MARK: - UI
extension FeedViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }
    /// Attributes를 설정합니다.
    private func setAttributes() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        feedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let feedCollectionView = feedCollectionView else { return }
        feedCollectionView.frame = view.bounds
        feedCollectionView.isPagingEnabled = true
        feedCollectionView.dataSource = self
        feedCollectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        feedCollectionView.contentInsetAdjustmentBehavior = .never
    }
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        guard let feedCollectionView = feedCollectionView else { return }
        view.addSubview(feedCollectionView)
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

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let result = data.count
        return result
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = data[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else { return FeedCollectionViewCell() }

        cell.configure(with: model)
        cell.delegate = self

        return cell
    }
}

extension FeedViewController: FeedCollectionViewCellDelegate {
    func didTapLikeButton(model: TestViewModel) {
        print("like Button Tapped")
        viewModel?.didTapLikeButton()
    }

    func didTapListButton(model: TestViewModel) {
        print("List Button Tapped")
        viewModel?.didTapListButton()
    }

    func didTapMapButton(model: TestViewModel) {
        print("Map Button Tapped")
        viewModel?.didTapMapButton()
    }

    func didTapFollowButton(model: TestViewModel) {
        print("follow Button Tapped")
        viewModel?.didTapFollowButton()
    }
}
