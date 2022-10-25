//
//  CourseTableViewCell.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    private var imageURLStrings: [String] = []
    static let identifier = "CourseTableViewCell"

    var likeTapped: (() -> Void)?
    var followTapped: (() -> Void)?

    var course: SearchCourse? {
        didSet {
            guard let course = course else {
                return
            }
            planetImageView.image = UIImage(named: course.planetImageString)
            planetNameLabel.text = course.planetNameString
            timeLabel.text = course.timeString
            locationNameLabel.text = course.locationString
            imageURLStrings = course.imageURLStrings
            likeButton.setButtonImage(isLike: course.isLike)
            followButton.setButtonDetailConfiguration(isFollow: course.isFollow)
        }
    }
    
    private lazy var planetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var planetNameLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .regular, size: ._11)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .regular, size: ._11)
        label.textColor = .designSystem(.grayC5C5C5)
        return label
    }()
    
    private lazy var locationNameLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .bold, size: ._13)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    private lazy var followButton: FollowButton = {
        let button = FollowButton()
        button.addTarget(self, action: #selector(toggleFollow), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: LikeButton = {
        let button = LikeButton()
        button.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var planetNameAndTimeHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [planetNameLabel, timeLabel])
        stackView.spacing = 10
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var planetNameLocationVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [planetNameAndTimeHStackView, locationNameLabel])
        stackView.spacing = 7
        stackView.alignment = .leading
        stackView.axis = .vertical
        return stackView
    }()
    
    private let courseImageCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        let lineSpacing = 5.0
        let cellWidth = (DeviceInfo.screenWidth - 20 * 2 - lineSpacing * 2) / 3
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth / 113 * 169)
        flowLayout.minimumLineSpacing = lineSpacing
        return flowLayout
    }()
    
    private lazy var courseImageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: courseImageCollectionViewFlowLayout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CourseImageCollectionViewCell.self, forCellWithReuseIdentifier: CourseImageCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    private func setUI() {
        
        selectionStyle = .none
        backgroundColor = .designSystem(.black)
        
        setAttributes()
        setConstraints()
    }
    
    private func setAttributes() {
        contentView.addSubviews(planetImageView, planetNameLocationVStackView, followButton, likeButton, courseImageCollectionView)
    }

    private func setConstraints() {
        planetImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(50)
        }
        
        followButton.snp.makeConstraints { make in
            make.width.equalTo(67.5)
            make.height.equalTo(25)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(planetImageView)
        }
        
        followButton.snp.makeConstraints { make in
            make.trailing.equalTo(likeButton.snp.leading).offset(-16.5)
            make.centerY.equalTo(planetImageView)
        }

        planetNameLocationVStackView.snp.makeConstraints { make in
            make.leading.equalTo(planetImageView.snp.trailing).offset(10)
            make.trailing.equalTo(followButton.snp.leading).offset(4)
            make.centerY.equalTo(planetImageView)
        }
        
        courseImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(planetImageView.snp.bottom).offset(20)
            make.leading.equalTo(planetImageView.snp.leading)
            make.height.equalTo(courseImageCollectionViewFlowLayout.itemSize.height)
            make.bottom.equalToSuperview()
            make.trailing.equalTo(likeButton.snp.trailing)
        }
    }
    
    @objc
    private func toggleLike() {
        likeButton.toggleLike()
        likeTapped?()
    }
    
    @objc
    private func toggleFollow() {
        followTapped?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension CourseTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageURLStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseImageCollectionViewCell.identifier, for: indexPath) as? CourseImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.photoImageView.image = UIImage(named: imageURLStrings[indexPath.row])
        return cell
    }
}
