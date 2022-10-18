//
//  EmptyResultView.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

final class EmptyResultView: UIView {
    private lazy var emptyResultLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다!"
        label.textColor = .designSystem(.white)
        return label
    }()
    lazy var courseRegisterButton = SmallRoundButton(type: .addCourse)
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: Constants.Image.appIcon)
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubviews(emptyResultLabel, courseRegisterButton, iconImageView)
        
        emptyResultLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        courseRegisterButton.snp.makeConstraints { make in
            make.top.equalTo(emptyResultLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(courseRegisterButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
}
