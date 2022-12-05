//
//  LogImageFullScreenViewController.swift
//  우주라이크
//
//  Created by YeongJin Jeong on 2022/12/05.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit

final class LogImageFullScreenViewController: BaseViewController {
    
    var viewModel: LogImageFullScreenViewModel
    
    private var currentImageIndex: Int
    
    private let imageIndexLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .bold, size: ._15)
        return label
    }()
    
    private let fullScreenFlowLayout: UICollectionViewFlowLayout = {
        let width = DeviceInfo.screenWidth
        let height = DeviceInfo.screenHeight * 0.75
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }()
    
    private lazy var fullScreenImageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: fullScreenFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(FullScreenImageCollectionViewCell.self, forCellWithReuseIdentifier: FullScreenImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()

    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addButtonTarget()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollFullScreenImageCollectionView()
    }
    
    // MARK: Initializer
    init(viewModel: LogImageFullScreenViewModel, currentImageIndex: Int) {
        self.currentImageIndex = currentImageIndex
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: CollectionView Delegate
extension LogImageFullScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullScreenImageCollectionViewCell.identifier, for: indexPath) as? FullScreenImageCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(imageUrl: viewModel.imageUrl[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? FullScreenImageCollectionViewCell {
            cell.imageContainerView.setZoomScale(1.0, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        imageIndexLabel.text = "\(indexPath.row + 1) / \(viewModel.imageUrl.count)"
    }
}

// MARK: - UI
extension LogImageFullScreenViewController {
    
    private func setUI() {
        backgroundView.isHidden = true
        view.backgroundColor = .black
        
        view.addSubview(fullScreenImageCollectionView)
        view.addSubview(imageIndexLabel)
        view.addSubview(dismissButton)
        
        fullScreenImageCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(DeviceInfo.screenHeight * 0.8)
            make.center.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.right.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(50)
        }
        
        imageIndexLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(dismissButton.snp.centerY)
        }
    }
    
    private func addButtonTarget() {
        dismissButton.addTarget(self, action: #selector(tapDismissButton), for: .touchUpInside)
    }
    
    private func scrollFullScreenImageCollectionView() {
        fullScreenImageCollectionView.scrollToItem(at: IndexPath(row: currentImageIndex, section: 0), at: .bottom, animated: true)
    }
    
    @objc
    func tapDismissButton() {
        viewModel.dismissViewController()
        viewModel.pushLogTicketViewController()
    }
}
