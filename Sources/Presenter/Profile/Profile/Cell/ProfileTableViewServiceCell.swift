//
//  ProfileTableViewServiceCell.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

final class ProfileTableViewServiceCell: UITableViewCell {
    static let identifier = "ProfileTableViewServiceCellIdentifier"
    
    let serviceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .designSystem(.white)
        label.font = .designSystem(weight: .regular, size: ._13)
        return label
    }()
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 13)
        let image = UIImage(systemName: Constants.Image.chevron_right, withConfiguration: configuration)
        imageView.image = image
        imageView.tintColor = .designSystem(.white)
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .designSystem(.gray818181)?.withAlphaComponent(0.5)

        self.addSubviews(
            serviceLabel,
            chevronImageView
        )
        
        serviceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
}
