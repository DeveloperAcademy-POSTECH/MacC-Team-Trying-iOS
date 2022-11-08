//
//  PathTableFooter.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class PathTableFooter: UITableViewHeaderFooterView {
    static let cellId = "PathTableFooter"
    
    let registerReviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.setTitle("후기 등록", for: .normal)
        button.layer.borderColor = .designSystem(.mainYellow)
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.layer.cornerRadius = 17
        // MARK: - SF Symbol크기 조절하는 메서드
        button.setPreferredSymbolConfiguration(.init(pointSize: 11), forImageIn: .normal)
        button.tintColor = .designSystem(.mainYellow)
        button.setTitleColor(.designSystem(.mainYellow), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11, weight: .bold)
        return button
    }()
    
    let settingButton: UIButton = {
        let buttonImage = UIImage(named: "PathSettingButton")
        let button = UIButton(type: .custom)
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(registerReviewButton)
        addSubview(settingButton)
        registerReviewButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(69)
            make.height.equalTo(34)
            make.centerY.equalToSuperview()
        }
        settingButton.snp.makeConstraints { make in
            make.leading.equalTo(registerReviewButton.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(34)
            make.centerY.equalToSuperview()
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
