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
    
    var viewModel = HomeViewModel()
    
    lazy var homeLottie: LottieAnimationView = {
        let lottie = LottieAnimationView.init(name: "HomeLottie")
        lottie.contentMode = .scaleAspectFill
        lottie.animationSpeed = 0.5
        lottie.loopMode = .loop
        lottie.play()
        return lottie
    }()

     let myProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
     let otherPlanets: [UIImageView] = [
        UIImageView(image: UIImage(named: "PodingPlanet")),
        UIImageView(image: UIImage(named: "WodyPlanet")),
        UIImageView(image: UIImage(named: "YouthPlanet"))
    ]
    
     let otherProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
     let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
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
    
     let ddayLabel: UILabel = {
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
        let stackView = UIStackView(arrangedSubviews: viewModel.isSingled ? [myProfileImage, otherProfileImage] : [myProfileImage])
        stackView.spacing = -10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
     let alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AlarmImage"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
     let constellationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 50, left: 20, bottom: 20, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ConstellationCollectionViewCell.self, forCellWithReuseIdentifier: ConstellationCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
     lazy var courseRegistrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("코스 등록", for: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.setTitleColor(UIColor(named: "mainYellow"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        button.tintColor = UIColor(named: "mainYellow")
        button.clipsToBounds = true
        button.layer.cornerRadius = 17
        button.backgroundColor = .black
        button.layer.borderColor = UIColor(named: "mainYellow")?.cgColor
        button.layer.borderWidth = 1.5
        
        return button
    }()
    
     let myPlanetImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MyPlanetImage")
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
        myPlanetImage.isUserInteractionEnabled = true
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
