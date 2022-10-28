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
        let lottie = LottieAnimationView.init(name: "shooting-star")
        lottie.contentMode = .scaleAspectFill
        lottie.animationSpeed = 0.5
        lottie.backgroundColor = .clear
        lottie.loopMode = .loop
        return lottie
    }()
    
    lazy var myProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
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

        return label
    }()
    
    lazy var ddayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "D+123"
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
    
    lazy var courseNameButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.titleLabel?.font = .designSystem(weight: .bold, size: ._15)
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 22
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.tintColor = .white
        button.contentHorizontalAlignment = .center
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        return button
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.backgroundColor = .clear
        label.font = .designSystem(weight: .light, size: ._13)
        return label
    }()
    
    lazy var currentImageBox: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.borderColor = .designSystem(.mainYellow)
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    lazy var currentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var beforeImageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.alpha = 0.7
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.isHidden = true
        return button
    }()
    
    lazy var afterImageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.alpha = 0.7
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.isHidden = true
        return button
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
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        self.backgroundColor = .clear
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
        addSubview(courseRegistrationButton)
        addSubview(courseNameButton)
        addSubview(dateLabel)
        addSubview(currentImageBox)
        currentImageBox.addSubview(currentImage)
        addSubview(beforeImageButton)
        addSubview(afterImageButton)
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
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
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
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(courseNameButton.snp.bottom).offset(15)
            make.height.equalTo(15)
        }
        
        currentImageBox.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(50)
            make.bottom.equalTo(myPlanetImage.snp.top).offset(-47)
        }
        
        currentImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(30)
        }
        
        beforeImageButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(55)
            make.size.equalTo(50)
            make.centerY.equalTo(currentImageBox.snp.centerY).offset(30)
        }
        
        afterImageButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(55)
            make.size.equalTo(50)
            make.centerY.equalTo(currentImageBox.snp.centerY).offset(30)
        }
    
        myPlanetImage.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.size.equalTo(DeviceInfo.screenWidth * 1.2)
        }
        
        courseRegistrationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(105)
            make.width.equalTo(86)
            make.height.equalTo(34)
        }
    }
}
