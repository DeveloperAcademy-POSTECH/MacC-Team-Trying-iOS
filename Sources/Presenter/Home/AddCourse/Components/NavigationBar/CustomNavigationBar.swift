//
//  CustomNavigationBar.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import SnapKit

enum CustomNavigationBarType {
    /// 코스 등록 과정에서 지도가 있는 화면에서 사용되는 Navigation Bar 입니다.
    /// - Left Item : x_mark
    /// - Item : 장소 입력 TextField (클릭 시 다음 화면으로 넘어가도록 구현)
    case map
    
    /// 장소를 검색할 수 있는 화면에서 사용되는 Navigation Bar 입니다.
    /// - Left Item : chevron_left
    /// - Item : 장소 입력 TextField
    case search
    
    /// 코스 등록 과정에서 코스 이름, 내용, 사진을 입력하는 화면에서 사용되는 Navigation Bar 입니다.
    /// - Left Item : chevron_left
    /// - Item : 일정 선택 버튼
    case courseDetail
}

final class CustomNavigationBar: UIView {
    var type: CustomNavigationBarType
    
    private var leftItem = UIImageView()
    private var searchTextField: CustomTextField?
    private var titleLabel: UILabel?
    private var selectDateButton: SmallRoundButton?
    
    init(type: CustomNavigationBarType) {
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
        case .map:
            leftItem = UIImageView(image: UIImage(named: Constants.Image.x_mark))
            searchTextField = CustomTextField(type: .search)
            
        case .search:
            leftItem = UIImageView(image: UIImage(named: Constants.Image.chevron_left))
            searchTextField = CustomTextField(type: .search)
            
        case .courseDetail:
            leftItem = UIImageView(image: UIImage(named: Constants.Image.chevron_left))
            selectDateButton = SmallRoundButton(type: .selectDate)
        }
        self.backgroundColor = .designSystem(.black)
    }
    
    private func setLayout() {
        self.addSubview(leftItem)
        
        self.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.Screen.width)
            make.height.equalTo(DeviceInfo.Screen.height * 0.1244)
        }
        
        self.leftItem.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        switch type {
        case .map, .search:
            self.addSubview(searchTextField!)
            
            searchTextField?.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(20)
                make.centerY.equalTo(leftItem)
            }
            
        case .courseDetail:
            self.addSubview(selectDateButton!)
            
            selectDateButton?.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(leftItem)
            }
        }
    }
}
