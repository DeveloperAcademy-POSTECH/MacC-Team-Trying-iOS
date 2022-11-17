//
//  MyConstellationCollectionViewCell.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class MyConstellationCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "MyConstellationCollectionViewCell"
    
    var course: CourseEntity? {
        didSet {
            guard let course = course else { return }
            courseNameLabel.text = course.courseTitle
            constellationImage.image = StarMaker.makeStars(places: course.places)
            dateLabel.text = course.date
        }
    }
    
    lazy var courseNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .gmarksans(weight: .bold, size: ._15)
        label.textColor = .white
        return label
    }()
    
    lazy var constellationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .designSystem(weight: .light, size: ._13)
        label.textColor = .white
        return label
    }()
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    func setUI() {
        contentView.addSubview(courseNameLabel)
        contentView.addSubview(constellationImage)
        contentView.addSubview(dateLabel)
        
        courseNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        constellationImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(45)
            make.top.bottom.equalToSuperview().inset(60)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
    }
}
