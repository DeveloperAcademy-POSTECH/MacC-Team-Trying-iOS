//
//  MapPlaceTableViewCell.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

final class MapPlaceTableViewCell: UITableViewCell {
    static let identifier = "MapPlaceTableViewCellIdentifier"
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .bold, size: ._15)
        label.textColor = .designSystem(.mainYellow)
        return label
    }()
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
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.Image.x_mark_circle_fill), for: .normal)
        button.tintColor = .designSystem(.white)?.withAlphaComponent(0.85)
        return button
    }()
    
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
        contentView.addSubviews(numberLabel, placeContainerView, deleteButton)
        
        numberLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        placeContainerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalTo(numberLabel.snp.trailing).offset(20)
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
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
}
