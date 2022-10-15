//
//  HomeViewController.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag
import SnapKit
import Lottie

final class HomeViewController: BaseViewController {
    
    var viewModel = HomeViewModel()
    
    lazy var homeLottie: LottieAnimationView = {
        let lottie = LottieAnimationView.init(name: "HomeLottie")
        lottie.frame = self.view.bounds
        lottie.center = self.view.center
        lottie.contentMode = .scaleAspectFill
        lottie.animationSpeed = 0.5
        lottie.loopMode = .loop
        lottie.play()
        return lottie
    }()

    private let myProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private let otherPlanets: [UIImageView] = [
        UIImageView(image: UIImage(named: "PodingPlanet")),
        UIImageView(image: UIImage(named: "WodyPlanet")),
        UIImageView(image: UIImage(named: "YouthPlanet"))
    ]
    
    private let otherProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImage")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private let nameLabel: UILabel = {
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
    
    private let ddayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "D+273"
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, ddayLabel])
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: viewModel.isSingled ? [myProfileImage, otherProfileImage] : [myProfileImage])
        stackView.spacing = -10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "AlarmImage"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let constellationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 50, left: 20, bottom: 20, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ConstellationCollectionViewCell.self, forCellWithReuseIdentifier: ConstellationCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var courseRegistrationButton: UIButton = {
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
        button.addTarget(self, action: #selector(courseRsgistrationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let myPlanetImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MyPlanetImage")
        return imageView
    }()

    /// View Model과 bind 합니다.
    private func bind() {
        // input
        
        // output
        
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    @objc
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let screenHeight = UIScreen.main.bounds.height
        if gesture.state == .changed {
            UIView.animate(withDuration: 0.8) {
                self.constellationCollectionView.alpha = 0
                let scale = CGAffineTransform(scaleX: 0.5, y: 0.5).translatedBy(x: 0, y: -screenHeight)
                self.myPlanetImage.transform = scale
            }
        } else if gesture.state == .ended {
            if translation.y > -screenHeight / 5 {
                UIView.animate(withDuration: 0.5) {
                    self.myPlanetImage.transform = .identity
                    self.constellationCollectionView.alpha = 1
                }
            } else {
                self.constellationCollectionView.isHidden = true
                self.myPlanetImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myPlanetImageTappedAfterSmaller)))
                self.homeLottie.stop()
            }
        }
    }
    
    @objc
    func myPlanetImageTappedAfterSmaller() {
        UIView.animate(withDuration: 0.5) {
            self.constellationCollectionView.isHidden = false
            self.constellationCollectionView.alpha = 1
            self.myPlanetImage.transform = .identity
            self.homeLottie.play()
        }
    }
    
    @objc
    func courseRsgistrationButtonTapped() {
        print("코스등록하기 버튼이 눌림")
    }
}

// MARK: - UI
extension HomeViewController {
    private func setUI() {
        setAttributes()
        setConstraints()
        myPlanetImage.isUserInteractionEnabled = true
        myPlanetImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
    }
    
    /// Attributes를 설정합니다.
    private func setAttributes() {
        view.addSubview(homeLottie)
        view.addSubview(labelStackView)
        view.addSubview(profileStackView)
        view.addSubview(alarmButton)
        view.addSubview(myPlanetImage)
        view.addSubview(constellationCollectionView)
        view.addSubview(courseRegistrationButton)

        constellationCollectionView.dataSource = self
        constellationCollectionView.delegate = self
    }

    /// 화면에 그려질 View들을 추가하고 SnapKit을 사용하여 Constraints를 설정합니다.
    private func setConstraints() {
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
            make.centerY.equalTo(view.snp.bottom)
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

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.constellations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstellationCollectionViewCell.identifier, for: indexPath) as? ConstellationCollectionViewCell else { return UICollectionViewCell() }
        cell.constellationImage.image = viewModel.constellations[indexPath.row]
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tmpLabel = UIImageView()
        tmpLabel.image = viewModel.constellations[indexPath.row]
        return CGSize(width: tmpLabel.intrinsicContentSize.width / 5, height: 100)
    }
}
