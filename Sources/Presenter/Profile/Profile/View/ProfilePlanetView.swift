//
//  ProfilePlanetView.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/09.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

enum ProfilePlanetState {
    case noPlanet
    case alone
    case couple
}

final class ProfilePlanetView: UIView {
    var type: ProfilePlanetState {
        didSet {
            presentPlanetView()
        }
    }
    
    // MARK: No Planet View
    lazy var enterPlanetButton = SmallRoundButton(type: .enterPlanet)
    
    lazy var createPlanetButton = SmallRoundButton(type: .createPlanet)
    
    // MARK: Alone View
    lazy var inviteMateButton = SmallRoundButton(type: .inviteMate)
    
    // MARK: Couple View
    lazy var placeLabel = UILabel()
    
    // MARK: No Planet View, Alone View
    private lazy var viewLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .regular, size: ._15)
        return label
    }()
    
    // MARK: Alone View, Couple View
    lazy var planetNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .bold, size: ._15)
        return label
    }()
    
    // MARK: Common
    lazy var planetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(type: ProfilePlanetState) {
        self.type = type
        super.init(frame: .zero)
        
        presentPlanetView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension ProfilePlanetView {
    private func presentPlanetView() {
        switch type {
        case .noPlanet:
            presentNoPlanetView()
            viewLabel.text = "현재 소속된 행성이 없어요!"
            
        case .alone:
            presentAlonePlanetView()
            viewLabel.text = "현재 메이트가 없어요!"
            
        case .couple:
            presentCouplePlanetView()
        }
    }
    
    private func presentNoPlanetView() {
        self.addSubviews(
            viewLabel,
            enterPlanetButton,
            createPlanetButton,
            planetImageView
        )
        
        viewLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        enterPlanetButton.snp.makeConstraints { make in
            make.top.equalTo(viewLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(95)
        }
        
        createPlanetButton.snp.makeConstraints { make in
            make.top.equalTo(viewLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(95)
        }
        
        planetImageView.snp.makeConstraints { make in
            make.top.equalTo(enterPlanetButton.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    private func presentAlonePlanetView() {
        self.addSubviews(
            viewLabel,
            inviteMateButton,
            planetImageView,
            planetNameLabel
        )
        
        viewLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        inviteMateButton.snp.makeConstraints { make in
            make.top.equalTo(viewLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(116)
        }
        
        planetImageView.snp.makeConstraints { make in
            make.top.equalTo(inviteMateButton.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
        
        planetNameLabel.snp.makeConstraints { make in
            make.top.equalTo(planetImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func presentCouplePlanetView() {
        self.addSubviews(
            placeLabel,
            planetImageView,
            planetNameLabel
        )
        
        placeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        planetImageView.snp.makeConstraints { make in
            make.top.equalTo(placeLabel.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
        
        planetNameLabel.snp.makeConstraints { make in
            make.top.equalTo(planetImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
}
