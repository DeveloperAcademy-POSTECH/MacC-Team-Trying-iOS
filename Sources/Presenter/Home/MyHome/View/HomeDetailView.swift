//
//  HomeDetailView.swift
//  MatStar
//
//  Created by uiskim on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit
import Lottie

class HomeDetailView: UIView {
    
    lazy var homeLottie: LottieAnimationView = {
        let lottie = LottieAnimationView.init(name: "HomeLottie")
        lottie.contentMode = .scaleAspectFill
        lottie.animationSpeed = 0.5
        lottie.loopMode = .loop
        lottie.play()
        return lottie
    }()
    
    lazy var myProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    lazy var otherPlanets: [UIImageView] = [
        UIImageView(image: UIImage(named: "PodingPlanet")),
        UIImageView(image: UIImage(named: "WoodyPlanet")),
        UIImageView(image: UIImage(named: "YouthPlanet"))
    ]
    
    // TODO : - 추후 필드명 변경되면 변수명 수정(mate)
    lazy var otherProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .heavy, size: ._20)
        label.textColor = .white
        label.attributedText = String.makeAtrributedString(
            name: "카리나",
            appendString: " 와 함께",
            changeAppendStringSize: 15,
            changeAppendStringWieght: .regular,
            changeAppendStringColor: .white
        )
        return label
    }()
    
    lazy var ddayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "D+273"
        return label
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, ddayLabel])
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [myProfileImage, otherProfileImage])
        stackView.spacing = -10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AlarmImage"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    lazy var constellationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ConstellationCollectionViewCell.self, forCellWithReuseIdentifier: ConstellationCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var courseRegistrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("코스 등록", for: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.setTitleColor(UIColor.designSystem(.mainYellow), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        button.tintColor = UIColor.designSystem(.mainYellow)
        button.clipsToBounds = true
        button.layer.cornerRadius = 17
        button.backgroundColor = .black
        button.layer.borderColor = UIColor.designSystem(.mainYellow)?.cgColor
        button.layer.borderWidth = 1.5
        return button
    }()
    
    lazy var myPlanetImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MyPlanetImage")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        setAttributes()
        setConstraints()
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        addSubview(homeLottie)
        addSubview(labelStackView)
        addSubview(profileStackView)
        addSubview(alarmButton)
        addSubview(myPlanetImage)
        addSubview(constellationCollectionView)
        addSubview(courseRegistrationButton)
    }
    
    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setConstraints() {
        constellationCollectionView.contentInset = UIEdgeInsets(top: 50, left: 20, bottom: 20, right: 20)
        homeLottie.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        myProfileImage.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        otherProfileImage.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        profileStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(60)
            make.height.equalTo(50)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.left.equalTo(profileStackView.snp.right).offset(10)
            make.height.equalTo(50)
            make.width.equalTo(180)
            make.centerY.equalTo(profileStackView.snp.centerY)
        }
        
        alarmButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(19)
            make.height.equalTo(22)
            make.centerY.equalTo(labelStackView.snp.centerY)
        }
        
        constellationCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(labelStackView.snp.bottom)
            make.bottom.equalTo(myPlanetImage.snp.top)
        }
        
        myPlanetImage.snp.makeConstraints { make in
            let bounds = UIScreen.main.bounds
            make.centerY.equalTo(self.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(bounds.width * 1.2)
            make.height.equalTo(bounds.width * 1.2)
        }
        
        courseRegistrationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(105)
            make.width.equalTo(86)
            make.height.equalTo(34)
        }
    }
}
