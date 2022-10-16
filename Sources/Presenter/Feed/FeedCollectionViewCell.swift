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
}

class FeedCollectionViewCell: UICollectionViewCell {

    private let gradient = CAGradientLayer()

    private var model: TestViewModel?

    static let identifier = "FeedCollectionViewCell"

    // delegate
    weak var delegate: FeedCollectionViewCellDelegate?

    // Subviews
    private let courseImageView = UIImageView()

    private let planetImageView = UIImageView()

    private var bottomView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.40))

    // Labels
    private let planetNameLabel = UILabel()

    private let courseNameLabel = UILabel()

    private let dateLabel = UILabel()

    private let followButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.backgroundColor = .white

        return button
    }()

    // Buttons
    private let mapButton = UIButton()

    private let listButton = UIButton()

    private let likeButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(courseImageView)
        contentView.addSubview(planetImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(planetNameLabel)
        contentView.addSubview(courseNameLabel)
        contentView.addSubview(mapButton)
        contentView.addSubview(listButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(bottomView)
        contentView.sendSubviewToBack(bottomView)
        contentView.sendSubviewToBack(courseImageView)

        // Add Action
        listButton.addTarget(self, action: #selector(didTapListButton), for: .touchUpInside)
        mapButton.addTarget(self, action: #selector(didTapMapButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
    }

    public func configure(with model: TestViewModel) {

        self.model = model
        courseImageView.image = UIImage(named: model.image)
        planetNameLabel.text = model.planet
        courseNameLabel.text = model.title
        dateLabel.text = model.date
        planetImageView.image = UIImage(named: "woodyPlanetImage")

        // MARK: Constraints

        // Images
        courseImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.65)
        }

        planetImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.left.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(187)
        }

        // Subviews
        bottomView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
        }

        // Buttons

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

        // Labels
        planetNameLabel.snp.makeConstraints { make in
            make.left.equalTo(planetImageView.snp.right).offset(10)
            make.top.equalTo(planetImageView.snp.top)
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

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        courseImageView.image = nil
        planetNameLabel.text = nil
        courseNameLabel.text = nil
        dateLabel.text = nil
    }

    // Actions
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
}

extension FeedCollectionViewCell {
    private func setUI() {
        setAttributes()
        setLayout()
    }

    /// Attributes를 설정합니다.
    private func setAttributes() {

        contentView.backgroundColor = .systemGray2
        contentView.clipsToBounds = false
        // 코스 이미지
        courseImageView.image = UIImage(named: "lakeImage")
        courseImageView.layer.opacity = 0.89

        planetImageView.image = UIImage(named: "woodyPlanetImage")
        // 아래 검은 뷰
        bottomView.backgroundColor = . black
        gradient.colors = [UIColor.white.cgColor ,UIColor.black.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: bottomView.frame.width, height: bottomView.frame.height/10)
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.opacity = 0.3
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        bottomView.layer.addSublayer(gradient)

        // 지도 버튼
        mapButton.backgroundColor = .black
        mapButton.tintColor = .white
        mapButton.layer.cornerRadius = 25
        mapButton.layer.opacity = 0.5
        mapButton.layer.masksToBounds = true
        mapButton.setImage(UIImage(systemName: "map.fill"), for: .normal)
        // 리스트 버튼
        listButton.tintColor = .white
        listButton.backgroundColor = .black
        listButton.layer.cornerRadius = 25
        listButton.layer.opacity = 0.5
        listButton.layer.masksToBounds = true
        listButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)

        likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = .red

        planetNameLabel.textAlignment = .left
        planetNameLabel.textColor = .white

        courseNameLabel.textAlignment = .left
        courseNameLabel.textColor = .white

        dateLabel.textAlignment = .left
        dateLabel.textColor = .white
    }

    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setLayout() {

    }
}
