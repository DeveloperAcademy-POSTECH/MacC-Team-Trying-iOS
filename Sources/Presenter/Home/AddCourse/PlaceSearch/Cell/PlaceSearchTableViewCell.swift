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
    
    lazy var placeContainerView = UIView()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .bold, size: ._15)
        return label
    }()
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.grayC5C5C5)
        label.font = .designSystem(weight: .regular, size: ._11)
        return label
    }()
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.grayC5C5C5)
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
        
        placeContainerView.addSubviews(titleLabel, categoryLabel, addressLabel)
        contentView.addSubviews(placeContainerView, addCourseButton)
        
        placeContainerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.bottom.equalTo(titleLabel)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
        }
        
        addCourseButton.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
        }
    }
}
