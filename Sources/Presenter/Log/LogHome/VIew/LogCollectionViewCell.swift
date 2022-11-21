//
//  LogCollectionViewCell.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/09.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import CoreLocation

import SnapKit
import Lottie

class LogCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LogCollectionViewCell"
    
    let courseNameButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.titleLabel?.font = UIFont.gmarksans(weight: .bold, size: ._15)
        button.setTitleColor(.designSystem(.white), for: .normal)
        button.tintColor = .designSystem(.white)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 17.5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = .designSystem(.mainYellow)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        return button
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.designSystem(weight: .regular, size: ._13)
        label.tintColor = UIColor.designSystem(.grayC5C5C5)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LogCollectionViewCell {
    
    func configure(with course: CourseEntity) {
        
        self.contentView.subviews
            .filter { view in
                return !(view == dateLabel || view == courseNameButton)
            }
            .forEach { $0.removeFromSuperview() }
        
        let courseView = StarMaker.makeConstellation(places: course.places)
        
        contentView.addSubview(courseView)
        
        courseView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.6)
        }
        
        dateLabel.text = course.date
        courseNameButton.setTitle(course.courseTitle, for: .normal)
        
        courseNameButton.snp.remakeConstraints { make in
            make.width.equalTo(17 * (courseNameButton.titleLabel?.text?.count ?? 50) + 35)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(dateLabel.snp.top).offset(-10)
        }
    }
    
    private func setConstraints() {
        contentView.addSubviews(
            courseNameButton,
            dateLabel
        )
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(130)
        }
        
        courseNameButton.snp.makeConstraints { make in
            make.width.equalTo(123)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(dateLabel.snp.top).offset(-10)
        }
    }
}
