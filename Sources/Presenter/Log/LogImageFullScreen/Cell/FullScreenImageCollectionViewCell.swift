//
//  FullScreenImageCollectionViewCell.swift
//  우주라이크
//
//  Created by YeongJin Jeong on 2022/12/06.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class FullScreenImageCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var gestureRecognizer: UITapGestureRecognizer!
    
    static let identifier = "FullScreenImageCollectionViewCell"
    
    private let imageView = UIImageView()
    
    lazy var imageContainerView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        setContainerView()
        setConstraints()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI
extension FullScreenImageCollectionViewCell {
    
    func configure(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        imageView.contentMode = .scaleAspectFit
        imageView.load(url: url)
    }
    
    func setContainerView() {
        imageContainerView.minimumZoomScale = 1.0
        imageContainerView.maximumZoomScale = 6.0
        imageContainerView.delegate = self
    }
    
    private func setConstraints() {
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        
        imageContainerView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    // MARK: Double Tap Gesture
    func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        imageContainerView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    func handleDoubleTap() {
        imageContainerView.setZoomScale(1.0, animated: true)
    }
}

// MARK: ScrollView Delegate
extension FullScreenImageCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 0.1 {
            if let image = imageView.image {
                let widthRatio = imageView.frame.width / image.size.width
                let heightRatio = imageView.frame.height / image.size.height
                let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let left = 0.5 * (newWidth * scrollView.zoomScale > imageView.frame.width ? (newWidth - imageView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeight * scrollView.zoomScale > imageView.frame.height ? (newHeight - imageView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        }
    }
}
