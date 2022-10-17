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
    
    var info: Info? {
        didSet {
            guard let info = info else {
                return
            }
            planetImageView.image = UIImage(named: info.planetImageString)
            planetNameLabel.text = info.planetNameString
            timeLabel.text = info.timeString
            locationNameLabel.text = info.locationString
            
            let image = UIImage(named: info.isLike ? "like_image" : "unlike_image")
            likeButton.setImage(image, for: .normal)
            imageURLStrings = info.imageURLStrings
            followButton.isSelected = info.isFollow
        }
    }
    
    private lazy var planetImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var planetNameLabel: UILabel = {
        $0.font = .systemFont(ofSize: 11, weight: .medium)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private lazy var timeLabel: UILabel = {
        $0.font = .systemFont(ofSize: 11, weight: .medium)
        $0.textColor = .gray
        return $0
    }(UILabel())
    
    private lazy var locationNameLabel: UILabel = {
        $0.font = .systemFont(ofSize: 13, weight: .bold)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private lazy var followButton: FollowButton = {
        let button = FollowButton()
        button.addTarget(self, action: #selector(toggleFollow), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        $0.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var planetNameAndTimeHStackView: UIStackView = {
        $0.spacing = 10
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    private lazy var planetNameLocationVStackView: UIStackView = {
        $0.spacing = 7
        $0.alignment = .leading
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    private lazy var followAndLikeHStackView: UIStackView = {
        $0.spacing = 16.5
        $0.alignment = .center
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    private lazy var courseImageCollectionView: CourseImageCollectionView = {
        let collectionView = CourseImageCollectionView()
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
        backgroundColor = .black
        
        setAttributes()
        setConstraints()
    }
    
    private func setAttributes() {
       
        contentView.addSubview(planetImageView)
        planetNameAndTimeHStackView.addArrangedSubview(planetNameLabel)
        planetNameAndTimeHStackView.addArrangedSubview(timeLabel)
        
        planetNameLocationVStackView.addArrangedSubview(planetNameAndTimeHStackView)
        planetNameLocationVStackView.addArrangedSubview(locationNameLabel)
        contentView.addSubview(planetNameLocationVStackView)
        
        followAndLikeHStackView.addArrangedSubview(followButton)
        followAndLikeHStackView.addArrangedSubview(likeButton)
        contentView.addSubview(followAndLikeHStackView)
        contentView.addSubview(courseImageCollectionView)
    }

    private func setConstraints() {
        planetImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        followButton.snp.makeConstraints { make in
            make.width.equalTo(67.5)
            make.height.equalTo(25)
        }
        
        likeButton.snp.makeConstraints { make in
            make.width.equalTo(19)
            make.height.equalTo(18)
        }
        
        followAndLikeHStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(planetImageView)
        }
        
        planetNameLocationVStackView.snp.makeConstraints { make in
            make.leading.equalTo(planetImageView.snp.trailing).offset(10)
            make.trailing.equalTo(followAndLikeHStackView.snp.leading).offset(4)
            make.centerY.equalTo(planetImageView)
        }
        
        courseImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(planetImageView.snp.bottom).offset(20)
            make.leading.equalTo(planetImageView.snp.leading)
            make.height.equalTo(169)
            make.trailing.equalTo(likeButton.snp.trailing)
        }
    }
    
    @objc private func toggleLike() {
        //TODO: ViewModel을 통한 toggle
        if likeButton.imageView?.image == UIImage(named: "like_image") {
            likeButton.setImage(UIImage(named: "unlike_image"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like_image"), for: .normal)
        }
    }
    
    @objc private func toggleFollow() {
        //TODO: ViewModel을 통한 toggle
        followButton.isSelected.toggle()
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
