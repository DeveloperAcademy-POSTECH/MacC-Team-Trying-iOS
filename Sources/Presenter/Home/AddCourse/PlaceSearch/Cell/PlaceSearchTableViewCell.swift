//
//  PlaceSearchTableViewCell.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

final class PlaceSearchTableViewCell: UITableViewCell {
    static let identifier = "PlaceSearchTableViewCellIdentifer"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .bold, size: ._15)
        return label
    }()
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .regular, size: ._11)
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .regular, size: ._13)
        return label
    }()
    lazy var addCourseButton = SmallRectButton(type: .add)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        contentView.backgroundColor = .designSystem(.black)
        contentView.addSubviews(titleLabel, categoryLabel, addressLabel, addCourseButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.bottom.equalTo(titleLabel)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview()
        }
        
        addCourseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
