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
import SwiftUI

protocol FeedCollectionViewCellDelegate: AnyObject {

    func didTapLikeButton(model: TestViewModel)

    func didTapListButton(model: TestViewModel)

    func didTapMapButton(model: TestViewModel)

    func didTapFollowButton(model: TestViewModel)
}

class FeedCell: UICollectionViewCell {

    static let identifier = "FeedCollectionViewCell"

    private var isCourseDetailLabelTapped: Bool = false

    weak var delegate: FeedCollectionViewCellDelegate? // Delegate

    private let gradient = CAGradientLayer() // gradient for bottomView

    private var model: TestViewModel?

    private var tagCollectionView: UICollectionView?

    private var gradientView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    private var pageControl = UIPageControl()
    private var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    var images = [UIImage(named: "lakeImage"), UIImage(named: "lakeImage"), UIImage(named: "lakeImage"), UIImage(named: "lakeImage")]
    private let courseImageView = [UIImageView]()
    private let planetImageView = UIImageView()
    private var bottomView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.35))

    // Labels
    private let planetNameLabel = UILabel()
    private let courseNameLabel = UILabel()
    private let dateLabel = UILabel()
    private var courseDetailLabel = UILabel()

    // Buttons
    private let mapButton = UIButton()
    private let listButton = UIButton()
    private let likeButton = UIButton()
    private let followButton = UIButton()

    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = false
        isCourseDetailLabelTapped = false
        addSubviews()
        setScrollView()
        layoutImageViews()
        setButtons()
        setLabels()
        setPageControl()
        setGestureRecognizer()
        setCollectionView()
        scrollView.delegate = self
        /// 테스트
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        planetNameLabel.text = nil
        courseNameLabel.text = nil
        dateLabel.text = nil
        courseDetailLabel.text = nil
    }

    func configure(with model: TestViewModel) {
        self.model = model
        planetNameLabel.text = model.planet
        courseNameLabel.text = model.title
        dateLabel.text = model.date
        planetImageView.image = UIImage(named: "woodyPlanetImage")
        courseDetailLabel.text = model.body
    }
}

extension FeedCell: UIScrollViewDelegate {

    private func setScrollView() {
        for index in 0..<images.count {
            let imageView = UIImageView()
            let xPos = scrollView.frame.width * CGFloat(index)
            imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            imageView.image = images[index]
            scrollView.addSubview(imageView)
            scrollView.contentSize.width = imageView.frame.width * CGFloat(index + 1)
        }
        scrollView.showsHorizontalScrollIndicator = false
    }

    private func setPageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }

    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
    }
}

extension FeedCell {

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
        contentView.addSubview(gradientView)

        contentView.sendSubviewToBack(gradientView)
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

        courseDetailLabel.numberOfLines = 1
        courseDetailLabel.textAlignment = .left
        courseDetailLabel.backgroundColor = .clear
        courseDetailLabel.textColor = .white
        courseDetailLabel.font = UIFont.designSystem(weight: .regular, size: ._13)

        courseDetailLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(planetImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

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
    }

    private func layoutImageViews() {
        // ImageViews
        scrollView.isPagingEnabled = true
        scrollView.bounces = false

        // Views
        bottomView.backgroundColor = .clear
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: bottomView.frame.width, height: contentView.frame.height)
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.25)
        gradient.opacity = 0.7
        bottomView.layer.addSublayer(gradient)
        gradientView.backgroundColor = .black
        gradientView.layer.opacity = 0.4
        gradientView.isHidden = true

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

    private func setGestureRecognizer() {
        let tapgestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCourseDetailLabel))
        courseDetailLabel.addGestureRecognizer(tapgestureRecognizer)
        courseDetailLabel.isUserInteractionEnabled = true

    }

    @objc
    private func didTapCourseDetailLabel(_ tapRecognizer: UITapGestureRecognizer) {
        isCourseDetailLabelTapped.toggle()

        var bottomViewHeight = contentView.frame.size.height * 0.35

        if isCourseDetailLabelTapped { // 늘어나야함

            guard let text = courseDetailLabel.text else { return }
            let attrString = NSMutableAttributedString(string: text)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            courseDetailLabel.attributedText = attrString

            bottomViewHeight += CGFloat(courseDetailLabel.countCurrentLines()) * ( courseDetailLabel.font.lineHeight + 4)
            print(courseDetailLabel.font.lineHeight)
            courseDetailLabel.numberOfLines = 0
            bottomView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(bottomViewHeight)
            }
            gradientView.isHidden = false
            pageControl.isHidden = true

        } else {
            courseDetailLabel.numberOfLines = 1
            bottomView.snp.remakeConstraints { make in
                make.bottom.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(bottomViewHeight)
            }
            gradientView.isHidden = true
            pageControl.isHidden = false
        }
    }

    // Button Actions
    @objc
    func didTapLikeButton() {
        guard let model = model else { return }
        delegate?.didTapLikeButton(model: model)
    }

    @objc
    func didTapListButton() {
        guard let model = model else { return }
        delegate?.didTapListButton(model: model)
    }

    @objc
    func didTapMapButton() {
        guard let model = model else { return }
        delegate?.didTapMapButton(model: model)
    }

    @objc
    func didTapFollowMapButton() {
        guard let model = model else { return }
        delegate?.didTapFollowButton(model: model)
    }

    private func setCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 0, left: 15, bottom: 0, right: 15)

        tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        tagCollectionView?.setCollectionViewLayout(flowLayout, animated: false)
        tagCollectionView?.delegate = self
        tagCollectionView?.dataSource = self
        tagCollectionView?.backgroundColor = .clear
        tagCollectionView?.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        contentView.addSubview(tagCollectionView!)

        tagCollectionView?.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalTo(courseDetailLabel.snp.bottom).offset(10)

        }
    }
}

extension FeedCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.tag.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let items = model?.tag else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        cell.configure(name: items[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return TagCell.fittingSize(availableHeight: 24, name: model?.tag[indexPath.item])
    }

}

