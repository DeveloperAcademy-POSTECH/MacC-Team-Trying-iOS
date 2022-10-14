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
    
    private lazy var viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Feed"
        return label
    }()
    
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
                                      body: "찰리랑 놀아서 개좋았다..ㅎ 담에 또 찰리랑 놀고 싶다...",
                                      date: "2022년 10월 10일",
                                      tag: ["삐갈레브레드", "도산공원"],
                                      image: "lakeImage")
            data.append(model)
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        feedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        feedCollectionView?.isPagingEnabled = true
        feedCollectionView?.dataSource = self
        feedCollectionView?.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else { return FeedCollectionViewCell() }

        cell.configure(with: model)

        return cell
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
        
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {
        view.addSubview(viewLabel)
        
        viewLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
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
