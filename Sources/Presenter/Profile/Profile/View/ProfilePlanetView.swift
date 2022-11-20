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

final class ProfilePlanetView: UIView {
    lazy var placeLabel = UILabel()
    
    lazy var planetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var planetNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .bold, size: ._15)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.presentPlanetView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension ProfilePlanetView {
    private func presentPlanetView() {
        self.presentCouplePlanetView()
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
