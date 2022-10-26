//
//  RandomPlanetView.swift
//  MatStar
//
//  Created by uiskim on 2022/10/26.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class RandomPlanetView: UIView {
    
    var planet: Planet? {
        didSet {
            guard let planet = planet else { return }
            planetImageView.image = planet.planetTyle.planetImage
            planetTitleLabel.text = planet.name
        }
    }
    
    lazy var planetImageView = UIImageView()
    lazy var planetTitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        addSubview(planetImageView)
        planetImageView.contentMode = .scaleAspectFit
        addSubview(planetTitleLabel)
        planetTitleLabel.textAlignment = .center
        planetTitleLabel.font = .designSystem(weight: .bold, size: ._15)
        planetTitleLabel.textColor = .white
    }
    
    func setUI() {
        planetImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(65)
        }
        planetTitleLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(planetImageView.snp.bottom)
        }
    }
    
}
