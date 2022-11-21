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
import Lottie

final class LogHomeViewController: BaseViewController {
    
    var viewModel: LogHomeViewModel
    
    private var currentIndex: Int = 0
    
    lazy var previousConstellationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.alpha = 0.7
        button.clipsToBounds = true
        button.layer.cornerRadius = 9
        button.isHidden = true
        return button
    }()
    
    lazy var currentConstellationButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.5
        button.layer.borderColor = .designSystem(.mainYellow)
        return button
    }()
    
    lazy var nextConstellationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.alpha = 0.7
        button.clipsToBounds = true
        button.layer.cornerRadius = 9
        button.isHidden = true
        return button
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
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let width = DeviceInfo.screenWidth
        let height = DeviceInfo.screenHeight * 0.68
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }()
    
    private lazy var logCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(LogCollectionViewCell.self, forCellWithReuseIdentifier: LogCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    // MARK: Initializer
    init(viewModel: LogHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        Task {
            try await viewModel.fetchConstellation()
            logCollectionView.reloadData()
            setConstellationButtonOption()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension LogHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // MARK: 수정
        return viewModel.courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogCollectionViewCell.identifier, for: indexPath) as? LogCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: viewModel.courses[indexPath.row])
        cell.courseNameButton.addTarget(self, action: #selector(tapConstellationDetailButton), for: .touchUpInside)
        return cell
    }
}

extension LogHomeViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.logCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        currentIndex = Int(round(index))
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            currentIndex = Int(floor(index))
        } else {
            currentIndex = Int(ceil(index))
        }
        offset = CGPoint(x: CGFloat(currentIndex) * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setConstellationButtonOption()
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
        logCollectionView.delegate = self
        setButtonTarget()
        setConstellationButtonOption()
    }
    
    private func setButtonTarget() {
        mapButton.addTarget(self, action: #selector(tapMapButton), for: .touchUpInside)
        listButton.addTarget(self, action: #selector(tapListButton), for: .touchUpInside)
        previousConstellationButton.addTarget(self, action: #selector(tapPreviousConstellationButton), for: .touchUpInside)
        nextConstellationButton.addTarget(self, action: #selector(tapNextConstellationButton), for: .touchUpInside)
    }
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setConstraints() {
        
        view.addSubviews(
            mapButton,
            listButton,
            logCollectionView,
            previousConstellationButton,
            currentConstellationButton,
            nextConstellationButton
        )
        
        mapButton.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth * 0.1102)
            make.height.equalTo(DeviceInfo.screenHeight * 0.0509)
            make.right.equalToSuperview().inset(DeviceInfo.screenWidth * 0.0512)
            make.top.equalToSuperview().inset(DeviceInfo.screenHeight * 0.0663)
        }
        
        listButton.snp.makeConstraints { make in
            make.width.height.equalTo(mapButton.snp.width)
            make.centerX.equalTo(mapButton.snp.centerX)
            make.top.equalTo(mapButton.snp.bottom).offset(DeviceInfo.screenWidth * 0.0512)
        }
        
        logCollectionView.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth)
            make.height.equalTo(DeviceInfo.screenHeight * 0.7)
            make.centerX.equalToSuperview()
            make.top.equalTo(listButton.snp.bottom)
        }
        
        currentConstellationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(DeviceInfo.screenHeight * 135 / 844)
            make.width.height.equalTo(DeviceInfo.screenWidth * 50 / 390)
        }
        
        previousConstellationButton.snp.makeConstraints { make in
            make.width.height.equalTo(currentConstellationButton.snp.width).multipliedBy(0.6)
            make.centerY.equalTo(currentConstellationButton.snp.centerY)
            make.right.equalTo(currentConstellationButton.snp.left).offset(-DeviceInfo.screenWidth * 20 / 390)
        }
        
        nextConstellationButton.snp.makeConstraints { make in
            make.width.height.equalTo(currentConstellationButton.snp.width).multipliedBy(0.6)
            make.centerY.equalTo(currentConstellationButton.snp.centerY)
            make.left.equalTo(currentConstellationButton.snp.right).offset(DeviceInfo.screenWidth * 20 / 390)
        }
    }
    
    @objc
    func tapConstellationDetailButton() {
        viewModel.presentTicketView(course: viewModel.courses[currentIndex], currentIndex: currentIndex)
    }
    
    @objc
    func tapMapButton() {
        viewModel.pushLogMapViewController()
    }
    
    @objc
    func tapListButton() {
        viewModel.pushMyConstellationView(courses: viewModel.courses)
    }
    
    @objc
    func tapPreviousConstellationButton() {
        currentIndex -= 1
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.logCollectionView.scrollToItem(at: IndexPath(row: max(0, self.currentIndex), section: 0), at: .left, animated: true)
            self.setConstellationButtonOption()
        }
    }
    
    @objc
    func tapNextConstellationButton() {
        currentIndex += 1
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.logCollectionView.scrollToItem(at: IndexPath(row: min(self.currentIndex, self.viewModel.courses.count - 1), section: 0), at: .left, animated: true)
            self.setConstellationButtonOption()
        }
    }
    
    /// 이전, 이후, 현재 별자리의 제약조건을 추가합니다.
    func setConstellationButtonOption() {
        
        let courses = viewModel.courses
        
        if courses.isEmpty {
            previousConstellationButton.isHidden = true
            currentConstellationButton.isHidden = true
            nextConstellationButton.isHidden = true
            return
        } else {
            previousConstellationButton.isHidden = (currentIndex == 0) ? true : false
            nextConstellationButton.isHidden = (currentIndex == viewModel.courses.count - 1) ? true : false
        }
        
        let currentConstellationImage = StarMaker.makeStars(places: courses[currentIndex].places)?.resizeImageTo(size: CGSize(width: 22, height: 22))
        
        let previousConstellationImage = StarMaker.makeStars(places: courses[max(currentIndex - 1, 0)].places)?.resizeImageTo(size: CGSize(width: 13, height: 13))
        
        let nextConstellationImage = StarMaker.makeStars(places: courses[min(currentIndex + 1, courses.count - 1)].places)?.resizeImageTo(size: CGSize(width: 13, height: 13))
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentConstellationButton.setImage(currentConstellationImage, for: .normal)
            self.previousConstellationButton.setImage(previousConstellationImage, for: .normal)
            self.nextConstellationButton.setImage(nextConstellationImage, for: .normal)
        }
    }
}
