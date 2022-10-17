//
//  FeedViewControllerCell.swift
//  MatStar
//
//  Created by YeongJin Jeong on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol FeedCollectionViewCellDelegate: AnyObject {

    func didTapLikeButton(model: TestViewModel)

    func didTapListButton(model: TestViewModel)

    func didTapMapButton(model: TestViewModel)

    func didTapFollowButton(model: TestViewModel)
}

class FeedCollectionViewCell: UICollectionViewCell {

    static let identifier = "FeedCollectionViewCell"

    weak var delegate: FeedCollectionViewCellDelegate? // Delegate

    private let gradient = CAGradientLayer() // gradient for bottomView

    private var model: TestViewModel?

    private var pageControl = UIPageControl()
    private var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.65))

    var images = [UIImage(named: "lakeImage"), UIImage(named: "lakeImage"), UIImage(named: "lakeImage"), UIImage(named: "lakeImage")]
    private let courseImageView = [UIImageView]()

    private let planetImageView = UIImageView()
    private var bottomView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35))

    // Labels
    private let planetNameLabel = UILabel()
    private let courseNameLabel = UILabel()
    private let dateLabel = UILabel()
    private let courseDetailLabel = UILabel()

    // Buttons
    private let mapButton = UIButton()
    private let listButton = UIButton()
    private let likeButton = UIButton()
    private let followButton = UIButton()

    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        scrollView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.clipsToBounds = false
        setButtons()
        setLabels()
        layoutImageViews()
        setScrollView()
        setPageControl()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        planetNameLabel.text = nil
        courseNameLabel.text = nil
        dateLabel.text = nil
        courseDetailLabel.text = nil
    }

    public func configure(with model: TestViewModel) {
        self.model = model
        planetNameLabel.text = model.planet
        courseNameLabel.text = model.title
        dateLabel.text = model.date
        planetImageView.image = UIImage(named: "woodyPlanetImage")
        courseDetailLabel.text = model.body
    }
}

extension FeedCollectionViewCell: UIScrollViewDelegate {

    private func setScrollView() {
            for index in 0..<images.count {
                let imageView = UIImageView()
                let xPos = scrollView.frame.width * CGFloat(index)
                imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
                imageView.image = images[index]
                imageView.layer.opacity = 0.89
                scrollView.addSubview(imageView)
                scrollView.contentSize.width = imageView.frame.width * CGFloat(index + 1)
            }
        }

    private func setPageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }

    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let value = scrollView.contentOffset.x / scrollView.frame.size.width
            setPageControlSelectedPage(currentPage: Int(round(value)))
    }
}

extension FeedCollectionViewCell {

    private func addSubviews() {
        contentView.addSubview(planetImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(planetNameLabel)
        contentView.addSubview(courseNameLabel)
        contentView.addSubview(courseDetailLabel)
        contentView.addSubview(mapButton)
        contentView.addSubview(listButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(followButton)
        contentView.addSubview(bottomView)
        contentView.addSubview(scrollView)
        contentView.addSubview(pageControl)
        contentView.sendSubviewToBack(bottomView)
        contentView.sendSubviewToBack(scrollView)

        // Add Action
        listButton.addTarget(self, action: #selector(didTapListButton), for: .touchUpInside)
        mapButton.addTarget(self, action: #selector(didTapMapButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(didTapFollowMapButton), for: .touchUpInside)
    }

    private func setButtons() {
        // Buttons UI
        mapButton.backgroundColor = .black
        mapButton.tintColor = .white
        mapButton.layer.cornerRadius = 21.5
        mapButton.layer.opacity = 0.5
        mapButton.layer.masksToBounds = true
        mapButton.setImage(UIImage(systemName: "map.fill"), for: .normal)

        listButton.tintColor = .white
        listButton.backgroundColor = .black
        listButton.layer.cornerRadius = 21.5
        listButton.layer.opacity = 0.5
        listButton.layer.masksToBounds = true
        listButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)

        likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = .red

        followButton.layer.masksToBounds = true
        followButton.backgroundColor = .black
        followButton.layer.cornerRadius = 12.5
        followButton.layer.borderColor = UIColor.designSystem(Palette.mainYellow)?.cgColor
        followButton.layer.borderWidth = 2
        followButton.setTitle("팔로우", for: .normal)
        followButton.setTitleColor(UIColor.designSystem(Palette.mainYellow), for: .normal)
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)

        // Button Constraints
        mapButton.snp.makeConstraints { make in
            make.width.height.equalTo(43)
            make.right.equalTo(contentView.snp.right).inset(20)
            make.top.equalTo(contentView.snp.top).inset(56)
        }

        listButton.snp.makeConstraints { make in
            make.width.height.equalTo(43)
            make.right.equalTo(contentView.snp.right).inset(20)
            make.top.equalTo(mapButton.snp.bottom).offset(20)
        }

        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(self.planetImageView.snp.centerY)
            make.width.equalTo(25)
            make.height.equalTo(24)
        }

        followButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(60)
            make.centerY.equalTo(self.planetImageView.snp.centerY)
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
    }

    private func setLabels() {
        // Labels UI
        planetNameLabel.textAlignment = .left
        planetNameLabel.textColor = .white
        planetNameLabel.font = UIFont.designSystem(weight: .regular, size: ._11)

        courseNameLabel.textAlignment = .left
        courseNameLabel.textColor = .white
        courseNameLabel.font = UIFont.designSystem(weight: .bold, size: ._13)

        dateLabel.textAlignment = .left
        dateLabel.textColor = .white
        dateLabel.font = UIFont.designSystem(weight: .regular, size: ._11)

        courseDetailLabel.textAlignment = .left
        courseDetailLabel.textColor = .white
        courseDetailLabel.font = UIFont.designSystem(weight: .regular, size: ._13)

        // Label Constraints
        planetNameLabel.snp.makeConstraints { make in
            make.left.equalTo(planetImageView.snp.right).offset(10)
            make.top.equalTo(planetImageView.snp.top).offset(8)
        }

        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(planetNameLabel.snp.right).offset(10)
            make.top.equalTo(planetNameLabel.snp.top)
        }

        courseNameLabel.snp.makeConstraints { make in
            make.top.equalTo(planetNameLabel.snp.bottom).offset(10)
            make.left.equalTo(planetNameLabel.snp.left)
        }

        courseDetailLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(planetImageView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
        }
    }

    private func layoutImageViews() {
        // ImageViews
        scrollView.isPagingEnabled = true
        scrollView.bounces = false

        // Views
        bottomView.backgroundColor = . black
        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: bottomView.frame.width, height: bottomView.frame.height / 10)
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.opacity = 0.3
        bottomView.layer.addSublayer(gradient)

        // Constraints

        pageControl.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).inset(10)
            make.centerX.equalToSuperview()
        }

        planetImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(bottomView.snp.top).inset(55)
        }

        // Subviews
        bottomView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
        }
    }

    private func setPageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = images.count
        pageControl.pageIndicatorTintColor = UIColor.designSystem(Palette.grayC5C5C5)
        pageControl.currentPageIndicatorTintColor = UIColor.designSystem(Palette.mainYellow)
    }

    // Button Actions
    @objc func didTapLikeButton() {
        guard let model = model else { return }
        delegate?.didTapLikeButton(model: model)
    }

    @objc func didTapListButton() {
        guard let model = model else { return }
        delegate?.didTapListButton(model: model)
    }

    @objc func didTapMapButton() {
        guard let model = model else { return }
        delegate?.didTapMapButton(model: model)
    }

    @objc func didTapFollowMapButton() {
        guard let model = model else { return }
        delegate?.didTapFollowButton(model: model)
    }
}
