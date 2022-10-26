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

class FeedCollectionViewCell: UICollectionViewCell {

    static let identifier = "FeedCollectionViewCell"

    private var isBodyCollapsed: Bool = false

    weak var delegate: FeedCollectionViewCellDelegate?

    private var model: TestViewModel?
    private var images = [String]()

    private let gradient = CAGradientLayer()

    private var tagCollectionView: UICollectionView?
    private var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: DeviceInfo.screenHeight))

    private let courseImageView = [UIImageView]()
    private var gradientView = UIView(frame: CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: DeviceInfo.screenHeight))
    private var bottomView = UIView(frame: CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: DeviceInfo.screenHeight * 0.35))

    private let planetImageView = UIImageView()

    private var pageControl = UIPageControl()

    private let planetNameLabel = UILabel()
    private let courseNameLabel = UILabel()
    private let dateLabel = UILabel()
    private var bodyLabel = UILabel()

    private let mapButton = UIButton()
    private let listButton = UIButton()
    private let likeButton = UIButton()
    private let followButton = UIButton()

    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewsToSuperView()
        setViews()
        setButtons()
        setLabels()
        setGestureRecognizer()
        setTagCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: TestViewModel) {
        self.model = model
        planetNameLabel.text = model.planet
        courseNameLabel.text = model.title
        dateLabel.text = model.date
        bodyLabel.text = model.body
        planetImageView.image = UIImage(named: model.planetImage)
        images = model.images
        setScrollView()
        setPageControl()
    }
}

extension FeedCollectionViewCell: UIScrollViewDelegate {

    private func setScrollView() {
        for index in 0..<images.count {
            let imageView = UIImageView()
            let xPos = scrollView.frame.width * CGFloat(index)
            imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            imageView.image = UIImage(named: images[index])
            scrollView.addSubview(imageView)
            scrollView.contentSize.width = imageView.frame.width * CGFloat(index + 1)
        }
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }

    private func setPageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
    }
}

extension FeedCollectionViewCell {

    private func addSubviewsToSuperView() {
        contentView.addSubview(planetImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(planetNameLabel)
        contentView.addSubview(courseNameLabel)
        contentView.addSubview(bodyLabel)

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
        listButton.addTarget(self, action: #selector(didTapListButton), for: .touchUpInside)
        mapButton.addTarget(self, action: #selector(didTapMapButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(didTapFollowMapButton), for: .touchUpInside)
    }

    private func setLabels() {
        planetNameLabel.textAlignment = .left
        planetNameLabel.textColor = .white
        planetNameLabel.font = UIFont.designSystem(weight: .regular, size: ._11)

        courseNameLabel.textAlignment = .left
        courseNameLabel.textColor = .white
        courseNameLabel.font = UIFont.designSystem(weight: .bold, size: ._13)

        dateLabel.textAlignment = .left
        dateLabel.textColor = .white
        dateLabel.font = UIFont.designSystem(weight: .regular, size: ._11)

        bodyLabel.numberOfLines = 1
        bodyLabel.textAlignment = .left
        bodyLabel.backgroundColor = .clear
        bodyLabel.textColor = .white
        bodyLabel.font = UIFont.designSystem(weight: .regular, size: ._13)

        bodyLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(planetImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

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

    private func setViews() {
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
        guard let model = model else { return }
        pageControl.currentPage = 0
        pageControl.numberOfPages = model.images.count
        pageControl.pageIndicatorTintColor = UIColor.designSystem(Palette.grayC5C5C5)
        pageControl.currentPageIndicatorTintColor = UIColor.designSystem(Palette.mainYellow)

        pageControl.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).inset(10)
            make.centerX.equalToSuperview()
        }
    }

    private func setGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCourseDetailLabel))
        bodyLabel.addGestureRecognizer(tapGestureRecognizer)
        bodyLabel.isUserInteractionEnabled = true
    }

    @objc
    private func didTapCourseDetailLabel(_ tapRecognizer: UITapGestureRecognizer) {
        isBodyCollapsed.toggle()

        var bottomViewHeight = contentView.frame.size.height * 0.35

        if isBodyCollapsed { // 늘어나야함
            guard let text = bodyLabel.text else { return }
            let attrString = NSMutableAttributedString(string: text)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            bodyLabel.attributedText = attrString

            bottomViewHeight += CGFloat(bodyLabel.countCurrentLines()) * (bodyLabel.font.lineHeight + 4)
            bodyLabel.numberOfLines = 0
            bottomView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(bottomViewHeight)
            }
            gradientView.isHidden = false
            pageControl.isHidden = true
        } else {
            bodyLabel.numberOfLines = 1
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

    private func setTagCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 0, left: 15, bottom: 0, right: 15)

        tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        guard let collectionView = tagCollectionView else { return }

        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)

        contentView.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalTo(bodyLabel.snp.bottom).offset(10)
        }
    }
}

extension FeedCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let resultModel = model else {
            print("model is nil")
            return 0
        }
        let count = resultModel.tag.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let items = model?.tag else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(name: items[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var result = ""
        if let model = model {
            result = model.tag[indexPath.item]
        } else {
            print("Model is nil")
        }
        return TagCollectionViewCell.fittingSize(availableHeight: 24, name: result)
    }
}
