//
//  PlaceDetailView.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/23.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

final class PlaceDetailView: UIView {
    private lazy var placeInfoView = UIView()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "호맥"
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .bold, size: ._15)
        return label
    }()
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "음식점"
        label.textColor = .designSystem(.grayC5C5C5)
        label.font = .designSystem(weight: .regular, size: ._11)
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "경북 포항시 북구 흥해읍 학천리"
        label.textColor = .designSystem(.grayC5C5C5)
        label.font = .designSystem(weight: .regular, size: ._13)
        return label
    }()
    lazy var addCourseButton = SmallRectButton(type: .add)
    private lazy var relatedCourseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.layer.cornerRadius = 10
        stackView.backgroundColor = .designSystem(.gray818181)?.withAlphaComponent(0.5)
        return stackView
    }()
    private lazy var relatedCourseLabel: UILabel = {
        let label = UILabel()
        label.text = "연관 코스"
        label.font = .designSystem(weight: .regular, size: ._15)
        label.textColor = .designSystem(.grayC5C5C5)
        return label
    }()
    private lazy var relatedCourseNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "5개"
        label.font = .designSystem(weight: .bold, size: ._20)
        label.textColor = .designSystem(.mainYellow)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .designSystem(.black)
        self.layer.cornerRadius = 20
        
        placeInfoView.addSubviews(titleLabel, categoryLabel, addressLabel)
        relatedCourseStackView.addArrangedSubview(relatedCourseLabel)
        relatedCourseStackView.addArrangedSubview(relatedCourseNumberLabel)
        self.addSubviews(placeInfoView, addCourseButton, relatedCourseStackView)
        
        placeInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(33)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(37)
            make.bottom.equalTo(titleLabel)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview()
        }
        
        addCourseButton.snp.makeConstraints { make in
            make.centerY.equalTo(placeInfoView)
            make.trailing.equalToSuperview().inset(20)
        }
        
        relatedCourseStackView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(64)
        }
    }
}
