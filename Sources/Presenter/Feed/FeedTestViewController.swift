//
//  FeedTestViewController.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class FeedTestViewController: BaseViewController {
    var viewModel: FeedTestViewModel?

    private var feedCollectionView: UICollectionView?

    private var data = [TestViewModel]()
    
    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }

    // MARK: Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<10 {
            let model = TestViewModel(id: 1,
                                      planet: "우디",
                                      title: "부산풀코스",
                                      body: "찰리랑 놀아서 개좋았다..ㅎ 담에 또 찰리랑 놀고 싶다...찰리랑 놀아서 개좋았다..ㅎ 담에 또 찰리랑 놀고 싶다...찰리랑 놀아서 개좋았다..ㅎ 담에 또 찰리랑 놀고 싶다...찰리랑 놀아서 개좋았다..ㅎ 담에 또 찰리랑 놀고 싶다...찰리랑 놀아서 개좋았다..ㅎ 담에 또 찰리랑 놀고 싶다...찰리랑 놀아서 개좋았다..ㅎ 담에 또 찰리랑 놀고 싶다...찰리랑 놀아서 개좋았다..ㅎ 담에 또 찰리랑 놀고 싶다...찰리랑 놀아서 개좋았다..ㅎ 담에 또 찰리랑 놀고 싶다...찰리랑 놀아서 개좋았다..ㅎ 담에 또 찰리랑 놀고 싶다...찰리랑 놀아서 개좋았다..ㅎ 담에 또 찰리랑 놀고 싶다...찰리랑 놀아서 개좋았다..ㅎ ",
                                      date: "2022년 10월 10일",
                                      tag: ["삐갈레브레드삐갈레브레드", "도산공원", "가나다라마사아자타"],
                                      image: "lakeImage")
            data.append(model)
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        feedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        feedCollectionView?.isPagingEnabled = true
        feedCollectionView?.dataSource = self
        feedCollectionView?.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        view.addSubview(feedCollectionView!)
        setUI()
        bind()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedCollectionView?.frame = view.bounds
    }
}

extension FeedTestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = data[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else { return FeedCell() }

        cell.configure(with: model)
        cell.delegate = self

        return cell
    }
}

extension FeedTestViewController: FeedCollectionViewCellDelegate {
    func didTapLikeButton(model: TestViewModel) {
        print("like Button Tapped")
    }

    func didTapListButton(model: TestViewModel) {
        print("List Button Tapped")
    }

    func didTapMapButton(model: TestViewModel) {
        print("Map Button Tapped")
    }

    func didTapFollowButton(model: TestViewModel) {
        print("follow Button Tapped")
    }
}

// MARK: - UI
extension FeedTestViewController {
    private func setUI() {
        setAttributes()
        setLayout()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        feedCollectionView?.contentInsetAdjustmentBehavior = .never
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {

    }
}

#if DEBUG

import SwiftUI
struct FeedTestViewControllerReperesentable: UIViewControllerRepresentable {

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // empty
    }

    @available(iOS 13.0.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        FeedTestViewController()
    }
}

@available(iOS 13.0.0, *)
struct FeedTestViewControllerRepresentablePreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            FeedTestViewControllerReperesentable()
                .ignoresSafeArea()
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
        }
    }
}
#endif
