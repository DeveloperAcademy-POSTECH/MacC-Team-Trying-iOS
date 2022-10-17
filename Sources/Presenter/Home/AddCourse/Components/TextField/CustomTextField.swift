//
//  CustomTextField.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

enum CustomTextFieldType {
    /// 검색에 사용되는 TextField
    /// - Width : 디바이스 가로 길이 * 0.7948
    /// - Height : 36
    /// - Placeholder : 장소를 입력해 주세요.
    case search
    
    /// 코스 등록에 사용되는 TextField
    /// - Height : 50
    /// - Placeholder : 방문하신 가게 이름을 입력해 주세요.
    case shopTitle
    
    /// 코스 등록에 사용되는 TextField
    /// - Height : 50
    /// - Placeholder : 방문하신 가게 위치를 입력해 주세요.
    case location
    
    /// 코스 기록에 사용되는 TextField
    /// - Height : 50
    /// - Placeholder : 코스 이름을 입력해 주세요.
    case courseTitle
}

final class CustomTextField: UITextField {
    var type: CustomTextFieldType
    
    init(type: CustomTextFieldType) {
        self.type = type
        super.init(frame: .zero)
        
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        switch type {
        case .search:
            self.leftImage(UIImage(systemName: Constants.Image.magnifyingglass), imageWidth: 10, padding: 10)
            self.attributedPlaceholder = .init(string: "장소를 입력해 주세요.", attributes: [.foregroundColor: UIColor.designSystem(.grayEBEBF5) as Any])
            self.tintColor = .designSystem(.grayEBEBF5)
            self.textColor = .designSystem(.white)
            self.backgroundColor = .designSystem(.gray767680)
            self.layer.cornerRadius = 10
            
        case .shopTitle:
            let imageView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            self.leftView = imageView
            self.attributedPlaceholder = .init(string: "방문하신 가게 이름을 입력해 주세요.", attributes: [.foregroundColor: UIColor.designSystem(.grayC5C5C5) as Any])
            self.textColor = .designSystem(.black)
            self.backgroundColor = .designSystem(.white)
            self.layer.cornerRadius = 15
            
        case .location:
            let imageView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            self.leftView = imageView
            self.attributedPlaceholder = .init(string: "방문하신 가게 위치를 입력해 주세요.", attributes: [.foregroundColor: UIColor.designSystem(.grayC5C5C5) as Any])
            self.textColor = .designSystem(.black)
            self.backgroundColor = .designSystem(.white)
            self.layer.cornerRadius = 15

        case .courseTitle:
            let imageView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            self.leftView = imageView
            self.attributedPlaceholder = .init(string: "코스 이름을 입력해 주세요.", attributes: [.foregroundColor: UIColor.designSystem(.white) as Any])
            self.textColor = .designSystem(.white)
            self.backgroundColor = .designSystem(.white)?.withAlphaComponent(0.1)
            self.layer.cornerRadius = 15
        }
        self.font = .designSystem(weight: .regular, size: ._15)
        self.leftViewMode = .always
    }
    
    private func setLayout() {
        switch type {
        case .search:
            self.snp.makeConstraints { make in
                make.width.equalTo(DeviceInfo.Screen.width * 0.7948)
                make.height.equalTo(36)
            }
            
        case .shopTitle, .location, .courseTitle:
            self.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        }
    }
}
