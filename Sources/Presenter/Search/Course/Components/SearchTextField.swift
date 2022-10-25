//
//  SearchTextField.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/23.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

final class SearchTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        self.leftImage(UIImage(systemName: Constants.Image.magnifyingglass), imageWidth: 10, padding: 10)
        self.attributedPlaceholder = .init(string: "검색어를 입력하세요.", attributes: [.foregroundColor: UIColor.designSystem(.grayEBEBF5) as Any])
        self.tintColor = .designSystem(.grayEBEBF5)
        self.textColor = .designSystem(.white)
        self.backgroundColor = .designSystem(.gray767680)
        self.layer.cornerRadius = 10
        self.font = .designSystem(weight: .regular, size: ._15)
        self.leftViewMode = .always
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth - 20 * 2)
            make.height.equalTo(36)
        }
    }
}
