//
//  ProfileTableViewHeaderView.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

import SnapKit

final class ProfileTableViewHeaderView: UITableViewHeaderFooterView {
    static let identifier = "ProfileTableViewHeaderView"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .designSystem(weight: .bold, size: ._15)
        label.textColor = .designSystem(.white)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
}
