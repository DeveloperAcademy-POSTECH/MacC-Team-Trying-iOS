//
//  CarouselView.swift
//  MatStar
//
//  Created by uiskim on 2022/10/23.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

protocol CarouselViewDelegate: AnyObject {
    func currentPageDidChange(to page: Int)
}

class CarouselView: UIView {
    // MARK: - Subviews
    
    lazy var carouselCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.cellId)
        collection.backgroundColor = .clear
        return collection
    }()
    
    // MARK: - Properties
    
    private var pages: Int
    private weak var delegate: CarouselViewDelegate?
    private var carouselData = [Constellation]()
    var currentPage = 0 {
        didSet {
            delegate?.currentPageDidChange(to: currentPage)
        }
    }
    
    // MARK: - Initializers
    
    init(pages: Int, delegate: CarouselViewDelegate?) {
        self.pages = pages
        self.delegate = delegate
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setups

extension CarouselView {
    func setupUI() {
        backgroundColor = .clear
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let cellPadding = (frame.width - 300) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 300, height: 400)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        carouselCollectionView.collectionViewLayout = carouselLayout
        
        addSubview(carouselCollectionView)
        carouselCollectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(450)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CarouselView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.cellId, for: indexPath) as? CarouselCell else { return UICollectionViewCell() }
        
        let image = carouselData[indexPath.row].image
        let text = carouselData[indexPath.row].name
        
        cell.configure(image: image, text: text)
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension CarouselView: UICollectionViewDelegate {
    
    //MARK : - 속도가 0이 되었을때 알아서 움직이다가 딱 멈췄을때 호출
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
    
    //MARK : - touches up했을때 손가락을 떼면 호출
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
    }
    
//    //MARK : - 움직이는 동안 작동
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        currentPage = getCurrentPage()
//    }
}

// MARK: - Public

extension CarouselView {
    public func configureView(with data: [Constellation]) {
        let cellPadding = (frame.width - 300) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 300, height: 400)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        carouselCollectionView.collectionViewLayout = carouselLayout
        carouselData = data
        carouselCollectionView.reloadData()
    }
}


// MARKK: - Helpers
extension CarouselView {
    func getCurrentPage() -> Int {
        let visibleRect = CGRect(origin: carouselCollectionView.contentOffset, size: carouselCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = carouselCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        return currentPage
    }
}

